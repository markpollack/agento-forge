#!/usr/bin/env python3
"""Condense one AppMap call recording using declared component membership.

usage: sequence-overview.py RECORDING VIEW OUTPUT [SETTINGS]

Derived from Agent Journal a64833b83486c07db76027f6f6c075fc7685b17b.
Folds overload delegation and calls within a component (except a thread root's
own steps); reduces repeated sibling blocks to counted loops. Each message
carries thread-local call ids, including folded ids. Repetitions choose the
largest recorded body; see README.md for limits. Every thread root is retained.
Threads are drawn separately: vertical layout establishes no cross-thread order.
Requires complete, nested call/return events within each thread. No dependencies.
"""
import json
import re
from pathlib import Path
import sys
import textwrap

def short(fq, prefixes):
    # Explicit compatibility for generators that use package-relative class names.
    # Full names are preferred. Never infer a project-specific prefix.
    for root in sorted(prefixes, key=len, reverse=True):
        if fq.startswith(root):
            return fq[len(root):]
    return fq


class Call:
    def __init__(self, event, prefixes):
        self.ids = [event["id"]]
        self.folded = []
        self.cls = short(event["defined_class"], prefixes)
        self.method = event["method_id"]
        self.children = []
        self.thread = event["thread_id"]
        self.receiver = (event.get("receiver") or {}).get("object_id")

    @property
    def simple(self):
        return self.cls.split(".")[-1]

    @property
    def top(self):
        return self.cls.split("$")[0]

    def label(self):
        return self.simple.replace("$", ".") + "." + self.method

    def all_ids(self):
        out = self.ids + self.folded
        for c in self.children:
            out.extend(c.all_ids())
        return out


class Loop:
    """A repeated block: every recorded repetition, in order."""

    def __init__(self, repetitions):
        self.repetitions = repetitions

    def all_ids(self):
        return [i for block in self.repetitions for item in block for i in item.all_ids()]

    def body(self):
        return max(self.repetitions, key=lambda block: sum(len(item.all_ids()) for item in block))


def trees(recording, prefixes):
    roots, stacks, seen = {}, {}, set()
    for e in recording["events"]:
        if e["event"] not in ("call", "return"):
            continue
        thread = e["thread_id"]
        key = (thread, e["id"])
        if key in seen:
            raise ValueError(f"duplicate event id within thread: {key}")
        seen.add(key)
        stack = stacks.setdefault(thread, [])
        if e["event"] == "call":
            call = Call(e, prefixes)
            (stack[-1].children if stack else roots.setdefault(thread, [])).append(call)
            stack.append(call)
        else:
            if not stack or stack[-1].ids[0] != e["parent_id"]:
                raise ValueError(f"unmatched return in thread {thread}: {e['id']}")
            stack.pop()
    if not roots or any(stacks.values()):
        raise ValueError("recording has no calls or has unclosed calls")
    return roots


def fold(call, component, root):
    kept = []
    for child in call.children:
        child_kept = fold(child, component, False)
        same_method = child.cls == call.cls and child.method == call.method
        same_component = component(child) == component(call)
        if same_method or (same_component and not root):
            call.folded.extend(child.ids + child.folded)
            kept.extend(child_kept)
        else:
            child.children = child_kept
            kept.append(child)
    return kept


def shapes(items, component):
    """The canonical shape of a list of calls: loops flattened to one body, then repeated blocks reduced to one copy."""
    seq = []
    for item in items:
        if isinstance(item, Loop):
            seq.extend(shapes(item.body(), component))
        else:
            seq.append((component(item), item.cls, item.method, shapes(item.children, component)))
    changed = True
    while changed:
        changed = False
        for k in range(1, len(seq) // 2 + 1):
            for i in range(len(seq) - 2 * k + 1):
                if seq[i:i + k] == seq[i + k:i + 2 * k]:
                    seq = seq[:i + k] + seq[i + 2 * k:]
                    changed = True
                    break
            if changed:
                break
    return tuple(seq)


def repeat(items, component):
    for item in items:
        if isinstance(item, Call):
            item.children = repeat(item.children, component)
    out, i = [], 0
    while i < len(items):
        best_k, best_r = 1, 1
        for k in range(1, (len(items) - i) // 2 + 1):
            block = shapes(items[i:i + k], component)
            r = 1
            while i + (r + 1) * k <= len(items) and shapes(items[i + r * k:i + (r + 1) * k], component) == block:
                r += 1
            if r > 1 and r * k > best_r * best_k:
                best_k, best_r = k, r
        if best_r > 1:
            out.append(Loop([items[i + r * best_k:i + (r + 1) * best_k] for r in range(best_r)]))
            i += best_r * best_k
        else:
            out.append(items[i])
            i += 1
    return out


def first_call(items):
    item = items[0]
    return first_call(item.body()) if isinstance(item, Loop) else item


def occurrences(items, key, component):
    """How often a call of this (component, class, method) was recorded among these items, nested loops included."""
    n = 0
    for item in items:
        if isinstance(item, Loop):
            n += sum(occurrences(block, key, component) for block in item.repetitions)
        else:
            n += ((component(item), item.cls, item.method) == key) + occurrences(item.children, key, component)
    return n


def main(recording_path, view_path, out_path, settings_path=None):
    recording = json.loads(Path(recording_path).read_text(encoding="utf-8"))
    view = json.loads(Path(view_path).read_text(encoding="utf-8"))
    settings = json.loads(Path(settings_path).read_text(encoding="utf-8")) if settings_path else {}
    prefixes = settings.get("class_prefixes", [])
    member, order, names = {}, [], {}
    for c in view["components"]:
        cid = c["id"]
        if not re.fullmatch(r"[a-z][a-z0-9_-]*", cid) or cid in order or cid == "external_entry":
            raise ValueError(f"invalid, duplicate or reserved component id: {cid}")
        if alias(cid) in [alias(existing) for existing in order]:
            raise ValueError(f"component aliases collide: {cid}")
        order.append(cid)
        names[cid] = c["name"]
        for cls in c["classes"]:
            if cls in member:
                raise ValueError(f"class belongs to multiple components: {cls}")
            member[cls] = cid
    shared = set(view.get("drawing", {}).get("incoming_edges_not_drawn_to", []))
    if shared - set(order):
        raise ValueError("drawing names unknown shared components")

    def component(call):
        if call.top not in member:
            raise SystemExit(f"{call.cls} is not in any component of {view_path}")
        return member[call.top]

    roots = trees(recording, prefixes)
    # Check all calls before folding; an unassigned call must never disappear.
    def validate(call):
        component(call)
        for child in call.children:
            validate(child)
    for thread_roots in roots.values():
        for call in thread_roots:
            validate(call)
    for thread_roots in roots.values():
        for r in thread_roots:
            r.children = fold(r, component, True)
    for thread in roots:
        roots[thread] = repeat(roots[thread], component)

    used, lines = [], []

    def use(cid):
        if cid not in used:
            used.append(cid)

    def emit(item, caller, depth, scope):
        """scope: the repetitions of the enclosing loops, to count a nested loop over all of them."""
        if isinstance(item, Loop):
            head = first_call(item.body())
            key = (component(head), head.cls, head.method)
            total = sum(occurrences(block, key, component) for block in scope) if scope else occurrences([item], key, component)
            label = settings.get("loop_labels", {}).get("|".join((key[0], head.cls, head.method)), "repeated")
            lines.append("  " * depth + f"loop {label}, {total} recorded")
            lines.append("  " * depth + "' covers recorded calls " + ", ".join(str(i) for i in sorted(item.all_ids())))
            for child in item.body():
                emit(child, caller, depth + 1, [[x] for block in item.repetitions for x in block] if not scope else scope)
            lines.append("  " * depth + "end")
            return
        callee = component(item)
        if callee in shared and caller != "external_entry":
            callee = caller
        use(callee)
        note = f"' thread {item.thread}, recorded call " + ", ".join(str(i) for i in item.ids)
        if item.folded:
            note += "; folded into it " + ", ".join(str(i) for i in sorted(item.folded))
        lines.append("  " * depth + note)
        arrow = "[->" if caller == "external_entry" else f"{alias(caller)} ->"
        lines.append("  " * depth + f"{arrow} {alias(callee)} : {item.label()}")
        for child in item.children:
            emit(child, callee, depth, scope)

    for thread, thread_roots in roots.items():
        lines.append(f"group thread {thread}; order relative to other threads not established")
        for call in thread_roots:
            emit(call, "external_entry", 1, None)
        lines.append("end")

    with open(out_path, "w", encoding="utf-8") as out:
        out.write("@startuml " + Path(out_path).stem + "\n")
        out.write("' GENERATED from one scoped recording and explicit component membership; do not edit.\n")
        out.write("' Per-message comments preserve thread and recorded call ids. See the adjacent recording manifest.\n")
        out.write("skinparam shadowing false\nskinparam defaultFontName Helvetica\nskinparam defaultFontSize 12\nskinparam maxMessageSize 150\nhide footbox\n")
        out.write("title " + settings.get("title", "Observed overview of one scoped scenario") + "\n")
        used.sort(key=order.index)
        for cid in used:
            out.write(f'participant "{cid.replace("-", " ")}" as {alias(cid)}\n')
        out.write("\n".join(lines) + "\n")
        legend = ["Participants are declared documentation components: "
                  + "; ".join(f"{cid.replace('-', ' ')}: {names[cid]}" for cid in used) + ".",
                  "Observed calls from one scoped recording. Calls within a component are folded except a thread root's own steps. "
                  "Shared-component calls may be drawn on the caller; ids remain in comments. Return values are omitted.",
                  "Threads are separate groups. Receiver identity and event ids do not establish cross-thread order or overlap.",
                  settings.get("scenario", "Describe the recorded input, scope and scenario in the project settings."),
                  "Full trace: " + settings.get("full_trace", "observed-sequence.svg")]
        out.write("legend bottom left\n")
        for paragraph in legend:
            for line in textwrap.wrap(paragraph, 96):
                out.write("  " + line + "\n")
        out.write("endlegend\n@enduml\n")


def alias(cid):
    return cid.replace("-", "_")




if __name__ == "__main__":
    if len(sys.argv) not in (4, 5):
        raise SystemExit(__doc__)
    main(*sys.argv[1:])
