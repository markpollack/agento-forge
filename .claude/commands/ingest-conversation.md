---
name: ingest-conversation
description: Ingest an ongoing/ChatGPT conversation into a federated KB (the conversation-side sibling of /ingest-status)
---

# Ingest Conversation — Absorb an ongoing/ChatGPT conversation into a KB

You are ingesting an **ongoing conversation** (a ChatGPT export, or any non-call text
thread) into a federated knowledge base. This is the conversation-side analog of
`/ingest-status`: the procedure here is **invariant across KBs**; every KB-specific
variable (prefixes, authority classes, themes, target files, routing) is read from the
KB's **intake contract** at `conversations/INTAKE.md`. Do not hardcode any of those —
read the contract.

Calls are a different corpus with their own ritual (`conversations/calls/README.md`) — do
not process call transcripts here (see Phase 1.5).

## Arguments

`$ARGUMENTS` — path to a conversation file (e.g. `conversations/ongoing/inbox/foo.md`), OR
a prefix id to re-ingest (e.g. `DEPLOY-1`), OR empty. If empty, look for the most recently
modified file in `conversations/ongoing/inbox/` (fall back to an unsynthesized file in
`conversations/ongoing/`).

**One conversation per invocation** — do not batch.

---

## Phase 0: Load the intake contract

Read `conversations/INTAKE.md` from the KB root. This file parameterizes everything below:
landing/naming (§1), authority classes (§2), the prefix registry (§3), the theme + keyword
map (§4), target files (§5), routing exceptions (§6), and the synthesis-log location (§7).

If `conversations/INTAKE.md` does not exist, **stop** and tell the user: this KB has no
intake contract; scaffold one with `/forge-research-kb` (it emits a stub) or copy one from
a sibling KB and fill in the tables. Do not improvise the variables.

---

## Phase 1: Locate and read the conversation

1. Resolve the target file per Arguments (path → that file; id → find it under
   `conversations/ongoing/`; empty → newest in `inbox/`).
2. Read the file **completely** before proceeding.

---

## Phase 1.5: Route-out check (calls and talks)

Apply the contract's routing exceptions (§6) **before** synthesizing:

- If the file is a **recorded call transcript** (counterparty position/commitments, a
  spoken bizdev/client/partner/podcast conversation): move it to `conversations/calls/inbox/`
  and stop. Tell the user to run the CALL- intake (`conversations/calls/README.md`) — it
  assigns `CALL-N` and does commitments extraction, which this ritual does not.
- If the file is a **`type: talk` recording** (the owner was in the audience, no
  counterparty position): move it to `plans/research/talks/{event-slug}/` per
  `plans/research/talks/README.md` and stop. Talks are external-reference, never
  commitments, never action items.

Sanity check from the calls README: a talk's participants must not include the KB owner —
if they do, it is a conversation mislabeled as a talk.

---

## Phase 2: Assign prefix + id + rename

1. Determine the **topic prefix** from the contract's Prefix Registry (§3) by matching the
   conversation's subject.
2. **Self-heal**: if no existing prefix fits, propose a new 3–6 char prefix, and **append a
   row** to the registry in `conversations/INTAKE.md` (topic + authority class). Mirror it
   into the human-readable prefix table in `CLAUDE.md` in the same run (ritual-maintained
   duplication — see the contract header).
3. Assign the next free sequence number `{N}` within that prefix.
4. Rename to the contract's filename pattern (§1), e.g. `ChatGPT-{PREFIX}-{N}-{Title}.md`,
   and **move it out of `inbox/`** into `conversations/ongoing/`.

---

## Phase 3: Determine authority class (this gates the rest)

Read the prefix's **authority class** from the registry (§2/§3). This decides what the
conversation is allowed to drive:

- **conclusion** → may drive theme updates AND action items.
- **external-ref** → index + theme-tag ONLY. It must **not** be presented as the owner's
  conclusions, and must **not** drive action items. (Phase 7 is skipped.)
- **primary-evidence** → should have been routed to the calls corpus in Phase 1.5; if it
  reaches here, stop and route it out.

State the determined class explicitly in your working notes and in the commit message.

---

## Phase 4: MASTER-SUMMARY entry

Append an entry to the contract's master-summary file (§5) in the established format:
**synopsis**, **chapter breakdown**, **key decisions** (for `external-ref`: key *claims/news*,
not decisions), **open questions**, **theme tags**. Record the **line offset** of the new
entry — Phase 5 needs it.

Match the surrounding entries' depth and style. Quote exact numbers, names, and terms from
the conversation; do not paraphrase into vague summaries.

---

## Phase 5: CONVERSATION-INDEX entry

Add a row to the conversation index (§5): `{id} → line offset`, theme tags, and a short
key-topics list. Keep the table's existing column order.

---

## Phase 6: Theme docs

Map the conversation to themes using the contract's **theme + keyword map** (§4), honoring
the Theme 7 guard. For each affected theme, **append** an additions section to the end of
`synthesis/phase2/theme-{N}-*.md`:

```markdown
---

## Additions from {id} — {YYYY-MM-DD}

**Source**: `conversations/ongoing/{filename}` ({authority class})

### {finding heading}
{2-5 sentences, quoting exact numbers/terms}
```

Rules (same discipline as `/ingest-status`):
- **Append, never rewrite** — preserve existing content; mark additions clearly.
- **Section scope** — only add this conversation's own section; do not edit other entries.
- For `external-ref`, phrase as "industry context / external claim", not as the owner's view.
- Update the theme matrix in `synthesis/phase2/THEME-INDEX.md`.
- **Size-class maintenance**: after appending, `wc -l` each touched theme doc; if it crossed
  an S/M/L threshold (S <800, M 800–1,800, L >1,800), update the Size cell in BOTH theme
  tables (root `CLAUDE.md` and `synthesis/CLAUDE.md`). Never record exact line counts.

---

## Phase 7: ACTION-ITEMS (authority-gated)

**Skip entirely unless the authority class is `conclusion`.** `external-ref` conversations
must not create or modify action items.

If `conclusion`, read the action-items file (§5). For new work the conversation surfaces,
add an item using the **next available id** (check the current highest id first; maintain
HIGH-N / MEDIUM-N / DEFERRED-N continuity). For existing items it advances, add a dated
progress note citing a specific fact from the conversation. Do not add interpretive framing
ungrounded in the source.

---

## Phase 8: Inventory + synthesis log

1. **INVENTORY.md**: add a row for the new file if inventory tracking is in the contract (§5).
2. **Synthesis log** (§7): append one dated line to the `CLAUDE.md` header in the
   established format, naming the ingested id, the themes touched, and the MASTER-SUMMARY
   offset. Update any prefix table "Synthesized?" column if present. This line is the
   freshness authority for the conversation channel.

---

## Phase 9: Commit

**Never use `git add -A`, `git add .`, or broad staging.** Stage only the files this ingest
changed. Typical set:

```bash
git add conversations/ongoing/{renamed-file}.md conversations/INTAKE.md \
        synthesis/phase1/MASTER-SUMMARY.md synthesis/phase1/CONVERSATION-INDEX.md \
        synthesis/phase2/theme-*.md synthesis/phase2/THEME-INDEX.md \
        synthesis/phase3/ACTION-ITEMS.md INVENTORY.md CLAUDE.md
git diff --name-only --cached   # verify nothing unrelated is staged
```

Commit message format:

```
Ingest conversation: {id} ({authority class}) → themes {N,N}

Source-grounded changes:
- Theme N: {1-line reason citing a specific fact}
- ACTION-ITEMS: {added/advanced/skipped} — {reason; "skipped — external-ref" if so}

Run metadata:
- CLAUDE.md: synthesis-log line added; prefix registry synced (if new prefix)
```

---

## Important notes

- **Never modify the source conversation's content** — clean nothing but the filename.
- **Authority enforcement is the point**: an `external-ref` conversation that drives an
  action item is a correctness bug, not a style nit.
- **Quote exact numbers/terms**; don't substitute "~" estimates.
- **One conversation per invocation.**
- **The contract is the source of truth** — if the registry/themes/paths here disagree with
  prose elsewhere in the KB, the contract wins; fix the prose pointer.
