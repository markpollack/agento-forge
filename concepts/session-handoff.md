# Session Handoff

## What It Is

Long-running development doesn't fit in one AI session. Context windows fill, conversations get compacted,
and compaction summaries degrade — the session's understanding of the work gets *lossier* the longer it runs.
Session handoff is the practice of treating **sessions as disposable and the repository as the memory**:
development continues across many deliberately-cleared sessions, each launched from a written **handoff work
order** rather than from an inherited (and decayed) transcript.

The same mechanism serves two purposes:

1. **Succession** — the ending session writes a handoff for its own replacement (clear → paste a two-line
   launcher → continue exactly where work stopped).
2. **Dispatch** — a coordinating session writes a work order for a *satellite* session in another repo
   (multi-repo programs; see `hierarchical-reporting.md` for the status-flow counterpart).

One protocol, two directions: down (to satellites) and forward (to successors).

## Why This Matters

Forge's exit criteria already force durable state into files — roadmap checkboxes, learnings, CLAUDE.md's
current status. That makes any session collapsible into *(current docs) + (one handoff file) + (a two-line
launcher)*. A deliberate handoff written at a known-good state beats an automatic compaction summary for
three reasons:

- **Intentionality** — everything in it was written on purpose, with the ending session's full context,
  not summarized under pressure as the window filled.
- **The "do this now" is explicit** — a compaction summary tells the next session what *happened*; a work
  order tells it what to *do*, in what order, with acceptance criteria.
- **Hard-won mechanics survive** — the operational tricks a session learned (how to run the long jobs, which
  tools have sharp edges, what not to rediscover) are precisely what compaction drops first.

Without this practice, each new session pays an orientation tax re-deriving state from the repo — or worse,
re-decides things the previous session already settled.

## The Closing Ritual

When a session is ending (the human says "prepare the handoff," or a step boundary is reached):

1. **Doc currency pass** — bring the durable state up to truth: CLAUDE.md's current-status/next-action
   section, roadmap step checkboxes, the status board (if the project keeps one), learnings for anything not
   yet recorded. Commit.
2. **Write the handoff** — `plans/inbox/handoff-<date>-<topic>.md` from `templates/HANDOFF-TEMPLATE.md`:
   roles inherited, reading order, state summary, DO-THIS-NOW work list, run mechanics, guardrails,
   human-gates. Commit and push; verify the tree is clean.
3. **Hand over the launcher** — the standard two-line prompt (below). Only the filename ever changes.

```
Read plans/inbox/handoff-<date>-<topic>.md — it is your work order for this session. Execute it end-to-end:
the reading list in order, then the work items, respecting the guardrails. Don't re-plan or ask for
confirmation; begin. STOP where the handoff says stop and report back as it asks.
```

## Anatomy of a Work Order

The template carries seven sections; the non-obvious design choices:

- **Reading order, not a reading pile** — the next session reads its own conventions *first* (CLAUDE.md,
  trackers), then the work order's specifics. Ordering prevents the classic failure of acting on the task
  before absorbing the constraints.
- **DO-THIS-NOW with a STOP condition** — every work order ends at a defined checkpoint with a report-back
  in a stated format. Bounded execution keeps the human in the loop at step boundaries and gives the
  coordinator (or the human) a clean absorption point.
- **Run mechanics** — the hard-won operational knowledge: exact commands for long-running jobs, environment
  pins, known traps. This section is why successors don't re-lose an afternoon to something the predecessor
  already solved.
- **Human-gates, surfaced not decided** — decisions that belong to the human are listed explicitly so the
  next session raises them instead of silently resolving them.

## Hygiene Rules

- **The ending session writes the next handoff** — it knows the state best. Never ask the human to
  reconstruct state for a new session.
- **Supersede consumed handoffs** — once a session has absorbed a work order, the next handoff replaces it
  (the inbox-triage convention). A fresh session must never grab a stale order.
- **"Not 100% fresh" is fine — often better** — auto-loaded conventions (CLAUDE.md) + persistent memories +
  a deliberate handoff give more *faithful* context than a long compacted transcript.
- **Git history is the audit trail** — every session boundary is a commit; the sequence of handoff files in
  history reconstructs the entire program's session structure.

## Relationship to Other Concepts

- `hierarchical-reporting.md` — status flows *up* from satellites; work orders flow *down* and *forward*.
  Together they form the coordination loop for multi-session, multi-repo programs.
- `execution-pipeline.md` / Phase 4 — the handoff ritual is the session-boundary instance of the learning
  loop's exit discipline: state is only real once it's in the repo.
- `steward-agent.md` — a steward is effectively a standing succession of handoffs on a maintenance cadence.

## Provenance

Distilled from a multi-repo modernization program (2026-07) that ran a coordinator session plus satellite
sessions across four repositories: the same work-order shape was used to dispatch a step to a sibling repo,
to hand a research task to a knowledge-base session, and to continue the coordinator itself across context
clears — three uses, one protocol, each proven before this write-up.
