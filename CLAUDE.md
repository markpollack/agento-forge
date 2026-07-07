# Forge Methodology

A six-phase methodology for building AI agents, software projects, and conducting research. Forge separates discovery (iterative phases 0-2) from execution (sequential phases 3-5), treats evaluation as first-class, and produces learnings as a primary artifact alongside code.

## Partner Mode (Q&A)

Answer questions grounded in this corpus. Navigate using routing tables, not brute-force search.

**Query algorithm:**
1. Read `index.md` — check Question Routing for a direct match
2. If no direct match, check Topic Routing for the relevant domain
3. Read the domain's `index.md` (e.g. `concepts/index.md`) for more specific routing
4. Read the target file(s)
5. If Grep is needed, search with specific terms (not broad patterns)
6. Synthesize the answer with citations to specific files
7. If the corpus doesn't answer the question, say so — check Not Covered sections

**Response guidelines:**
- Ground every answer in specific files. Cite paths.
- Distinguish what the corpus says from your own interpretation.
- If a question spans multiple topics, show how the pieces connect.
- Note gaps — questions the corpus can't fully answer.

## Source Material Routing

| Document / Area | Path | Key Content |
|----------------|------|-------------|
| Methodology overview | `README.md` | Six phases, two loops, variant comparison, philosophy |
| Variant selection | `variants/README.md` | Decision tree for agent/project/research/steward/kb |
| Bud eval-agent scaffolding | `.claude/commands/forge-bud-eval-agent.md` | `/forge-bud-eval-agent` — copy-then-replace cousin of `/forge-eval-agent` that scaffolds from `bud-agent-experiment-template` (ACP/bud-core, studio.json, golden-path instrumentation pre-wired) |
| KB creation & federation | `variants/kb.md` | Graduation ladder, `/forge-kb` vs `/forge-research-kb`, federation registration, freshness obligations |
| Phase 0: Vision | `phases/00-vision.md` | Problem statement, success criteria, unknowns, exit criteria |
| Phase 1: Research | `phases/01-research.md` | Investigation of problem space, reference implementations |
| Phase 2: Design | `phases/02-design.md` | Technical specification, decisions with rationale |
| Phase 3: Roadmap | `phases/03-roadmap.md` | Implementable steps with entry/exit criteria |
| Phase 4: Learning Loop | `phases/04-learning-loop.md` | Iterative execution with variant-specific feedback |
| Phase 5: Documentation | `phases/05-documentation.md` | User-facing docs, Diataxis taxonomy |
| Core concepts (15 docs) | `concepts/` | Discovery loop, execution pipeline, KB architecture, judges, steward, oracles, research patterns, improvement flywheel |
| Templates (12 docs) | `templates/` | Fill-in templates for every phase output |
| Getting started | `guides/getting-started.md` | Step-by-step walkthrough of applying Forge |
| Methodology comparisons & research | `inbox/` | BMAD-METHOD comparison, AGENTS.md standard, PLANS.md convergence (staging area) |

## Corpus Layout

```
forge-methodology/
├── CLAUDE.md              # This file — session bridge
├── index.md               # Root routing table
├── README.md              # Methodology overview and entry point
├── concepts/
│   ├── index.md           # Concept routing table
│   ├── discovery-loop.md
│   ├── execution-pipeline.md
│   ├── research-loop.md
│   ├── judges-and-evaluation.md
│   ├── oracle-learning-loop.md
│   ├── knowledge-base-architecture.md
│   ├── research-agent.md
│   ├── steward-agent.md
│   ├── conversational-review.md
│   ├── conversation-bootstrapping.md
│   ├── prerequisite-designs.md
│   ├── quality-infrastructure.md
│   ├── documentation-taxonomy.md
│   ├── hierarchical-reporting.md
│   └── improvement-flywheel.md
├── phases/                # Phase 0-5 definitions
├── templates/             # Fill-in templates for phase outputs
├── variants/              # Agent, project, research, steward, kb variants
├── guides/                # Getting started, Java quality, research structure
├── examples/              # Minimal project structure examples
├── inbox/                 # Unsorted staging (comparisons, raw research)
└── plans/                 # Status reports
```

## Key Concepts

- **Discovery Loop vs Execution Pipeline** — Phases 0-2 iterate freely until stable; phases 3-5 execute sequentially. The transition is the highest-leverage review point.
- **Five Variants** — Agent (loss optimization), Project (QA review), Research (hypothesis-evidence iteration), Steward (ongoing health monitoring), KB (navigation quality + graduation ladder). Same six phases, different Phase 4 feedback loops.
- **Judges** — Deterministic (test suites, linters) and AI judges that produce verdicts. Judges drive the Phase 4 feedback loop for eval-agent projects.
- **Knowledge Base Architecture** — Two KB types: Code-Agent (task-driven, faceted, two-agent curator/navigator) and Research-Partner (question-driven, single session bridge). Both use routing tables for ≤3-hop navigation.
- **Steward** — A Level 1 cognitive-altitude agent that combines curator (KB maintenance) and developer (project evolution) roles. The natural successor to a completed build phase.
- **Improvement Flywheel** — A loss-driven iterative improvement method for agent systems. Five levers (prompt, knowledge, execution structure, model, rubric), seven loss dimensions, loop type classification, and the deterministic-over-exploratory principle. Uses journals, Markov analysis, and variant progression. See [concepts/improvement-flywheel.md](concepts/improvement-flywheel.md).

## Not Covered

This corpus does **not** address:
- Working code implementations (only methodology docs and templates)
- Language-specific tooling beyond Java
- Claude Code configuration or prompt engineering
- Forge skill source code (skills live in separate repos/commands)
- Case studies or production usage reports
