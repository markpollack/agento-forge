# Pilot Register

## Agent Judge — Pilot 1

| Field | State |
|---|---|
| Project repository | `markpollack/agent-judge` (public) |
| Steward repository | `markpollack/agent-judge-steward` (private) |
| Effort | Agent Judge 0.14 closure and Agent Workflow adoption readiness |
| Initial candidate | Private steward commit `a7ea488`, tag `review/aj-014-closure/candidate-01`; reviewed trio at project HEAD `8f8391b` plus recorded working-tree state |
| Initial sensor output | `roadmap-readiness-review-2026-08-06`, 16 findings |
| Current phase | STEP 1.2 IMPLEMENTED — CORRECTION REQUIRED |
| Ratification state | Candidate 02 ratified; Steps 1.0 and 1.1 accepted; Step 1.2 correction pending |

### Initial observations

- The public project gitignored its authoritative roadmap and learnings, leaving them without history or
  backup.
- A tracked, completed root roadmap contradicted the active ignored roadmap.
- Two older ignored VISION/DESIGN documents coexist with the newer reviewed root pair. The pilot must
  classify these rather than infer authority from location or filename.
- The review contains cross-repository exit criteria that Agent Judge cannot satisfy, testing ownership
  and work-order routing.
- M5 is a settled decision with corpus evidence; review must not reopen it without a new failure case.

### Next experiment action

Dogfood the bounded correction transition against Step 1.2, including one received Agent Journal
inbox message and one Agent Workflow message held pending creation of its 1:1 steward. Candidate 02,
received sensor records, and prior implementation evidence remain immutable.

### Candidate-packaging observation

Candidates 01 and 02 used numbered manifest directories without materialized copies of the reviewed
documents. Verification therefore required repeated `git show`, per-file hash reproduction, and Git
history comparisons. Integrity held, but the human-readable-numbered-record objective did not. Future
candidates default to materialized bundles; Git remains the backing integrity boundary rather than the
reviewer's document-reading interface.

### Implementation-dispatch observation

The first Step 1.0 implementation work order expanded to 173 lines by repeating ratification, M5
semantics, roadmap work items, exit evidence, generic Git procedure, and stopping rules. Although
bounded, it became a second roadmap and violated the pointer-only handoff rule. Future implementation
work orders are thin, normally one-page dispatch envelopes; missing substantive instruction is fixed
in DESIGN or ROADMAP rather than copied into the dispatch.

### First implementation-checkpoint observation

The Step 1.0 implementer followed its bounded dispatch, preserved unrelated working-tree state, met
the named exits, and stopped before Step 1.1. It also found that active VISION/DESIGN statements and a
tool-specific session pointer still described pre-Step-1.0 state. The dispatch correctly withheld
authority to edit those surfaces, but the method had no explicit post-step role responsible for
accepting evidence, restoring planning currency, checking trajectory, and preparing the next human
decision. The pilot therefore adds an AI Roadmap Controller checkpoint between implementation and any
next-step authorization.

The first filled checkpoint then grew into a detailed evidence report, repeating test results,
changed paths, design reasoning, and the learning record. It did not yet override the roadmap, but it
had the same drift risk as the oversized first implementation dispatch. Controller checkpoints are
therefore thin, one-page state-transition records; detailed evidence stays in the step learning
record.

### First correction-required observation

Step 1.2 satisfied its declared portability checks but exposed a semantic defect in the newly created
model-usage projection: a volatile price estimate was narrowed from `BigDecimal` to `double`, and an
unrepresentable value could disappear silently, while token categories were too weak for known
reasoning/cache accounting. The Roadmap Controller therefore could not accept the step merely because
its original checkboxes were green. This is the first dogfood of the explicit correction path:
reproduce the defect, ratify the smallest coherent contract correction, reopen only Step 1.2, dispatch
that correction, and run a new controller checkpoint before Step 1.3.

The same finding has consequences owned by Agent Journal and Agent Workflow. Pilot 1 will test an
actual gitmaildir `MailboxMessage` for Agent Journal and a pending outbound message for Agent
Workflow whose delivery is triggered by creation of its 1:1 steward. Recipient roadmaps—not the
messages—own acceptance and implementation.

The first method draft called a Markdown envelope under `plans/inbox/` “gitmaildir-compatible”
without reading gitmaildir's implementation. Human challenge exposed the mismatch: the real transport
uses `MailboxMessage` JSON under `inbox/new/<type>/`, with `cur/archive/dead` lifecycle directories,
generated IDs, leases, and a separate audit log. The binding now runs gitmaildir with `plans/` as its
work directory and uses a separate receipt message. Method integrations must inspect the named
external contract before borrowing its name.

## Agent Workflow — Pilot 2

| Field | State |
|---|---|
| Project repository | `markpollack/agent-workflow` |
| Steward repository | Not yet created |
| Entry trigger | Agent Judge adjudication establishes the cross-repository work order and the Agent Judge artifact is locally installed |
| Current phase | Planned |

Pilot 2 will test whether Agent Judge's completed work order can be consumed by reference—without a new
handoff document that restates and drifts from the upstream decisions.

## Method-level decision log

| Date | Decision | Standing |
|---|---|---|
| 2026-08-06 | Use a private one-project/one-steward-repository pairing | Pilot decision |
| 2026-08-06 | Use Git integrity plus numbered human-readable candidate/review records | Pilot decision |
| 2026-08-06 | Treat AI review as sensor output requiring adjudication | Pilot decision |
| 2026-08-06 | Keep this method provisional through both pilots | Owner decision |
| 2026-08-08 | Separate reusable work-order instructions from the adjudication output ledger | Pilot decision |
| 2026-08-08 | Add `accepted-open`; `fixed` is valid only after correction exists | Dogfood correction |
| 2026-08-08 | Use proportional evidence: coordinates for released dependencies; digests only when byte identity is disputed | Dogfood correction |
| 2026-08-08 | Front-load a plain-language human checkpoint and replace ambiguous `CORRECT` with `CORRECTIONS REQUIRED` | Dogfood correction |
| 2026-08-08 | Add a distinct verification work-order contract with `READY TO RATIFY` as its positive control state | Dogfood correction |
| 2026-08-08 | Require materialized numbered candidate bundles by default; grandfather Agent Judge Candidates 01/02 without rewriting them | Dogfood correction |
| 2026-08-08 | Separate human ratification, execution authorization, and fresh-session implementation dispatch | Dogfood correction |
| 2026-08-08 | Make implementation work orders thin pointer envelopes; prohibit duplicated design, roadmap, ratification, and completion content | Dogfood correction |
| 2026-08-08 | Add an AI Roadmap Controller checkpoint after every implementation step; the human remains Project Owner and next-step authority | Dogfood correction |
| 2026-08-08 | Keep Roadmap Controller checkpoints to one-page transition records that point to, rather than duplicate, roadmap and implementation evidence | Dogfood correction |
| 2026-08-08 | Make `CORRECTION REQUIRED` an explicit same-step control transition using the thin implementation dispatch in bounded-correction mode | Dogfood correction |
| 2026-08-08 | Bind cross-steward delivery to gitmaildir `MailboxMessage` JSON under `plans/inbox/new/<type>/`; disposition returns in a separate receipt and remains recipient-owned | Dogfood correction |
| 2026-08-08 | Require a named transport binding to match the transport's real on-disk schema and lifecycle; conceptual compatibility is insufficient | Dogfood correction |
