# Ingest Status — Absorb a satellite project's status report into the KB

You are ingesting a project status report into the Tuvium research knowledge base at
`~/tuvium/projects/tuvium-research-conversation-agent/`.

## Arguments

`$ARGUMENTS` — project path (e.g., `~/tuvium/projects/tuvium-ir-experiment`) or a
direct path to a status file (e.g., `.../plans/status-2026-03-17.md`). If omitted,
look for a recently modified `plans/status-*.md` in the current directory.

---

## Phase 1: Locate and Read the Status File

1. If `$ARGUMENTS` is a project path → find the **most recent** `plans/status-*.md`:
   ```bash
   ls {project}/plans/status-*.md | sort | tail -1
   ```
2. If `$ARGUMENTS` is a direct file path → read that file.
3. Read the status file completely before proceeding.

---

## Phase 1.5: Check Treatment Level

Before proceeding with theme mapping, determine the treatment level of this status report.

**LIGHT treatment indicators** (any of these means lifecycle-only ingest):
- The status file begins with `> Treatment: LIGHT (template-based from git log)`
- The project's `projectType` is `docs-site`, `website`, `methodology`, or `research-kb`
- The status file was auto-generated from a git log template (no Phase 2 "What Was Accomplished" sections, no build status, no open issues)

**If the status is LIGHT treatment**:

Do NOT proceed to Phase 2 (theme mapping) or Phase 3 (theme doc updates). Instead:
1. Skip directly to Phase 5 (KB-FEDERATION.md freshness update only)
2. Do NOT append to any theme docs
3. Do NOT update ACTION-ITEMS.md
4. Do NOT update CLAUDE.md routing rows
5. Commit with message: `Ingest status (LIGHT): {project-name} {YYYY-MM-DD} → KB-FEDERATION freshness only`

**If the status is FULL treatment**: proceed normally to Phase 2.

---

## Phase 2: Map to Themes

Identify which of the 7 themes this status touches. Use keyword mapping:

| Theme | Keywords |
|-------|---------|
| 1. Agent Architecture | agent invoker, loop, variant, judge, jury, invoker, state taxonomy, Markov, SAE, pre-analysis, skills, KB |
| 2. Knowledge Mining | KB construction, mined items, knowledge base, tier extraction, curator |
| 3. Research Methodology | publication, baseline, competitor, overfitting, benchmark, SWE-bench, experiment design, cross-project |
| 4. Business & Positioning | licensing, BSL, pricing, JetBrains, positioning, talk, conference |
| 5. Community & Tooling | Spring AI, community, ACP, skills, Loopy, forge methodology |
| 6. Data Analysis | Markov, parquet, DuckDB, figures, T3, coverage results, cost analysis |
| 7. Episodic Capture | stage complete, roadmap progress, blocked on, next step, session |

**Theme 7 guard**: Do not use Theme 7 merely because a status report exists. Theme 7 requires **both**:
1. The project has structured lifecycle artifacts (ROADMAP, plans/, phase docs, stage docs, experiment plans, or planning journals).
2. The status report explicitly references lifecycle movement: phase/stage completion, roadmap progress, paused/resumed state, evaluation result, handoff, or next-step sequencing.

If the update is ordinary maintenance, README changes, version bumps, dependency cleanup, or a stable-state note without lifecycle movement, do **not** map to Theme 7. When Theme 7 is used, cite the specific status-report sentence that justifies it.

---

## Phase 3: Update Theme Docs

For each affected theme, **append** an "Updates from {project} — {date}" section to the end of
`synthesis/phase2/theme-{N}-*.md`. Format:

```markdown
---

## Updates from {project-name} — {YYYY-MM-DD}

**Source**: `{relative path to status file}`

### {Descriptive heading for first finding}

{2-5 sentences summarizing the finding, quoting exact numbers/terms from the status report}

### {Descriptive heading for second finding}
...
```

Keep each section concise (under 15 lines). Quote exact numbers, variant names, and decisions
from the status file — don't paraphrase into vague summaries.

**Section-scope rule**: A single-project ingest may only:
- Create a new `## Updates from {project}` section for this project
- Edit this project's own existing section if correcting a prior ingest
- It must **not** modify, extend, or insert text into another project's section
- It must **not** add unheaded bridge sentences above the new section
- If you notice something relevant to another project, note it in the commit message as a follow-up — do not modify that project's section

**Theme fan-out discipline**: If more than three themes are selected for a single project, include a brief confidence/justification note for each theme in the commit message. Keep additions concise — a single project mapping to 5 themes should be the exception, not the norm.

**Size-class maintenance**: after appending, `wc -l` each touched theme doc and check whether it crossed a size-class threshold:
- **S** (small): < 800 lines — agents may read whole freely
- **M** (medium): 800–1,800 — read whole only when the theme is the primary target
- **L** (large): > 1,800 — navigate via THEME-INDEX summaries + targeted offsets

If a class changed, update the Size cell in BOTH theme tables: root `CLAUDE.md` and `synthesis/CLAUDE.md`. Never record exact line counts anywhere — size classes only (exact counts rot on every ingest; classes only change on threshold crossings).

---

## Phase 4: Update ACTION-ITEMS.md

**High-risk file** — only update when the status report directly supports the change.

Read `synthesis/phase3/ACTION-ITEMS.md`. For each action item that relates to this project:

1. **Update the description** if the project scope has shifted
2. **Add a Progress note** with date: `**Progress ({date})**: {what changed}`
3. **Update acceptance criteria** if baselines or targets were corrected
4. **Update Estimated Scope** if stage completion changed the picture

If the status reveals **new work** not covered by existing action items, add a new item using
the next available ID (check current highest ID first).

Do **not** add interpretive framing, strategic language, or coordination notes that are not grounded in the status report. Every progress note must cite a specific fact from the report.

---

## Phase 5: Update KB-FEDERATION.md

In `KB-FEDERATION.md`, update two locations:

1. **Project Status Reports table** (around line 44): update the `Latest Status` date and path
   for this project. If it's not in the table, add a row.

2. **KB Freshness table** (around line 82): update the consolidation date and summary for
   this project. If not present, add a row.

3. **Federation Routing block** (if present in the status report): treat it as a
   **recommendation, never an automatic rewrite**.
   - `Drift: no` → no action.
   - `Drift: yes` or `unknown` → add/refresh a flag on this project's KB Catalog row (or
     KB Freshness row if the project is not in the catalog):
     `⚠ entry-point drift flagged {YYYY-MM-DD}: {recommended routing} ({confidence})`
   - Do **not** re-point the catalog Entry Point column in the same run. Re-pointing requires
     human confirmation (interactive session, or weekly-kb-sync wave review).
   - Record the block's Reason in the commit message under "Run metadata changes".

---

## Phase 6: Update CLAUDE.md

**High-risk file** — only update when the status report directly supports the change.

In `CLAUDE.md` (project root):

1. Update the navigation row for this project (rows 42-44 range) if it exists, or add one.
2. If the project's state has changed materially (new stage complete, new blocker), update
   the row description.
3. Update `**Journal current through**` date if this status covers newer work than the
   current date shown.

Do **not** add unrelated cross-project coordination notes, routing changes, or strategic framing that is not grounded in this specific project's status report. Each CLAUDE.md change must be traceable to the ingested status.

---

## Phase 7: Commit

**Never use `git add -A`, `git add .`, or broad staging commands.**

Stage only the exact files intentionally changed by this ingest:

```bash
git add KB-FEDERATION.md synthesis/phase2/theme-{N}-*.md synthesis/phase3/ACTION-ITEMS.md CLAUDE.md
```

Before committing, verify no unrelated files are staged:

```bash
git diff --name-only --cached
```

If any file appears that was not intentionally modified by this ingest, unstage it with `git reset HEAD <file>` before committing.

Only these files should be staged:
- `synthesis/phase2/theme-*.md` (updated ones only)
- `synthesis/phase3/ACTION-ITEMS.md`
- `KB-FEDERATION.md`
- `CLAUDE.md`

Commit message format:
```
Ingest status: {project-name} {YYYY-MM-DD} → themes {N,N}

Project-grounded changes:
- Theme N: {1-line reason citing specific status-report fact}
- Theme 7: {used/skipped} — {reason, citing status-report evidence or lack thereof}
- ACTION-ITEMS: {updated/not updated} — {reason citing specific report fact}

Run metadata changes:
- KB-FEDERATION.md: freshness date updated
- CLAUDE.md: journal date updated (run bookkeeping, not project-derived)

Decisions:
- If >3 themes: {confidence justification for each}
```

The "Project-grounded" and "Run metadata" distinction is required. Run metadata (freshness dates, journal dates) is allowed but must not be presented as project-derived claims.

---

## Important Notes

- **Never modify the source status file** — it lives in the satellite project.
- **Append, don't rewrite** theme docs — preserve existing content.
- **Quote exact numbers** from the status report; don't substitute "~" estimates.
- **One status file per invocation** — don't try to batch multiple projects at once.
- If the status file has a "Cross-Project Impact" section, check those other projects
  too and make note of cascading updates needed.
- **Source grounding**: every new KB claim (theme update, action-item progress, CLAUDE.md change) must be traceable to a specific fact in the collected status report. Do not add interpretive synthesis, strategic framing, or cross-project coordination notes that are not grounded in the report being ingested.
- **Scope discipline**: a single-project ingest must not update KB sections unrelated to that project. If you notice something relevant to another project, note it in the commit message as a follow-up — do not modify unrelated sections in this commit.
