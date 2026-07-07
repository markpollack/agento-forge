# Prepare Handoff — Close this session with a work order for its successor

You are ending (or checkpointing) a development session. Perform the **closing ritual** from
`concepts/session-handoff.md`: bring the repo's durable state up to truth, write a handoff work order, and
hand back the launcher prompt. The premise: sessions are disposable, the repo is the memory — your successor
(a cleared session, or a session in another repo if this is a dispatch) must be able to continue from files
alone.

## Arguments

- $ARGUMENTS — Optional: a short topic for the handoff (e.g. "step-4.2-continuation") and/or the STOP
  checkpoint to encode. If omitted, derive the topic from the current step and stop at that step's exit
  criteria.

## Configuration

Paths are resolved via environment variables. Set these before running the command, or add them to your
shell profile.

- `AGENTO_FORGE_HOME` — the agento-forge checkout (default: `$HOME/projects/agento-forge`). Used for
  `templates/HANDOFF-TEMPLATE.md`; if unavailable, use the section list in Phase 2 verbatim.

## Phase 1: Doc Currency Pass

The handoff is only trustworthy if the documents it points at are true. Bring them current FIRST:

1. **Read** `CLAUDE.md`, `plans/ROADMAP.md` (or the project's tracker), any live status board, and the most
   recent learnings — identify every place where the documented state lags what actually happened this
   session.
2. **Update**: CLAUDE.md's current-status/next-action section; roadmap step checkboxes (tick ONLY what met
   its exit criteria — never round up); the status board; a learnings file for anything significant not yet
   recorded (discoveries, bugs found, decisions taken, run mechanics learned).
3. **Verify the build if code changed this session** (`./mvnw verify` or equivalent) — a handoff must never
   silently pass a broken tree forward. If it's red, say so IN the handoff rather than fixing at the buzzer.
4. **Commit** the currency pass (project commit conventions apply).

## Phase 2: Write the Work Order

Create `plans/inbox/handoff-{YYYY-MM-DD}-{topic}.md` from `$AGENTO_FORGE_HOME/templates/HANDOFF-TEMPLATE.md`
(create `plans/inbox/` if absent). Fill every section:

1. **Roles inherited** — every hat this session wore (executor of step X, coordinator, board-keeper), not
   just the task.
2. **Read in order** — the successor's own conventions first (CLAUDE.md, trackers), then the files that
   define the immediate work. Cite exact paths. If files in OTHER repos are needed, list only those exact
   files (no "explore the sibling repo").
3. **Where things stand** — per-lane/per-stage state with done/in-progress/blocked markers; name every
   blocking gate; list in-flight external work that may report back mid-session and what to do when it does.
4. **Do this now** — the ordered work list with acceptance checks, ending with an explicit **STOP
   condition** and the report-back format.
5. **Run mechanics** — the hard-won operational knowledge from this session: exact commands for long jobs,
   environment pins, detach/poll patterns, known traps. This is the section compaction would have destroyed;
   be generous.
6. **Guardrails** — the standing rules easiest to violate mid-flow (commit conventions, honest-measurement
   rules, classify-don't-guess policies, visibility constraints).
7. **Human-gates** — decisions reserved for the human, with enough context to raise them crisply. Surface,
   never decide.

**Supersede consumed handoffs**: if a previous session-continuation handoff exists in `plans/inbox/` and has
been absorbed, note at ITS top that it is superseded by the new file (or move it to `plans/archive/` per the
project's convention). A fresh session must never grab a stale order. Leave non-handoff work orders
(dispatches to other repos, stage work orders) untouched.

## Phase 3: Commit, Push, Verify Clean

1. Commit the handoff; push.
2. `git status` — the tree must be clean. If anything is uncommitted, either commit it or list it explicitly
   in the handoff's "Where things stand" (nothing silently left behind).

## Phase 4: Hand Back the Launcher

Output to the user:

1. A 3–6 line summary of what the currency pass changed and where the handoff lives.
2. The launcher prompt, ready to paste after `/clear`:

```
Read plans/inbox/handoff-{date}-{topic}.md — it is your work order for this session. Execute it end-to-end:
the reading list in order, then the work items, respecting the guardrails. Don't re-plan or ask for
confirmation; begin. STOP where the handoff says stop and report back as it asks.
```

## Important

- **You know the state best** — never leave state reconstruction to the human or the successor.
- The handoff is written at a known-good point ON PURPOSE; if the session is mid-disaster, stabilize or
  document the instability honestly — a work order that pretends the tree is healthy is worse than none.
- Do NOT begin executing the next work — this command ENDS with the launcher.
