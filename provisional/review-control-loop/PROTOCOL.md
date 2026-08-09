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

For a verified grandfathered candidate, the controller may certify the unchanged active trio as the
implementation session's ordinary-file planning view. The controller performs the equivalence check
once and records it in ratification/dispatch state; the implementer does not repeat the candidate's
Git reconstruction. If the active trio has changed since verification, create a new materialized
candidate rather than claiming equivalence.

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
   `templates/IMPLEMENTATION-WORK-ORDER-TEMPLATE.md`. It is a thin dispatch envelope pointing to the
   ratified candidate, exact roadmap step, mutation roots, evidence destination, and stopping
   checkpoint. It does not restate design semantics, roadmap work items, exit criteria, or the human
   decision.
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
      -> ROADMAP CONTROLLER CHECKPOINT
      -> HUMAN AUTHORIZATION, BOUNDED CORRECTION, or HOLD
```

## 7. Control a completed roadmap step

An implementer reports evidence and stops; it does not decide that its own work is accepted or that
the next roadmap step may begin. An **AI Roadmap Controller** assists the human Project Owner at every
implementation checkpoint. This is a continuity and control role, not an independent-review claim.

The Roadmap Controller:

1. identifies both repositories explicitly and records the project and steward commits being
   examined—never an unqualified `HEAD`;
2. checks the completed step's evidence against its entry conditions, work boundary, and exit
   criteria, reproducing high-value evidence in proportion to risk;
3. checks repository status, the implementation diff, and preserved unrelated changes;
4. sweeps VISION, DESIGN, ROADMAP, `AGENTS.md`, tool-specific bridges, current baselines, and learning
   indexes for current-state claims made stale by the completed step;
5. checks trajectory: whether the result still advances the Vision, preserves settled Design, and
   leaves the next roadmap step correctly ordered and executable;
6. classifies every discovery as a bounded planning-currency correction, an implementation defect, a
   new or reopened owner decision, or explicitly deferred work with an owner/trigger; and
7. writes a checkpoint using `templates/ROADMAP-CONTROLLER-CHECKPOINT-TEMPLATE.md` and presents one
   exact next human decision.

The controller may directly apply bounded planning-currency corrections that only make authoritative
documents truthfully describe already accepted evidence. It must not use that permission to change
product semantics, broaden scope, rewrite historical evidence records, or begin the next step. A new
design choice goes to the human/adjudication; a behavior defect goes to bounded correction; genuinely
deferred work receives a named roadmap owner or observable reopening trigger.

The controller emits one of three recommendations:

- `STEP ACCEPTED` — exit evidence holds and any bounded currency corrections are recorded;
- `CORRECTION REQUIRED` — the completed step has a reproducible defect or unmet exit; or
- `HOLD` — authority conflicts or an owner decision prevents safe continuation.

`STEP ACCEPTED` does not authorize the next step. The Project Owner separately accepts or rejects the
controller recommendation and authorizes at most one next roadmap step. Only then may the controller
prepare the next thin dispatch.

An independent implementation reviewer is an optional additional sensor selected by risk, novelty,
or owner request. The Roadmap Controller can request that review, but its persistent project context
means it must not represent itself as the independent sensor.

## 8. Handoffs and cross-repository work

A handoff points; it does not restate.

> Read decision `D-17` in DESIGN and execute ROADMAP Step `2.3`.

An implementation work order follows the same rule. Its normal size is one readable page. It contains
only transient dispatch facts that do not belong in standing authorities: authorization identity,
exact step pointer, execution planning view, mutation boundary, known working-tree exception, evidence
destination, and stop point. If a worker needs substantive behavior, sequence, or completion criteria
that the roadmap/design does not provide, correct the authoritative document before dispatch; do not
hide the missing specification in the work order.

An incoming handoff is triaged once:

- pointer-only: archive or delete after delivery;
- evidence: promote to research or attach to a finding;
- decision: ratify into DESIGN/journal, then archive the handoff;
- pending work: add to ROADMAP with an owner, then archive the handoff.

For cross-repository dependencies, the owning steward records the obligation and the consuming steward
records the dependency. Neither repository silently claims it can satisfy the other's exit criterion.

## 9. Steward repository invariants

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

## 10. Reusable work orders

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

For implementation dispatch, the four contracts remain compact:

- **Input:** exact ratification, planning view, and roadmap-step pointers;
- **Authority:** authority order and stop-on-conflict rule, without semantic restatement;
- **Mutation:** permitted repositories/path families plus transient dirty-state exceptions;
- **Completion:** evidence destination and stop point, by reference to the roadmap exits.

Duplicating roadmap bullets, design truth tables, human authorization prose, generic Git procedure,
or an independent completion checklist is a dispatch defect because it creates a second plan that can
drift. `AGENTS.md` points to the dispatch; it does not cause the dispatch to absorb `AGENTS.md`, the
ratification record, or the roadmap.

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
project commit + steward implementation record
          |
          v
templates/ROADMAP-CONTROLLER-CHECKPOINT-TEMPLATE.md
          |
          v
plans/checkpoints/<step-id>-roadmap-controller.md
```

Each flow keeps its reusable template, filled dispatch/decision record, and produced evidence separate.
Templates define lifecycle contracts; project records bind those contracts to exact candidates,
roadmap steps, repositories, and outputs.

### Automation maturity

Use progressive extraction rather than immediately building an orchestrator:

| Level | Mechanism | Promotion evidence |
|---|---|---|
| 1 — current | Materialized candidate bundles plus filled Markdown adjudication, verification, ratification, implementation-dispatch, and roadmap-controller templates | Agent Judge completes one full planning loop and two controlled implementation checkpoints without prompt repair |
| 2 | Deterministic generator from candidate/review metadata | Agent Workflow needs the same fields with only values changed |
| 3 | Forge command or skill with preflight validation | At least three clean uses establish stable inputs and stop rules |
| 4 | Automated review controller | Pilot measurements show orchestration, rather than judgment, is the recurring bottleneck |

Do not encode project judgment into a generator. Automation may copy exact bundle inputs, inventory
paths, verify the single candidate ref, validate mutation boundaries and required fields, and enforce
lifecycle transitions; adjudication remains evidence-bearing work.
