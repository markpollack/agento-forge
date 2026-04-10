# Your First Research Agent

You're going to build a file-based research knowledge base and teach an AI agent to navigate it. By the end, you'll ask a question about coding agents and get a grounded answer — sourced from real papers, not training data.

**Time**: ~20 minutes. **Result**: A working research KB with 5 papers, routing tables, and a research partner you can query.

## What You're Building

This is not a chatbot. It's not a vector database. It's a structured file system that an agent reads directly — markdown files with routing tables that guide the agent to the right context.

Three ideas make it work:

1. **Knowledge lives in files** — summaries, routing tables, and metadata are plain markdown in git
2. **The agent reads those files directly** — no embeddings, no vector search, no retrieval pipeline
3. **Routing tables guide the agent to the right context** — this replaces vector search for this class of problems

The agent runs a simple loop: read a file, decide what to read next, synthesize an answer. It's not guessing. It reads files, follows routing tables, and composes answers from that context.

## Prerequisites

- Python 3 (any recent version — no pip packages needed)
- Git
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)
- Internet access (for arXiv downloads)

## Step 1: Clone and Scaffold (2 min)

Clone Agento Studio and scaffold your research KB:

```bash
git clone https://github.com/markpollack/agento-studio.git ~/agento-studio
cd ~/agento-studio
claude
```

Once Claude Code opens, run the slash command:

```
/forge-research-kb ~/my-research-kb "How do coding agents use tools?"
```

The skill will ask a few questions about your research scope and consumers, then scaffold the project. When it finishes, you'll have:

```
~/my-research-kb/
├── CLAUDE.md                    # Session bridge — teaches agent how to use this KB
├── plans/
│   ├── VISION.md                # Research questions
│   └── supporting_docs/
│       └── paper-tracker.md     # Bibliography with status tracking
├── papers/
│   └── summaries/               # Per-paper structured summaries
└── findings/                    # Cross-cutting analysis
```

Open a new Claude Code session inside your KB:

```bash
cd ~/my-research-kb
claude --add-dir ~/agento-studio
```

The `--add-dir` flag gives Claude Code access to Agento Studio's scripts and slash commands alongside your project.

## Step 2: Seed Your Paper Tracker (2 min)

Open `plans/supporting_docs/paper-tracker.md` and add 5 seed papers. Copy-paste this into the tracker's topic table:

```markdown
## Core Papers

| Ref | Type | arXiv | Priority | Status | Summary File | Notes |
|-----|------|-------|----------|--------|--------------|-------|
| Yao et al. (2023) — ReAct | Paper | 2210.03629 | P0 | Unread | | Reasoning + acting paradigm |
| Yang et al. (2024) — SWE-agent | Paper | 2405.15793 | P0 | Unread | | Agent-computer interface for SWE-bench |
| Jimenez et al. (2024) — SWE-bench | Paper | 2310.06770 | P0 | Unread | | Benchmark for coding agents |
| Wang et al. (2024) — LLM Agents Survey | Paper | 2308.11432 | P0 | Unread | | Comprehensive agent survey |
| Anthropic — Building Effective Agents | Blog | — | P0 | Unread | | Practical agent patterns |

## Download Links for Unread Papers

- 2210.03629
- 2405.15793
- 2310.06770
- 2308.11432
```

## Step 3: Ingest Papers — The Deterministic Layer (3 min)

Run the arXiv ingest script to download PDFs, metadata, and LaTeX source for all tracked papers:

```bash
python3 ~/agento-studio/scripts/arxiv_ingest.py \
  --from-tracker \
  --tracker-file plans/supporting_docs/paper-tracker.md \
  --papers-dir papers
```

You'll see progress output as each paper downloads:

```
Resolved 4 arXiv IDs.
[1/4] 2210.03629
[2/4] 2405.15793
[3/4] 2310.06770
[4/4] 2308.11432
Done.
Stats: success=4 partial=0 failed=0 skipped=0
```

After this, your `papers/` directory contains:

```
papers/
├── 2210.03629.pdf
├── 2405.15793.pdf
├── 2310.06770.pdf
├── 2308.11432.pdf
├── metadata/
│   ├── 2210.03629.json
│   └── ...
├── source/
│   ├── 2210.03629/
│   │   ├── *.tex
│   │   └── ...
│   └── ...
└── manifests/
    └── 20260410T...-batch.json
```

This is the foundation. If the structure is inconsistent, the agent cannot navigate it reliably. The scripts enforce a predictable layout that the agent depends on.

> The Anthropic blog post doesn't have an arXiv ID — you'll need to fetch it separately using Claude Code's WebFetch or save it manually as `papers/anthropic-building-effective-agents.md`.

## Step 4: Generate Your First Summary (5 min)

Ask Claude Code to read a paper and write a structured summary:

```
Read the LaTeX source for ReAct (papers/source/2210.03629/) and write a summary
to papers/summaries/react-reasoning-acting.md using this format:

## Yao et al. (2023) — ReAct: Synergizing Reasoning and Acting in Language Models
**arXiv**: 2210.03629
**Status**: Summarized

### Key Contribution
{1-2 sentences}

### Key Findings
- {finding 1}
- {finding 2}

### Methodology
{How they tested it}

### Limitations
{What they didn't cover}

### Connections
- Relates to: {other papers}
```

Claude Code reads the `.tex` files directly and produces a grounded summary. Update the paper tracker to mark it as `Summarized`.

## Quick Test — Your First Query (1 min)

Now ask a question:

```
What is the ReAct pattern?
```

The agent reads your summary and answers from it — not from training data. You'll see it navigate to `papers/summaries/react-reasoning-acting.md` and cite specific findings. That's the loop working: read, decide, synthesize.

Repeat Step 4 for the remaining papers. Each one takes a few minutes.

## Step 5: Build Routing Tables — Manual Retrieval (3 min)

With summaries written, create the routing layer. This is what makes the KB navigable — and it's what replaces vector search for this class of problems.

Create `papers/summaries/index.md`:

```markdown
# Paper Summaries

Structured summaries of the research corpus on coding agent tool use.

| Summary | Read when... |
|---------|-------------|
| [react-reasoning-acting.md](react-reasoning-acting.md) | Question involves reasoning + acting paradigm, thought-action-observation loops |
| [swe-agent-interface.md](swe-agent-interface.md) | Question involves agent-computer interfaces, SWE-bench tooling |
| [swe-bench-benchmark.md](swe-bench-benchmark.md) | Question involves coding benchmarks, evaluation methodology |
| [llm-agents-survey.md](llm-agents-survey.md) | Question involves agent taxonomy, broad landscape |
| [anthropic-effective-agents.md](anthropic-effective-agents.md) | Question involves practical agent patterns, production systems |

## Not Covered

This corpus does **not** address:
- Multi-agent orchestration (single-agent tool use only)
- Non-coding agent domains (customer service, scientific research)
- Reinforcement learning approaches to agent training
- Commercial agent platforms (LangChain, CrewAI internals)
```

The `Read when...` column is the core mechanism. When the agent gets a question, it reads this table and follows the link whose description matches. If the agent answers poorly, this table is usually the problem — the descriptions aren't specific enough, or they're missing a topic.

The `Not Covered` section is negative knowledge. It prevents the agent from searching for content that doesn't exist and hallucinating an answer.

## Step 6: Ask a Real Question

Now ask something that requires cross-summary reasoning:

```
How does SWE-agent's approach to tool use differ from the ReAct pattern?
```

The agent reads the routing table, identifies two relevant summaries, reads both, and synthesizes a comparison. It cites specific findings from each paper.

This is the full loop:
1. Read routing table (`index.md`)
2. Decide which summaries are relevant
3. Read those summaries
4. Synthesize an answer with citations

## If It Doesn't Work

When the agent gives a wrong or weak answer, the fix is always in the knowledge — not in prompts.

- **Wrong answer** — The routing table needs refinement. The `Read when...` descriptions don't match the question well enough.
- **Missing detail** — The summaries are too shallow. Go back and add more content to the relevant summary.
- **Hallucination** — The `Not Covered` section is missing a topic. Add it explicitly so the agent knows not to fabricate.

This system improves by editing knowledge, not tuning prompts. If the agent can't find the right file, that's a routing problem. If it finds the file but the answer is incomplete, that's a content problem. Both are fixed by editing markdown.

## Step 7: Validate Your KB

Run the health check to catch structural issues:

```
/kb-reindex
```

This checks for orphan files (not referenced by any routing table), broken cross-references, stale indexes, and missing "Not Covered" sections. Fix anything it flags — routing gaps are the most common cause of weak agent answers.

## What You Built

```
~/my-research-kb/
├── CLAUDE.md                         # Session bridge
├── plans/
│   ├── VISION.md                     # Research questions
│   └── supporting_docs/
│       └── paper-tracker.md          # Bibliography + download status
├── papers/
│   ├── 2210.03629.pdf                # Downloaded PDFs
│   ├── metadata/                     # arXiv metadata JSON
│   ├── source/                       # LaTeX source trees
│   ├── summaries/
│   │   ├── index.md                  # Routing table
│   │   ├── react-reasoning-acting.md
│   │   ├── swe-agent-interface.md
│   │   └── ...
│   └── manifests/                    # Batch download logs
└── findings/                         # Cross-cutting analysis
```

## What You Learned

- Routing tables replace vector search for this class of problems
- Knowledge improves by editing files, not tuning prompts
- Structure enables agent navigation — the agent reads, decides, synthesizes

## Why This Works

Instead of probabilistic retrieval:
- You control exactly what the agent reads
- Context selection is explicit, not fuzzy
- Improvements are local — edit a file, not a system

This trades automation for control — and that's the point. You know precisely what the agent sees. When it gets something wrong, you know exactly where to fix it. The knowledge base is a living artifact that improves with every question you ask.

## What Just Happened

You built a research partner that answers questions grounded in real papers. This same pattern scales to codebases (migration guides, API cheatsheets), issue trackers (decision logs, triage rules), and multi-agent systems (federated KBs that cross-reference each other).

The structured knowledge you built here is exactly what coding agents use to navigate unfamiliar codebases and what research partners use to synthesize across dozens of sources.

This is an example of the [Forge methodology](../README.md) — a way to build agent-native knowledge systems incrementally.

## Next Steps

- **Add more papers** — Expand the tracker, run the batch pipeline, write summaries
- **Synthesize themes** — Write cross-cutting analysis in `findings/`
- **Federate** — Connect this KB to other projects via `KB-FEDERATION.md`
- **Explore the full methodology** — See the [Forge phases](../phases/), [concept docs](../concepts/), and [project variants](../variants/)
