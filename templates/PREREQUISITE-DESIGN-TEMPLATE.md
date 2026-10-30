# Prerequisite Design: {{TOOL_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Parent project**: {{PROJECT_NAME}}
> **Feeds into**: {{WHAT_THIS_ENABLES}} (e.g., "Main DESIGN.md — provides validation corpus")

## Overview

{{ONE_PARAGRAPH — what the tool does, why it's needed, what it enables for the main project.}}

## Consumer Example and Contract

{{COMPLETE_INVOCATION_AND_NEXT_USE_OF_ITS_OUTPUT}}

Start with one invocation using concrete inputs and show the consumer reading the result. Label
proposed commands or helpers. In a paragraph answer: what was accepted; what normal return guarantees;
what failure/cancellation means; what can safely happen next; and who owns output/temporary resources.
State when a question does not apply. Add another example only for a distinct behavior.

{{FIVE_QUESTION_PARAGRAPH}}

## Inputs

| Input | Source | Format |
|-------|--------|--------|
| {{INPUT_1}} | {{WHERE_IT_COMES_FROM}} | {{FORMAT}} |

## Outputs

| Output | Format | Consumed by |
|--------|--------|-------------|
| {{OUTPUT_1}} | {{FORMAT}} | {{WHAT_USES_IT}} |

### Output Schema

```
{{SCHEMA_DEFINITION — JSON, YAML, or structured description of the output format}}
```

## Design Decisions

### DD-1: {{DECISION_TITLE}}

**Context**: {{WHAT_PROMPTED_THIS_DECISION}}

**Decision**: {{WHAT_WE_CHOSE}}

**Alternatives considered**:
1. {{ALTERNATIVE_1}} — rejected because {{REASON}}
2. {{ALTERNATIVE_2}} — rejected because {{REASON}}

**Rationale**: {{WHY_THIS_APPROACH}}

---

## Testing Strategy

{{CONSUMER_NEED → RETURN_PROMISE → DESIGN_DECISION → SCENARIO_AND_ASSERTION}}

Name planned checks before implementation; afterwards cite actual results and limits. Read the
example first at the existing review. Ready means the consumer can explain the result and next action,
needs no internal-state knowledge, sees clear failure/cleanup/ownership boundaries and existing/proposed
labels, and can identify a check for each important promise. Keep unresolved limits and deferrals visible.

## Open Questions

1. {{OPEN_QUESTION_1}}
2. {{OPEN_QUESTION_2}}

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`.
