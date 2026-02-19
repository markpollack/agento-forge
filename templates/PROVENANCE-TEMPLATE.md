# Data Provenance: {{DATASET_NAME}}

> **Created**: {{DATETIME}}
> **Last updated**: {{DATETIME}}
> **Version**: {{VERSION}}

This document tracks the lineage of data from source through analysis-ready form. Required for reproducibility.

## Dataset Overview

| Field | Value |
|-------|-------|
| **Name** | {{DATASET_NAME}} |
| **Purpose** | {{WHAT_THIS_DATA_IS_USED_FOR}} |
| **Size** | {{N_RECORDS}} records, {{SIZE}} on disk |
| **Time range** | {{START_DATE}} to {{END_DATE}} |
| **Format** | {{FORMAT}} (Parquet, JSON, CSV) |
| **Location** | `{{PATH}}` |
| **DOI** | {{ZENODO_DOI}} (if published) |

---

## Source Data

Where the raw data came from:

### Primary Source

| Field | Value |
|-------|-------|
| **Source** | {{SOURCE_NAME}} (e.g., GitHub API, survey, web scrape) |
| **Access method** | {{HOW_ACCESSED}} (API, download, manual) |
| **Access date** | {{DATETIME}} |
| **Credentials** | {{CREDENTIAL_TYPE}} (PAT, API key, none) |
| **Rate limits** | {{RATE_LIMIT_INFO}} |

### Collection Parameters

```
{{COLLECTION_COMMAND_OR_PARAMETERS}}
```

Example:
```bash
python scripts/collect_project.py spring-projects/spring-boot \
    --created-after 2023-01-01 \
    --created-before 2026-01-01 \
    --state closed
```

### Raw Data Location

| Artifact | Path | Records | Size |
|----------|------|---------|------|
| {{ARTIFACT_TYPE}} | `data/raw/{{path}}` | {{N}} | {{SIZE}} |

---

## Transformations

Each transformation step from raw to analysis-ready:

### Step 1: {{TRANSFORMATION_NAME}}

**Input**: `{{INPUT_PATH}}`
**Output**: `{{OUTPUT_PATH}}`
**Script**: `scripts/{{SCRIPT_NAME}}.py`

**What it does**:
- {{TRANSFORMATION_1}}
- {{TRANSFORMATION_2}}

**Filters applied**:
- {{FILTER_1}} — e.g., "Date range: 2023-01-01 to 2026-01-01"
- {{FILTER_2}} — e.g., "State: closed only"

**Records**: {{INPUT_N}} → {{OUTPUT_N}} ({{RETENTION}}% retained)

**Verification**:
```sql
-- Check output count
SELECT COUNT(*) FROM '{{OUTPUT_PATH}}'
```

---

### Step 2: {{TRANSFORMATION_NAME}}

{{REPEAT_STRUCTURE}}

---

## Derived Datasets

Datasets derived from the primary dataset:

| Name | Derivation | Path | Records |
|------|------------|------|---------|
| {{NAME}} | {{HOW_DERIVED}} | `{{PATH}}` | {{N}} |

---

## Quality Checks

Validation performed on the final dataset:

### Completeness

| Check | Expected | Actual | Pass |
|-------|----------|--------|------|
| Total records | >= {{N}} | {{ACTUAL}} | ✓/✗ |
| Date range coverage | {{RANGE}} | {{ACTUAL}} | ✓/✗ |
| Required fields non-null | 100% | {{ACTUAL}}% | ✓/✗ |

### Consistency

| Check | Expected | Actual | Pass |
|-------|----------|--------|------|
| No duplicate IDs | 0 | {{ACTUAL}} | ✓/✗ |
| Foreign keys valid | 100% | {{ACTUAL}}% | ✓/✗ |

### Known Issues

Issues that affect data quality or interpretation:

- **{{ISSUE_NAME}}**: {{DESCRIPTION}}. Impact: {{IMPACT}}. Mitigation: {{MITIGATION}}.

---

## Reproducibility

### Environment

```yaml
# conda environment
name: {{ENV_NAME}}
dependencies:
  - python={{VERSION}}
  - duckdb={{VERSION}}
  - pandas={{VERSION}}
```

Or:
```
# requirements.txt
duckdb=={{VERSION}}
pandas=={{VERSION}}
```

### Full Reproduction Steps

```bash
# 1. Set up environment
conda env create -f environment.yml
conda activate {{ENV_NAME}}

# 2. Collect raw data (requires credentials)
python scripts/collect_project.py {{PARAMS}}

# 3. Transform to analysis-ready format
python scripts/transform.py

# 4. Verify output
python scripts/verify_data.py
```

### Reproduction Notes

- Collection requires: {{REQUIREMENTS}} (API token, network access, etc.)
- Approximate time: {{TIME}} for full collection
- Approximate cost: {{COST}} (API calls, storage, etc.)

---

## Change Log

| Date | Version | Change | Impact |
|------|---------|--------|--------|
| {{DATETIME}} | 1.0 | Initial collection | — |
| | | | |

---

## Related Documents

- Collection script: `scripts/{{SCRIPT}}.py`
- Transform script: `scripts/{{SCRIPT}}.py`
- Analysis using this data: `notebooks/{{NOTEBOOK}}.py`
- Paper referencing this data: `papers/{{PAPER}}/`
