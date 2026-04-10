# Hierarchical Status Reporting

A pattern for collecting, aggregating, and synthesizing project status across a portfolio of agent-managed projects.

## The Problem

When multiple projects are managed by agents (stewards, research partners, eval-agents, project bootstrappers), no single agent has global visibility. Each operates within its own CLAUDE.md context. The human becomes the sole integration point — manually checking each project, mentally synthesizing progress, and identifying cross-project dependencies.

This doesn't scale. With 10+ active projects, the human cannot maintain accurate global state.

## The Pattern

```
┌───────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR AGENT                       │
│  (research-conversation-agent or similar)                   │
│                                                             │
│  Ingests status reports → updates themes → updates action   │
│  items → identifies cross-project impact → reports to human │
└─────────────┬───────────┬───────────┬───────────┬──────────┘
              │           │           │           │
    ┌─────────▼──┐  ┌─────▼──────┐  ┌▼────────┐  ┌▼─────────┐
    │  Steward   │  │  Research   │  │  Eval-  │  │  Project  │
    │  Agent     │  │  Partner    │  │  Agent  │  │  Agent    │
    │            │  │             │  │         │  │           │
    │ agent-     │  │ agentic-    │  │ experi- │  │ project-  │
    │ client     │  │ patterns    │  │ ment-   │  │ collector │
    │            │  │ research    │  │ driver  │  │           │
    └────────────┘  └─────────────┘  └─────────┘  └───────────┘
         │               │               │              │
    status.md       status.md       status.md      status.md
```

**Key distinction**: This is NOT multi-agent collaboration to solve a single problem. This is organizational hierarchy — each agent independently manages its project and periodically reports upward.

## Status Reports: One Adaptive Format

All agent-managed projects produce status reports with the same core structure. Supplementary sections are included based on what exists in the project — not based on variant classification.

**Design principle**: The status-gathering agent checks what's present (paper tracker? KB? judges? build system?) and includes relevant sections. No need to pre-classify the variant — the project's artifacts speak for themselves.

### Core Sections (Always Present)

Every `plans/status-YYYY-MM-DD.md` includes:

```markdown
# Status: {project-name}

> **Period**: {start-date} through {end-date}
> **Last updated**: {ISO timestamp}

## Summary
{2-3 sentence overview of what happened}

## What Was Accomplished
{Numbered sections derived from git log}

## Current State
### What's Working
### What's Next

## Where to Look for Details
| Document | Path | What It Contains |
|----------|------|-----------------|

## Cross-Project Impact
| Project | What Changed | Where |
|---------|-------------|-------|
```

### Supplementary Sections (Include If Data Exists)

The status-gathering agent probes for these and includes them when found:

| Probe | If Found, Add Section |
|-------|----------------------|
| `pom.xml` or `build.gradle` exists | **Build Status** — pass/fail, test count |
| `gh repo view` succeeds | **Open Issues & PRs** — counts and notable items |
| `plans/knowledge/` directory exists | **KB Freshness** — last_updated dates from index.md files |
| `paper-tracker.md` exists | **Corpus State** — paper counts by status, pending foraging |
| `VISION.md` contains hypotheses | **Hypothesis Status** — ID, claim, status |
| Judge classes in codebase | **Judge Inventory** — tier, status, known issues |
| `ROADMAP*.md` files exist | **Roadmap Progress** — stages/steps complete vs pending |
| `HANDOFF-forage-*.md` files exist | **Pending Foraging** — items not yet executed |

This approach means:
- A project with both judges AND a paper tracker gets both sections
- A pure-code project with just a build system gets just Build Status
- No empty sections, no forced variant classification

## Timestamped Files

Status reports use timestamped filenames to preserve history:

```
plans/
├── status-2026-02-19.md    # Latest
├── status-2026-02-12.md    # Previous
├── status-2026-02-05.md    # Older
└── status.md               # Symlink or redirect to latest (optional)
```

**Why timestamps**: Over time, the status file grows and overwrites previous state. Timestamped files preserve the progression — an agent or human can diff two status files to see what changed between reporting periods.

**Naming convention**: `status-YYYY-MM-DD.md`. If multiple reports on the same day, append a sequence: `status-2026-02-19-2.md`.

## The Status-Gathering Agent

A reusable prompt that collects status from any project regardless of variant. The prompt adapts based on what it finds in the project directory.

### Discovery Protocol

```
1. Read CLAUDE.md → determine project type, scope, variant
2. Run: git log --oneline --since={last-status-date}
3. If build system exists → run build, capture result
4. If gh CLI available → check issues and PRs
5. If plans/knowledge/ exists → check KB freshness dates
6. If paper-tracker.md exists → count papers by status
7. If ROADMAP*.md exists → check stage/phase completion
8. Produce plans/status-YYYY-MM-DD.md using common + variant template
```

### Git History as Primary Signal

`git log` is the most reliable universal signal:
- **Commit messages** reveal what work was done
- **File paths in commits** reveal which areas changed
- **Commit frequency** reveals project activity level
- **Author patterns** reveal who's contributing (human vs agent)

The status-gathering agent should always start with git history, then layer on variant-specific checks.

## Hierarchical Aggregation (Future)

The current system has one level: satellite agents → orchestrator.

Future levels could include:

```
Human
  └── Global Orchestrator (research-conversation-agent)
        ├── Community Manager (aggregates all Apache 2.0 projects)
        │     ├── agent-client steward
        │     ├── agent-judge steward
        │     └── ...
        ├── Private Manager (aggregates all private projects)
        │     ├── experiment-driver eval-agent
        │     ├── refactoring-agent steward
        │     └── ...
        └── Research Manager (aggregates all research projects)
              ├── agentic-patterns research
              ├── judge-evaluation research
              └── ...
```

Each intermediate manager:
- Collects status from its direct reports
- Produces its own aggregated status report
- Passes upward to the global orchestrator

**When to add levels**: When the global orchestrator's context window can't efficiently process all individual status reports in one session. Currently ~10-15 projects can be handled in a single level.

## Automated Collection

For scheduled status collection, see the architecture in ACTION-ITEMS.md MEDIUM-19:

- **Scheduler**: JobRunr OSS (free tier — dashboard, persistence, StorageProvider API)
- **Runtime**: Spring Boot + claude-agent-sdk-java
- **Jobs**: Per-project recurring jobs (weekly), synthesis job (after collection)
- **Persistence**: PostgreSQL (job history, metadata via JobRunr labels)

The StorageProvider API enables orchestrator agents to query job history: "When was the last successful status collection for experiment-driver?"

## Relationship to Other Concepts

- **[Steward Agent](steward-agent.md)** — Stewards are one type of status producer. Their health monitoring loop (step 5: "Report gaps and recommendations") is the status reporting step.
- **[Knowledge Base Architecture](knowledge-base-architecture.md)** — Status reports reference KB state (freshness, coverage). The orchestrator's KB (federation) routes to individual project KBs.
- **[Research Loop](research-loop.md)** — Research projects report hypothesis status and corpus state alongside standard status sections.
- **[Execution Pipeline](execution-pipeline.md)** — Project and eval-agent variants report phase progress and experiment results.
