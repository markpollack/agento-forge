# The Act Pipeline: how a change to a decided artifact gets reviewed and ratified

> The stages between "we should change the contract" and "the contract is changed" — and why the
> humans come last.

> **Provenance**: a contract-and-authoring-surface effort, July–August 2026 — ~15 change acts, the human
> stage executed twice (one RELEASE, one HOLD). **Status: PROVISIONAL** — one project.

## The unit: an act

An **act** is one reviewed, ratified, lockstep change to a decided artifact *and everything that must
move with it*. If a contract clause changes, the schema, the fixtures, the producer, the consumers, the
digests and the change ledger all move in the same act. Splitting them across commits is how a repo
ends up with a tree that is green and wrong.

The act is the unit because it is the smallest thing that can be *coherently* reviewed. Reviewing a
clause without its fixtures reviews an intention; reviewing the fixtures without the clause reviews an
implementation.

Acts are for artifacts that are **decided**: a frozen contract, a ratified design decision, a public
API. Ordinary roadmap steps do not need this pipeline — they need
[phase reviews](../phases/phase-review-template.md). Reach for the act pipeline when the change would
invalidate something previously signed off.

## The pipeline

```
   design proposal  →  cold machine review  →  fix round  →  team review  →  ratification
                         (fresh session,        (revisions      (humans, on      (one lockstep
                          restricted inputs)     retained)       the post-fix     change)
                                                                 artifact only)
```

### 1. The design proposal

A written proposal, not a patch. It states what changes, what it costs, what it does *not* touch, and —
for each new rule — what would show the rule wrong. Nothing is written into the tree yet; measurements
run in a scratchpad and the proposal records the commands that produced them.

### 2. Cold machine review

A **fresh session** with no memory of the proposal's construction, given a prompt that lists its
**restricted inputs** — the exact set of artifacts it may read.

Restricting inputs is the point, not a convenience. A reviewer allowed to read everything reconstructs
the author's reasoning and validates it. A reviewer restricted to the contract and the proposal reads
them the way an outsider will, and the gap between those two readings is the finding. (The strongest
form of this restriction is a whole protocol of its own — see
[`../guides/second-implementation-protocol.md`](../guides/second-implementation-protocol.md).)

Findings are graded **MUST / SHOULD / CONSIDER**, and every finding is falsifiable: it names the
artifact, quotes the text, and exhibits the case. A MUST without a breaking case is not a MUST — see
[`refutation-by-counterexample.md`](refutation-by-counterexample.md).

### 3. The fix round

Two rules, and both are about keeping the record honest.

**Prior revisions are retained UNEDITED under a supersede banner.** The r2 document does not overwrite
r1; it sits beside it, and r1 gains a header saying what superseded it and when. The reason is
mechanical: the review's findings cite r1 by line, and editing r1 makes every one of those citations
lie. This is [records discipline](project-knowledge-layout.md#records-discipline-a-record-is-appended-to-never-rewritten)
applied at the review seam.

**The best discharge of a finding is refuting it, not patching it.** A fix round that accepts every
finding is a fix round that was not reading. A finding can be wrong — about the artifact, about the
constraint, about what the contract already says — and a refutation with its exhibit is worth more than
a change, because it also corrects the reviewer's model for the next round. Grade each finding as
*fixed* / *refuted, with the exhibit* / *filed with a named owner* / *parked with a trigger*, and none
of those is silence (see [`registers-of-absence.md`](registers-of-absence.md)).

Watch for the inverse failure: a fix round that silently re-decides something already ratified, on its
way to discharging a finding. This is what the next stage caught in practice.

### 4. Team review — of the post-fix artifact only

Humans review **after** the machine rounds have converged, never a draft.

The reason is arithmetic. A draft carrying eleven MUST-grade defects will spend the human hour on
findings a cold machine session produces for free — citation decay, numbering drift, structural
incoherence, an unsatisfiable rule. The scarce resource in the pipeline is human attention, and it is
spent on whatever is in front of it.

**Aim the humans exactly where the machine passes are structurally weak:**

| Machine reviews reliably catch | Human reviews reliably catch |
|---|---|
| citation decay, numbering drift | production war stories — what operators will actually file |
| structural incoherence, unsatisfiable rules | storage and crash behaviour under a real model |
| coverage gaps against a stated denominator | what a dashboard needs that the design never mentions |
| contradictions between two documents | what a name will teach the person who reads it first |

These are **disjoint blind spots**, not redundant layers. Machines re-derive from the tree; humans
predict the future. Observed instances: an atomicity requirement restated from a multi-row-transaction
implementation into a store-agnostic property (*"a single linearizable commit point; observers must
never see a committed settlement without the ledger advance"*) — which is what two engines on different
storage backends actually need, and which no machine pass produced; and an operational note that a run
can be logically complete while discarded work still settles, so dashboards need two counts or operators
file "complete but workers busy" bugs.

**Three mechanics that make the session work:**

- **The pack is self-contained** — a numbered reading order and a cover memo naming exactly what the
  ratifier is signing. Reviewers arriving from other work do not have a repo checked out.
- **Written reviewer instructions transplant the machine disciplines** — *cite the source, not the
  summary* · *decided ≠ open* · *findings are falsifiable* · *absence claims carry their method*.
  Without them the session re-litigates what the machine rounds already settled. With them, reviewers
  who never read the standard returned findings with recorded absence-attempts attached — "what I tried
  and failed to break" — voluntarily.
- **It is not a rubber stamp, and you should expect to see that proved.** In the two runs on record, the
  first returned RELEASE with three folded SHOULDs; the second returned HOLD with seven MUSTs, one of
  which caught the fix round quietly re-deciding an owner-ratified rule.

### 5. Ratification

One lockstep change: the artifact, its dependents, its ledger entry, its version bump. The decision
record ([`journal/`](project-knowledge-layout.md)) names what was decided, what was declined, and what
would reopen it.

## The grammar that runs through every stage

**Decided ≠ open.** Every artifact in the pack says which of its contents are settled and which are
being asked about. A reviewer who cannot tell will treat a ratified decision as a question, and the
round is spent re-deciding it.

**Reopen only with a new failure case.** A settled decision reopens on evidence of a defect or a major
missed opportunity — not on taste, and not because a new reviewer would have chosen differently. Pair
this with the finding classification the review lenses use: **(a) validates an existing decision ·
(b) additive, to the backlog with a one-line sketch · (c) would touch the signed-off artifact** — and
only (c) reopens anything.

**Scope is stated as an exclusion, not implied.** Every prompt in the pipeline carries an explicit
*out of scope* list, so nothing folds in. An unstated boundary is an invitation.

## The owner is inside the system, not above it

The human who convenes the review and signs the ratification is a participant in the pipeline, subject
to the same discipline. Three rules earned this section.

**Standards apply to the acts that mint them.** A new rule is tested first against the document that
introduces it. When a "no declaration without a reader" rule was minted, the honest application killed
several of the minting act's own proposed members. If the rule cannot survive its own document, the
rule is wrong — not exempt. Writing a special case at that moment hides the inadequacy where nobody
will find it again.

**Stop on a contradiction; frame the branches.** When two authorities conflict — the contract says one
thing, a ratified decision another — the move is to surface it with each branch's consequences worked
out, not to pick the plausible one and proceed. A silently resolved contradiction is indistinguishable
from a resolved one until it costs a week. This is the one place in the pipeline where blocking is
correct.

**A research input is not a mandate.** A commissioned research document, a survey, a recommendation
table — each row is verified against reality as it lands, not adopted because it was commissioned. In
one 27-row input, two rows were wrong, and both were findable only by running the thing rather than
reading about it. A contradiction found this way is a finding, and it is corrected back into the source
document.

## Anti-patterns

- **Reviewing a draft with humans.** The single most expensive mistake available here.
- **Editing a superseded revision.** It silently invalidates every finding that cites it.
- **Accepting every finding.** A fix round with no refutations was transcription, not review.
- **Bundling a record correction into a decision act.** A correction to the record is its own act, timed
  to the evidence that makes it strong — otherwise it rides in on a decision reviewed for something else.
- **Letting one act quietly decide another's substance.** When two in-flight acts collide on a name or a
  seam, reserve by name and let each keep its own decision — see
  [`vocabulary-law.md`](vocabulary-law.md).

## Related

[`review-lenses.md`](review-lenses.md) (which lens to point at which stage) ·
[`refutation-by-counterexample.md`](refutation-by-counterexample.md) (the evidence standard every stage
runs on) · [`conversational-review.md`](conversational-review.md) (the lighter discovery-phase cousin —
no severity tiers, no ratification) ·
[`../phases/phase-review-template.md`](../phases/phase-review-template.md) (the Phase-4 stage gate, for
ordinary implementation work) · [`session-handoff.md`](session-handoff.md) (how each stage's prompt is
dispatched to a fresh session).
