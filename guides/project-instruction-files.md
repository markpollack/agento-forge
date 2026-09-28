# Project Instruction Files

> The policy for a **project** repository's `AGENTS.md` and `CLAUDE.md`, and any other tool's
> instruction file. What they must say, what they must not, and how to check them.

> **Established**: 2026-09-28, on owner direction: *"what exists in claude.md and agents.md is for a
> simple agentic cli to read and see how to build and the basic modules and architecture of the
> project. links to online docs should be there as well."*
> **Skeleton**: [`templates/STEWARDED-PROJECT-INSTRUCTIONS-TEMPLATE.md`](../templates/STEWARDED-PROJECT-INSTRUCTIONS-TEMPLATE.md).
> **Scope**: code repositories. A knowledge-base corpus whose `CLAUDE.md` is its navigator follows
> [`variants/kb.md`](../variants/kb.md) instead. A steward repository follows its own templates; see
> the last section.

## 1. Purpose

A cold agentic CLI such as Claude Code or Codex opens the repository with no history. The instruction
files give it only what it cannot quickly infer from the code:

- how to build and test, and which command is the gate;
- the basic modules and architecture;
- the hard rules and invariants it would otherwise break for reasonable-looking reasons;
- links to the online docs;
- a pointer to the private steward, if the project has one.

Everything else is either derivable from the code or belongs somewhere else. A cold agent reads
every line of this file every session, so each line should be one it needs.

## 2. `AGENTS.md`: required sections

`AGENTS.md` is canonical and tool-neutral. Use these sections in this order, and keep each one short.

1. **Purpose.** One line: what this repository is.
2. **Steward pointer**, if the project is paired. The steward's path, and an instruction to read its
   `BINDING.md` before planning or executing work. Nothing from the steward is copied here.
3. **Build and test.** The exact commands, copy-pasteable, and which one is the gate that must pass
   before a commit. Include anything that fails before compilation, such as a formatter or license
   check bound to an early phase.
4. **Modules.** A short map: module or directory, then one line on what it holds. Leave out anything
   a directory listing makes obvious.
5. **Architecture.** Only the few decisions an agent must respect, such as dependency direction, the
   public API boundary, or what must stay framework-free. This is not a design document.
6. **Hard rules and invariants.** Each rule comes with its consequence, meaning what breaks and who
   notices. Where one exists, add a check a session can run before committing. A rule with no stated
   consequence gets bent by the first agent that finds a good reason to.
7. **Docs.** Links to the online documentation, and the source of truth for the API: the reference
   docs, the Javadoc, or the spec, whichever wins when they disagree.

## 3. Excluded from both files

| Content | Where it goes instead |
|---|---|
| Vision, roadmap, plans, current status, next actions | The steward (`VISION`, `ROADMAP`) |
| Design state, "current limits", per-provider behavior notes that change with each commit | Steward `DESIGN.md`, or the public docs if users need it |
| Session rituals such as preflight, handoff and closing checks | The steward, which already defines them |
| Narrative history or incident retellings | The steward journal. Keep only the resulting rule here, stated as a hard rule with its consequence |
| Anything private: owner decisions, correspondence, commercial or diligence state, message IDs | The steward. Never a public file |

The test for each line is whether it will still be true, unchanged, after the next ten commits. If
not, it is state, and state belongs in the steward.

## 4. `CLAUDE.md` is a bridge only

`CLAUDE.md` holds a heading, one sentence, and `@AGENTS.md`. It has no content of its own:

```markdown
# {{PROJECT_NAME}} Claude Code Bridge

`AGENTS.md` is the canonical instruction file for all coding agents and is imported below.

@AGENTS.md
```

Other tools get the same bridge wherever their conventions allow, using an import where the tool
supports one and a one-line redirect where it does not. Tools that read `AGENTS.md` natively need no
bridge at all.

**Why an `@` import and not prose** ("Read `AGENTS.md`"): a file that is only named is not loaded.
The session starts without its content and may or may not read it later, and Claude Code's
permission check only sees loaded instruction content. It cannot honor a rule it never loaded. The
import makes `AGENTS.md` part of every session from the first turn.

## 5. Size budget

Aim for **about 60 lines or fewer** in `AGENTS.md`. When it grows past that, **move content out;
do not summarize it in place.** A compressed paragraph is still in the wrong file, and it has lost
the detail that made it useful where it belongs. Apply §3: state goes to the steward, user-facing
detail goes to the public docs and gets a link under Docs, and history goes to the journal, leaving only
its rule behind.

## 6. Audit checklist

Run this against any project. A session can do it cold in a few minutes.

- [ ] `AGENTS.md` exists and has the seven sections of §2 in order, or omits the steward pointer
      only because no steward exists.
- [ ] The build and test commands run as written from a clean checkout, and the gate is named.
- [ ] Every hard rule states its consequence.
- [ ] None of the §3 content is present. Grep for roadmap, status, "next", "currently", dates, step
      numbers, and the names of private repositories.
- [ ] `AGENTS.md` is about 60 lines or fewer.
- [ ] `CLAUDE.md` is a bridge: heading, one sentence, `@AGENTS.md`, and nothing else.
      `~/scripts/claude-bridge.py <repo>` checks the import (exit 0 = clean). It does not check the
      absence of content.
- [ ] Other tool instruction files are bridges too, not copies.
- [ ] Every link under Docs resolves, for example with
      `grep -oE 'https?://[^) >]+' AGENTS.md | xargs -n1 curl -sfIL -o /dev/null -w '%{http_code} %{url_effective}\n'`,
      and every relative link points at a file that exists.

## 7. Steward files are different

A steward repository's own `AGENTS.md`, `CLAUDE.md` and `BINDING.md` follow the steward-repository
templates in
[`provisional/review-control-loop/templates/steward-repository/`](../provisional/review-control-loop/templates/steward-repository/).
Their job is authority and control: the binding, the trio, inbox preflight and delegated authority.
The steward's `CLAUDE.md` imports both `@AGENTS.md` and `@BINDING.md`. None of this policy's
section list applies to them, and none of their content belongs in the project's files.
