# Collect Status — Produce a timestamped status report for this project

You are producing a structured status report for the project rooted at your current working directory. This report will be consumed by an orchestrator agent that synthesizes status across multiple projects.

## Arguments
- $ARGUMENTS - Optional: date of last status report (e.g., "2026-02-12"). If not provided, use 14 days ago as the default lookback window.

## Phase 1: Understand the Project

1. **Read CLAUDE.md** at the project root. From it determine:
   - Project name and scope
   - What the project's primary artifacts are (code? research? design docs?)
   - Current priorities or active work

2. **Determine lookback date**: Use the argument if provided, otherwise check for the most recent `plans/status-*.md` file and use its date. If no prior status exists, use 14 days ago.

## Phase 2: Collect Data

Run these checks. Git history is the primary signal — everything else is supplementary.

### Core (always do these)

1. **Git history**: `git log --oneline --since={lookback-date}` — your primary signal. Group commits into logical accomplishments.
2. **Uncommitted work**: `git status` — note any staged or unstaged changes
3. **ROADMAP progress**: Read any `ROADMAP*.md` files — identify which stages/steps are complete vs pending

### If build system exists (pom.xml, build.gradle, package.json)

4. **Build status**: Run `./mvnw verify -q` or equivalent. Report pass/fail and test count.

### If GitHub repo (check with `gh repo view` or `.git/config`)

5. **Open issues/PRs**: `gh issue list --limit 10` and `gh pr list --limit 10`

### If KB exists (`plans/knowledge/` directory)

6. **KB freshness**: Check `last_updated` dates in `plans/knowledge/**/index.md`

### If paper tracker exists (`plans/supporting_docs/paper-tracker.md` or similar)

7. **Corpus state**: Count papers by status (Unread/Skimmed/Read/Summarized), count files in `papers/summaries/`
8. **Pending foraging**: Check for any `HANDOFF-forage-*.md` files

### If hypotheses exist (check VISION.md)

9. **Hypothesis status**: Extract hypothesis IDs and their current status (Untested/Supported/Refuted)

### If experiment/judge infrastructure exists

10. **Experiment results**: Check `plans/learnings/` for recent retrospectives
11. **Judge inventory**: List judges found in the codebase, note any known issues (ABSTAINing, missing data)

### If this is a code project (has build files or src/)

12. **Federation entry-point drift check**: Determine the project's declared federation entry point — look up this project's `entryPoint` field in `~/tuvium/projects/tuvium-research-conversation-agent/kb/projects.yaml` if readable; otherwise default to `CLAUDE.md` and record in the block that the entry point is **implicit (undeclared)**. Then check drift:
    - `git log -1 --format=%cs -- {entry-doc}` vs the dates of this period's substantive commits. **Git history only — never filesystem mtime** (mtime lies: checkouts, copies, tooling touches, restores)
    - Does the entry doc mention the components/concepts central to this period's work?

    This feeds the `## Federation Routing` block in Phase 3. **Scope guard**: this is a check, not a fix — never edit the entry doc, the registry, or KB-FEDERATION.md from here.

## Phase 3: Produce Status Report

Write the report to `plans/status-{today's date YYYY-MM-DD}.md`:

```markdown
# Status: {project-name}

> **Period**: {lookback-date} through {today}
> **Last updated**: {ISO timestamp}

## Summary
{2-3 sentences: what happened in this period, what's the project's current state}

## What Was Accomplished
{Numbered sections derived from git log. Group related commits into logical accomplishments. Include:
- What was done (from commit messages)
- Key decisions or design changes
- Artifacts produced}

## Current State

### What's Working
{Bullet list of things that are operational/complete}

### What's Next
{Bullet list of immediate priorities — from ROADMAP, open issues, or logical next steps}

## Where to Look for Details
| Document | Path | What It Contains |
|----------|------|-----------------|
{Key documents that changed or are relevant, with relative paths}

## Cross-Project Impact
| Project | What Changed | Where |
|---------|-------------|-------|
{Other projects affected by this work — repos touched, dependencies updated, KB entries changed. If none, write "No cross-project impact detected."}
```

**Then append any supplementary sections** based on what you found in Phase 2. Only include sections where you have data — do not include empty sections. Examples:

- If you checked build status → add `## Build Status` with pass/fail and test count
- If paper tracker exists → add `## Corpus State` with paper counts and pending foraging
- If hypotheses exist → add `## Hypothesis Status` table
- If KB exists → add `## KB Freshness` with dates
- If judges exist → add `## Judge Inventory` table
- If open issues/PRs → add `## Open Issues & PRs` summary

### Federation Routing block (code projects — always emit)

For code projects, append this section. It is consumed by `/ingest-status` and weekly-kb-sync as a **recommendation** — emitting it never edits the KB:

```markdown
## Federation Routing

- **Declared entry point**: {path from registry, or "IMPLICIT — none declared, defaulted to CLAUDE.md"}
- **Entry doc last commit**: {YYYY-MM-DD via `git log -1 --format=%cs -- {entryPoint}`, never filesystem mtime} — {N} substantive commits since
- **Latest status report**: this file
- **Stale docs detected**: {paths with 1-line reason each, or "none"}
- **Drift**: yes | no | unknown
- **Recommended routing**: keep {path} | change to {path}
- **Confidence**: high | medium | low
- **Reason**: {1-2 sentences citing specific gaps, e.g., "DESIGN.md predates RunSession/Sweep, both central to this period's work"}
```

## Phase 4: Verify

After writing the status file:
1. Read it back and verify all paths in the "Where to Look" table are valid
2. Ensure the summary accurately reflects the git log
3. Tell the user: "Status report written to `plans/status-{date}.md`"

## Important Notes

- **Do not run destructive commands**. Build verification should use read-only or test-only commands.
- **Git log is your primary signal**. If you can't run builds or access GitHub, the git log alone is sufficient for a useful status report.
- **Be concise**. The status report is consumed by another agent — precision matters more than prose.
- **Cross-project impact is critical**. The orchestrator agent needs to know which other projects were affected to update its global state.
- **Use relative paths** in the "Where to Look" table — the consuming agent knows the project root.
- **Only include what you find**. Don't pad the report with empty sections. A short, accurate report beats a comprehensive-looking empty one.
