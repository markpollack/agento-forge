# The Steward Agent

An agent that is continuously accountable for a project or domain — not a one-shot executor, but a persistent custodian.

## Origin

The Steward concept emerges from the cognitive altitude hierarchy described in conversation D-60:

| Level | Role | Time Horizon | Example |
|-------|------|-------------|---------|
| Level 0 | Task executor | Minutes | "Run this migration on File.java" |
| Level 1 | **Steward** | Days–weeks | "Keep agent-client healthy, execute roadmap items" |
| Level 2 | Strategist | Weeks–months | "Plan the three-paper research arc" |
| Level 3 | Meta-architect | Months–years | "Design the experiment-driver platform" |

The Steward sits at Level 1 — above individual task execution, but below strategic planning. It owns a domain, maintains awareness of its state, and executes work within its scope.

## What a Steward Does

A Steward combines two roles:

### Curator (KB Maintenance)
- Maintains the project's knowledge base
- Updates entries when APIs, patterns, or dependencies change
- Cross-references related topics
- Prunes stale content
- Connects to external KBs via federation

### Developer (Project Evolution)
- Executes roadmap items and fixes issues
- Runs builds and tests, flags regressions
- Monitors upstream dependencies for breaking changes
- Proposes and implements improvements within scope

The key insight: **these roles reinforce each other**. The curator's KB knowledge makes the developer more effective. The developer's implementation work generates new KB content. Neither role works well alone — a curator without development context writes abstract docs, and a developer without curated knowledge repeats past mistakes.

## The Lifecycle Arc

```
Project bootstraps → Steward maintains

Phase 0-3: Discovery + Roadmap ──> Phase 4-5: Build ──> Steward: Ongoing
     (Project variant)                (Project variant)     (Steward variant)
```

The transition from build to stewardship is natural:
1. During the build phase, knowledge accumulates in learnings, CLAUDE.md, and developer heads
2. Phase 5 (docs) captures the public-facing knowledge
3. The steward inherits this knowledge as its initial KB
4. Ongoing development generates new knowledge, which the steward curates

**Not every project needs a steward.** A one-off script, a conference demo, or a research paper may complete its lifecycle without ongoing stewardship. The steward variant is for projects with users, consumers, or ongoing development needs.

## github-collector as Infrastructure

The steward's monitoring capability depends on awareness of what's happening:

- **Issues**: What problems have been reported? What's stale?
- **Pull Requests**: What's pending review? What has merge conflicts?
- **Releases**: Have upstream dependencies released new versions?
- **Activity**: Is the project active or going dormant?

`github-collector` (or equivalent monitoring tools) provides this raw data. The steward's KB curates it into actionable summaries.

## Anti-Patterns

### Scope Creep
A steward tries to own too many domains. One steward per project, with federation for cross-project concerns. If a steward needs to touch another project, it should route through federation, not expand its own scope.

### Stale KB
The KB falls behind the actual project state. Stale knowledge is worse than no knowledge — it gives wrong answers confidently. The steward must update the KB as part of every development cycle.

### Monitoring Without Acting
The steward reports health status but never proposes or executes fixes. A steward is not a dashboard — it has development capabilities and should use them.

### Hero Steward
The steward makes significant architectural changes without human approval. Stewards operate within their accountability boundaries — significant changes get proposed, not silently implemented.

### Build-Phase Thinking
Treating every change as a multi-phase project. Stewardship is lighter-weight than bootstrapping. Small fixes and KB updates don't need elaborate roadmaps.

## Relationship to Other Concepts

- **[Knowledge Base Architecture](knowledge-base-architecture.md)** — The steward is the Curator agent for a Code-Agent KB. It owns the KB lifecycle: create, maintain, cross-reference, prune.
- **[Execution Pipeline](execution-pipeline.md)** — The steward enters at Phase 4 (its health monitoring loop), inheriting the roadmap and quality infrastructure from the build phase.
- **[Documentation Taxonomy](documentation-taxonomy.md)** — The steward's KB prioritizes Reference + How-to content (highest agent value), with Explanation content added as the domain matures.
- **[Hierarchical Reporting](hierarchical-reporting.md)** — Stewards produce status reports consumed by an orchestrator agent. Status reporting is step 5 of the health monitoring loop. See that doc for the universal status format, variant-specific sections, and aggregation patterns.
