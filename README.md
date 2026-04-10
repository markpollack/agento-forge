# Agento Studio

A methodology and toolkit for building agents that actually work.

Slash commands for Claude Code that scaffold knowledge bases, software projects, research projects, and ongoing stewardship. Start with `/forge-kb` — the rest is coming.

Built on the **Forge methodology** — a six-phase system that separates discovery (iterative phases 0-2) from execution (sequential phases 3-5), treats evaluation as first-class, and produces learnings as a primary artifact alongside code.

## Quick Start

Clone and open in Claude Code:

```bash
git clone https://github.com/markpollack/agento-studio.git
cd agento-studio
claude
```

All slash commands are available immediately. From another project, use `--add-dir`:

```bash
cd ~/my-project
claude --add-dir ~/agento-studio
```

## Slash Commands

| Command | What it does |
|---------|-------------|
| `/forge-project` | Bootstrap a software project (Vision + Design + Roadmap with QA review) |
| `/forge-research` | Bootstrap a research project (Forage + Vision) |
| `/forge-research-kb` | Bootstrap a federated research-partner knowledge base |
| `/forge-eval-agent` | Bootstrap an eval-agent project with judges and benchmarks |
| `/forge-steward` | Bootstrap stewardship for an existing project |
| `/forge-kb` | Structure a document corpus for JIT context Q&A |
| `/plan-to-roadmap` | Convert a plan into a Forge methodology roadmap |
| `/collect-status` | Produce a timestamped status report |

## Choose Your Variant

Forge supports four project types:

| Variant | Use when... | Guide |
|---------|-------------|-------|
| **Eval-Agent** | Building an autonomous agent with judge-based evaluation | [variants/agent.md](variants/agent.md) |
| **Project** | Bootstrapping new software projects | [variants/project.md](variants/project.md) |
| **Research** | Conducting research (papers, studies, investigations) | [variants/research.md](variants/research.md) |
| **Steward** | Ongoing stewardship of an active project or domain | [variants/steward.md](variants/steward.md) |

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

The **Discovery Loop** iterates freely — research invalidates vision assumptions, design reveals knowledge gaps. You exit when vision, research, and design are consistent.

The **Execution Pipeline** is sequential — commit to a roadmap, execute with feedback, document the result.

## Knowledge Base Architecture

Agento Studio codifies two types of knowledge bases for AI agents:

**Code-Agent KB** — Structured reference knowledge consumed by agents during task execution. Routing tables, faceted metadata, controlled vocabulary. Optimized for ≤3-hop lookup.

**Research-Partner KB** — Synthesized strategic knowledge consumed by an AI research partner. Theme-based routing, conversation synthesis, cross-cutting analysis.

Both use **JIT Retrieval** (Explore RAG) — Claude Code's native file tools navigate structured flat files. No vector database, no embeddings. Just markdown files with routing tables in git.

See [concepts/knowledge-base-architecture.md](concepts/knowledge-base-architecture.md) for the full specification including multi-KB federation.

## Key Concepts

- **[Discovery Loop](concepts/discovery-loop.md)** — Why phases 0-2 iterate and when to exit
- **[Execution Pipeline](concepts/execution-pipeline.md)** — Why phases 3-5 are sequential
- **[Research Loop](concepts/research-loop.md)** — Vision↔Research iteration (L₁/L₂/L₃ loss)
- **[Judges and Evaluation](concepts/judges-and-evaluation.md)** — Deterministic + AI judges
- **[Knowledge Base Architecture](concepts/knowledge-base-architecture.md)** — Two KB types, librarian layer, federation
- **[Conversation Bootstrapping](concepts/conversation-bootstrapping.md)** — Starting projects from saved AI conversations

## Scripts

Deterministic tools for research corpus management. No external dependencies — Python 3 standard library only.

| Script | What it does |
|--------|-------------|
| [`scripts/arxiv_ingest.py`](scripts/arxiv_ingest.py) | Download PDFs, metadata, and LaTeX source from arXiv. Idempotent, rate-limited, with verify mode. |
| [`scripts/sync_tracker_download_status.py`](scripts/sync_tracker_download_status.py) | Update paper-tracker tables with download status from batch manifests. |
| [`scripts/run_arxiv_batch.sh`](scripts/run_arxiv_batch.sh) | One-command pipeline: download → sync tracker → verify. |

```bash
# Download papers listed in your tracker
python3 scripts/arxiv_ingest.py --from-tracker --tracker-file plans/supporting_docs/paper-tracker.md

# Download specific papers
python3 scripts/arxiv_ingest.py --id 2210.03629 --id 2405.15793

# Full pipeline (download + sync + verify)
scripts/run_arxiv_batch.sh --from-tracker
```

## Templates

Ready-to-use templates for each phase output in [`templates/`](templates/).

## Philosophy

The core insight: building agents is a discovery problem first, then an execution problem. Most failures come from skipping discovery — jumping straight to implementation without understanding the problem space. Forge makes discovery explicit and gives it structure.

## License

[BSL 1.1](LICENSE) — Converts to Apache 2.0 on April 1, 2029.
