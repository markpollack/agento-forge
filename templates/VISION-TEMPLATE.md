# Vision: {{PROJECT_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Status**: Draft | Stable

> **Note**: For research projects (papers, studies, investigations), use [VISION-TEMPLATE-research.md](VISION-TEMPLATE-research.md) instead. It includes hypothesis tracking, unknowns management, and paper structure sections.

## Problem Statement

What specific problem does this project solve? Who has this problem? How do they deal with it today?

{{PROBLEM_DESCRIPTION}}

## Stakeholders and Personas

Everyone who will touch the system in year one — **especially the personas who won't show up to ask**
(operator, administrator, security reviewer). A persona without a row here gets no requirements, no
verbs, and no view — silently. (See `concepts/review-lenses.md`, lens 5.)

| Persona | Top concerns | What they must be able to DO |
|---------|--------------|------------------------------|
| {{PERSONA_1}} | {{CONCERNS}} | {{VERBS}} |
| {{PERSONA_2}} | {{CONCERNS}} | {{VERBS}} |
| Operator (on-call) | {{CONCERNS}} | {{VERBS — cancel? retry? re-drive? inspect?}} |
| Administrator | {{CONCERNS}} | {{VERBS — retention? policy? access?}} |

## Success Criteria

Measurable outcomes that determine if the project succeeded. Not features — outcomes.

1. {{CRITERION_1}}
2. {{CRITERION_2}}
3. {{CRITERION_3}}

## Scope

### In Scope

- {{IN_SCOPE_ITEM_1}}
- {{IN_SCOPE_ITEM_2}}

### Out of Scope

- {{OUT_OF_SCOPE_ITEM_1}}
- {{OUT_OF_SCOPE_ITEM_2}}

## Unknowns and Research Questions

What do you need to learn before you can design a solution?

1. {{RESEARCH_QUESTION_1}}
2. {{RESEARCH_QUESTION_2}}

## Assumptions

What are you assuming to be true? Each assumption is a risk if wrong.

1. {{ASSUMPTION_1}}
2. {{ASSUMPTION_2}}

## Constraints

- **Technology**: {{TECH_CONSTRAINTS}}
- **Timeline**: {{TIMELINE_CONSTRAINTS}}
- **Other**: {{OTHER_CONSTRAINTS}}

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`. These documents are living artifacts — inline revision history avoids needing to check git for change context.

> **Records discipline**: a record is appended to, never rewritten to agree with the present. Add a row above; keep a superseded revision under a banner rather than editing it (findings and cross-references cite it *by line*); put corrections **beside** the original words, dated; file received evidence — a review's findings, a quoted specification, someone else's words — verbatim. See `concepts/project-knowledge-layout.md`.
