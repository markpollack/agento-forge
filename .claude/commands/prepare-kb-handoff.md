# Prepare KB Handoff — Close a knowledge-base session with a work order for its successor

You are ending (or checkpointing) a **knowledge-base session** — foraging, Partner-Mode Q&A,
conversation intake, or consolidation in a KB built with `/forge-kb`, `/forge-research-kb`, or
`/forge-research`. Perform the KB closing ritual: bring the corpus's durable state up to truth,
regenerate the **standing forage order** (or write a dated work order for non-forage work), and
hand back the launcher prompt.

The premise is unchanged from `concepts/session-handoff.md`: sessions are disposable, the repo is
the memory. What differs for a KB: the successor's work is a **queue derived from the tracker**,
not a roadmap step. So the default handoff is a *standing* order (`HANDOFF-FORAGE.md` at the repo
root, rewritten in place each close — git history preserves the sequence), and the currency pass
is about **corpus truth** — does the tracker match the disk? — rather than build state.

## Arguments

- $ARGUMENTS — Optional. Omitted or `forage`: regenerate the standing forage order. A short topic
  (e.g. "answer-rq4-for-brick-game", "consolidation-sweep", "intake-backlog"): write a dated
  non-forage work order instead.

## Configuration

Paths are resolved via environment variables. Set these before running the command, or add them
to your shell profile.

- `AGENTO_FORGE_HOME` — the agento-forge checkout (default: `$HOME/projects/agento-forge`). Used
  for `templates/HANDOFF-KB-TEMPLATE.md`; if unavailable, use the section list there verbatim.
- `KB_FEDERATION_FILE` — optional. If set (or the KB's CLAUDE.md names a federation catalog), the
  federation freshness row is part of the currency pass.

## Phase 1: Corpus Currency Pass

A KB handoff is only trustworthy if the tracker tells the truth about what is on disk. Bring the
corpus current FIRST:

1. **Tracker truth** — the tracker (`plans/supporting_docs/*-tracker.md`): a status advances ONLY
   with the artifact present. `Summarized` requires the summary file; `Downloaded`/`Unread`
   requires the raw file or clone on disk plus a manifest row. Never round up — the canonical rot
   case is a row marked Downloaded while the PDF was never on disk, discovered months later by a
   session that trusted it. Update the corpus-size header line (N summarized / M tracked).
2. **Manifest** — every acquisition this session has a row: verified URL (what you actually
   fetched, not the tracker's guess), date, local path.
3. **VISION currency** — unknowns resolved or added this session; hypothesis status changes.
   New RQs are a human-gate: surface, don't add.
4. **Conversation channel** — if intake happened, the synthesis log and conversation index are
   current per `conversations/INTAKE.md` (§7).
5. **Session bridge** — CLAUDE.md's Corpus Layout / Not Covered / vocabulary sections, if the
   session changed structure or scope.
6. **Grounding spot-check** (the KB's analog of "verify the build"): for 2–3 rows whose status
   changed this session, confirm artifact-on-disk and that the summary's citations resolve. For a
   full structural pass run `/kb-reindex` — but don't block the handoff on it; queue it in the
   work order instead.
7. **Federation freshness** — if this KB is registered: update its freshness row (and the
   registry entry's notes, if materially changed) in the federation repo. Commit that repo
   separately, staging only the files you touched.
8. **Commit** the currency pass in the KB (project commit conventions apply).

## Phase 2: Write the Work Order

**Default — forage.** Regenerate `HANDOFF-FORAGE.md` at the repo root from
`$AGENTO_FORGE_HOME/templates/HANDOFF-KB-TEMPLATE.md`:

1. **Derive "Sources to Process" from the tracker** — the next batch by priority, including
   `Locate` rows (locating IS forage work), plus any gaps reported by Partner-Mode sessions that
   this batch should close.
2. **State the mission as a goal condition in RQ terms** ("after this batch the corpus answers
   RQ2 end-to-end and U1 is resolved"), not a count.
3. **Fill Run Mechanics generously** with THIS session's hard-won fetch tooling — working
   mirrors, capture commands, scripts, rate-limit workarounds. This is what compaction would have
   destroyed.
4. **Overwrite in place.** The standing order always reflects tracker state NOW; superseding is
   automatic and git history preserves the sequence. Never leave two forage orders in the repo.

**Non-forage** ($ARGUMENTS gave a topic). Write `plans/inbox/handoff-{YYYY-MM-DD}-{topic}.md`
from the same template, adapting "Sources to Process" into the ordered work list (answers to
write, findings to distill, consolidation steps) with acceptance checks and an explicit STOP
condition. Supersede consumed dated handoffs per the base ritual (`/prepare-handoff` Phase 2).
Leave `HANDOFF-FORAGE.md` untouched — unless the tracker changed this session, in which case
regenerate it too.

## Phase 3: Commit, Push, Verify Clean

1. Commit the work order; push.
2. `git status` — no unexplained *tracked* changes. Raw corpus dirs are gitignored by design, so
   "clean" here also means: every gitignored acquisition has its manifest row (nothing on disk
   that the committed record doesn't explain).

## Phase 4: Hand Back the Launcher

Output to the user:

1. A 3–6 line summary: what the currency pass changed, corpus size before → after, where the
   work order lives.
2. The launcher prompt, ready to paste after `/clear`:

```
Read HANDOFF-FORAGE.md — it is your work order for this session. Execute it end-to-end: the
reading list in order, then the sources, respecting the guardrails. Don't re-plan or ask for
confirmation; begin. STOP where the handoff says stop and report back as it asks.
```

(For a non-forage order, substitute the `plans/inbox/handoff-{date}-{topic}.md` path.)

## Important

- **Never advance a status to make the handoff look further along** — a false `Summarized` costs
  a future session more than an honest `Unread` costs this one.
- The standing order is **derived state**: when in doubt, the tracker is authoritative, and
  regenerating the order from it is always safe.
- Works for `/forge-research` projects too (same tracker + `HANDOFF-FORAGE.md` shape), not just
  federated KBs — skip the federation step when unregistered.
- Do NOT begin the next batch — this command ENDS with the launcher.
