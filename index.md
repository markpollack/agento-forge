# Forge Methodology KB

> A six-phase methodology for building AI agents, software projects, and conducting research — structured as a queryable knowledge base.

## Question Routing

| Question | Read |
|----------|------|
| What is Forge and how does it work? | `README.md` |
| Which variant should I use for my project? | `variants/README.md` |
| How do I get started with Forge? | `guides/getting-started.md` |
| What are the six phases? | `README.md` (The Six Phases table) |
| How does the discovery loop work? | `concepts/discovery-loop.md` |
| How does Phase 4 differ across variants? | `README.md` (Phase 4: Three Feedback Modes) then `variants/` |
| How do I structure a knowledge base for agents? | `concepts/knowledge-base-architecture.md` |
| What template do I use for my vision doc? | `templates/VISION-TEMPLATE.md` (or `VISION-TEMPLATE-research.md` for research) |
| How do judges and evaluation work? | `concepts/judges-and-evaluation.md` |
| What is a steward and when do I need one? | `concepts/steward-agent.md` then `variants/steward.md` |
| How do I review my design artifacts before implementation? | `concepts/conversational-review.md` |
| What quality tools should I set up first? | `concepts/quality-infrastructure.md` |
| How does Forge compare to other AI methodologies? | `inbox/bmad-vs-forge-comparison.md` |
| What's the oracle learning loop? | `concepts/oracle-learning-loop.md` |

## Topic Routing

| Topic | Location | Contains |
|-------|----------|----------|
| Core concepts | `concepts/` | Discovery loop, execution pipeline, KB architecture, judges, steward, research patterns |
| Phase definitions | `phases/` | Phase 0-5 detailed descriptions, exit criteria, anti-patterns |
| Templates | `templates/` | Fill-in templates for vision, research, design, roadmap, learnings, reviews |
| Project variants | `variants/` | Agent, project, research, steward — when to use each, key differences |
| Guides | `guides/` | Getting started, Java quality checklist, research project structure |
| Examples | `examples/` | Minimal directory structure examples for each variant |
| Unsorted | `inbox/` | Methodology comparisons and raw research (staging area) |

## Cross-Topic Questions

| Question | Start with | Also read |
|----------|-----------|-----------|
| How do I set up a research project end-to-end? | `variants/research.md` | `templates/VISION-TEMPLATE-research.md`, `guides/research-project-structure.md` |
| What happens after a project is built? | `concepts/steward-agent.md` | `variants/steward.md` |
| How do I build the evaluation system for an agent? | `variants/agent.md` | `concepts/judges-and-evaluation.md`, `concepts/oracle-learning-loop.md` |
| How do discovery and execution connect? | `concepts/discovery-loop.md` | `concepts/execution-pipeline.md` |

## Not Covered

This corpus does **not** contain:
- Working code implementations (only methodology docs and templates)
- Language-specific tooling beyond Java (only `guides/java-library-quality.md` exists)
- Claude Code configuration or prompt engineering guidance
- Forge skill source code (the `/forge-project`, `/forge-research` etc. skills live elsewhere)
- Case studies or production usage reports
