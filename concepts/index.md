# Forge Concepts

> Core ideas and patterns that underpin the Forge methodology.

## Question Routing

| Question | Read |
|----------|------|
| How do phases 0-2 iterate? When do I exit? | `discovery-loop.md` |
| How do phases 3-5 work sequentially? | `execution-pipeline.md` |
| What's the difference between the four variants? | `../variants/README.md` |
| How do judges and loss functions work in Phase 4? | `judges-and-evaluation.md` |
| How should I structure a knowledge base for agents? | `knowledge-base-architecture.md` |
| What is the oracle pattern and how does it reduce KB gaps? | `oracle-learning-loop.md` |
| How does the research variant iterate on claims and evidence? | `research-loop.md` |
| How do I automate Phase 1 research with hierarchical RAG? | `research-agent.md` |
| What is a steward agent and when do I need one? | `steward-agent.md` |
| How do I review discovery artifacts before committing to a roadmap? | `conversational-review.md` |
| What review lenses exist, and which catch what? (personas, gap-hunts, cold second implementations, byte vectors) | `review-lenses.md` |
| What makes a review finding worth acting on? Why do my reviews return opinions instead of defects? | `refutation-by-counterexample.md` |
| I need to change something already decided (a frozen contract, a ratified decision, a public API). What's the review pipeline? | `act-pipeline.md` |
| When do humans review, and what are they for in a pipeline that already runs AI reviews? | `act-pipeline.md` (Team review) |
| How do I keep a known gap from silently closing — or silently never closing? What are a finding's terminal states? | `registers-of-absence.md` |
| Two things in my project are called the same word / a rename keeps being argued about / a find-and-replace broke something | `vocabulary-law.md` |
| How does a recorded decision stay true after the session that made it is cleared? | `decision-enforcement.md` |
| How do I know a check actually catches anything? When does a prose rule become a script? | `quality-infrastructure.md` (Checks That Catch; The Graduation Rule) |
| How does a coordinating session dispatch and verify work done by other sessions? | `session-handoff.md` (The Supervisor Pattern) |
| How do I keep the project record trustworthy — supersessions, corrections, quoted evidence? | `project-knowledge-layout.md` (Records discipline) |
| How should a stage gate exit — what does a gate report actually say? | `../phases/phase-review-template.md` (Gate Exit Is a Measured Report) |
| How do I design a surface people author against (DSL, fluent API, CLI) so mistakes get diagnostics? | `../guides/authoring-surface-quality.md` |
| How do I run a cold second implementation against my own contract without it cheating? | `../guides/second-implementation-protocol.md` |
| What quality tooling should I set up in the first roadmap stage? | `quality-infrastructure.md` |
| What are prerequisite designs and when do they emerge? | `prerequisite-designs.md` |
| How do I bootstrap a project from saved AI conversations? | `conversation-bootstrapping.md` |
| What documentation types exist (tutorial, how-to, reference, explanation)? | `documentation-taxonomy.md` |
| How do I collect and aggregate status across multiple projects? | `hierarchical-reporting.md` |
| How do I continue development across cleared sessions (or dispatch work to another repo's session)? | `session-handoff.md` |
| How is a project's working knowledge organized (learnings/journal/research/inbox)? Where do decisions vs discoveries go? How does the inbox receive messages? | `project-knowledge-layout.md` |
| A delivery step hit an open question too big to absorb and too load-bearing to defer. How do I spend real effort on it without losing the roadmap? | `research-diversion.md` |
| How do I batch-ingest research results into an existing KB? | `../guides/curator-intake.md` |
| How do I scout and collect references to bootstrap a new KB domain? | `../guides/reference-harvest.md` |
| How does the iterative improvement loop work for agent systems? | `improvement-flywheel.md` |
| What are the five levers for improving agent behavior? | `improvement-flywheel.md` (Intervention Levers) |
| How do I build a state taxonomy for Markov analysis? | `improvement-flywheel.md` (Phase 0: State Taxonomy Discovery) |

## Contents

| File | Purpose | Read when... |
|------|---------|--------------|
| `discovery-loop.md` | Why phases 0-2 iterate and exit criteria | You need to understand the iterative discovery process |
| `execution-pipeline.md` | Why phases 3-5 are sequential | You need to understand post-discovery execution |
| `research-loop.md` | Vision-Research iteration for research projects | You're working on a research variant project |
| `judges-and-evaluation.md` | Deterministic + AI judges, loss computation | You're building eval-agent feedback loops |
| `oracle-learning-loop.md` | Oracle calls as KB gap indicators | You're optimizing agent autonomy over iterations |
| `quality-infrastructure.md` | Automated quality checks set up early | You're planning the first roadmap stage |
| `knowledge-base-architecture.md` | Two KB types, librarian layer, federation | You're designing a knowledge base for agents |
| `research-agent.md` | Hierarchical agentic RAG for Phase 1 | You're automating literature review and synthesis |
| `steward-agent.md` | Persistent project custodian (curator + developer) | You're setting up ongoing project maintenance |
| `conversational-review.md` | Using AI to review discovery artifacts | You're checking artifact quality before roadmap |
| `review-lenses.md` | The 9-lens stakeholder-view catalog for design/contract review (Views-and-Beyond + ATAM lineage, extended with gap-hunts, producer-coverage, persona-verb matrices, cold second implementations, conformance vectors, decision journaling) | You're gating a design or freezing a contract and need review coverage beyond requirement-validation |
| `decision-enforcement.md` | The design ↔ test contract: a roadmap exit criterion names the decision it defends, so undefended decisions are visible by absence (**PROVISIONAL** — one project, 2026-07) | You're recording a design decision and want it to survive the people who made it |
| `conversation-bootstrapping.md` | Starting from saved AI conversations | You're beginning a project from prior chat sessions |
| `prerequisite-designs.md` | Lightweight designs for tooling/data prerequisites | Research revealed you need a tool before the main project |
| `documentation-taxonomy.md` | Diataxis framework (tutorial/how-to/reference/explanation) | You're writing docs and need to classify content type |
| `hierarchical-reporting.md` | Status collection and aggregation across projects | You're managing multiple agent-driven projects |
| `improvement-flywheel.md` | Loss-driven iterative improvement for agent systems | You're improving an agent through measured behavioral deltas and experiments |
| `session-handoff.md` | Sessions are disposable, the repo is the memory: work-order handoffs for succession and satellite dispatch | Work outgrows one session, or a coordinator dispatches steps to other repos |
| `project-knowledge-layout.md` | The `plans/` working-memory tree: learnings (discovery) / journal (decisions) / research (reference) / inbox (intake, delivered by gitmaildir) / archive | You're organizing a project's working knowledge, or wondering where a decision vs a discovery belongs |
| `research-diversion.md` | Bounded parallel investigation mid-delivery: presumed-correct-not-frozen framework, open questions in one file, spike before research, adoption optional, terminates by scheduling mechanisms into the delivery roadmap | A step found something the plan can't absorb — a circular measurement, a borrowed-from-the-wrong-field analogy, a claim nobody can state precisely |
| `refutation-by-counterexample.md` | The evidence standard: findings are exhibits, non-findings are recorded searches; a MUST without its breaking case is not a MUST; fund the counterexample search rather than the proof | You're writing a review prompt, grading findings, or about to claim something is complete |
| `act-pipeline.md` | Changing a decided artifact: design → cold machine review (restricted inputs) → fix round (revisions retained) → team review of the post-fix artifact → lockstep ratification; and the owner's place inside the system | A frozen contract, ratified decision, or public API has to move |
| `registers-of-absence.md` | A known gap is a test written to FAIL when the gap closes; honest closure has three shapes; every finding ends fixed / refuted / filed-with-owner / parked-with-trigger | You're deferring something, or disposing of review findings |
| `vocabulary-law.md` | One meaning per word; stated translations at context boundaries; the fluency test decides renames; reserve-by-name at cross-act seams; counting occurrences without classifying senses is a defect | Two constructs are competing for a name, or a rename/sweep is being planned |

## Not Covered

This section does **not** include:
- Implementation details for specific languages or frameworks (see `guides/`)
- Fill-in templates for phase outputs (see `templates/`)
- Variant-specific workflows (see `variants/`)
- Example project structures (see `examples/`)
