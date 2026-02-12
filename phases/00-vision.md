# Phase 0: Vision & Scoping

## Purpose

Define what to build, why it matters, and what success looks like. The vision document is the anchor — everything else (research, design, roadmap) traces back to it.

## Inputs

- Problem statement or opportunity description
- Initial constraints (technology, timeline, team)
- Stakeholder requirements (if any)
- Saved AI conversations exploring the problem space (see [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md))

## Outputs

- **VISION.md** — structured vision document (see [template](../templates/VISION-TEMPLATE.md))

## Key Activities

1. **Clarify the problem** — What specific problem does this solve? Who has it? How do they deal with it today?
2. **Define success criteria** — Measurable outcomes that determine if the project succeeded. Not features — outcomes.
3. **Set scope boundaries** — What's explicitly in scope and out of scope. Be specific about what you won't build.
4. **Identify unknowns** — What do you need to learn before you can design a solution? These become Phase 1 research questions.
5. **State assumptions** — What are you assuming to be true? Each assumption is a risk if wrong.

### Variant-Specific Notes

**Agent projects**: Include evaluation criteria in success metrics. "Loss converges below 0.1" or "Passes 90% of benchmark cases."

**Software projects**: Success criteria focus on functionality and quality. "Handles all documented use cases" or "Zero critical bugs in production."

**Research projects**: Use [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) instead. Add hypotheses as testable predictions, track unknowns with resolution status, and include paper structure if targeting publications. See [research variant](../variants/research.md).

## Exit Criteria

- Vision document exists with problem statement, success criteria, scope, unknowns, and assumptions
- At least one research question identified for Phase 1
- No obvious contradictions between success criteria and scope

## Relationship to Other Phases

- **Feeds Phase 1** with research questions derived from unknowns
- **Updated by Phase 1** when research invalidates assumptions
- **Updated by Phase 2** when design reveals the vision was too broad or too narrow
- Part of the [Discovery Loop](../concepts/discovery-loop.md) — expect 2-4 revisions before stabilizing

## Anti-Patterns

- **Solution-first vision** — Describing the solution instead of the problem. "Build a REST API that..." is a design, not a vision.
- **Unmeasurable success** — "Make it good" is not a success criterion. "Pass the reference test suite" is.
- **Missing scope boundaries** — Without explicit "out of scope" items, scope creeps silently.
- **Skipping unknowns** — If you have zero unknowns, you either already know everything (unlikely) or haven't thought hard enough.
- **Premature commitment** — Treating the first vision draft as final. The whole point of the Discovery Loop is that the vision evolves.
