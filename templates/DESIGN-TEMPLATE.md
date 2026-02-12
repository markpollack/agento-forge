# Design: {{PROJECT_NAME}}

> **Created**: {{DATE}}
> **Vision version**: {{VISION_VERSION}}
> **Research version**: {{RESEARCH_VERSION}}

> **Note**: Skip this template for research projects. Research methodology typically lives in VISION.md alongside the hypotheses and claims. See the [research variant guide](../variants/research.md) for recommended structure.

## Overview

One-paragraph summary of the technical approach.

{{OVERVIEW}}

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

## Interfaces

### {{INTERFACE_1_NAME}}

```
{{INTERFACE_DEFINITION}}
```

**Contract**:
- {{BEHAVIORAL_CONTRACT_1}}
- {{BEHAVIORAL_CONTRACT_2}}

**Error handling**: {{ERROR_APPROACH}}

---

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

---

## Error Handling Strategy

{{ERROR_HANDLING_APPROACH}}

## Testing Strategy

{{TESTING_APPROACH}}

## Evaluation Architecture

> *Include this section for agent projects. Skip for conventional software projects.*

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

## Open Questions

Questions that don't block design but should be resolved before or during implementation:

1. {{OPEN_QUESTION_1}}
