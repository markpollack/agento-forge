# Learnings: {{PROJECT_NAME}}

> **Last compacted**: {{DATETIME}}
> **Covers through**: Phase {{N}}, Step {{X.Y}}

This is the **Tier 1 compacted summary**. Read this first for the current state of project knowledge. For details on specific steps, see the per-step files (Tier 2).

---

## Key Discoveries

Findings that changed the approach or should inform future decisions:

1. **{{DISCOVERY_TITLE}}** — {{ONE_SENTENCE_DESCRIPTION}}
   - *Source*: Step {{X.Y}}
   - *Impact*: {{HOW_THIS_CHANGED_THE_APPROACH}}

2. **{{DISCOVERY_TITLE}}** — {{ONE_SENTENCE_DESCRIPTION}}
   - *Source*: Step {{X.Y}}
   - *Impact*: {{HOW_THIS_CHANGED_THE_APPROACH}}

## Patterns Established

Patterns that emerged during implementation and should be followed consistently:

- **{{PATTERN_NAME}}**: {{DESCRIPTION}}
- **{{PATTERN_NAME}}**: {{DESCRIPTION}}

## Deviations from Design

Intentional deviations from DESIGN.md with rationale:

| Design says | Implementation does | Why |
|-------------|-------------------|-----|
| {{DESIGN_SPEC}} | {{ACTUAL}} | {{RATIONALE}} |

## Common Pitfalls

Mistakes made during implementation that future steps should avoid:

1. **{{PITFALL}}** — {{WHAT_HAPPENED_AND_HOW_TO_AVOID}}

> **Twice is a practice.** The first occurrence is bad luck and belongs here, as prose. The second is
> evidence of a *class*, and a class gets a mechanism — a script, a probe, a test — which then lands in
> the thing future work inherits (the template, the scaffolding command, the shared build config), not
> only in this project. Each mechanism carries the mistake that produced it, or the next person
> suppresses a rule they cannot see the reason for. An entry that improves only its own project has been
> filed, not graduated. Watch the new check fail before trusting it. See
> `concepts/quality-infrastructure.md`.

## Phase Review Summaries

| Phase | Iteration 1 | Iteration 2 | Final Status |
|-------|-------------|-------------|--------------|
| Stage 1 | {{N}} MUST FIX, {{N}} SHOULD FIX | {{STATUS}} | {{PASS/FAIL}} |

---

## Per-Step Detail Files (Tier 2)

| File | Step | Topic |
|------|------|-------|
| `step-1.0-{{topic}}.md` | 1.0 | {{BRIEF_DESCRIPTION}} |
| `step-1.1-{{topic}}.md` | 1.1 | {{BRIEF_DESCRIPTION}} |

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`.

> **Records discipline**: a record is appended to, never rewritten to agree with the present. Compaction
> summarizes per-step files; it does not revise what they said. Put corrections **beside** the original
> words, dated, and file received evidence — review findings, quoted specifications, someone else's
> words — verbatim. See `concepts/project-knowledge-layout.md`.
