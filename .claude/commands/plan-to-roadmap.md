---
name: plan-to-roadmap
description: "Convert Claude Code's plan into a Forge methodology roadmap with step-by-step tracking"
---

# Plan to Roadmap — Convert Plan to Forge Methodology Roadmap

You have just produced a plan (likely in `~/.claude/plans/`). Do NOT execute it directly. Instead, convert it into a Forge methodology roadmap so the user can track progress step-by-step, capture learnings, and course-correct as implementation proceeds.

## What to Do

1. **Read the plan** you just created (check `~/.claude/plans/` for the most recent file, or the plan you just presented to the user).

2. **Read the Forge roadmap template and phase definition** for structural guidance:
   - Template: `{agento-forge}/templates/ROADMAP-TEMPLATE.md`
   - Phase definition: `{agento-forge}/phases/03-roadmap.md`
   - Learnings template: `{agento-forge}/templates/LEARNINGS-TEMPLATE.md`

   `{agento-forge}` → `$AGENTO_FORGE_HOME` (default: `$HOME/projects/agento-forge`)

3. **Transform your plan** into the `ROADMAP-TEMPLATE.md` format:
   - Group related work items into numbered **stages** (Stage 1, Stage 2, ...)
   - Within each stage, create numbered **steps** (Step 1.0, 1.1, 1.2, ...)
   - Each step must have:
     - **Entry criteria** — what must be true before starting (checkboxes)
     - **Work items** — concrete tasks to do (checkboxes, imperative verbs: IMPLEMENT, CREATE, CONFIGURE, VERIFY, etc.)
     - **Exit criteria** — what must be true to consider it done (checkboxes)
     - **Deliverables** — what this step produces
   - Order steps by dependency — no circular dependencies
   - Stage 1 should begin with a review step (Step 1.0) that reads the plan/design
   - Keep steps small enough to complete in one focused session
   - **Every step's entry criteria** must include reading the prior step's learnings file:
     ```
     - [ ] Read: `plans/learnings/step-{PREV}-{topic}.md` — prior step learnings
     ```
     This ensures context from previous steps (discoveries, design changes, pitfalls) is loaded before starting new work. Without this, knowledge is lost between steps — especially across sessions.
   - **Every step's exit criteria** must include the standard items:
     ```
     - [ ] Create: `plans/learnings/step-X.Y-topic.md`
     - [ ] Update `CLAUDE.md` with distilled learnings
     - [ ] Update `ROADMAP.md` checkboxes
     - [ ] COMMIT
     ```
   - **The last step of each stage** (or the final stage) should be a **consolidation step** that:
     - Reads all per-step learnings from the stage
     - Compacts them into `plans/learnings/LEARNINGS.md` (key discoveries, patterns, deviations, pitfalls)
     - Updates `CLAUDE.md` with the full stage's distilled learnings
     - Creates a stage summary learnings file
     This prevents fragmented knowledge — `LEARNINGS.md` is the Tier 1 compacted summary that future stages and sessions read first.
   - **The first step of Stage N (N > 1)** must gate on Stage N-1 consolidation being complete. Add these to its entry criteria:
     ```
     - [ ] Stage N-1 consolidation complete — Read: `plans/learnings/step-X.K-stageN-1-summary.md`
     - [ ] Read: `plans/learnings/LEARNINGS.md` — full compacted project learnings
     ```
     Without this, a new stage can start before the prior stage's knowledge is captured, causing the exact knowledge fragmentation that consolidation is meant to prevent.

4. **Write the roadmap** to `plans/ROADMAP.md` in the current project directory.

5. **Set up the learnings structure**:
   - Create `plans/learnings/` directory
   - Create `plans/learnings/LEARNINGS.md` from the learnings template

6. **Add a reminder to the project's CLAUDE.md** (or create one if it doesn't exist) noting that `plans/ROADMAP.md` is the source of truth for implementation progress, and that each step should be executed individually with learnings captured.

## Important

- Do NOT begin implementation. Only produce the roadmap and learnings structure.
- Do NOT delete or modify the original plan in `~/.claude/plans/` — it's fine to leave it there as a reference.
- The roadmap lives in the **project directory** (`plans/ROADMAP.md`), not in `~/.claude/`.
- After producing the roadmap, tell the user which step to start with and ask if they'd like to begin Step 1.0.

## Why This Matters

Plans in `~/.claude/plans/` are ephemeral — they disappear with the conversation context. A Forge roadmap in `plans/ROADMAP.md`:
- Persists across sessions (it's in the repo)
- Has checkboxes for tracking progress
- Captures learnings at every step (preventing knowledge loss)
- Enables course correction (entry/exit criteria make state visible)
- Supports stage reviews (quality gates between groups of steps)
