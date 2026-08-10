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

### Escalate review strength by stage

Do not begin every artifact review with the most expensive model and maximum reasoning. Select a
review profile from the decision stage:

| Profile | Use | Sensor selection | Expected loop |
|---|---|---|---|
| `ITERATIVE` | While Vision, Design, Roadmap, or a correction is still developing | A capable, responsive model at its normal or high reasoning tier | Review, discuss, correct, and repeat while structural findings remain useful |
| `FINAL` | After the candidate is frozen and before ratification or execution authorization | The strongest suitable independent single-reviewer configuration currently available; use distinct model families or vendors when the decision warrants multiple sensors | Run each sensor cold against identical inputs, then adjudicate their durable reports |

The escalation is deliberate: inexpensive iterations remove ordinary defects before scarce final-pass
attention is spent. `FINAL` does not mechanically mean a flag named `max`; select the strongest tier
that preserves the declared single-reviewer boundary and record the choice. A nominally stronger mode
that silently delegates to subagents is a different sensor topology, not a drop-in tier increase.
Exact vendor and model names belong in the generated launcher and handoff record because availability
changes; they do not belong in this reusable protocol. The pilot's dated operator defaults live in
`PILOTS.md` so agento-university has a concrete profile to resolve without turning it into doctrine.

### Materialize the cold-review handoff

For a CLI reviewer, make the launch itself a small, inspectable artifact. Create one persistent
directory per reviewer containing a read-only `input/` view, a reviewer-local `run-review.sh`, and the
eventual `REVIEW.md`. Do not use a temporary directory for the only copy of review output. When
several reviewers examine the same candidate, derive every `input/` view from one frozen canonical
packet and keep their output directories separate.

The launcher pins the CLI, model, reasoning tier, permission/configuration mode, and exact pointer
prompt. That prompt should normally say only: read the review work order in `input/`, write
`REVIEW.md` here, and stop. The work order owns the substantive review contract. The launcher:

1. resolves and enters its own directory so invocation location cannot change the result paths;
2. refuses to overwrite an existing review;
3. verifies the frozen input before launch and after completion when the packet has a manifest or
   equivalent integrity check;
4. invokes one fresh, non-resuming reviewer with the recorded configuration;
5. requires a non-empty persistent output at the declared path; and
6. records enough version/configuration evidence to reproduce which sensor was selected.

Validate the wrapper without launching it, then give the owner or designated operator the one-line
launcher. Do not monitor or steer a cold reviewer after launch; a failed run remains a failed sensor
run and is relaunched from a clean reviewer directory. The wrapper is an auditable handoff and
capture mechanism, not a security boundary: read-only permissions, sandboxing, allowed roots, and
network policy still enforce the mutation and evidence boundary. Use
`templates/COLD-REVIEW-LAUNCHER-TEMPLATE.md` as the checklist and shell skeleton.

An authoring product implementing this protocol should expose these as two simple actions—iterative
review and final review. For either action it freezes the selected ordinary-file packet, resolves the
current recommended reviewer configuration, creates one persistent directory and launcher per
reviewer, and presents the launch commands. It does not silently launch reviewers, combine their
findings, or mutate the authored Vision/Design/Roadmap. Those remain explicit owner and adjudication
transitions. This is the provisional integration contract for the agento-university artifact-authoring
and Roadmap Steward experience.

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
5. Record the authorized step and work-order pointer in ROADMAP/ratification controller state. Do not
   put the current action into `AGENTS.md`; tool-specific files such as `CLAUDE.md` remain minimal
   bridges and do not duplicate the dispatch.
6. Commit the ratification, work order, and roadmap transition as controller state. Report that no
   implementation occurred.
7. Launch a fresh implementation session with a one-line pointer to the steward binding and named
   work order.
   The implementer stops at the work order's completion checkpoint; it does not self-ratify its result.

The worker may be a different model from the author or verifier. That provides a useful independent
implementer perspective and tests whether the plan is executable across contexts, but it is not an
independent verification sensor. A later review still evaluates the implementation evidence.

### Provisional worker state versus controller authority

At its stopping checkpoint, the implementer may check roadmap work items and exit criteria for which
it has recorded evidence, change the step status to `IMPLEMENTED — ACCEPTANCE PENDING`, and add the
new evidence pointer. These edits are provisional claims submitted with the implementation, not
self-acceptance. Keeping them beside the implementation evidence is useful because the worker has the
freshest command and mutation context.

The implementer must leave controller-only acceptance unchecked, must not mark the step accepted,
must not authorize a later step, and normally does not reconcile VISION/DESIGN current-state prose.
The Roadmap Controller reviews the worker's roadmap edits like every other exhibit, corrects planning
currency, and owns the transition recommendation. “Controller-owned” therefore
means decision authority and verification, not exclusive authorship of every state-bearing file.

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

1. performs the steward **inbox preflight**: synchronize the gitmaildir transport, inventory every
   unclaimed `plans/inbox/new/<type>/` message by ID/correlation/sender/age/requested outcome, and
   disposition any message that can affect acceptance, sequencing, or the next dispatch; ordinary
   Forge intake under an effort-local inbox remains a separate stage-boundary concern;
2. identifies both repositories explicitly and records the project and steward commits being
   examined—never an unqualified `HEAD`;
3. checks the completed step's evidence against its entry conditions, work boundary, and exit
   criteria, reproducing high-value evidence in proportion to risk;
4. checks repository status, the implementation diff, and preserved unrelated changes;
5. sweeps VISION, DESIGN, ROADMAP, current baselines, and learning indexes for current-state claims
   made stale by the completed step, and checks that `AGENTS.md` and tool-specific bridges contain no
   transient controller or session state;
6. promotes newly proved, reusable operational knowledge—recurring verification commands, quality
   invariants, and diagnostic pitfalls—into the canonical project or steward `AGENTS.md`; record the
   shortest durable rule, not the step transcript, and keep tool-specific bridges as pointers;
7. checks trajectory: whether the result still advances the Vision, preserves settled Design, leaves
   the next roadmap step correctly ordered and executable, and preserves every named downstream
   milestone whose prerequisites the current step could accidentally erase;
8. classifies every discovery as a bounded planning-currency correction, an implementation defect, a
   new or reopened owner decision, or explicitly deferred work with an owner/trigger; and
9. writes a checkpoint using `templates/ROADMAP-CONTROLLER-CHECKPOINT-TEMPLATE.md` and presents one
   exact next human decision.

The checkpoint is a **thin control-transition record**, normally one readable page. It points to the
roadmap and implementation evidence; it does not restate design semantics, roadmap criteria, test
transcripts, changed-path inventories, or discoveries already preserved in the step learning record.
If the supporting evidence is incomplete, correct that evidence record rather than copying the
missing report into the checkpoint. Like a thin implementation dispatch, an oversized controller
checkpoint can become a competing roadmap or implementation report.

The controller may directly apply bounded planning-currency corrections that only make authoritative
documents truthfully describe already accepted evidence. It must not use that permission to change
product semantics, broaden scope, rewrite historical evidence records, or begin the next step. A new
design choice goes to the human/adjudication; a behavior defect goes to bounded correction; genuinely
deferred work receives a named roadmap owner or observable reopening trigger.

Operational-knowledge promotion is bounded by the same rule. Promote a command only after it has
proved useful and executable in the project, and promote an invariant only after the build or evidence
supports it. Do not turn one incident into a universal technology prescription: for example, a Java
project may record its exact Javadoc and release-rehearsal commands, while the generic method records
only the obligation to preserve newly discovered recurring gates in canonical agent instructions.

The controller emits one of three recommendations:

- `STEP ACCEPTED` — exit evidence holds and any bounded currency corrections are recorded;
- `CORRECTION REQUIRED` — the completed step has a reproducible defect or unmet exit; or
- `HOLD` — authority conflicts or an owner decision prevents safe continuation.

### Correction-required transition

`CORRECTION REQUIRED` reopens the completed step; it does not authorize the next step and does not
send the original implementation report back as an informal prompt. The correction path is:

```text
IMPLEMENTATION CHECKPOINT
      -> ROADMAP CONTROLLER: CORRECTION REQUIRED
      -> HUMAN ACCEPTS OR REJECTS THE BOUNDED CORRECTION
      -> AUTHORITY DOCUMENTS UPDATED, WHEN SEMANTICS OR SCOPE CHANGED
      -> THIN CORRECTION DISPATCH
      -> CORRECTED IMPLEMENTATION CHECKPOINT
      -> NEW ROADMAP CONTROLLER CHECKPOINT FOR THE SAME STEP
```

The controller records the reproduced defect, affected exit criterion, and smallest coherent
correction boundary. If the defect exposes a new product choice, that choice is ratified in DESIGN or
the journal before dispatch. If the existing decision was right and only implementation was wrong,
the checkpoint and ROADMAP correction block are sufficient authority.

Use the implementation work-order template in `BOUNDED CORRECTION` mode. The dispatch points to the
controller checkpoint, the accepted decision, and the reopened ROADMAP step; it does not copy the
finding, replacement design, or revised exit criteria. The correction implementer writes a new
evidence record or a dated correction beside the prior record. Historical implementation evidence is
not rewritten to claim that the first attempt was correct.

Until the new controller checkpoint is accepted, the step remains open and every later roadmap step
remains unauthorized. A correction may file consequences in another repository, but it cannot mark
that repository's work complete.

`STEP ACCEPTED` does not authorize the next step. The Project Owner separately accepts or rejects the
controller recommendation and authorizes at most one next roadmap step. Only then may the controller
prepare the next thin dispatch.

Record that response in the same controller checkpoint by changing its human-decision field from
`PENDING` to the received decision and naming any one authorized next step. This closes the transition
without creating a separate ad hoc authorization document. Do not alter the controller's earlier
recommendation or evidence summary while recording the response.

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

### Inter-steward delivery through `plans/inbox/`

The project-knowledge layout binds gitmaildir's work directory to the recipient steward's `plans/`.
The actual delivery path is `plans/inbox/new/<type>/<id>.json`, followed by the standard `cur`,
`archive`, or `dead` transitions and `plans/audit/events.jsonl`. Use
`templates/INTER-STEWARD-MESSAGE-TEMPLATE.md` for the message payload. The transport artifact is a
gitmaildir `MailboxMessage` JSON record, not a Markdown handoff, not an authority, and not a miniature
specification.

#### Inbox-preflight cadence and authority promotion

A repository does not notice mail by itself. The **controller process** notices it. Every Roadmap
Controller or planning session performs an inbox preflight at session entry and again immediately
before dispatching a new roadmap step. Stage consolidation still performs the broader zero-inbox
triage over ordinary Forge intake. A bounded implementation session does **not** poll or triage the
inbox; new work cannot silently alter its mutation boundary.

Keep three operations distinct:

1. **Receive/sense** — synchronize transport state and report the finite inventory of unclaimed
   message IDs and correlations. This is mechanical and may later be automated.
2. **Triage/disposition** — the Roadmap Controller reproduces the pointer, classifies the request, and
   records exactly one recipient-owned disposition. This is governance and is not delegated to the
   transport.
3. **Promote/archive** — accepted work becomes a named ROADMAP obligation with an owner and target or
   observable trigger; a decision input becomes a journal/DESIGN record; a refutation or park gets
   its own exhibit/trigger. Only after that authority exists does the handler archive the message and
   return a receipt.

The roadmap never says merely "read message X." It states the accepted obligation and cites the
correlation as provenance. `FILED` means accepted as recipient-owned work and therefore requires a
named roadmap home; it does not mean prioritized next. A receipt closes the sender's routing
obligation, not the recipient's implementation obligation.

The sender records both a durable correlation ID and the generated gitmaildir message ID in its
checkpoint, roadmap dependency, or journal. The recipient's idempotent handler owns disposition:

- accept as work: create or amend a named ROADMAP item with an owner, then archive the message;
- accept as a decision input: ratify the decision in DESIGN/journal, then archive the message;
- refute: record the counter-exhibit and archive the message;
- park: record the observable reopening trigger and archive the message.

An inbox item is never completion evidence. The recipient's roadmap, journal, or refutation record is
the authority. After recording that disposition, the recipient sends a new `steward-receipt` message
whose payload carries `inReplyTo`, `disposition`, and the resulting authority pointer; it never edits
the received message. The handler may then return successfully so gitmaildir archives the transport
record. A sender may close its routing obligation from that receipt, but it must not edit the
recipient's priority or claim acceptance on the recipient's behalf.

gitmaildir processing is at least once across a crash between handler completion and archive push.
The handler therefore keys disposition and receipt deduplication by the original message ID or
correlation ID.

When the recipient's 1:1 private steward does not yet exist, record the outbound message as pending
with that steward boundary as its delivery trigger. Do not create a new transitional authority in a
project repository immediately before steward migration merely to make delivery appear complete.

## 9. Steward repository invariants

- One project repository maps to exactly one private steward repository.
- The steward binding names the project remote, local checkout, default branch, and authority boundary.
- Active planning filenames are singular and stable: `plans/VISION.md`, `plans/DESIGN.md`, and
  `plans/ROADMAP.md`.
- Reviews, candidate records, adjudications, journals, and learnings are tracked; `plans/` is never
  gitignored in the private steward.
- The public project's tracked `AGENTS.md` is a minimal, stable repository interface: ownership
  boundary, steward-binding pointer, durable build rules, confidentiality/licensing constraints, and
  links to maintained engineering standards. It contains no current action, candidate or artifact
  identity, roadmap status, work-order pointer, pending decision, checkpoint state, or dirty-tree
  exception.
- The steward's `AGENTS.md`, when present, follows the same stability rule. Operational state belongs
  in ROADMAP, ratification, dispatch, checkpoint, and evidence records; a fresh-session prompt points
  directly to the binding and authorized dispatch.
- A steward `AGENTS.md` may state the stable obligation that Roadmap Controller and planning sessions
  perform the inbox preflight defined by the steward binding. It never names a current message,
  correlation, disposition, or inbox depth. The binding owns transport paths and invocation details;
  controller records own each observed inventory and disposition.
- Tool-specific files such as `CLAUDE.md` are optional minimal bridges to `AGENTS.md`; they do not
  carry private planning or current-action state.
- Public project files may temporarily mirror steward documents during migration only when the
  binding names one authority and a deadline/step for removing those mirrors. `AGENTS.md` remains an
  interface, never a planning mirror.
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
drift. The launch instruction points to the dispatch; `AGENTS.md` stays stable and does not point at
the current dispatch or absorb the ratification record or roadmap.

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
<persistent-review-root>/<reviewer>/run-review.sh
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

templates/INTER-STEWARD-MESSAGE-TEMPLATE.md
          |
          v
recipient-steward/plans/inbox/new/steward-follow-up/<message-id>.json
          |
          v
recipient ROADMAP / journal / refutation + steward-receipt + archived transport record
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
