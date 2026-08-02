# Forge Methodology KB

> A six-phase methodology for building AI agents, software projects, and conducting research — structured as a queryable knowledge base.

## The reading contract

**To use Forge: read your project's trio — VISION.md, DESIGN.md, ROADMAP.md — and the template for the
phase you are in.** That is the whole obligation. A session can run a phase correctly having read only
those.

**Everything under `concepts/` is reference.** It is case law: why a rule is what it is, and the evidence
behind it. The [concepts register](concepts/index.md) states each concept's rule in one line and tells
you the situation that makes the full page worth opening — read the register, open a page only when its
row describes where you actually are.

If acting correctly ever requires reading a concept page, that is a defect: the rule has not been
distilled into the template where the session meets it.

## Question Routing

| Question | Read |
|----------|------|
| What is Forge and how does it work? | `README.md` |
| Which variant should I use for my project? | `variants/README.md` |
| How do I get started with Forge? | `guides/getting-started.md` |
| What are the six phases? | `README.md` (The Six Phases table) |
| Which concept page is worth my time right now? | `concepts/index.md` (the register — rules + read-this-when) |
| How does the discovery loop work? When does execution go back to it? | `concepts/discovery-loop.md` (both loops) |
| How does Phase 4 differ across variants? | `phases/04-learning-loop.md` (Primary Feedback Modes) then `variants/` |
| How do I develop or maintain a forge command? | `guides/command-development.md` |
| How do I structure a knowledge base for agents? | `concepts/knowledge-base-architecture.md` |
| How do I create a new KB and register it in a federation? | `variants/kb.md` (then `/forge-kb` or `/forge-research-kb`) |
| When should a KB get frontmatter / VOCABULARY.md? | `variants/kb.md` (Stage 3 upgrade path) |
| What template do I use for my vision doc? | `templates/VISION-TEMPLATE.md` (or `VISION-TEMPLATE-research.md` for research) |
| How do judges and evaluation work? | `concepts/judges-and-evaluation.md` |
| What is a steward and when do I need one? | `concepts/steward-agent.md` then `variants/steward.md` |
| How do I review my design artifacts before implementation? | `concepts/conversational-review.md` |
| I need to change a frozen contract / ratified decision / public API. What's the pipeline? | `concepts/act-pipeline.md` |
| What makes a review finding worth acting on? | `concepts/refutation-by-counterexample.md` |
| How do I keep a deferred gap from being silently dropped? | `concepts/registers-of-absence.md` |
| Two things are fighting over one name / a rename keeps being re-argued | `concepts/vocabulary-law.md` |
| What quality tools should I set up first? | `concepts/quality-infrastructure.md` |
| How do I know a check actually catches anything? | `concepts/quality-infrastructure.md` (Checks That Catch) |
| How do I design a DSL / fluent API / CLI so author mistakes get real diagnostics? | `guides/authoring-surface-quality.md` |
| How do I run an independent second implementation against my own contract? | `guides/second-implementation-protocol.md` |
| What should a stage gate's exit report actually say? | `phases/phase-review-template.md` (Gate Exit Is a Measured Report) |
| What is our Java quality bar? (JaCoCo, ArchUnit, JSpecify, OWASP, Javadoc) | `guides/java-library-quality.md` — **the canonical standard**, formerly GP-9 `java-library-finishing-touches.md` |
| How do I make `@NullMarked` actually mean something? | `guides/java-library-quality.md` §4.7 (JSpecify ships annotations only — NullAway at ERROR is the enforcer; wiring, config decisions, adoption triage) |
| `Optional<T>` or `@Nullable` for this return? | `guides/java-library-quality.md` §4.7 (the criterion is *can the caller act on the absence?*, not method-vs-field) |
| How does Forge compare to other AI methodologies? | `inbox/bmad-vs-forge-comparison.md`, `inbox/another-ai-methodology.md` |
| How does AGENTS.md relate to Forge? | `inbox/agents-md-and-plans-directory.md` |
| How does OpenAI's PLANS.md compare to Forge? | `inbox/plans-md-convergence.md` |
| What's the oracle learning loop? | `concepts/oracle-learning-loop.md` |
| How does the Improvement Flywheel work? | `concepts/improvement-flywheel.md` |
| What are the five levers for improving agents? | `concepts/improvement-flywheel.md` (Intervention Levers) |

## Topic Routing

| Topic | Location | Contains |
|-------|----------|----------|
| Core concepts | `concepts/index.md` — **the register** | 23 concepts as one-line rules with a *read this when*, grouped by the moment each bites. The two loops, KB architecture, judges, steward, research patterns, review lenses and the act pipeline, evidence standards, registers of absence, vocabulary law |
| Phase definitions | `phases/` | Phase 0-5 detailed descriptions, exit criteria, anti-patterns |
| Templates | `templates/` | Fill-in templates for vision, research, design, roadmap, learnings, reviews |
| Project variants | `variants/` | Agent, project, research, steward, kb — when to use each, key differences |
| Guides | `guides/` | Getting started, **the canonical Java quality standard** (`java-library-quality.md` — the single home; the `grand-plan/v2` and research-KB `conversations/archive/` copies are frozen snapshots), authoring-surface quality, the second-implementation protocol, research project structure |
| Examples | `examples/` | Minimal directory structure examples for each variant |
| Unsorted | `inbox/` | Methodology comparisons, AGENTS.md/PLANS.md convergence research (staging area) |

## Cross-Topic Questions

| Question | Start with | Also read |
|----------|-----------|-----------|
| How do I set up a research project end-to-end? | `variants/research.md` | `templates/VISION-TEMPLATE-research.md`, `guides/research-project-structure.md` |
| What happens after a project is built? | `concepts/steward-agent.md` | `variants/steward.md` |
| How do I build the evaluation system for an agent? | `variants/agent.md` | `concepts/judges-and-evaluation.md`, `concepts/oracle-learning-loop.md` |
| How do discovery and execution connect? | `concepts/discovery-loop.md` (both loops, one page) | `phases/03-roadmap.md` |

## Not Covered

This corpus does **not** contain:
- Working code implementations (only methodology docs and templates)
- Language-specific tooling beyond Java (only `guides/java-library-quality.md` exists)
- Claude Code configuration or prompt engineering guidance
- Forge skill source code (the `/forge-project`, `/forge-research` etc. skills live elsewhere)
- Case studies or production usage reports
