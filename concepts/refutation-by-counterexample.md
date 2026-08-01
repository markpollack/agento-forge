# Refutation by Counterexample: findings are exhibits, non-findings are recorded searches

> The review currency that does not ask to be trusted.

> **Provenance**: named and codified during a contract-and-authoring-surface effort, July–August 2026.
> **Status: PROVISIONAL** — one project, but the technique's own record spans ~15 reviewed change acts,
> five human review sessions, and two independent audit passes.

## The principle

**A finding is an exhibit, not an assessment.** A document that validates when it should not. A program
that compiles into the wrong graph. Two lines of a specification that contradict each other, quoted. A
list of seven vendors where a claim asserted seven and the grep found two.

The alternative — a completeness argument — is expensive to produce, expensive to check, and wrong in
ways nobody can see. A counterexample is cheap to produce, **self-verifying for the receiver** (run the
document, compile the program, read the two lines), and wrong in ways that are immediately visible.

That last property is the whole reason. Reviews are performed by fallible narrators, machine or human.
An argument's value depends on trusting the narrator; an exhibit's does not. In a pipeline where a
session with no memory of yesterday reviews the work of a session with no memory of the day before, the
only findings that survive the trust gap are the ones that carry their own proof.

## Why it beats rigor here

Mathematics has settled decades-old conjectures with a single counterexample posted in a few lines.
The asymmetry is structural, not cultural: proving a universal claim requires covering a space; refuting
it requires one point in that space. Software design work is full of universal claims — *every valid
document has a producer*, *no author can reach this state*, *these two spellings mean the same thing* —
and each of them is one exhibit away from being settled.

The corollary is an allocation rule: **when a claim of completeness matters, do not fund the proof —
fund the search for its counterexample.** Adversarial passes, hostile fixtures, loop-until-dry
sweeps. Then record the search when it comes up dry (below).

## Four practice rules

**1. Review prompts ask for construction, not assessment.** *"Construct a document where the declared
class and the actual shape disagree." "Build the topology where both readings look correct." "Attack
this union with a concept it did not anticipate."* A prompt that asks *"is this design sound?"* gets
an opinion; a prompt that asks *"break it"* gets an artifact.

**2. A MUST without its breaking case is not a MUST.** Every blocking finding states the observation
that would show it wrong, and exhibits the case where it bites. A reviewer who cannot produce the case
has found a SHOULD or a CONSIDER, and should file it as one. This is a severity discipline as much as
an evidence one: the bar keeps MUST scarce and therefore meaningful.

**3. A fix is proven when the counterexample becomes a committed fixture.** Not when the code changes —
when the exhibit is checked in, running, and failing on a revert. The exhibit then outlives the argument
that produced it, and the next person to reintroduce the defect meets it as a red build rather than as
a paragraph in a design document nobody re-reads. (This is the same move as the
[graduation rule](quality-infrastructure.md#the-graduation-rule), arrived at from the other side.)

**4. A row flips only on an exhibit.** When a status table, coverage ledger, or capability matrix is
re-measured, no cell changes on reasoning alone. Reasoning is how you decide where to look for the
exhibit; it is not the exhibit.

## The pairing that keeps it honest

A counterexample regime has exactly one failure mode: **the absent counterexample read as proof.** "I
could not construct one" and "one does not exist" are different claims, and the gap between them is
where a false clean bill of health lives.

The answer is the standing companion rule — **an absence claim carries its method**:

> *"I sought a double-commit race around the n-th arrival, by enumerating the orderings in which two
> settlements could observe the same ledger cell, and found none constructible."*

not

> *"There is no race here."*

So the method has two halves, and neither is an argument:

| | Form | What makes it checkable |
|---|---|---|
| **Finding** | an exhibit | the receiver can run it |
| **Non-finding** | a recorded search | the receiver can judge whether the search *could have found* the thing |

A recorded search is falsifiable in the way that matters: a reader who knows a search the reviewer did
not run has found something, and can say so precisely.

## What this changes in practice

- **Fixture corpora become counterexample libraries.** The negative fixtures — documents that must be
  rejected, programs that must not compile — are not an afterthought to the positive ones. They are
  where the findings live.
- **Checks are watched failing.** Sabotaging a check to confirm it fires is a counterexample aimed at
  the check. See [quality-infrastructure.md](quality-infrastructure.md).
- **Disagreements terminate.** Two people arguing about whether a rule is too strict can trade positions
  indefinitely; one program that the rule wrongly refuses ends it in a minute. When a review round
  stalls, the question to ask is *what artifact would settle this?*
- **Being wrong gets cheap.** A reviewer who exhibits and is refuted by a second exhibit has lost
  nothing — the exchange produced two artifacts. A reviewer who argued and was out-argued has produced
  nothing.

## What it does not license

- **Not a licence to skip the search.** "No counterexample found" without a stated method is the failure
  mode above wearing this concept's clothes.
- **Not applicable to postures.** Some decisions are regimes, stances, or priorities with no predicate
  over any artifact ("the freeze is a stabilization, not a coronation"). They have no counterexamples
  because they make no falsifiable claim — which is exactly what
  [decision-enforcement.md](decision-enforcement.md) says about what can and cannot be defended by a
  check. Recognize them and stop looking.
- **Not a substitute for coverage.** One exhibit refutes one universal claim. Knowing that the *set* of
  claims has been walked is a different instrument — see the census discipline in
  [`phases/phase-review-template.md`](../phases/phase-review-template.md).

## Related

[`quality-infrastructure.md`](quality-infrastructure.md) (a check watched failing is a counterexample
aimed at the check) · [`review-lenses.md`](review-lenses.md) (which lens is likely to produce which
exhibit) · [`act-pipeline.md`](act-pipeline.md) (falsifiability as a grading rule for findings) ·
[`registers-of-absence.md`](registers-of-absence.md) (a proved-unreachable claim needs a program, not a
reading) · [`../guides/second-implementation-protocol.md`](../guides/second-implementation-protocol.md)
(the lens that most reliably produces exhibits before a freeze).
