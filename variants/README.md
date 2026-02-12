# Forge Variants

Forge supports three project types. Choose based on your goals:

| Variant | Use when... | Key difference |
|---------|-------------|----------------|
| [Agent](agent.md) | Building an AI agent with automated evaluation | Loss-function optimization loop in Phase 4 |
| [Software](project.md) | Building conventional software | QA review loop in Phase 4 |
| [Research](research.md) | Conducting research (papers, studies, investigations) | Vision↔Research iteration, multi-roadmap pattern |

## How to Choose

**Agent** if:
- You're building something that uses AI to complete tasks
- You need automated judges to evaluate output quality
- Success is measured by a loss function converging below a threshold

**Software** if:
- You're building a library, service, or application
- Quality is measured through code review and testing
- The output is deployable software with users

**Research** if:
- You're investigating a question or testing hypotheses
- The output is knowledge artifacts (papers, datasets, findings)
- You need to track literature, claims, and evidence provenance

## Shared Core

All variants share the same six-phase structure:

```
Phase 0: Vision    → What to build/investigate and why
Phase 1: Research  → Deep investigation of the problem space
Phase 2: Design    → Technical specification (software) or methodology (research)
Phase 3: Roadmap   → Implementable steps with entry/exit criteria
Phase 4: Execution → Iterative work with feedback
Phase 5: Docs      → User-facing documentation or publication
```

The [Discovery Loop](../concepts/discovery-loop.md) (Phases 0-2) and [Execution Pipeline](../concepts/execution-pipeline.md) (Phases 3-5) apply to all variants. The templates and feedback mechanisms differ.

## Quick Start by Variant

### Agent Projects

1. Copy [VISION-TEMPLATE.md](../templates/VISION-TEMPLATE.md) → your `plans/VISION.md`
2. Include the Evaluation Architecture section in [DESIGN-TEMPLATE.md](../templates/DESIGN-TEMPLATE.md)
3. Follow the agent-specific steps in [ROADMAP-TEMPLATE.md](../templates/ROADMAP-TEMPLATE.md) (Steps 1.4-1.6, benchmark stage)
4. See [agent.md](agent.md) for the optimization loop

### Software Projects

1. Copy [VISION-TEMPLATE.md](../templates/VISION-TEMPLATE.md) → your `plans/VISION.md`
2. Skip the Evaluation Architecture section in DESIGN-TEMPLATE.md
3. Skip Steps 1.4-1.6 and benchmark stage in ROADMAP-TEMPLATE.md
4. See [project.md](project.md) for the QA review loop

### Research Projects

**Fastest**: Use the `/bootstrap-research` skill — it will ask what you're researching and guide you through setup:

```
/bootstrap-research
```

**Manual**:
1. Copy [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) → your `plans/VISION.md`
2. Skip DESIGN-TEMPLATE.md (methodology lives in VISION.md and per-roadmap docs)
3. Use [ROADMAP-TEMPLATE-research.md](../templates/ROADMAP-TEMPLATE-research.md) for each paper/study
4. See [research.md](research.md) for the Vision↔Research loop and multi-roadmap pattern
