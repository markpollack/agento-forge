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
| What quality tooling should I set up in the first roadmap stage? | `quality-infrastructure.md` |
| What are prerequisite designs and when do they emerge? | `prerequisite-designs.md` |
| How do I bootstrap a project from saved AI conversations? | `conversation-bootstrapping.md` |
| What documentation types exist (tutorial, how-to, reference, explanation)? | `documentation-taxonomy.md` |
| How do I collect and aggregate status across multiple projects? | `hierarchical-reporting.md` |
| How do I batch-ingest research results into an existing KB? | `../guides/curator-intake.md` |

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
| `conversation-bootstrapping.md` | Starting from saved AI conversations | You're beginning a project from prior chat sessions |
| `prerequisite-designs.md` | Lightweight designs for tooling/data prerequisites | Research revealed you need a tool before the main project |
| `documentation-taxonomy.md` | Diataxis framework (tutorial/how-to/reference/explanation) | You're writing docs and need to classify content type |
| `hierarchical-reporting.md` | Status collection and aggregation across projects | You're managing multiple agent-driven projects |

## Not Covered

This section does **not** include:
- Implementation details for specific languages or frameworks (see `guides/`)
- Fill-in templates for phase outputs (see `templates/`)
- Variant-specific workflows (see `variants/`)
- Example project structures (see `examples/`)
