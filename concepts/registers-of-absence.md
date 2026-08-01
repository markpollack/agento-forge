# Registers of Absence: keeping a known gap visible until it closes

> A gap you have decided not to close yet is a claim about the future. Make it a claim something can
> check.

> **Provenance**: a contract-and-authoring-surface effort, July–August 2026 — the mechanism ran end to
> end several times, including two closures that deleted their own register entries.
> **Status: PROVISIONAL** — one project.

## The problem with a TODO

Every project accumulates deliberate absences: a feature not built yet, a field with no producer, a
rule the design names but nothing enforces. Recorded as prose — a `## Deferred` list, a comment, a
learnings paragraph — an absence has two failure modes and both are silent.

1. **It closes and nobody notices.** The gap gets filled as a side effect of unrelated work. The prose
   still says it is open. Every future reader is misinformed, and the register decays into noise that
   people learn to skip.
2. **It never closes and nobody notices that either.** The trigger was a sentence nobody re-reads.

Both are the same defect: the record and the world drift apart with no mechanism to notice.

## The mechanism: a known absence is a failing-when-closed test

> **Write the gap as a test that PASSES today because the thing is missing, and FAILS the moment it
> exists.**

```
@Test  // known absence: the surface cannot express a held gate verdict (owns: step 3.5)
void gateVerdictCannotBeHeld() {
    assertThatThrownBy(() -> flow.gate("review").hold())
        .isInstanceOf(NoSuchMethodError.class);   // delete this test when 3.5 lands
}
```

The inversion is the whole idea. A test written this way makes **closing the gap break the build**, so
the act that closes it *must* delete its own register entry — the record cannot survive the world
changing under it. Bookkeeping stops being a discipline and becomes a build dependency.

Two conventions make it work:

- **Every entry names its owning step.** "Scheduled" without an owner is deferred-forever with a
  paper trail. If no step owns it, say *that* — an unowned gap is a real state and a different one.
- **The entry says what it is waiting for, in the test's own words.** The person who deletes it is a
  stranger. The comment is the handoff.

The technique is not restricted to unit tests. A schema field with no producer, a documented error code
nothing emits, a CLI flag not implemented — each has a form of "assert it is still missing" that a
build can run.

## Honest closure has three shapes

The temptation, when walking a register, is to mark everything *done*. Closure is honest three ways,
and they are not interchangeable:

| Class | What it means | What proves it |
|---|---|---|
| **Reached** | the gap is closed; the thing exists | the test fails → delete the entry in the same act |
| **No plausible author** | no program can reach this state, so there is nothing to build | **a reachability program**, not a reading |
| **Surface gap** | it is unreachable *because a specific seam blocks it* | the blocking seam named, and the entry reclassified — not deleted |

**"No plausible author" is the one that goes wrong.** It is the claim that a state cannot be reached,
and it is exactly the kind of universal claim that a careful reading gets wrong. In one measured walk,
reading the producer got **one of eleven** such claims wrong. The fix is to bind the claim to a program
that attempts the reach and demonstrably fails — an executable version of "I looked, here is how".
This is [verified absence](refutation-by-counterexample.md#the-pairing-that-keeps-it-honest) with a
compiler attached.

**Deleting an entry as if reached when it was not is the defect this whole concept exists to prevent.**
A register that has been quietly emptied is worse than no register: it reports coverage it does not have.

## Nothing dropped: the terminal states of a finding

The same discipline governs the output of reviews, audits and sweeps. **Every finding ends in a
terminal state**, and there are exactly four:

| State | Requirement |
|---|---|
| **Fixed** | the change landed, with the exhibit committed as a fixture |
| **Refuted** | with evidence — an exhibit showing the finding was wrong, not an assertion that it was |
| **Filed** | with a **named owner** — a person or a step, never "later" |
| **Parked** | with a **trigger** — the observable condition that reopens it |

Silence is not a fifth option. Neither is "addressed in passing".

**Never hand a fix to an act that might not happen.** Flagging an out-of-scope fix is right; assigning
it to a conditional future act is a drop with a paper trail attached — it reads as disposed and behaves
as dropped. If the owning act is not certain to run, the finding is *filed with an owner*, not
*scheduled*.

**Parked items re-verify their citations when walked.** A park is a claim that some cited evidence still
holds — a section number, a fixture, a decision. Citations decay. A walk that re-reads the parked list
without re-checking what it points at converts a live park into a stale one, invisibly. Budget the
re-verification as part of the walk, and report it as done.

## Where the register lives

Two homes, chosen by what the entry is about:

- **About the shipped artifact** → in the test suite, beside the artifact. Executable, therefore
  checkable, therefore not prose. This is the default.
- **About the plan** → in the roadmap or the working-memory tree
  ([`project-knowledge-layout.md`](project-knowledge-layout.md)). Use this for gaps whose statement
  would leak planning content into a public artifact, or that have no runnable form.

If a project's planning tree is gitignored, "commit the table with the act" cannot be taken literally
for anything in it. Split on what each table is *about* rather than shrugging: the graded diagnostics
table belongs with the shipped surface (as tests), the plan-citing coverage table belongs with the plan.

## Anti-patterns

- **A register of prose.** If closing the gap does not break anything, the register is a wish.
- **"No plausible author" by reading.** See above; it fails at a measurable rate.
- **A scheduled item with no owning step.** Deferred forever, formatted as planned.
- **Emptying the register at a gate.** A gate reports what is *measured*, including what is still open.
  See [gate exit as a measured report](../phases/phase-review-template.md#gate-exit-is-a-measured-report-not-a-claim-of-completeness).

## Related

[`decision-enforcement.md`](decision-enforcement.md) (its mirror image: a decision made visible by the
check that defends it; here, a gap made visible by the check that outlives it) ·
[`quality-infrastructure.md`](quality-infrastructure.md) (a check must be watched failing — a
known-absence test is watched failing at the moment it is deleted) ·
[`refutation-by-counterexample.md`](refutation-by-counterexample.md) (findings are exhibits; parks and
refutations carry theirs) · [`act-pipeline.md`](act-pipeline.md) (where findings are graded into these
four states).
