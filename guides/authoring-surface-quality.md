# Authoring-Surface Quality: refuse, don't default

> How to finish a surface that humans write into — a fluent API, a DSL, a CLI, a config schema — so that
> the plausible wrong thing gets a diagnostic instead of a silent result.

> **Provenance**: a contract-and-authoring-surface effort, July–August 2026, whose finishing pass graded
> 77 deliberate author mistakes at every seam of a fluent API. **Status: PROVISIONAL** — one project.

## What this guide covers

An **authoring surface** is anything a person writes into where the writing is not the final artifact:
a builder API, an embedded DSL, a CLI's flag grammar, a configuration schema, a template language. Its
defining property is that **the author's mental model and the surface's semantics can disagree while
everything succeeds** — the program compiles, the config validates, the command exits zero, and the
result is not what was meant.

That failure class is invisible to ordinary quality tooling. Coverage, architecture rules, null checks
and vulnerability scans all grade the implementation. This guide grades the *experience of getting it
wrong*.

Two axes: **conduct** (what happens when the author does the plausible wrong thing) and **diagnostics**
(what they are told when it is refused).

---

## Part 1 — Conduct: no silent class

> **Every way an author can misuse a surface member has a *classified* conduct. There is no silent
> class.**

The defect being closed here is not a *wrong* answer. It is **no answer** — reached because nobody asked
the question when the member was written. A verb gets added, the author calls it twice, and whatever the
implementation happens to do becomes the semantics.

### Classify each member's repeat conduct

Enumerate the classes your surface actually needs and give every member exactly one. A working partition
from a fluent builder, offered as a starting shape rather than a standard:

| Class | Conduct on a second call |
|---|---|
| **set-once** | refuses at the call, quoting the first value and its site |
| **append** | accumulates; a *collision* within the accumulation refuses |
| **fold** | refuses at build time, naming **both** authored lines (because a later call can legitimately change which tier applies) |
| **idempotent** | accepted; the second call states the same fact |
| **places a node** | each call produces a distinct element; no repeat semantics needed |
| **refused elsewhere** | already unreachable via a different guard, with that guard named |

The partition is less important than the property: **every member is in exactly one class, and "we never
thought about it" is not a class.**

### Enforce it with a reflective denominator

A classification kept in a side register drifts the moment someone adds a member. Bind the denominator
to the surface itself:

```
test: every public member of the surface has exactly one conduct classification
      → enumerate members by reflection, not from a maintained list
```

Now **a new member fails the build until it is classified**. Observed working exactly as intended: a
newly written verb broke the classification test *the moment it compiled*, before any test of the verb
itself existed.

Where the language allows it, put the classification **on the member** (an annotation, a decorator, an
attribute) rather than beside it — then the question is asked at the point of writing and the register
cannot fall out of sync.

> **Two traps this catches only if you look for them**, both observed through a green build:
> a repeated match arm that emitted *two* edges carrying one condition (more output, not less — a
> byte-diff shows it as growth, not as a defect), and a duplicated `writing(KEY)` on one node that
> inflated a writer count and silently changed which convergence rule applied (identical output bytes).

### Wrong-receiver mistakes are a different class

Repeat-call discipline covers *a second call on the right receiver*. It is blind to **a first call on
the wrong one** — and that is the mistake that survives review, because only the *position* is wrong.

If your surface nests scopes (blocks, arms, lambdas that receive a sub-builder), the shape to worry
about is a call written inside an inner scope but aimed at the outer receiver, which is still in scope
and still valid. In the case on record, this compiled, built green, and emitted a valid artifact
describing a **different graph**.

Two properties close it, and both live on the nesting seam:

- **A receiver is locked while a callable it supplied the argument for is running.** Every member aimed
  at a locked receiver refuses, naming the receiver, what it has open, and the parameter to use instead.
  Nesting then leaves exactly the innermost receiver unlocked.
- **A scope callable returns the receiver it was given.** Returning an enclosing receiver, a foreign
  one, or nothing at all is refused at the seam.

Two notes a successor should not rediscover. Take the identity check over a *value-returning* callable,
not a void one — a void callback cannot distinguish *untouched* from *went somewhere else*, which is the
distinction you are buying. And **the eagerness the lock depends on must itself be pinned by a test**:
a refactor that defers applying scope callables to build time dissolves the locking window with every
other test still green.

---

## Part 2 — Diagnostics: the followable-advice bar

> **A refusal must name the site, name what is wrong in the author's vocabulary, and name a remedy the
> author can actually type.**

All three. Each one fails on its own:

| Missing | What the author gets |
|---|---|
| the site | a true statement they cannot locate |
| the author's vocabulary | internal type names, generic parameters, a compiler type dump — accurate, unusable |
| a typeable remedy | "this is not allowed", which is where they were already |

**A compiler's raw type-variable dump fails the bar.** When a surface makes a plausible call not exist,
the language's own diagnostic is what the author sees, and a message naming `I#1,O#1,I#2,O#2` and never
naming the type they should have used is a diagnostic defect *belonging to your surface*, not to the
compiler. Either add the overload or produce a targeted refusal.

**The remedies are checkable and must be checked.** Take each refusal message's suggested remedy and
build it. A test suite whose method is *"follow the advice, and assert it works"* catches the class of
message that is confidently wrong — including the one introduced by a rename, where the message string
carries the old member name that no refactoring tool touched.

**Speak the domain's names, not the implementation's.** *"applies to an operation"*, not *"applies to a
op"*, and never *"applies to `OperationNodeImpl`"*. The author knows the domain's kinds because the
documentation taught them; they have never heard of your class.

---

## Part 3 — The author-error sweep

The instrument that makes the two parts above measurable.

> **Deliberately make the plausible mistakes at every seam, grade every diagnostic against the bar, and
> commit the graded table as tests.**

### Procedure

1. **Enumerate the seams.** Every place the surface accepts author input: each verb, each nesting arm,
   each place a name/type/reference crosses from the author's world into yours.
2. **At each seam, write the plausible mistake** — not the perverse one. The wrong-but-adjacent member,
   the value of the wrong type, the reference to a thing that does not exist, the call in the wrong
   order, the typo in a name you resolve.
3. **Run it and record what happens**, in three columns: *was* (the observed conduct/message), *bar*
   (pass/fail), *now* (after the fix).
4. **Fix, file, or adjudicate each failure.** A row that turns out to be a legal shape awaiting a design
   decision is filed as one — it is not a diagnostic defect.
5. **Commit the graded table as tests.** The table's rows *become* the test methods; the table itself is
   the test class's documentation. Then the grade enforces itself and cannot decay into prose.

### Two findings about the procedure itself

**Run the sweep after the fixes, not only before.** In the run on record, one of six failures was a
defect the fixing act had introduced *two hours earlier* — a refusal message claiming a value was
"listed above" in a message that listed nothing. A sweep run only at the start would have shipped it.

**The sweep finds things the expressiveness gate cannot.** A coverage gate measures *can the thing be
said*; this measures *what happens when it is said wrong*. They are different instruments and they find
different defects — the gate that preceded this sweep produced three author-error findings incidentally,
without looking for them, which is why the sweep existed at all.

### Two defect classes to expect

- **Emitted-wrong-value defects.** Output that is schema-valid, semantically valid, and *wrong* —
  dispatching a value the author never meant. These pass every structural check you own. The sweep is
  how you find them; a committed fixture is how you keep them found.
- **The obvious fix that is refuted by your own corpus.** Before landing a broadening fix, run it against
  the existing examples. One "six-line change" on record would have silently inverted the meaning of a
  legitimate loop already in the corpus. When that happens, land the narrow certain thing and file the
  structural gap **with the counterexample attached** — see
  [`../concepts/refutation-by-counterexample.md`](../concepts/refutation-by-counterexample.md).

---

## Checklist

When finishing an authoring surface:

- [ ] **Conduct partition** — every public member classified; no silent class
- [ ] **Reflective denominator** — a new member fails the build until it is classified
- [ ] **Scope integrity** — nested receivers locked while a scope callable runs; scope callables return
      what they were given; the eagerness that makes the lock work is pinned by a test
- [ ] **Followable advice** — every refusal names site, defect (in domain vocabulary), and a typeable
      remedy
- [ ] **Remedies built** — a test that follows each refusal's advice and asserts it works
- [ ] **Author-error sweep** — plausible mistakes at every seam, graded, and committed as tests
- [ ] **Sweep re-run after the fixes** — the fixing act is a source of new defects
- [ ] **Diagnostics re-graded after any rename** — the member name lives in strings

## Related

[`../concepts/vocabulary-law.md`](../concepts/vocabulary-law.md) (a surface's verbs are its most-read
vocabulary; the fluency test decides renames) ·
[`../concepts/quality-infrastructure.md`](../concepts/quality-infrastructure.md) (this guide is the
authoring-surface member of the deterministic-judge family) ·
[`../concepts/refutation-by-counterexample.md`](../concepts/refutation-by-counterexample.md) (the sweep
is a funded counterexample search) ·
[`second-implementation-protocol.md`](second-implementation-protocol.md) (a cold second surface finds
what the first surface's authors cannot) ·
[`java-library-quality.md`](java-library-quality.md) (the implementation-side standard this sits beside).
