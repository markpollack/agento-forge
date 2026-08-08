# Pilot Register

## Agent Judge — Pilot 1

| Field | State |
|---|---|
| Project repository | `markpollack/agent-judge` (public) |
| Steward repository | `markpollack/agent-judge-steward` (private) |
| Effort | Agent Judge 0.14 closure and Agent Workflow adoption readiness |
| Initial candidate | Private steward commit `a7ea488`, tag `review/aj-014-closure/candidate-01`; reviewed trio at project HEAD `8f8391b` plus recorded working-tree state |
| Initial sensor output | `roadmap-readiness-review-2026-08-06`, 16 findings |
| Current phase | CANDIDATE 02 VERIFIED — READY FOR HUMAN RATIFICATION |
| Ratification state | Not ratified |

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

Preserve `verification-02.md` exactly as received. Wait for the human Candidate 02 decision, record it
separately, and—only if one exact roadmap step is authorized—instantiate the implementation-dispatch
work order and update the steward's canonical `AGENTS.md` current-action pointer. Candidate 02 remains
immutable.

### Candidate-packaging observation

Candidates 01 and 02 used numbered manifest directories without materialized copies of the reviewed
documents. Verification therefore required repeated `git show`, per-file hash reproduction, and Git
history comparisons. Integrity held, but the human-readable-numbered-record objective did not. Future
candidates default to materialized bundles; Git remains the backing integrity boundary rather than the
reviewer's document-reading interface.

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
