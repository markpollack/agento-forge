# Roadmap: {{PAPER_OR_STUDY_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Status**: Not started | In progress | Complete
> **Vision version**: {{VISION_VERSION}}
> **Variant**: Research

## Overview

{{ONE_PARAGRAPH_DESCRIBING_WHAT_THIS_ROADMAP_ACCOMPLISHES}}

### Dependencies

```
{{DEPENDENCY_DIAGRAM_IF_MULTI_ROADMAP}}
```

Example:
```
Roadmap 1 (Data Collection) ──► Roadmap 2 (Analysis) ──► Roadmap 3 (Paper Writing)
                                      │
                                      └──► Roadmap 4 (Replication Study)
```

---

## Context Loading

> *Research roadmaps require loading substantial context before work begins. This section lists what to read and understand.*

### Required Reading

Files the executor must read before starting any stage:

| File | Purpose | Est. Time |
|------|---------|-----------|
| `plans/VISION.md` | Research program overview, hypotheses | 15 min |
| `plans/conversations/{{KEY_CONVERSATION}}` | Core research decisions | 30 min |
| `plans/supporting_docs/summaries/{{SUMMARY}}` | Prior work synthesis | 20 min |

### Context Verification

Before starting Stage 1, verify understanding by answering:

- [ ] What are the hypotheses being tested?
- [ ] What data is required?
- [ ] What are the known threats to validity?
- [ ] What would cause a go/no-go decision?

---

## Stage 1: {{STAGE_NAME}}

> **Status**: ○ Not started | ◐ In progress | ● Complete

### Step 1.0: Setup and Review

**Entry criteria**:
- [ ] Read: Context Loading files above
- [ ] Read: Relevant sections of VISION.md

**Work items**:
- [ ] REVIEW scope and hypotheses for this roadmap
- [ ] VERIFY required data/tools are accessible
- [ ] IDENTIFY any blocking unknowns

**Exit criteria**:
- [ ] Ready to proceed (no blockers)
- [ ] Create: `plans/learnings/step-1.0-setup.md`

---

### Step 1.1: {{STEP_NAME}}

**Entry criteria**:
- [ ] Step 1.0 complete

**Work items**:
- [ ] {{WORK_ITEM_1}}
- [ ] {{WORK_ITEM_2}}

**Exit criteria**:
- [ ] {{EXIT_CRITERION}}
- [ ] Create: `plans/learnings/step-1.1-{{topic}}.md`

---

### Step 1.K: Stage 1 Go/No-Go

> *Research roadmaps include explicit go/no-go decision points.*

**Entry criteria**:
- [ ] All Stage 1 steps complete

**Decision criteria**:

| Signal | Go | No-Go |
|--------|-----|-------|
| {{DATA_QUALITY}} | >= {{THRESHOLD}} | < {{THRESHOLD}} |
| {{COVERAGE}} | >= {{THRESHOLD}} | < {{THRESHOLD}} |
| {{FEASIBILITY}} | Confirmed | Blocked |

**Work items**:
- [ ] EVALUATE decision criteria
- [ ] DOCUMENT decision rationale
- [ ] IF no-go: Update VISION.md with findings, create pivot roadmap

**Exit criteria**:
- [ ] Go/No-Go decision documented
- [ ] If Go: Proceed to Stage 2
- [ ] If No-Go: VISION.md updated, alternative roadmap created

---

## Stage 2: {{STAGE_NAME}}

{{REPEAT_STRUCTURE}}

---

## Stage N: Write-Up

> *Research roadmaps typically end with a write-up stage.*

### Step N.0: Outline and Claims

**Work items**:
- [ ] DRAFT paper outline with section purposes
- [ ] LIST claims and supporting evidence for each
- [ ] VERIFY each claim traces to analysis output

### Step N.1: First Draft

**Work items**:
- [ ] WRITE introduction (problem, contribution, structure)
- [ ] WRITE methodology (reproducible detail)
- [ ] WRITE results (findings with figures/tables)
- [ ] WRITE discussion (interpretation, limitations)
- [ ] WRITE conclusion (summary, future work)

### Step N.2: Internal Review

**Work items**:
- [ ] RUN reviewer simulation (read as skeptical reviewer)
- [ ] LIST anticipated objections and responses
- [ ] FIX gaps identified in simulation

### Step N.3: Finalize Artifacts

**Work items**:
- [ ] PREPARE replication package (data, scripts, environment)
- [ ] UPLOAD to Zenodo (or equivalent) for DOI
- [ ] VERIFY all figures/tables regenerate from scripts
- [ ] UPDATE paper with artifact DOIs

---

## Quick Reference

### Key Paths

| What | Path |
|------|------|
| Vision | `plans/VISION.md` |
| This roadmap | `plans/{{ROADMAP_FILE}}` |
| Learnings | `plans/learnings/` |
| Data (raw) | `data/raw/` |
| Data (curated) | `data/curated/` |
| Analysis scripts | `scripts/` or `notebooks/` |
| Paper source | `papers/{{paper}}/latex/` or `papers/{{paper}}/` |

### Common Commands

```bash
# Analysis environment
conda activate {{ENV_NAME}}

# Run analysis
python scripts/{{SCRIPT}}.py

# Compile paper
./paperctl.sh compile {{paper}}
```

---

## Pilot Data Pattern (Optional)

> *For large data collection efforts, run a pilot first.*

### Pilot Scope

| Aspect | Pilot | Full |
|--------|-------|------|
| Sample size | {{PILOT_N}} | {{FULL_N}} |
| Time window | {{PILOT_WINDOW}} | {{FULL_WINDOW}} |
| Projects | {{PILOT_PROJECTS}} | {{ALL_PROJECTS}} |

### Pilot Success Criteria

- [ ] Collection scripts work end-to-end
- [ ] Data quality meets threshold
- [ ] Analysis produces interpretable results
- [ ] No showstopper issues discovered

### Pilot → Full Transition

If pilot succeeds:
1. Preserve pilot data in `data/raw/` (don't overwrite)
2. Collect full data to `data/expanded/`
3. Validate full data against pilot patterns
4. Re-run all analyses on full data

---

## Conventions

### Commit Convention

```
Stage X: Brief description of what was done
```

### Progress Convention

Fill in blanks and check boxes as you complete each step. Record actual counts for verification.

### Learnings Structure

```
plans/learnings/
├── step-1.0-{{topic}}.md
├── step-1.1-{{topic}}.md
├── stage1-review.md
└── archive/
```

---

## Revision History

| Timestamp | Change | Trigger |
|-----------|--------|---------|
| {{DATETIME}} | Initial draft | — |

> **Timestamp format**: ISO 8601 with minutes and timezone, e.g., `2026-02-12T16:22-05:00`.
