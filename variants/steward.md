# Steward Variant

Ongoing stewardship of an active project or domain.

## When to Use

Use the steward variant when:

- A project already exists and needs ongoing health monitoring and development
- A domain needs a persistent, accountable agent (not one-shot)
- Knowledge base maintenance is part of the work
- github-collector or similar monitoring feeds into the agent's awareness
- The project has passed its build phase and needs continuous attention

## Key Differences from Other Variants

| Aspect | Steward | Eval-Agent | Project | Research |
|--------|---------|-----------|---------|----------|
| Phase 4 | Health monitoring loop | Loss optimization loop | QA review loop | Knowledge quality loop |
| Lifecycle | **Ongoing** (continuous) | Finite (converge) | Finite (build + ship) | Finite (publish) |
| Success metric | Domain health maintained | Loss < threshold | Zero blocking findings | Claims supported |
| Primary artifact | Maintained project + KB | Working agent | Shipped software | Papers/findings |
| KB role | **Curator** (read-write) | Consumer (optional) | None | Research-Partner KB |

## Entering Stewardship

Projects transition to steward variant from other variants:

```
Project Variant (bootstrap) ──handoff──> Steward Variant (maintain & evolve)
Eval-Agent Variant (build)  ──agent built──> Steward Variant (maintain the agent)
Research Variant (investigate) ──findings──> Steward (consumes research findings)
```

### Handoff Conditions

- Phase 5 (documentation) complete, or project is already live
- Knowledge accumulated during build phases becomes the initial KB
- Steward sections are added to the existing CLAUDE.md (augment, don't replace)
- Deferred roadmap items become the steward's initial development queue

### What the Steward Inherits

- **From Project variant**: build config, test suite, quality infrastructure, learnings
- **From Eval-Agent variant**: benchmark cases, judges, convergence history
- **From Research variant**: findings, paper summaries, research methodology
- **From the codebase**: existing CLAUDE.md, plans/, and any accumulated knowledge

## Phase 4: Health Monitoring Loop

The steward variant uses a **health monitoring loop** — continuous, not convergent:

```
┌──────────────────────────────────────────────────────────────────┐
│                   HEALTH MONITORING LOOP                          │
│                                                                   │
│  1. Check project health (build, tests, deps, open issues)       │
│  2. Review incoming changes (issues, PRs, releases from          │
│     github-collector or similar monitoring)                      │
│  3. Maintain KB currency (new patterns, API changes,             │
│     stale entries)                                                │
│  4. Plan and execute development work (roadmap steps,            │
│     issue fixes, dependency updates)                             │
│  5. Produce status report (plans/status-YYYY-MM-DD.md)           │
│  6. Report gaps and recommendations to human                     │
│                                                                   │
│  No termination — loop runs continuously across sessions         │
└──────────────────────────────────────────────────────────────────┘
```

### Two Operating Modes

The steward alternates between two modes within each session:

**Development Mode** — actively building or fixing:
- Execute roadmap steps or issue fixes
- Write code, run tests, create PRs
- Update CLAUDE.md and learnings as work progresses
- Standard Forge execution patterns apply (entry/exit criteria, learnings)

**Stewardship Mode** — monitoring, maintaining, planning:
- Check build and test health
- Review github-collector output (new issues, PRs, releases)
- Update KB with new patterns, API changes, deprecations
- Plan upcoming development work
- Identify and report gaps to the human

**Which mode to use?** If the human says "check on things" or "what's the status" → Stewardship Mode. If they say "fix this" or "implement that" → Development Mode. When in doubt, start with Stewardship Mode and propose Development Mode actions.

## Monitoring Integration

The steward uses available monitoring tools to stay aware of project state:

### github-collector

Primary data source for open-source projects:
- **Issues**: new issues, labels, priority, staleness
- **Pull Requests**: open PRs, review status, merge conflicts
- **Releases**: upstream dependency releases, changelog entries
- **Collaborators**: contributor activity patterns

Output goes to the steward's KB (e.g., `plans/knowledge/monitoring/github-summary.md`).

### Build/Test Status

- Run the project's build and test suite
- Track test pass rates, build times, coverage trends
- Flag regressions early

### Dependency Monitoring

- Check for dependency updates (security patches, major versions)
- Track upstream SDK/framework releases
- Assess migration effort for breaking changes

## Knowledge Base Stewardship

The steward is the **curator** of the project's KB. This means:

### KB Structure

The steward's KB lives under `plans/knowledge/` (gitignored for private knowledge):

```
plans/knowledge/
├── index.md                    # Root routing table + federation cross-refs
├── {domain}/
│   ├── index.md                # Domain routing table
│   └── {topic}.md              # Detail files
└── monitoring/
    ├── index.md                # Monitoring routing
    └── github-summary.md       # Issue/PR/release summary
```

### KB Maintenance Responsibilities

1. **Currency** — Update entries when APIs, patterns, or dependencies change
2. **Cross-referencing** — Link related topics across domains
3. **Gap identification** — Note what's missing and flag to the human
4. **Federation** — Maintain cross-references to external KBs via federation routing
5. **Pruning** — Remove stale or incorrect entries

See [Knowledge Base Architecture](../concepts/knowledge-base-architecture.md) for the full KB structure specification.

## Accountability Boundaries

Every steward CLAUDE.md must define explicit boundaries:

### What the Steward Owns

- The project's build health, test suite, and quality infrastructure
- The project's KB (plans/knowledge/)
- Tracking upstream changes that affect the project
- Executing roadmap items and fixing issues within scope

### What the Steward Does NOT Own

- Upstream dependencies (can monitor, cannot fix)
- Other projects in the ecosystem (use federation cross-refs)
- Strategic decisions (reports to human, doesn't make product decisions)
- Confidential or IP-sensitive content outside its domain

### Why Boundaries Matter

Without explicit boundaries, stewards suffer from **scope creep** — trying to own everything they can see. The boundary definition prevents this by making the scope explicit in CLAUDE.md, so every session starts with a clear understanding of what's in and out of scope.

## Anti-Patterns

### Monitoring Without Acting
Reporting issues without proposing or executing fixes. The steward is not a dashboard — it's an agent with development capabilities.

### Stale KB
Letting the KB fall behind the actual project state. If the KB is stale, it's worse than no KB — it gives wrong answers confidently.

### Scope Creep
Trying to steward too many domains or projects. One steward per project/domain, with federation for cross-project concerns.

### Hero Steward
A steward that makes big changes without reporting to the human. The steward should propose significant changes and get approval, not silently refactor.

### Build-Phase Thinking
Treating stewardship like a project build — creating elaborate roadmaps and phase gates for minor maintenance work. Stewardship is lighter-weight: check, maintain, develop, report.

## CLAUDE.md Template

A steward's CLAUDE.md augments the existing project CLAUDE.md with these sections:

```markdown
## Steward Mission
{One sentence: what this steward is accountable for}

## KB Navigation
{Routing table to plans/knowledge/ and federation cross-refs}

## Two Modes
- **Development Mode**: {what triggers it, what to do}
- **Stewardship Mode**: {what triggers it, what to do}

## Health Checklist
- [ ] Build passes: {build command}
- [ ] Tests pass: {test command}
- [ ] {domain-specific checks}

## Accountability Boundaries
### Owns: {explicit list}
### Does NOT own: {explicit list}
```

## Concepts

- [Knowledge Base Architecture](../concepts/knowledge-base-architecture.md) — KB structure, librarian layer, federation
- [Steward Agent](../concepts/steward-agent.md) — Origin, design philosophy, lifecycle arc
- [Execution Pipeline](../concepts/execution-pipeline.md) — How feedback flows (steward enters at Phase 4)
- [Hierarchical Reporting](../concepts/hierarchical-reporting.md) — Status report format, variant-specific data collection, automated aggregation

## Example

See the agent-client project (`~/community/agent-client/`) for a steward instance with:
- KB at `plans/knowledge/` with architecture, development, and monitoring domains
- CLAUDE.md with steward sections, health checklist, and accountability boundaries
- Federation cross-references to agentic-patterns-research and tuvium-devnexus-2026
