# Handoff: {Forage Mode — Batch {N} | {topic}} ({date})

> {Standing forage order | Work order} for the next session in this KB. Written at a known-good
> state (tracker true to disk, manifest current, tree clean, pushed). See
> `concepts/session-handoff.md` for the practice and `variants/kb.md` for the KB specialization;
> launch with the standard two-line prompt. A forage order is REGENERATED in place at each
> session close (`/prepare-kb-handoff`) — the tracker is authoritative; this file is derived
> from it and trustworthy only as of its date.

## Mission
{The goal condition in RQ terms, not counts: "after this batch the corpus answers RQ2 end-to-end
and U1 is resolved" — a batch that only moves a number teaches the successor nothing about done.}
Corpus: {N}/{M} summarized.

## Before You Start (read in order)
1. `CLAUDE.md` — modes + per-source summary format
2. `plans/VISION.md` — RQs, hypotheses, open unknowns
3. `{tracker path}` — the batch list + RQ Coverage Map
{The KB's own conventions first, specifics second. Pull ONLY cited files from other repos.}

## Where the corpus stands ({date})
{Per-topic state: summarized ✅ / fetched-not-summarized 🔵 / Locate 🟡. Open unknowns that gate
consumers. Gaps reported by Partner-Mode sessions that this batch should close. In-flight
acquisitions (ordered books, pending permissions) and what to do when they arrive.}

## Sources to Process
{One block per item, derived from the tracker's next priority batch — `Locate` rows belong here
too (locating IS forage work):}

### {N}. {Source name} ({origin, year})
- **Fetch**: {verified URL, or the locate strategy if status is Locate} → `{local path}`
- **RQ coverage**: {which RQs, Primary/Yes}
- **Why**: {one sentence, tied to a consumer need}

## Per-Source Workflow
1. Fetch → correct the tracker's URL if it was a guess → add a manifest row (verified URL, date, path)
2. Read thoroughly; write `{summaries path}/<slug>.md` per the CLAUDE.md format — fill
   "Applicable to RQs" and "Implications for {consumer}"
3. Update tracker: status → `Summarized`, Summary File column, corpus-size header line
4. Newly discovered sources → tracker rows (`Locate`/`Unread`), not mid-batch detours

## After All Done
- Distill ripe findings → `findings/` (a finding is due when one question's answer now spans
  several summaries)
- Update VISION unknowns; note the RQ coverage gaps that remain
- Update the federation freshness row (if this KB is registered)
- Run `/prepare-kb-handoff` — regenerate this file for the NEXT batch
- Commit + push

## Run mechanics (hard-won — do not rediscover)
{Working mirrors/URLs found, capture commands, `scripts/` helpers, PDF-vs-text strategy, rate
limits, auth quirks, fetch tooling that worked. This is the section compaction would have
destroyed; be generous.}

## Guardrails (standing)
{A tracker status advances ONLY with the artifact on disk (Summarized ⇒ summary file exists;
Downloaded/Unread ⇒ raw file or clone present + manifest row) · raw dirs are gitignored — the
manifest is the committed record · the KB's trust rules (e.g. cite primary sources, never
from-memory claims) · authority classes for conversation-derived material (INTAKE.md) ·
licensing/copyright constraints on what may be stored or committed.}

## Human-gates (surface only — never decide)
{Scope changes: new RQs, new topics, priority reshuffles beyond the batch · consumer-facing
recommendations not yet grounded · purchases/downloads with cost or licensing implications.}
