---
name: kb-reindex
description: "Run re-indexing health checks across all federated knowledge bases"
---

# KB Re-Index — Health Check

You are running health checks on the knowledge base(s) in the current project. This catches structural drift before it compounds — broken links, orphaned files, stale routing tables.

## Arguments

- `$ARGUMENTS` — Optional: path to a specific KB directory to check. If omitted, checks the current project root and any KBs listed in `KB-FEDERATION.md` (if it exists).

## Finding KBs to Check

1. Check if the current project root has a `CLAUDE.md` or `index.md` — if so, it's a KB
2. Check if `KB-FEDERATION.md` exists — if so, read it and check each listed KB
3. If `$ARGUMENTS` is a path, check that specific directory

## Health Checks

Run these checks against each KB. Skip checks that don't apply (e.g., vocabulary checks only matter if `VOCABULARY.md` exists).

### Check 1: Routing Table Coverage

For each `index.md` or routing table file:
- List all `.md` files in the same directory (and subdirectories if the table references them)
- Verify every file appears in at least one routing table
- Report files that exist but aren't referenced (**orphans**)
- Report table entries that reference files that don't exist (**broken links**)

### Check 2: Cross-Reference Integrity

- Extract all markdown links and `see_also` references from YAML frontmatter
- Verify each referenced file exists at the specified path
- Report broken references

### Check 3: Vocabulary Compliance

Only if `VOCABULARY.md` exists:
- Extract all `subjects` values from YAML frontmatter across all files
- Confirm each value appears in `VOCABULARY.md`
- Report uncontrolled terms

### Check 4: Bidirectional Links

- If file A references file B in `see_also`, verify B also references A
- Report one-directional references (these cause navigation dead-ends)

### Check 5: Index Freshness

- Compare file modification dates against their parent `index.md`
- Flag routing tables that haven't been updated since new files were added to their directory
- Check the `last_updated` date in file frontmatter if present

### Check 6: Not Covered Sections

- Check that each `index.md` or `CLAUDE.md` has a "Not Covered" section
- Flag KBs missing negative knowledge (these cause hallucination on out-of-scope questions)

### Check 7: Federation Consistency

Only if `KB-FEDERATION.md` exists:
- Verify each KB path in the catalog is accessible
- Check `last_consolidated` dates — flag KBs not updated in 30+ days as potentially stale
- Verify "Read when..." descriptions exist for each entry

## Output Format

```markdown
## KB Health Report — {date}

### {KB Name or Path}
**Checks run**: {N}/7

| Check | Status | Issues |
|-------|--------|--------|
| Routing table coverage | PASS/FAIL | {N orphans, M broken links} |
| Cross-references | PASS/FAIL | {details} |
| Vocabulary | PASS/SKIP | {details} |
| Bidirectional links | PASS/FAIL | {details} |
| Index freshness | PASS/WARN | {details} |
| Not Covered sections | PASS/FAIL | {details} |
| Federation consistency | PASS/SKIP | {details} |

### Recommended Fixes
1. {Specific fix with file path}
2. {Specific fix with file path}
```

## After All Checks

1. Present the report to the user
2. Offer to fix simple issues automatically (add missing files to routing tables, create stub "Not Covered" sections)
3. For complex issues (stale content, vocabulary drift), describe the fix but let the user decide

## Tone

Direct and actionable. Each finding should include the file path and a one-line fix description. Don't over-explain — if a routing table is missing a file, say which file and which table.
