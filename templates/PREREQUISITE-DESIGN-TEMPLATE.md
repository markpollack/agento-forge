# Prerequisite Design: {{TOOL_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Parent project**: {{PROJECT_NAME}}
> **Feeds into**: {{WHAT_THIS_ENABLES}} (e.g., "Main DESIGN.md — provides validation corpus")

## Overview

{{ONE_PARAGRAPH — what the tool does, why it's needed, what it enables for the main project.}}

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

{{HOW_TO_VERIFY_THE_TOOL_WORKS — e.g., spot-check N outputs manually, compare against known-good examples, round-trip validation}}

## Open Questions

1. {{OPEN_QUESTION_1}}
2. {{OPEN_QUESTION_2}}

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`.
