---
name: kb-reindex
description: "Run re-indexing health checks across all federated knowledge bases"
---

# KB Re-Index — Federation-Wide Health Check

You are running a re-indexing health check across the Tuvium knowledge base federation. This command can be run from any project — it operates on all federated KBs.

## Arguments

- `$ARGUMENTS` — Optional: specific KB name to check (e.g., "tuvium-knowledge", "research-conversation-agent"). If omitted, checks all federated KBs.

## Federation Catalog

Read the canonical federation catalog at:
`/home/mark/tuvium/projects/tuvium-research-conversation-agent/KB-FEDERATION.md`

This lists all KBs, their entry points, and last-consolidated dates.

## Health Checks (per KB)

Run these 7 checks against each KB. Adapt based on KB type — not all KBs have all file types.

### Check 1: Cross-reference integrity
- Extract all `see_also` targets from YAML frontmatter
- Verify each referenced file exists
- Report broken links

### Check 2: Vocabulary compliance (Code-Agent KBs only)
- Extract all `subjects` values from frontmatter
- Confirm each is in the KB's `VOCABULARY.md`
- Report uncontrolled terms

### Check 3: Orphan detection
- Find files without faceted metadata: `grep -rL "task_types:" {kb}/*/`
- For Research KBs without frontmatter, check for files not referenced by any index
- Report orphaned files

### Check 4: Index freshness
- For each index.md, verify routing tables reference all files in their directory
- Check for files added since last index update
- Report stale routing tables

### Check 5: Bidirectional links
- If A→B in see_also, verify B→A exists
- Report one-directional references

### Check 6: Concept coverage (NEW — from rehydration experiment)
- Grep theme docs, detail files, and synthesis docs for defined terms and taxonomies
- Check which concepts appear in KEY-CONCEPTS.md (or equivalent glossary)
- Flag concepts that exist in detail docs but not in the glossary
- Bias toward operational concepts: if an agent would need it to answer a domain question, it should be indexed
- **What to grep for**: pattern names with capital letters, "N-tier/N-layer/N-branch" constructs, named taxonomies, acronyms defined in-place

### Check 7: Summary-source consistency (NEW — from rehydration experiment)
- For each bullet in THEME-INDEX.md (or equivalent summary) that contains a number or taxonomy name
- Read the source document and verify the number/name still matches
- Flag mismatches (e.g., summary says "3-tier" but source says "4-tier")
- **Common failure mode**: a concept evolves in the detail doc but the summary isn't updated

## KB-Specific Adaptations

| KB | Glossary File | Summary File | Has Frontmatter? |
|----|--------------|--------------|-------------------|
| tuvium-knowledge | `index.md` + domain indexes | Domain index.md files | Yes (full YAML) |
| research-conversation-agent | `KEY-CONCEPTS.md` | `synthesis/phase2/THEME-INDEX.md` | Partial |
| agentic-patterns-research | `CLAUDE.md` (lines 110-136) | Synthesis docs | No |
| tuvium-experiment-driver | `plans/DESIGN.md` | N/A | No |
| judge-evaluation-research | `CLAUDE.md` | N/A | No |
| tuvium-collector | `plans/DESIGN.md` | `plans/ROADMAP*.md` | No |

For KBs without formal frontmatter, adapt checks:
- Skip checks 1-3, 5 (no structured metadata)
- Run checks 4, 6, 7 against their CLAUDE.md, DESIGN.md, and synthesis docs

## Output Format

For each KB, produce a health report:

```markdown
### {KB Name}
**Path**: {path}
**Last consolidated**: {date from KB-FEDERATION.md}
**Checks run**: {N}/7

| Check | Status | Issues |
|-------|--------|--------|
| Cross-references | PASS/FAIL | {details} |
| Vocabulary | PASS/SKIP | {details} |
| Orphans | PASS/FAIL | {details} |
| Index freshness | PASS/FAIL | {details} |
| Bidirectional links | PASS/SKIP | {details} |
| Concept coverage | PASS/FAIL | {N concepts missing from glossary} |
| Summary-source consistency | PASS/FAIL | {N mismatches} |
```

## After All Checks

1. Write the full report to `/home/mark/tuvium/projects/tuvium-research-conversation-agent/analysis/kb-health-report-{date}.md`
2. Update the `last_consolidated` dates in `KB-FEDERATION.md` for any KBs that pass all checks
3. Summarize: total issues found, KBs needing attention, recommended fixes

## Execution Strategy

Use parallel subagents (one per KB) for speed. Each agent should:
1. Read the KB's entry point and structure
2. Run the applicable checks
3. Return structured results

Then aggregate into the final report.

## Provenance

This command was created based on findings from the **cognitive rehydration experiment** (2026-02-27). The experiment revealed that:
- Concept coverage gaps (Check 6) caused agents to miss important terms not indexed in KEY-CONCEPTS.md
- Summary-source inconsistencies (Check 7) caused scoring disagreements about factual details (e.g., "3-tier" vs "4-tier" CascadedJury)
- These gaps were invisible to the existing 5-check maintenance workflow

See: `/home/mark/tuvium/projects/tuvium-cognitive-rehydration/findings/cognitive-rehydration-results.md`
