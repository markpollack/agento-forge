# Research Project Structure

Directory conventions and organization patterns for research projects using the Forge methodology.

## Standard Structure

```
my-research/
├── CLAUDE.md                        # AI assistant context (optional)
├── plans/
│   ├── VISION.md                    # Research program overview
│   ├── ROADMAP-paper1-*.md          # Per-paper roadmaps
│   ├── conversations/               # Saved AI conversations
│   ├── supporting_docs/             # Literature, summaries
│   └── learnings/                   # Per-step learnings
├── data/
│   ├── raw/                         # Original collected data
│   ├── curated/                     # Analysis-ready data
│   ├── expanded/                    # Large-scale collection (optional)
│   └── provenance/                  # Data lineage docs (optional)
├── scripts/                         # Collection and analysis scripts
├── notebooks/                       # Jupyter/Jupytext notebooks
├── papers/
│   └── 01-paper-name/
│       ├── latex/
│       │   ├── main.tex
│       │   └── sections/
│       └── figures/
├── findings/                        # Analysis outputs, summaries
└── docs/                            # Setup, environment docs
```

## Directory Details

### plans/

The planning directory contains Forge artifacts:

```
plans/
├── VISION.md                        # Required: research program overview
├── ROADMAP-paper1-data.md           # Optional: data collection roadmap
├── ROADMAP-paper1-analysis.md       # Optional: analysis roadmap
├── conversations/
│   ├── ChatGPT-*.md                 # Exported conversations
│   └── Claude-*.md
├── supporting_docs/
│   ├── summaries/
│   │   ├── deep-research-*.md       # Deep research query results
│   │   └── literature-*.md          # Literature summaries
│   ├── paper-tracker.md             # Literature tracking
│   └── README.md                    # Organization guide
└── learnings/
    ├── step-1.0-setup.md            # Per-step learnings
    ├── step-1.1-collection.md
    └── archive/                     # Old learnings
```

### data/

Data directories separate raw from processed:

```
data/
├── raw/
│   └── project-name/
│       ├── issues/
│       │   └── *.json
│       ├── prs/
│       └── events/
├── curated/
│   ├── fct_issues.parquet           # Analysis-ready tables
│   ├── fct_events.parquet
│   └── dim_projects.parquet
├── expanded/                        # Large-scale collection
│   └── project-name/
│       └── ...
└── provenance/                      # Optional: lineage docs
    └── issues-provenance.md
```

**Conventions**:
- Never modify files in `raw/` after collection
- `curated/` contains derived, analysis-ready data
- `expanded/` for large collections that don't fit in `raw/`
- Use Parquet for analytical queries, JSON for raw API responses

### scripts/

Analysis and collection scripts:

```
scripts/
├── collect_*.py                     # Data collection
├── transform_*.py                   # Raw → curated transforms
├── analyze_*.py                     # Analysis scripts
└── make_figures.py                  # Figure generation
```

**Naming conventions**:
- `collect_X.py` — Fetches data from external sources
- `transform_X.py` — Transforms raw data to curated format
- `analyze_X.py` — Runs analysis, produces findings
- `make_*.py` — Generates figures or tables

### notebooks/

Jupyter or Jupytext notebooks for exploratory analysis:

```
notebooks/
├── 01_exploratory.py                # Initial exploration
├── 02_h1_analysis.py                # Per-hypothesis analysis
├── 03_h2_analysis.py
└── 04_figures.py                    # Final figure generation
```

**Conventions**:
- Prefix with numbers for execution order
- Use Jupytext `.py` files for version control compatibility
- Move finalized analysis to `scripts/` for reproducibility

### papers/

Paper source files:

```
papers/
└── 01-golden-datasets/
    ├── latex/
    │   ├── main.tex
    │   ├── sections/
    │   │   ├── intro.tex
    │   │   ├── methodology.tex
    │   │   ├── results.tex
    │   │   └── discussion.tex
    │   ├── figures/
    │   │   └── *.pdf
    │   └── bibliography.bib
    └── README.md                    # Paper-specific notes
```

**Naming convention**: `NN-short-name/` where NN is paper number.

### findings/

Analysis outputs and summaries:

```
findings/
├── h1-label-authority.md            # Per-hypothesis findings
├── h2-label-stability.md
├── spring-project-survey.md         # Data exploration findings
└── figures/
    ├── h1-authority-distribution.pdf
    └── h2-stability-timeline.pdf
```

## File Naming Conventions

### Roadmaps

```
ROADMAP-{paper}-{phase}.md
```

Examples:
- `ROADMAP-paper1-data.md` — Paper 1 data collection
- `ROADMAP-paper1-analysis.md` — Paper 1 analysis
- `ROADMAP-paper2-replication.md` — Paper 2 replication study

### Learnings

```
step-{stage}.{step}-{topic}.md
```

Examples:
- `step-1.0-setup.md`
- `step-1.1-collection.md`
- `step-2.3-h1-analysis.md`

### Deep Research Summaries

```
deep-research-{question-id}-{topic}.md
```

Examples:
- `deep-research-q4-llm-variance-summary.md`
- `deep-research-q6-nlbse-dataset-realism.md`

### Conversations

```
{Source}-{Topic}.md
```

Examples:
- `ChatGPT-GitHub Issue Label History.md`
- `Claude-Research Publication Strategy.md`

## Data Lineage

For reproducibility, document data lineage using [PROVENANCE-TEMPLATE.md](../templates/PROVENANCE-TEMPLATE.md):

1. **Where did the data come from?** — API, download, manual collection
2. **What transformations were applied?** — Filters, joins, aggregations
3. **What is the final state?** — Record counts, date ranges, quality checks

Store provenance docs in:
- `data/provenance/` (dedicated directory), or
- Inline in the curated data directory as `*-provenance.md`

## Environment Management

Document the analysis environment for reproducibility:

```
docs/
├── setup.md                         # Setup instructions
└── environment.yml                  # Conda environment spec
```

Or use `requirements.txt` / `pyproject.toml` at project root.

**Minimum documentation**:
- Python version
- Key package versions (duckdb, pandas, etc.)
- How to set up from scratch

## Multi-Paper Organization

For research programs with multiple papers:

```
my-research/
├── plans/
│   ├── VISION.md                    # Program overview (all papers)
│   ├── ROADMAP-paper1-*.md
│   ├── ROADMAP-paper2-*.md
│   └── ROADMAP-paper3-*.md
├── data/                            # Shared data (or per-paper subdirs)
├── papers/
│   ├── 01-golden-datasets/
│   ├── 02-classification/
│   └── 03-agents/
└── shared/                          # Shared utilities (optional)
    └── analysis_utils.py
```

## Quick Setup

Minimal setup for a new research project:

```bash
mkdir my-research && cd my-research

# Core directories
mkdir -p plans/{conversations,supporting_docs/summaries,learnings}
mkdir -p data/{raw,curated}
mkdir -p scripts notebooks papers findings docs

# Copy templates
cp path/to/forge-methodology/templates/VISION-TEMPLATE-research.md plans/VISION.md
cp path/to/forge-methodology/templates/PAPER-TRACKER-TEMPLATE.md plans/supporting_docs/paper-tracker.md

# Initialize git
git init
echo "data/raw/" >> .gitignore
echo "data/expanded/" >> .gitignore
echo "*.pyc" >> .gitignore
```

## See Also

- [Research Variant Guide](../variants/research.md) — Full research methodology
- [PROVENANCE-TEMPLATE.md](../templates/PROVENANCE-TEMPLATE.md) — Data lineage documentation
- [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md) — Using saved conversations
