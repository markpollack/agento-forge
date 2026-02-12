# Research Variant

Conducting research with hypothesis-driven iteration and knowledge artifact outputs.

## Quick Start

Bootstrap a new research project:

**Claude Code** (recommended):
```
/bootstrap-research
```

The skill will ask you:
1. What are you researching? (describe your topic and questions)
2. What materials do you have? (conversations, existing directories)
3. Where should the project live?

Then it reads your materials, creates the structure, and drafts a VISION.md with extracted research questions, hypotheses, and unknowns — iterating with you until it captures your research accurately.

**Shell script** (portable fallback):
```bash
/home/mark/tuvium/projects/forge-methodology/scripts/bootstrap-research.sh ~/tuvium/projects/my-study --conversation ~/chats/exploration.md
```

See [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md) for details.

## When to Use

Use the research variant when:

- You're investigating a question or testing hypotheses
- The output is knowledge artifacts: papers, datasets, findings, methodologies
- You need to track literature, claims, and evidence provenance
- Success means "publishable and reproducible findings"

## Key Differences from Other Variants

| Aspect | Research | Software | Agent |
|--------|----------|----------|-------|
| Phase 4 feedback | Knowledge quality loop | QA review loop | Loss optimization loop |
| Success metric | Claims supported by evidence | Zero blocking findings | Loss below threshold |
| Primary artifact | Papers, datasets, findings | Working software | Trained/tuned agent |
| Discovery pattern | Vision↔Research iteration | Vision→Research→Design | Vision→Research→Design |
| Roadmap pattern | Multi-roadmap (per paper/study) | Single roadmap | Single roadmap |

## The Vision↔Research Loop

Research projects use an iterative loop between what you claim (vision) and what the evidence supports (research). This is the core pattern:

```
Vision (claims, hypotheses, positioning)
   ↓
Research (literature review, data analysis, experiments)
   ↓
Evaluate: Does the evidence support the claims?
   ↓
Update Vision (refine claims, add/drop hypotheses, reposition)
   ↓
Repeat until claims are publication-ready
```

See [Research Loop](../concepts/research-loop.md) for the full concept including the L₁/L₂/L₃ loss function for evaluating claim readiness.

## Phase Structure

### Phase 0: Vision

Use [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) instead of the standard template.

Key sections for research:

- **Research Questions** — Core questions you're investigating
- **Hypotheses** — Testable predictions with measurement approach and status
- **Unknowns Tracking** — Open questions with resolution status
- **Paper Structure** — If targeting specific papers, outline them
- **Research Loop Status** — Track L₁/L₂/L₃ for each claim

### Phase 1: Research

Research projects have an expanded Phase 1:

**Literature Review**
- Systematic paper search and reading
- Use [PAPER-TRACKER-TEMPLATE.md](../templates/PAPER-TRACKER-TEMPLATE.md) to organize
- Identify gaps your work addresses
- Find related work to position against

**Data Collection**
- Identify data sources
- Document provenance using [PROVENANCE-TEMPLATE.md](../templates/PROVENANCE-TEMPLATE.md)
- Run pilots before full collection
- Track data quality metrics

**Exploratory Analysis**
- Initial data exploration
- Validate assumptions
- Identify surprises that might change direction

### Phase 2: Design → Methodology

For research, "design" means study methodology:

- What will you measure?
- How will you measure it?
- What are the controls?
- What are the threats to validity?

This often lives in VISION.md rather than a separate DESIGN.md, since the claims and methodology are tightly coupled.

**Skip DESIGN-TEMPLATE.md** for pure research projects. Use it only if you're also building software (e.g., an analysis tool).

### Phase 3: Roadmap

Research projects often have **multiple roadmaps** — one per paper, study, or major milestone:

```
plans/
├── VISION.md                           # Research program overview
├── ROADMAP-paper1-data.md              # Data collection roadmap
├── ROADMAP-paper1-analysis.md          # Analysis roadmap
├── ROADMAP-paper2-replication.md       # Replication study
└── ROADMAP-paper3-extension.md         # Future work
```

Use [ROADMAP-TEMPLATE-research.md](../templates/ROADMAP-TEMPLATE-research.md) for each.

Key patterns:

**Context Loading**
Research roadmaps require loading substantial context before execution. The template includes a "Required Reading" section that lists files the executor must read.

**Go/No-Go Gates**
Research roadmaps include explicit decision points: "If data quality < threshold, stop and pivot."

**Pilot-Then-Full**
For large data efforts, run a pilot first. The template includes a pilot pattern section.

### Phase 4: Knowledge Quality Loop

Research Phase 4 uses a **knowledge quality loop**:

```
┌──────────────────────────────────────────────────────────────────┐
│                   KNOWLEDGE QUALITY LOOP                          │
│                                                                   │
│  1. Execute analysis (run scripts, generate figures)              │
│  2. Evaluate claims against evidence                              │
│     - Does the data support each hypothesis?                      │
│     - Are there alternative explanations?                         │
│     - What would a reviewer object to?                            │
│  3. Refine hypotheses based on findings                           │
│  4. Update Vision.md with refined claims                          │
│  5. Repeat until claims are publication-ready                     │
│                                                                   │
│  Exit when: L₁, L₂, L₃ are bounded and documented                 │
└──────────────────────────────────────────────────────────────────┘
```

**L₁ — External Validity Gap**: How far do claims generalize?
**L₂ — Reproducibility Pressure**: Can someone replicate this?
**L₃ — Methodological Honesty**: Are threats acknowledged?

See [Research Loop](../concepts/research-loop.md) for details on these loss terms.

### Phase 5: Publication

Research Phase 5 is publication rather than documentation:

1. **Write the paper** — Introduction, methodology, results, discussion
2. **Prepare replication package** — Data, scripts, environment files
3. **Publish artifacts** — Zenodo DOI for datasets, GitHub for code
4. **Submit** — Target venue, handle reviews

## Research-Specific Templates

| Template | Purpose |
|----------|---------|
| [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) | Hypotheses, unknowns tracking, paper structure |
| [ROADMAP-TEMPLATE-research.md](../templates/ROADMAP-TEMPLATE-research.md) | Context loading, go/no-go gates, pilot pattern |
| [PAPER-TRACKER-TEMPLATE.md](../templates/PAPER-TRACKER-TEMPLATE.md) | Literature inventory with reading priority |
| [PROVENANCE-TEMPLATE.md](../templates/PROVENANCE-TEMPLATE.md) | Data lineage for reproducibility |

## Project Structure

Research projects typically have this structure:

```
my-research/
├── plans/
│   ├── VISION.md                    # Research program overview
│   ├── ROADMAP-*.md                 # Per-paper/study roadmaps
│   ├── conversations/               # Saved AI conversations
│   │   └── *.md
│   ├── supporting_docs/
│   │   ├── summaries/               # Deep research summaries
│   │   └── paper-tracker.md         # Literature tracking
│   └── learnings/
│       └── *.md
├── data/
│   ├── raw/                         # Original collected data
│   ├── curated/                     # Analysis-ready data
│   └── provenance/                  # Data lineage docs
├── scripts/                         # Analysis scripts
├── notebooks/                       # Jupyter/Jupytext notebooks
├── papers/
│   └── 01-paper-name/
│       ├── latex/
│       └── figures/
└── docs/                            # Setup, environment docs
```

See [research-project-structure.md](../guides/research-project-structure.md) for detailed conventions.

## Multi-Paper Programs

For research programs spanning multiple papers:

### Vision as Program Overview

VISION.md describes the entire research program — all papers, how they connect, the meta-claim they build toward.

### One Roadmap Per Paper

Each paper or major study gets its own roadmap with its own lifecycle.

### Dependencies Between Roadmaps

Document which roadmaps depend on others:

```
Roadmap: Paper 1 Data ──► Roadmap: Paper 1 Analysis
                                  │
                                  └──► Roadmap: Paper 2 (uses Paper 1's dataset)
```

### Shared Artifacts

Multiple roadmaps may share:
- The same dataset (collected once, analyzed multiple ways)
- Common scripts and utilities
- Shared literature review

## Research Activities

### Claim Shaping

Moving from vague intuitions to precise, testable statements:

**Before**: "This approach works better"
**After**: "Method X achieves 15% higher F1 on dataset Y compared to baseline Z (p < 0.05)"

### Deep Research Queries

Targeted literature investigation to answer specific unknowns:

1. Identify a blocking unknown
2. Formulate a precise question
3. Focused search (Google Scholar, Semantic Scholar, dblp)
4. Summarize findings in `supporting_docs/summaries/`
5. Update VISION.md

### Reviewer Simulation

Reading your own work as a skeptical reviewer:

- What would Reviewer 2 complain about?
- Where is the methodology weak?
- What's the most obvious counterargument?
- Which claims are over-stated?

### Threat Discovery

Actively looking for ways the research could be wrong:

- What if the data is biased?
- What if there's a confounding variable?
- What if the sample isn't representative?
- What if the measurement is flawed?

## Concepts

- [Research Loop](../concepts/research-loop.md) — Vision↔Research iteration with L₁/L₂/L₃ loss
- [Discovery Loop](../concepts/discovery-loop.md) — The broader iterative structure
- [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md) — Starting from saved AI conversations

## Example

See [examples/research-project/](../examples/research-project/) for a minimal research project structure.

## Anti-Patterns

### Infinite Literature Review
Reading forever without committing to claims. Set a timebox.

### Premature Writing
Starting the paper before understanding what you're claiming. Run the Vision↔Research loop first.

### Data Hoarding
Collecting more data than needed "just in case." Define what you need upfront.

### Claim Inflation
Overstating findings beyond what evidence supports. Be precise about scope and limitations.

### Single Giant Roadmap
Cramming an entire multi-paper program into one roadmap. Split by paper/study.
