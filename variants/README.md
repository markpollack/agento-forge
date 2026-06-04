# Forge Variants

Forge supports five project types. Choose based on your goals:

| Variant | Use when... | Key difference |
|---------|-------------|----------------|
| [Eval-Agent](agent.md) | Building an autonomous agent with judge-based evaluation | Loss optimization loop in Phase 4 |
| [Project](project.md) | Bootstrapping new software projects | QA review loop in Phase 4 |
| [Research](research.md) | Conducting research (papers, studies, investigations) | Vision↔Research iteration, multi-roadmap pattern |
| [Steward](steward.md) | Ongoing stewardship of an active project or domain | Health monitoring loop (continuous, not convergent) |
| [KB](kb.md) | Structuring a corpus for agent navigation, optionally federated | Navigation quality loop; graduation ladder (local → standalone → federated) |

## How to Choose

**Eval-Agent** if:
- You're building an autonomous agent that completes tasks
- You need automated judges to evaluate output quality
- Success is measured by per-judge convergence criteria

**Project** if:
- You're building a library, service, or application
- Quality is measured through code review and testing
- The output is deployable software with users

**Research** if:
- You're investigating a question or testing hypotheses
- The output is knowledge artifacts (papers, datasets, findings)
- You need to track literature, claims, and evidence provenance

**Steward** if:
- A project already exists and needs ongoing health monitoring and development
- A domain needs a persistent, accountable agent (not one-shot)
- Knowledge base maintenance is part of the work

**KB** if:
- You have a document corpus you want to query across sessions
- Other projects will consume this knowledge (research-partner KB)
- The knowledge base itself is the deliverable, not a project it belongs to

## Lifecycle Connections

The variants have natural lifecycle transitions:

```
Project Variant (bootstrap) ──handoff──> Steward Variant (maintain & evolve)
Eval-Agent Variant (build)  ──agent built──> Steward Variant (maintain the agent)
Research Variant (investigate) ──findings──> Steward (consumes research findings)
Research Variant (investigate) ──consumers appear──> KB Variant (federate the corpus)
Project/Steward knowledge ──outgrows plans/──> KB Variant (graduate to standalone KB)
```

The first three variants are **finite** — they converge on a deliverable and complete. The Steward and KB variants are **ongoing** — Steward maintains a project or domain continuously; KB maintains a corpus and its routing infrastructure continuously.

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

The [Discovery Loop](../concepts/discovery-loop.md) (Phases 0-2) and [Execution Pipeline](../concepts/execution-pipeline.md) (Phases 3-5) apply to the finite variants. The Steward variant enters at Phase 4 (its health monitoring loop) after inheriting context from a completed build phase. The KB variant compresses Phases 0-3 into its bootstrap commands (`/forge-kb`, `/forge-research-kb`) and then lives in Phase 4 (its navigation quality loop). The templates and feedback mechanisms differ per variant.

## Quick Start by Variant

### Eval-Agent Projects

1. Copy [VISION-TEMPLATE.md](../templates/VISION-TEMPLATE.md) → your `plans/VISION.md`
2. Include the Evaluation Architecture section in [DESIGN-TEMPLATE.md](../templates/DESIGN-TEMPLATE.md)
3. Follow the eval-agent-specific steps in [ROADMAP-TEMPLATE.md](../templates/ROADMAP-TEMPLATE.md) (Steps 1.4-1.6, benchmark stage)
4. See [agent.md](agent.md) for the optimization loop

### Project Variant

1. Copy [VISION-TEMPLATE.md](../templates/VISION-TEMPLATE.md) → your `plans/VISION.md`
2. Skip the Evaluation Architecture section in DESIGN-TEMPLATE.md
3. Skip Steps 1.4-1.6 and benchmark stage in ROADMAP-TEMPLATE.md
4. See [project.md](project.md) for the QA review loop

### Research Projects

**Fastest**: Use the `/forge-research` skill — it will ask what you're researching and guide you through setup:

```
/forge-research
```

**Manual**:
1. Copy [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) → your `plans/VISION.md`
2. Skip DESIGN-TEMPLATE.md (methodology lives in VISION.md and per-roadmap docs)
3. Use [ROADMAP-TEMPLATE-research.md](../templates/ROADMAP-TEMPLATE-research.md) for each paper/study
4. See [research.md](research.md) for the Vision↔Research loop and multi-roadmap pattern

### Steward Projects

**Fastest**: Use the `/forge-steward` skill to bootstrap stewardship for an existing project:

```
/forge-steward
```

**Manual**:
1. Identify the project or domain to steward
2. Bootstrap a knowledge base under `plans/knowledge/`
3. Add steward sections to the project's `CLAUDE.md`
4. See [steward.md](steward.md) for the health monitoring loop

### KB Projects

**Fastest**: Use the `/forge-kb` skill on an existing document corpus, or `/forge-research-kb` for a new federated research corpus:

```
/forge-kb {path-to-corpus}
/forge-research-kb {path-to-brief}
```

**Choosing between them**: `/forge-kb` is the 80/20 — routing tables + session bridge over docs you already have. `/forge-research-kb` is the superset for corpora with explicit consumer projects: adds VISION.md, paper tracker with RQ coverage map, PARTNER-QUERY-TEMPLATE.md, and federation registration.

See [kb.md](kb.md) for the graduation ladder (project-local → standalone → federated → Code-Agent KB), federation registration, and the freshness obligations a federated KB takes on.
