# Design: {{PROJECT_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Vision version**: {{VISION_VERSION}}
> **Research version**: {{RESEARCH_VERSION}}

> **Note**: Skip this template for research projects. Research methodology typically lives in VISION.md alongside the hypotheses and claims. See the [research variant guide](../variants/research.md) for recommended structure.

## Overview

One paragraph: who needs this feature, what they can accomplish, and its boundary.

{{OVERVIEW}}

## Consumer Examples

<!-- Use only the sections this feature needs. One complete example and a paragraph can be enough
for a small change. Usually 2–3 examples cover an ordinary feature, 3–4 a stateful client; these
are starting sizes, not quotas. Add examples for distinct behavior, not to meet a document count. -->

{{COMPLETE_PROGRAM_OR_USER_FLOW}}

Show configuration, operation, result use, ordinary follow-up and cleanup. Add consequential
failure/cancellation paths. Include imports and defined helpers; label invented syntax as proposed.
Explain the returned result and where saved artifacts live. For a product feature, use entry point,
user action, visible outcome and next action instead of code.
A complete example may be a callable function taking configured dependencies. State their setup and
ownership boundary; do not invent a host application or provider factory just to supply a main method.

### Today versus proposed

For each main consumer task, show today's program or visible flow next to the proposed one. Cite
the repository, pinned revision and source locations for existing code. Compare result meaning,
follow-up, failure and cleanup as well as calls. If the task has no existing path, say so explicitly.

| Main task | Today: program/flow and pinned code | Proposed program/flow | Changed promises and migration |
|---|---|---|---|
| {{TASK}} | {{CURRENT_PROGRAM_AND_SOURCE_OR_NONE}} | {{PROPOSED_PROGRAM}} | {{CHANGE}} |

Keep long programs adjacent under each task instead of squeezing them into table cells.

### Existing-path inventory

Inspect that pinned code for **every public way to reach the same capability today**, including
lower-level APIs, factories and returned handles the proposed examples never call. This inventory
extends beyond the new API's used entry points; unrelated capabilities remain out of scope.

| Capability | Existing public path / pinned source | Retained / routed through new contract / removed | Contract enforcement or removal; reason |
|---|---|---|---|
| {{CAPABILITY}} | {{ENTRY_TO_OPERATION_PATH_AND_SOURCE}} | {{DISPOSITION}} | {{ENFORCEMENT_OR_REMOVAL_AND_REASON}} |

For each retained path, explain why it does not bypass the new contract. For a routed path, identify
where the contract's guarantees are enforced. For removal, name the affected entry points and the
replacement or deliberate loss. Use **one public way per capability unless a reason is recorded**,
including compatibility exceptions. A type's migration row alone does not resolve its public callers.
If there are no existing paths, record the inspected scope and revision (or no baseline for greenfield).

## Public Surface and Operation Contracts

List every public type, constructor, method, overload, configuration field, result and error in the
feature's scope, including reused entry points needed by the examples. Give full signatures and
exceptions. Label each **existing at {{REVISION}}** or **proposed**; acceptance or compilation alone
does not make a proposal implemented. For product flows, list actions, outcomes and errors instead.
Link large existing definitions at a pinned revision or appendix instead of copying them all here.
State inherited/generated members covered and compatibility effects of changed/retired entries.
The boundary is this feature and its used entry points, not every unrelated dependency API.

| Surface entry / full signature | Existing at revision / proposed | Contract |
|---|---|---|
| {{ENTRY}} | {{STATUS}} | {{OPERATION_ANCHOR}} |

### {{OPERATION_ANCHOR}}: {{OPERATION_NAME}}

1. **Accepted:** {{INPUTS_PRECONDITIONS_AND_REJECTION}}
2. **Normal return:** {{GUARANTEE_AND_RESULT_MEANING}}
3. **Failure or cancellation:** {{OUTCOME_AND_WHAT_MAY_REMAIN_UNSETTLED}}
4. **Next action:** {{SAFE_NEXT_ACTION_AND_CONDITIONS}}
5. **Ownership:** {{RESOURCES_ARTIFACTS_OWNER_AND_RELEASE}}

Repeat for significant operations: those changing work, state, ownership or the next permitted action,
or presenting a wait/failure boundary. Simple accessors may share a contract. Treat submission and
result retrieval separately. Keep required processing distinct from optional observers.
If startup can fail after acquisition, explain what remains owned and how the caller can inspect or
clean it up without a successfully returned handle. Distinguish borrowed dependencies from owned resources.

Deliberately absent or deferred surface: {{ABSENCES_AND_REASONS}}

## Selected Precedent

Platform/version constraints: {{BASELINE}}

| Consumer problem | Pinned source and actual guarantee | Differing assumption here | Reuse / adapt / avoid |
|---|---|---|---|
| {{PROBLEM}} | {{SOURCE_GUARANTEE}} | {{DIFFERENCE}} | {{CHOICE_AND_REASON}} |

Use the relevant research; do not restart a broad survey. Resolve routine conventions and bring
material tradeoffs or conflicting expectations to the owner.

## Promises, Requirements and Verification

**Consumer need → operation postcondition → mechanism → test evidence.** A postcondition says what
is true after an operation returns. Link existing requirement IDs where they already express it.
Every mechanism and active requirement names a promise or a safeguard. A safeguard names a hazard,
whom it protects, its reason and a check. Withdraw rules with no trace, reserving their IDs; preserve
deferred work separately. Re-check both directions at the design gate.

| Need / example | Operation promise or safeguard | Requirement / source, if any | Mechanism / decision | Scenario and expected outcome | Evidence / limits |
|---|---|---|---|---|---|
| {{NEED}} | {{PROMISE}} | {{REQUIREMENT}} | {{DECISION}} | {{CHECK}} | {{PLANNED_OR_EXECUTED_AT_REVISION}} |

Before code exists, name planned assertions. After implementation, cite checks actually run and
what they leave untested. Prototype compilation establishes syntax/types only.

## Build Coordinates

> *Include this section for projects that produce build artifacts (Java, Python, etc.). Skip for pure documentation or research projects.*

| Field | Value |
|-------|-------|
| **Group ID** | `{{GROUP_ID}}` (e.g., `io.github.username`) |
| **Artifact ID** | `{{ARTIFACT_ID}}` |
| **Version** | `{{VERSION}}` (e.g., `0.1.0-SNAPSHOT`) |
| **Packaging** | `pom` (multi-module) / `jar` |
| **Java version** | {{JAVA_VERSION}} (e.g., 17) |
| **Base package** | `{{BASE_PACKAGE}}` (e.g., `io.github.username.project`) |

### Module Structure

```
{{ARTIFACT_ID}}/
├── pom.xml                    # Aggregator parent
├── {{module-core}}/           # {{MODULE_PURPOSE}}
└── {{module-other}}/          # {{MODULE_PURPOSE}}
```

### Key Dependencies

| Dependency | Scope | Purpose |
|------------|-------|---------|
| {{DEPENDENCY}} | compile / test | {{PURPOSE}} |

## Architecture

### Components

| Component | Responsibility | Public API |
|-----------|---------------|------------|
| {{COMPONENT_1}} | {{RESPONSIBILITY}} | {{API_SUMMARY}} |
| {{COMPONENT_2}} | {{RESPONSIBILITY}} | {{API_SUMMARY}} |

### Component Diagram

```
{{ASCII_DIAGRAM}}
```

### Data Flow

```
{{DATA_FLOW_DIAGRAM}}
```

## Data Models

### {{MODEL_1_NAME}}

| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| {{FIELD}} | {{TYPE}} | {{YES/NO}} | {{DESCRIPTION}} |

---

## Design Decisions

### DD-1: {{DECISION_TITLE}}

**Context**: {{WHAT_PROMPTED_THIS_DECISION}}

**Decision**: {{WHAT_WE_CHOSE}}

**Alternatives considered**:
1. {{ALTERNATIVE_1}} — rejected because {{REASON}}
2. {{ALTERNATIVE_2}} — rejected because {{REASON}}

**Rationale**: {{WHY_THIS_APPROACH}}

> **Phrasing**: state the decision as a **predicate over artifacts** where you can — something an observation could contradict — rather than as a state of the world or of a reader's understanding. That is what decides whether a roadmap step can ever defend it (`concepts/decision-enforcement.md`). Postures and regimes legitimately have no such form; leave them as prose.

---

## Error Handling Strategy

{{ERROR_HANDLING_APPROACH}}

## Model / Code Boundary

> *Include when a model drives workflow steps (a conversational agent, a skill, an AI step in a workflow). See `concepts/model-code-boundary.md`.*

| Job | Owner | Here |
|-----|-------|------|
| Turn the human's words into a structured intent | Model | {{INTENT_TYPES}} (e.g., operation + inputs, affirmative, none) |
| Which states admit which operations | Code | {{STATE_OPERATION_TABLE}} |
| At most one state change per turn; what an affirmative refers to | Code | {{TURN_RULE}} |
| Refusal format (operation, reason, state, next valid step) | Code | {{REFUSAL_FORMAT}} |

Every prompt rule that would change state if ignored has a behavioural test, not a prompt-presence test.

## Testing Strategy

{{TESTING_APPROACH}}

## Evaluation Architecture

> *Include this section for eval-agent projects. Skip for project variant.*

### Agent Loop

| Field | Value |
|-------|-------|
| **Loop type** | {{LOOP_TYPE}} (e.g., turn-limited, evaluator-optimizer, fresh-context) |
| **Implements** | `AgentLoop<{{RESULT_TYPE}}>` (or custom loop interface) |
| **Termination** | {{TERMINATION_STRATEGIES}} (e.g., all cases pass, max iterations, cost limit) |

### Benchmark Cases

- **Format**: {{CASE_FORMAT}} (e.g., YAML, JSON, programmatic)
- **Source**: {{CASE_SOURCE}} (e.g., reference test suite, hand-crafted, generated)
- **Case model**: {{CASE_MODEL}} (e.g., PRD with user stories, task descriptions, input/output pairs)

### Judges

| Judge | Type | Evaluates | Weight |
|-------|------|-----------|--------|
| {{JUDGE_1}} | Deterministic | {{CRITERIA}} (e.g., test pass rate) | {{WEIGHT}} |
| {{JUDGE_2}} | Deterministic | {{CRITERIA}} (e.g., iteration efficiency) | {{WEIGHT}} |
| {{JUDGE_3}} | AI | {{CRITERIA}} (e.g., output quality) | {{WEIGHT}} |

### Loss Function

```
loss = 1 - weighted_sum(judge_scores) / max_score
```

- **Convergence threshold**: {{THRESHOLD}} (e.g., loss < 0.1)
- **Primary metric**: {{PRIMARY_METRIC}}

### Tracking

- **Framework**: {{TRACKING_FRAMEWORK}} (e.g., tracking-core, custom)
- **Per-iteration**: {{ITERATION_METRICS}} (e.g., tokens, cost, duration, cases attempted/passed)
- **Per-execution**: {{EXECUTION_METRICS}} (e.g., total iterations, total cost, final state, termination reason)

## Architecture Specification (optional provisional practice)

<!-- If dogfooding the architecture-documentation pack: retain this before spec; write the after
guide separately and a third changes document when useful. Select views by reader questions.
Markdown + conceptual Mermaid class/sequence/state/flowchart views; label proposals and accepted intent
as proposed / declared design. Render and inspect figures. Apply selected lenses and a fresh Codex
review given the pinned spec, baseline source and a named outside KB; exclude author conclusions and
prior reviews. Findings cite passages and breaking cases, classified validates/additive/reopens.
Reproduce findings, retain prior revisions, obtain owner acceptance before the spike.
See provisional/architecture-documentation/SPEC-MODE.md for the prompt and separate spec skeleton. -->

- Before revision: {{SPEC_REVISION}}
- Selected views and reader questions: {{VIEWS}}
- Fresh outside-knowledge review and dispositions: {{REVIEW}}
- Owner acceptance: {{ACCEPTANCE}}
- After guide / change explanation: {{LINKS_OR_PENDING}}

## Consumer Readiness and Review

Read the complete examples before earlier findings, then review contracts, mechanisms and checks
for usability and correctness at the same checkpoint (consumer-code lens 11). Construct a confusing
or breaking program/flow; record searches that found none. Preserve the existing applicable gates.

- [ ] A consumer can explain the main result and the next permitted action.
- [ ] Each main task compares pinned current code with the proposal, or records no current path.
      Every existing public path is retained with a non-bypass reason, routed through the contract,
      or removed; multiple public ways to the same capability have a recorded reason.
- [ ] Ordinary use needs no internal-state knowledge or unexplained conversions/extra waits.
- [ ] Acceptance, normal return, failure/cancellation, cleanup and ownership are clear where relevant;
      significant operations answer all five questions.
- [ ] The complete in-scope surface labels existing/proposed entries, including errors and helpers;
      evidence status does not confuse compilation with implementation.
- [ ] Important promises and safeguards have scenarios and trace; untraced rules are withdrawn with
      IDs reserved. Limits/deferrals are visible and nothing blocks implementation planning.

Review evidence and owner acceptance: {{REVIEW_AND_ACCEPTANCE}}

For an intermediate API checkpoint: {{READY_TO_REVIEW_NOW_AND_DECISIONS_STILL_BLOCKING_FULL_DESIGN}}.
Keep those limits visible; partial review and syntax compilation do not pass the full readiness gate.

## Open Questions

Questions that don't block design but should be resolved before or during implementation:

1. {{OPEN_QUESTION_1}}

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`. These documents are living artifacts — inline revision history avoids needing to check git for change context.

> **Records discipline**: a record is appended to, never rewritten to agree with the present. Add a row above; keep a superseded revision under a banner rather than editing it (findings and cross-references cite it *by line*); put corrections **beside** the original words, dated; file received evidence — a review's findings, a quoted specification, someone else's words — verbatim. See `concepts/project-knowledge-layout.md`.
