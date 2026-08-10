# Review Control Loop Experiment

> **Status:** PROVISIONAL — dogfood before promotion into Forge
> **Started:** 2026-08-06
> **Experiment owner:** Agento Forge
> **Pilot order:** Agent Judge, then Agent Workflow

This directory preserves an experimental method for making AI-authored planning reliable without
pretending that either the author or a second AI is an oracle. It is the overall tracking home for the
experiment. The Agent Judge and Agent Workflow steward repositories contain each project's actual
planning state and pilot evidence.

Nothing here is normative Forge doctrine yet. Existing Forge concepts remain authoritative. This
experiment combines and tests several of them—cold review, review lenses, exhibits, adjudication,
terminal finding states, and records discipline—together with a new one-project/one-steward-repository
boundary.

## Hypothesis

Planning reliability improves when review is operated as a bounded feedback-control loop:

```text
                    reference
              VISION / DESIGN / rules
                         |
                         v
author policy -> candidate artifact -> sensors / reviewers
      ^                   |                    |
      |                   |                    v
      |                   +------------ evidence ledger
      |                                        |
      |                                        v
      +--- bounded correction <- controller <- adjudication
```

- The **author** proposes a candidate; authorship does not confer correctness.
- A **reviewer** is a fallible sensor. A review finding is a measurement, not authority.
- **Adjudication** reproduces, refutes, files, or parks every finding against evidence and standing
  decisions.
- The **controller** applies only accepted, bounded corrections. It does not maximize for reviewer
  satisfaction or zero comments.
- A **verification reviewer** examines the corrected, frozen candidate for new structural blockers.
- The human receives a compact decision brief plus reproducible exhibits, not a pile of opinions.

The planning loop hands control to execution through an explicit transition:

```text
verified candidate
       |
       v
human ratification ----> reopen or reject
       |
       v
one-step authorization
       |
       v
pointer-based work order -> fresh implementer -> implementation checkpoint
                                                      |
                                                      v
                                            AI Roadmap Controller
                                             |                 |
                                             v                 +-> independent review when risk warrants
                                   human next-step decision
```

Ratification, execution authorization, worker selection, and implementation acceptance are distinct
events. The controller records and dispatches them; conversational glue such as “I would then…” is not
an adequate project artifact.

After each implementation step, an **AI Roadmap Controller** checks the step evidence, mutation scope,
planning currency, and overall trajectory. It may make bounded current-state corrections, but the
human Project Owner accepts the checkpoint and decides whether one next step is authorized. This
closes the gap between “the worker stopped” and “the roadmap may safely continue.”

The implementer may submit evidence-backed roadmap checkmarks and set the step to `IMPLEMENTED —
ACCEPTANCE PENDING`. Those are provisional state claims. The controller owns acceptance and
reconciliation, not exclusive authorship of the roadmap file; it verifies the submitted edits under
“trust but verify.”

The dispatch is intentionally thin. VISION/DESIGN/ROADMAP remain the source of truth; the work order
adds only authorization, mutation, evidence-destination, and stopping metadata that is specific to one
fresh session. Repeating roadmap or design content in a handoff creates another authority and is a
method defect.

## Repository experiment

Each public project is paired 1:1 with a private steward repository.

| Project repository | Private steward repository | Boundary |
|---|---|---|
| `agent-judge` | `agent-judge-steward` | First full pilot |
| `agent-workflow` | `agent-workflow-steward` | Second pilot after Agent Judge closes |

The project repository owns code, tests, builds, releases, public documentation, and accepted
implementation commits. The private steward repository owns VISION, DESIGN, ROADMAP, journals,
learnings, review records, work orders, and private research. Cross-repository work is expressed as a
named dependency or work order; it is not copied into ad hoc handoff prose.

Public and steward `AGENTS.md` files are stable interfaces, not control-state ledgers. They may carry
the ownership boundary, steward pointer, durable build and licensing rules, and maintained engineering
standards. Current actions, candidate identities, pending decisions, dispatch pointers, and checkpoint
state remain in ROADMAP and the controller records. A launch prompt points directly to the binding and
authorized dispatch.

## Experiment questions

1. Does the private steward boundary eliminate ignored authoritative files and accidental competing
   sources of truth?
2. Can a cold AI reviewer find defects without gaining authority to rewrite settled decisions?
3. Does adjudication prevent excessive controller gain—accepting every suggestion and causing document
   oscillation?
4. Do immutable candidates plus human-readable numbered records give enough provenance without making
   Git history noisy or inaccessible?
5. Can handoffs become pointers to decisions and roadmap steps instead of restatements that drift?
6. What minimum review lenses and coverage denominators produce useful confidence at acceptable cost?
7. Can materialized numbered bundles preserve provenance while keeping Git out of the normal document-reading path?
8. Can ratification and implementation dispatch become an explicit, reusable controller transition rather than an ad hoc handoff?
9. Can an AI Roadmap Controller keep active plans current and execution on trajectory without becoming a self-approving implementer?
10. Can `CORRECTION REQUIRED` produce a bounded same-step repair without reopening settled work or
    authorizing the next step?
11. Can steward-to-steward obligations travel through transparent inbox files while authority remains
    in each recipient's journal and roadmap?
12. Can a stable inbox-preflight cadence make cross-steward work visible soon enough to affect
    sequencing without letting incoming messages expand a bounded implementation session or become
    authority merely by arriving?
13. Can stage-aware model escalation keep iterative artifact review responsive while reserving the
    strongest diverse cold sensors for the final ratification boundary, with launch handoffs simple
    enough for agento-university to generate?

## Promotion gate

The method may be proposed for Forge only after both pilots record:

- candidate and correction cycle counts;
- findings by severity and terminal disposition;
- reproduced versus refuted findings;
- structural blockers first found by verification;
- document oscillation or reopened settled decisions;
- stale or duplicate authorities removed;
- human time required for adjudication and ratification;
- reviewer-interface overhead, including Git reconstruction commands versus substantive checks;
- selected review profile/model/reasoning tier and its elapsed time and useful-finding yield;
- dispatch prompt repairs or missing controller-transition artifacts;
- post-step stale claims, controller corrections, and human checkpoint decisions; and
- failures and exceptions, not only successes.

Promotion is a separate reviewed change. Pilot success does not silently make this directory normative.

## Contents

- [PROTOCOL.md](PROTOCOL.md) — the operating protocol being tested
- [PILOTS.md](PILOTS.md) — cross-pilot status and observations
- [ANTECEDENTS.md](ANTECEDENTS.md) — bounded comparison with configuration management, IV&V,
  scenario-based review, and current SDD
- [templates/ADJUDICATION-WORK-ORDER-TEMPLATE.md](templates/ADJUDICATION-WORK-ORDER-TEMPLATE.md) —
  fill-in instructions for a fresh adjudication session
- [templates/ADJUDICATION-TEMPLATE.md](templates/ADJUDICATION-TEMPLATE.md) — adjudication output ledger
- [templates/CANDIDATE-BUNDLE-TEMPLATE.md](templates/CANDIDATE-BUNDLE-TEMPLATE.md) — required
  materialized numbered-candidate layout and source inventory
- [templates/VERIFICATION-WORK-ORDER-TEMPLATE.md](templates/VERIFICATION-WORK-ORDER-TEMPLATE.md) —
  independent verification contract for a corrected bundle
- [templates/COLD-REVIEW-LAUNCHER-TEMPLATE.md](templates/COLD-REVIEW-LAUNCHER-TEMPLATE.md) —
  persistent reviewer-directory and inspectable CLI launcher pattern for cold sensors
- [templates/RATIFICATION-TEMPLATE.md](templates/RATIFICATION-TEMPLATE.md) — human candidate decision
  and separately recorded execution authorization
- [templates/IMPLEMENTATION-WORK-ORDER-TEMPLATE.md](templates/IMPLEMENTATION-WORK-ORDER-TEMPLATE.md) —
  bounded dispatch contract for a fresh implementation session
- [templates/ROADMAP-CONTROLLER-CHECKPOINT-TEMPLATE.md](templates/ROADMAP-CONTROLLER-CHECKPOINT-TEMPLATE.md) —
  post-step evidence, planning-currency, trajectory, and human-decision checkpoint
- [templates/INTER-STEWARD-MESSAGE-TEMPLATE.md](templates/INTER-STEWARD-MESSAGE-TEMPLATE.md) —
  actual gitmaildir `MailboxMessage` JSON/payload schema whose recipient owns triage and disposition
