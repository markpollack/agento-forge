# Provisional Review Control Loop Protocol

## 1. Declare authority and the review question

Before authoring or review, record:

- the authoritative VISION, DESIGN, ROADMAP, subsidiary decisions, and external dependencies;
- which decisions are settled, which are proposed, and what evidence is allowed to reopen them;
- the exact review question, in-scope artifacts, exclusions, and selected lenses;
- the project repository SHA and steward repository SHA or working-tree snapshot being examined.

Contradictory authorities stop the loop long enough to frame and decide the branches. A reviewer must
not silently choose the most plausible document.

## 2. Freeze a candidate

A candidate must remain immutable while findings cite it. Use both mechanisms:

1. a Git commit or tag for byte integrity; and
2. a numbered candidate record (`candidate-01`, `candidate-02`) for human legibility.

The numbered record is a **materialized review bundle**, not merely a manifest that requires the
reviewer to reconstruct files from Git. Its default layout is:

```text
plans/reviews/<review-id>/candidate-NN/
├── README.md                 # identity, standing, source references, and bundle inventory
├── VISION.md                 # exact frozen copy of the active Vision
├── DESIGN.md                 # exact frozen copy of the active Design
├── ROADMAP.md                # exact frozen copy of the active Roadmap
├── CORRECTIONS.md            # finding-to-candidate exhibit map from the prior adjudication
├── decisions/                # exact copies of decisions needed to interpret this candidate
└── project-inputs/           # exact copies of external/project-owned supporting inputs
```

`README.md` declares that the copies are immutable review records, not competing authorities. It maps
each copy to its authoritative source path and source repository commit. The candidate tag protects
the committed bundle as one tree. Per-file hashes are not required for tracked files already contained
in that tree; an external project commit is sufficient provenance for tracked project inputs. Reserve
digests for untracked inputs or claims whose subject is byte identity.

The reviewer reads ordinary files in `candidate-NN/`. Routine review must not require repeated
`git show`, a linked worktree, or Git history navigation. One tag/commit preflight may establish bundle
integrity; Git diff remains an optional challenge tool for a specific provenance claim. Human-readable
comparison may use the numbered bundles and `CORRECTIONS.md` directly.

A manifest-only candidate is an exception for a genuinely large or non-copyable input set. It must
record why materialization is impractical and the expected reviewer cost. Agent Judge Candidates 01
and 02 are grandfathered pilot records and remain immutable; their Git-heavy verification is evidence
for this rule, not a reason to rewrite them.

A mutable filename alone is not a review candidate. Prior candidates and received reviews are records:
append a supersession note outside the frozen bundle; never rewrite their substance.

Committing a candidate does not mean the documents are finished. It means only: **these are the exact
bytes under review**. Review branches and candidate commits may be squashed later, but received review
and adjudication records remain in the private steward history.

## 3. Run independent sensors

Use a fresh reviewer with restricted, declared inputs. Author self-review is useful but correlated with
the generating context; it is not the independent sensor.

Each review lens reports two things:

- **findings**, each with a falsifiable exhibit; and
- **non-findings**, as recorded searches that another reviewer can evaluate or extend.

Every lens also reports its **denominator**: the finite space it claims to have walked. Examples are
`12/12 vision promises traced`, `9/9 roadmap exit criteria tested for satisfiability`, or `7/7 affected
public API members checked`. The denominator is not the number of MUST/SHOULD findings. Open-ended
adversarial work cannot claim completeness; it reports the scenario families attempted instead.

Severity is not authority. A MUST without a breaking case is downgraded until its exhibit exists.

### Evidence proportionality

Use the least expensive evidence that distinguishes the states relevant to the claim. More evidence is
not automatically better; irrelevant precision consumes time and obscures the decision.

| Claim being tested | Normally sufficient evidence |
|---|---|
| Which released dependency is declared | build-file coordinate and version |
| Which dependency Maven actually resolved, when disputed | dependency-tree/effective-model output |
| Which immutable review candidate was examined | Numbered materialized bundle plus its single Git tag/commit |
| Whether two artifacts under one mutable coordinate contain the same bytes | digest comparison |
| Whether behavior satisfies a rule | executable counterexample or regression test |

Do not checksum ordinary versioned dependencies or tracked candidate-bundle files prophylactically.
Reserve byte digests for claims about byte identity—especially local installations, snapshots, mutable
artifacts, untracked inputs, or an explicit provenance investigation. Evidence should answer the
finding's question, not demonstrate that the reviewer can collect stronger-looking measurements.

## 4. Adjudicate before correcting

The author or a separate adjudicator reproduces every finding against the frozen candidate and standing
decisions. Keep two states separate:

- **Adjudication result**: reproduced, partially reproduced, refuted, or owner decision required.
- **Closure state**: accepted-open, fixed, refuted, filed, or parked.

`Accepted-open` is deliberately non-terminal. It means the defect was reproduced and admitted to the
bounded correction round. Calling it `fixed` before the next candidate exists would make the ledger
claim an intervention that has not happened. After correction and verification, every item reaches
exactly one terminal state:

| State | Required evidence |
|---|---|
| Fixed | accepted defect, bounded correction, and regression exhibit where executable |
| Refuted | an exhibit showing why the finding does not hold |
| Filed | a named owner or roadmap step |
| Parked | an observable trigger that reopens it |

Adjudication distinguishes measurement from intervention. It may downgrade severity, reject a proposed
remedy while accepting the defect, or identify that a finding belongs to another repository. Silence,
"handled," and "later" are not dispositions.

### Human checkpoint before correction

Adjudication is a control seam, so its output begins with a short human checkpoint before detailed
evidence. The checkpoint states current state, why work stopped, established facts, owner decisions
with recommended defaults, what changed and did not, review coverage in plain counts, and the next
authorized action.

This is a view into the adjudication ledger, not a second authority. It points to detailed findings and
does not restate project decisions. Method records may call the total inventory a *denominator*;
human-facing checkpoints translate it as, for example, `122/122 roadmap clauses examined`. The count
describes the declared space walked, not how many items passed and not proof that an open-ended search
found every possible issue.

Use unambiguous control states: `CORRECTIONS REQUIRED`, `HOLD`, or `READY FOR VERIFICATION`. Do not use
`CORRECT`, which can be misread as either an instruction or a claim that the candidate is correct.

## 5. Apply bounded correction

Correct only accepted findings and consequences required for coherence. Do not opportunistically reopen
settled decisions, fold in unrelated cleanup, or adopt every reviewer preference. One correction round
produces the next candidate; it does not edit the reviewed candidate in place.

This is the control-gain rule: enough intervention to remove demonstrated error, not enough to make the
documents chase each new reviewer's style.

## 6. Verify and ratify

A fresh reviewer checks the new candidate, the adjudication ledger, and the accepted correction scope.
The loop can exit when:

- all findings are reproduced or refuted;
- zero reproduced blocking findings remain;
- owner decisions are resolved, filed, or parked with explicit triggers;
- each selected lens reports its denominator or attempted scenario families;
- the corrected candidate is frozen;
- a fresh verification review finds no new structural blocker; and
- pilot measurements are recorded.

Human ratification decides whether to execute, merge, or reopen. The setpoint is **decision readiness
with known residual risk**, not zero reviewer comments.

### Ratification-to-execution transition

Ratification and execution authorization are separate control decisions. A positive verification does
not authorize implementation, and ratifying a planning candidate does not silently choose a worker or
start a roadmap step.

After verification reports `READY TO RATIFY`, the controller performs this sequence:

1. Commit the verification record exactly as received; do not edit sensor output while accepting it.
2. Wait for an explicit human candidate decision: `RATIFIED`, `REOPEN`, or `REJECTED`.
3. Record that decision in `ratification-NN.md`, naming the candidate tag and verification record.
   Record execution authorization separately as `NOT AUTHORIZED` or as one exact roadmap step.
4. If an execution step is authorized, instantiate one bounded implementation work order from
   `templates/IMPLEMENTATION-WORK-ORDER-TEMPLATE.md`. It points to the ratified candidate, roadmap
   step, decisions, mutation roots, evidence obligations, and stopping checkpoint; it does not restate
   their substance.
5. Update canonical `AGENTS.md` so its current-action section points to that work order. Tool-specific
   files such as `CLAUDE.md` remain minimal bridges to `AGENTS.md` and do not duplicate the dispatch.
6. Commit the ratification, work order, and current-action pointer as controller state. Report that no
   implementation occurred.
7. Launch a fresh implementation session with a one-line pointer to the steward's agent instructions.
   The implementer stops at the work order's completion checkpoint; it does not self-ratify its result.

The worker may be a different model from the author or verifier. That provides a useful independent
implementer perspective and tests whether the plan is executable across contexts, but it is not an
independent verification sensor. A later review still evaluates the implementation evidence.

The lifecycle states are explicit:

```text
FROZEN CANDIDATE
      -> VERIFIED: READY TO RATIFY
      -> RATIFIED / EXECUTION NOT AUTHORIZED
      -> RATIFIED / STEP N AUTHORIZED
      -> IMPLEMENTATION CHECKPOINT
      -> VERIFIED STEP EVIDENCE or BOUNDED CORRECTION
```

## 7. Handoffs and cross-repository work

A handoff points; it does not restate.

> Read decision `D-17` in DESIGN and execute ROADMAP Step `2.3`.

An incoming handoff is triaged once:

- pointer-only: archive or delete after delivery;
- evidence: promote to research or attach to a finding;
- decision: ratify into DESIGN/journal, then archive the handoff;
- pending work: add to ROADMAP with an owner, then archive the handoff.

For cross-repository dependencies, the owning steward records the obligation and the consuming steward
records the dependency. Neither repository silently claims it can satisfy the other's exit criterion.

## 8. Steward repository invariants

- One project repository maps to exactly one private steward repository.
- The steward binding names the project remote, local checkout, default branch, and authority boundary.
- Active planning filenames are singular and stable: `plans/VISION.md`, `plans/DESIGN.md`, and
  `plans/ROADMAP.md`.
- Reviews, candidate records, adjudications, journals, and learnings are tracked; `plans/` is never
  gitignored in the private steward.
- Public project files may temporarily mirror or point to steward documents during migration, but the
  binding names one authority and a deadline/step for removing transition mirrors.
- Code changes occur in the project repository. Steward commits may update planning, evidence, and work
  orders, but never masquerade as implementation commits.

## 9. Reusable work orders

The reusable unit is a **work-order contract**, not a copied project prompt. It has four stable parts:

1. **Input contract** — ordered authoritative inputs and the immutable candidate identity.
2. **Authority contract** — settled decisions, reopening rule, and evidence ownership.
3. **Mutation contract** — allowed evidence roots, permitted outputs or path families, and explicit
   exclusions.
4. **Completion contract** — required ledger fields, coverage denominators, stop conditions, and the
   decision brief.

The work order points to project decisions; it never restates them. Project-specific facts belong in
the binding, candidate-bundle README, and active documents. The work order may name a protected
decision by identifier and say what evidence can reopen it, but it must not paraphrase the decision's
substance.

Keep instructions separate from results:

```text
templates/ADJUDICATION-WORK-ORDER-TEMPLATE.md
          |
          v
plans/reviews/<review-id>/work-order-adjudication-01.md
          |
          v
plans/reviews/<review-id>/adjudication-01.md

templates/VERIFICATION-WORK-ORDER-TEMPLATE.md
          |
          v
plans/reviews/<review-id>/work-order-verification-02.md
          |
          v
plans/reviews/<review-id>/verification-02.md

templates/RATIFICATION-TEMPLATE.md
          |
          v
plans/reviews/<review-id>/ratification-02.md

templates/IMPLEMENTATION-WORK-ORDER-TEMPLATE.md
          |
          v
plans/work-orders/<work-order-id>.md
          |
          v
project commit + steward implementation record/checkpoint
```

Each flow keeps its reusable template, filled dispatch/decision record, and produced evidence separate.
Templates define lifecycle contracts; project records bind those contracts to exact candidates,
roadmap steps, repositories, and outputs.

### Automation maturity

Use progressive extraction rather than immediately building an orchestrator:

| Level | Mechanism | Promotion evidence |
|---|---|---|
| 1 — current | Materialized candidate bundles plus filled Markdown adjudication, verification, ratification, and implementation-dispatch templates | Agent Judge completes one full planning loop and one dispatched implementation step without prompt repair |
| 2 | Deterministic generator from candidate/review metadata | Agent Workflow needs the same fields with only values changed |
| 3 | Forge command or skill with preflight validation | At least three clean uses establish stable inputs and stop rules |
| 4 | Automated review controller | Pilot measurements show orchestration, rather than judgment, is the recurring bottleneck |

Do not encode project judgment into a generator. Automation may copy exact bundle inputs, inventory
paths, verify the single candidate ref, validate mutation boundaries and required fields, and enforce
lifecycle transitions; adjudication remains evidence-bearing work.
