# Research Project Example

A minimal example of a research project structure using the Forge methodology.

## Structure

```
my-research/
├── plans/
│   ├── VISION.md                    # Research program overview
│   ├── ROADMAP-paper1-data.md       # Data collection roadmap
│   ├── ROADMAP-paper1-analysis.md   # Analysis roadmap
│   ├── conversations/
│   │   └── ChatGPT-initial-exploration.md
│   ├── supporting_docs/
│   │   ├── summaries/
│   │   │   └── deep-research-q1-*.md
│   │   └── paper-tracker.md
│   └── learnings/
│       └── step-*.md
├── data/
│   ├── raw/                         # Original collected data
│   └── curated/                     # Analysis-ready data
├── scripts/
│   ├── collect_data.py
│   └── transform.py
├── notebooks/
│   ├── 01_exploratory.py
│   └── 02_h1_analysis.py
├── papers/
│   └── 01-paper-name/
│       ├── latex/
│       │   ├── main.tex
│       │   └── sections/
│       └── figures/
└── docs/
    └── setup.md
```

## Key Files

### VISION.md — Research Template

```markdown
# Vision: My Research Program

> **Status**: Active — evolving through Vision ↔ Research iteration

## Problem Statement
Academic work on X assumes Y, but this has never been validated.

## Research Questions
1. RQ1: Does assumption Y hold in practice?
2. RQ2: What factors predict Z?

## Hypotheses

### H1 — Assumption Validity
**Claim**: Assumption Y holds in >90% of cases in domain D.
**Measurement**: Analyze N samples, compute percentage.
**Status**: Untested

### H2 — Predictive Factors
**Claim**: Factor F1 predicts Z better than F2.
**Measurement**: Regression analysis, compare R².
**Status**: Untested

## Unknowns Tracking
| ID | Unknown | Status | Resolution |
|----|---------|--------|------------|
| U1 | Can we get data from source S? | Answered | Yes, API available |
| U2 | What's the baseline performance? | Open | — |

## Paper Structure

### Paper 1 — Validating Assumption Y
**Thesis**: Assumption Y is empirically validated on dataset D.
**Hypotheses tested**: H1
**Target venue**: ICSE/ICSME

## Research Loop Status
- **L₁ (External validity)**: Unbounded — single ecosystem
- **L₂ (Reproducibility)**: Bounded — scripts version-controlled
- **L₃ (Methodological honesty)**: Unbounded — threats not yet listed
```

### ROADMAP-paper1-data.md — Research Roadmap

```markdown
# Roadmap: Paper 1 Data Collection

## Context Loading
### Required Reading
| File | Purpose | Est. Time |
|------|---------|-----------|
| plans/VISION.md | Hypotheses and methodology | 15 min |

## Stage 1: Data Collection

### Step 1.0: Setup
- [ ] READ context loading files
- [ ] VERIFY API access

### Step 1.1: Pilot Collection
- [ ] COLLECT 100 samples
- [ ] VERIFY data quality
- [ ] CHECK: Is coverage sufficient?

### Step 1.K: Go/No-Go
| Signal | Go | No-Go |
|--------|-----|-------|
| Coverage | >= 70% | < 70% |
| Quality | Parseable | Errors |

**Decision**: ___

## Stage 2: Full Collection
(If Go from Stage 1)

### Step 2.1: Collect All Data
- [ ] COLLECT full dataset
- [ ] TRANSFORM to analysis-ready format
- [ ] DOCUMENT provenance
```

## Phase 4: Knowledge Quality Loop

```
1. Execute analysis (run notebooks/scripts)
2. Evaluate claims against evidence:
   - Does H1 hold? What's the percentage?
   - Are there confounds?
   - What would reviewers object to?
3. Update VISION.md:
   - Refine hypothesis wording
   - Add threats discovered
   - Update L₁/L₂/L₃ status
4. Repeat until claims are publication-ready
```

## Multi-Roadmap Pattern

Research programs often have multiple roadmaps:

```
VISION.md (program overview)
    │
    ├── ROADMAP-paper1-data.md ──► ROADMAP-paper1-analysis.md
    │                                      │
    │                                      └──► Paper 1
    │
    └── ROADMAP-paper2-replication.md ──► Paper 2
```

## See Also

- [Research Variant Guide](../../variants/research.md)
- [Research Loop Concept](../../concepts/research-loop.md)
- [VISION-TEMPLATE-research.md](../../templates/VISION-TEMPLATE-research.md)
- [ROADMAP-TEMPLATE-research.md](../../templates/ROADMAP-TEMPLATE-research.md)
- [Research Project Structure Guide](../../guides/research-project-structure.md)
