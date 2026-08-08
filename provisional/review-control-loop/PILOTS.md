# Pilot Register

## Agent Judge — Pilot 1

| Field | State |
|---|---|
| Project repository | `markpollack/agent-judge` (public) |
| Steward repository | `markpollack/agent-judge-steward` (private) |
| Effort | Agent Judge 0.14 closure and Agent Workflow adoption readiness |
| Initial candidate | Private steward commit `a7ea488`, tag `review/aj-014-closure/candidate-01`; reviewed trio at project HEAD `8f8391b` plus recorded working-tree state |
| Initial sensor output | `roadmap-readiness-review-2026-08-06`, 16 findings |
| Current phase | READY FOR ADJUDICATION |
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

Execute the filled `work-order-adjudication-01.md` in the private steward. Adjudicate all 16 findings
against Candidate 01 before changing the active trio. Record reproductions, refutations, owners, and
triggers. Produce Candidate 02 only from accepted corrections.

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
