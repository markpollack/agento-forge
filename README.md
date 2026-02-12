# Forge Methodology

A systematic six-phase methodology for building AI agents, software projects, and conducting research — from initial vision through production-ready results.

Forge structures the messy process of creating something new into repeatable phases with clear inputs, outputs, and exit criteria.

## Choose Your Variant

Forge supports three project types. Start here:

| Variant | Use when... | Guide |
|---------|-------------|-------|
| **Agent** | Building an AI agent with automated evaluation | [variants/agent.md](variants/agent.md) |
| **Software** | Building conventional software | [variants/project.md](variants/project.md) |
| **Research** | Conducting research (papers, studies, investigations) | [variants/research.md](variants/research.md) |

Not sure which to choose? See [variants/README.md](variants/README.md) for a detailed comparison.

## The Six Phases

| Phase | Name | Purpose | Output |
|-------|------|---------|--------|
| 0 | [Vision](phases/00-vision.md) | Define what to build and why | VISION.md |
| 1 | [Research](phases/01-research.md) | Deep investigation of the problem space | Research corpus, reference implementations |
| 2 | [Design](phases/02-design.md) | Technical specification and decisions | DESIGN.md, decision records |
| 3 | [Roadmap](phases/03-roadmap.md) | Break design into implementable steps | ROADMAP.md with entry/exit criteria |
| 4 | [Learning Loop](phases/04-learning-loop.md) | Iterative implementation with feedback | Working implementation + learnings |
| 5 | [Documentation](phases/05-documentation.md) | User-facing docs and tutorials | docs/ directory |

## Two Loops

Forge organizes the six phases into two distinct execution patterns:

```
        DISCOVERY LOOP (Phases 0-2)              EXECUTION PIPELINE (Phases 3-5)
        Iterate until stable                      Sequential after discovery stabilizes

     ┌──────────┐   ┌──────────┐   ┌──────────┐       ┌──────────┐   ┌──────────┐   ┌──────────┐
     │ Phase 0  │<─>│ Phase 1  │<─>│ Phase 2  │ ───>  │ Phase 3  │──>│ Phase 4  │──>│ Phase 5  │
     │ Vision   │   │ Research │   │ Design   │       │ Roadmap  │   │ Learning │   │   Docs   │
     └──────────┘   └──────────┘   └──────────┘       └──────────┘   │   Loop   │   └──────────┘
                                                                      └──────────┘
     <─> = Iterative refinement                       ──> = Sequential execution
```

The **Discovery Loop** iterates freely — research invalidates vision assumptions, design reveals knowledge gaps, and that's expected. You exit when vision, research, and design are consistent and no new discoveries are changing direction.

The **Execution Pipeline** is sequential — you commit to a roadmap, execute it with feedback, and document the result. See [Discovery Loop](concepts/discovery-loop.md) and [Execution Pipeline](concepts/execution-pipeline.md) for details.

## Phase 4: Three Feedback Modes

Phase 4 adapts its feedback mechanism based on what you're building:

- **Agent creation** — a loss-function optimization loop. Execute tests, compute loss, analyze capability gaps, modify the agent, repeat until loss converges.
- **Software creation** — a QA review loop. Implement a roadmap stage, run a structured review, fix findings by severity, repeat until zero blocking issues remain.
- **Research** — a knowledge quality loop. Execute analysis, evaluate claims against evidence, refine hypotheses, repeat until claims are publication-ready.

All three use the same phase structure. They differ in how "done" is measured. See [Judges and Evaluation](concepts/judges-and-evaluation.md) for agent evaluation, and [Research Loop](concepts/research-loop.md) for research evaluation.

## Key Concepts

- **[Discovery Loop](concepts/discovery-loop.md)** — Why phases 0-2 iterate and when to exit
- **[Execution Pipeline](concepts/execution-pipeline.md)** — Why phases 3-5 are sequential and how feedback flows
- **[Research Loop](concepts/research-loop.md)** — Vision↔Research iteration for research projects (L₁/L₂/L₃ loss function)
- **[Judges and Evaluation](concepts/judges-and-evaluation.md)** — Deterministic judges, AI judges, and loss computation
- **[Quality Infrastructure](concepts/quality-infrastructure.md)** — Automated quality checks set up early and running on every build
- **[Prerequisite Designs](concepts/prerequisite-designs.md)** — Lightweight design docs for tooling and data prerequisites that emerge from research
- **[Conversation Bootstrapping](concepts/conversation-bootstrapping.md)** — Starting projects from saved AI conversations as the natural entry point
- **[Conversational Review](concepts/conversational-review.md)** — Using conversational AI to review discovery loop artifacts against the methodology

## Templates

Ready-to-use templates for each phase output:

- [VISION-TEMPLATE.md](templates/VISION-TEMPLATE.md) — Standard vision template
- [VISION-TEMPLATE-research.md](templates/VISION-TEMPLATE-research.md) — Research variant with hypotheses and unknowns tracking
- [RESEARCH-TEMPLATE.md](templates/RESEARCH-TEMPLATE.md)
- [DESIGN-TEMPLATE.md](templates/DESIGN-TEMPLATE.md)
- [ROADMAP-TEMPLATE.md](templates/ROADMAP-TEMPLATE.md) — Standard roadmap template
- [ROADMAP-TEMPLATE-research.md](templates/ROADMAP-TEMPLATE-research.md) — Research variant with context loading and go/no-go gates
- [LEARNINGS-TEMPLATE.md](templates/LEARNINGS-TEMPLATE.md)
- [PREREQUISITE-DESIGN-TEMPLATE.md](templates/PREREQUISITE-DESIGN-TEMPLATE.md)
- [CONVERSATIONAL-REVIEW-TEMPLATE.md](templates/CONVERSATIONAL-REVIEW-TEMPLATE.md)
- [PAPER-TRACKER-TEMPLATE.md](templates/PAPER-TRACKER-TEMPLATE.md) — Literature tracking for research projects
- [PROVENANCE-TEMPLATE.md](templates/PROVENANCE-TEMPLATE.md) — Data lineage documentation

## Guides

- **[Getting Started](guides/getting-started.md)** — Walk through applying Forge to a real problem
- **[Java Library Quality](guides/java-library-quality.md)** — Quality checklist for Java library projects
- **[Research Project Structure](guides/research-project-structure.md)** — Directory conventions for research projects
- **[Phase Review Template](phases/phase-review-template.md)** — Structured quality gate for implementation phases

## Examples

Minimal project structure examples:

- **[Agent Project](examples/agent-project/)** — AI agent with automated evaluation
- **[Software Project](examples/software-project/)** — Conventional software with QA review
- **[Research Project](examples/research-project/)** — Research with multi-roadmap pattern

## Philosophy

Forge is open methodology. The phases, templates, and evaluation patterns are all here for anyone to use.

The core insight: building agents (and software generally) is a discovery problem first, then an execution problem. Most failures come from skipping discovery — jumping straight to implementation without understanding the problem space. Forge makes discovery explicit and gives it structure.

## How Forge Differs

Most AI development guides focus on prompt engineering or tool configuration. Forge is a **project-level methodology** — it structures the entire lifecycle from "I want to build X" through "here's the working, documented result."

- It separates discovery (iterative, exploratory) from execution (sequential, disciplined)
- It treats evaluation as a first-class concern, not an afterthought
- It produces learnings as a primary artifact, not just code
- It works for both AI agents and conventional software projects

## License

[Apache 2.0](LICENSE)
