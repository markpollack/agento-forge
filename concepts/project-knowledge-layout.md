# Project Knowledge Layout: the `plans/` working-memory tree

> The subdirectory convention that organizes a project's **working knowledge** — the durable-but-evolving record of how the work is being thought about, decided, and learned — as distinct from the shipped code and the published documentation.

## Why this exists

A Forge project accumulates four kinds of knowledge that are neither source code nor published docs:

1. **What we're learning** as we execute (discoveries, pitfalls, deviations).
2. **What we've decided** and why (ratified choices, with rationale, that outlive the step that produced them).
3. **What we're drawing on** to decide (teardowns, surveys, positioning, prior art).
4. **What's arriving** that hasn't been processed yet (briefs, handoffs, review results, external messages).

Left unorganized these bleed together, and the project loses the ability to answer "why did we decide X?" or "what did we already learn about Y?" across cleared sessions. The convention below gives each kind a home with clear boundaries and a lifecycle. It emerged in practice across the agentworks-umbrella projects (nearly all carry `plans/{learnings,inbox}`, most add `research/`, and the `journal/` arrived with the contract-heavy efforts) and is codified here so new projects start with it.

## The root: `plans/`

`plans/` is the project's **agent-and-human-facing working memory**. It holds the Forge artifacts (`VISION.md`, `DESIGN.md`, `ROADMAP.md`) at its root and the four knowledge subdirectories below. **Whether it is tracked is decided by repository visibility, not by the nature of the content.**

- **Public repo → gitignore `plans/`.** The planning — vision, competitive positioning, commercial model, unshipped roadmap — is usually not for public view. Two consequences to accept deliberately: the reasoning must survive session clears on its own organization rather than on git history, and **it has no backup** unless you mirror it elsewhere.
- **Private repo → track `plans/`.** Backup, history, and multi-machine access come free, and the reasoning is versioned alongside the code it explains. There is no confidentiality argument to trade against.

Getting this backwards is costly in both directions: a private project that gitignores out of habit loses history for no benefit, and a public project that tracks by default publishes its strategy. The trap is moving between the two — the convention inverts and nothing in the working tree signals it. (One practical marker: encode visibility in the checkout location, so the path itself tells you which convention applies.)

A repo whose `plans/` is gitignored for confidentiality carries a second obligation: **nothing from it should surface in public artifacts** — commit messages, code comments, published docs — or the gitignore was decorative.

**Multi-effort nesting.** A project running distinct efforts (a rewrite, a major version) nests the full set under an effort directory: `plans/v2/…`, `plans/v3/…`, each with its own `learnings/ journal/ research/ inbox/`. The parked effort's tree stays frozen; the active one evolves. (Example: `agent-workflow` carries `plans/v2/` parked and `plans/v3/` active.)

```
plans/                      # (or plans/<effort>/ for multi-effort projects)
├── VISION.md   DESIGN.md   ROADMAP.md
├── learnings/              # what we're LEARNING (per-step, compacted → LEARNINGS.md)
├── journal/                # what we've DECIDED (dated, ratified, durable, never compacted)
├── research/               # what we're DRAWING ON (active reference for upcoming work)
├── inbox/                  # what's ARRIVING (unprocessed; the gitmaildir delivery endpoint)
└── archive/                # what's DONE (superseded, kept for provenance, not consulted)
```

## The four subdirectories

### `learnings/` — the discovery record

Per-step learnings (`step-X.Y-topic.md`) capturing what executing the step revealed: discoveries, pitfalls, deviations from design. **Tiered and compacted**: at stage boundaries the per-step files consolidate into `LEARNINGS.md` (the Tier-1 summary every future session reads first). Learnings are *chronological-by-step* and *execution-oriented*; the per-step files may be archived once compacted. Already codified in [Phase 3](../phases/03-roadmap.md) and the [ROADMAP template](../templates/ROADMAP-TEMPLATE.md).

### `journal/` — the decision record

Dated decision entries (`YYYY-MM-DD-<slug>.md`) recording **ratified choices and their rationale** — the "why we chose X over Y," the verdict, the superseded-by pointers. This is an **ADR-style** record (Architecture Decision Records) generalized to any standing project decision, not only architecture.

**Journal is not learnings** — the distinction is the point:

| | `learnings/` | `journal/` |
|---|---|---|
| Captures | what a *step* taught us | what we *decided* |
| Orientation | execution / discovery | choice / rationale |
| Lifetime | compacted, per-step files archivable | **durable — each entry is a standing record, never compacted away** |
| Supersession | rolled into `LEARNINGS.md` | a later entry *supersedes* an earlier one by explicit pointer; both are kept |
| Reads like | "implementing X surfaced pitfall Y" | "we chose X because Y; alternatives Z rejected; ratified <date>" |

A decision belongs in `journal/` when a future session (or a challenger) would reasonably ask "*why* is it this way?" and the answer isn't derivable from the code or the roadmap. Ratified reversals of prior decisions are journal entries that name and supersede the entry they overturn — the trail of *how the thinking changed* is itself the value.

### `research/` — the reference corpus

Active reference material informing upcoming stages: competitive teardowns, prior-art surveys, positioning notes, gap-hunts. Promoted from `inbox/` when an item is linked to a roadmap step. Reference-shaped (greppable, citation-linked), consulted while deciding. Distinct from the *research-variant* project's `plans/` (which uses `conversations/` + `supporting_docs/` — see [research-project-structure](../guides/research-project-structure.md)); this `research/` is the software/agent project's working reference shelf.

### `inbox/` — the intake endpoint

Unprocessed incoming: ideas, design briefs, handoff notes, review results, and — via the transport below — external and human messages. **Triaged at stage boundaries** (typically consolidation steps): items informing upcoming work move to `research/`; completed/superseded items move to `archive/`; actionable items become roadmap steps (then the original is archived). **Goal: zero inbox at each wave boundary**; delete `inbox/` when empty.

### `archive/` — provenance

Completed or superseded items, kept for provenance and *not consulted* in normal work. The demotion target for done inbox items and compacted learnings.

## Inbox transport: the project gitmaildir binding

The `inbox/` is not only a manual accumulation point — it is the **delivery endpoint for the project's message transport**. The reference transport is **gitmaildir**: steward-to-steward coordination and human-in-the-loop (HITL) messages are materialized as **transparent git files** that land in `inbox/`, where they are triaged exactly like any other inbox item.

This unifies two things the methodology otherwise treated separately:

- **The inbox pattern** (accumulate → triage → promote/archive) gains a real *arrival* mechanism instead of only hand-dropped files.
- **HITL** (a human replies to an agent's question; a steward hands work to a peer) becomes concrete: the reply is a git file in `inbox/`, reviewable and diffable, with no opaque channel. A human approval, a reviewer's verdict, a sibling project's request — all arrive as inbox files.

Keeping the transport's payload as git files (rather than a database row or a queue message) preserves the Forge property that *the repo is the memory*: intake is inspectable, versioned, and survives session clears with no external dependency to reconstruct. gitmaildir is the reference implementation; the binding at the methodology level is simply **"the message transport delivers into `inbox/` as files."**

## Boundaries with adjacent layers

- **Not published documentation.** `plans/` is working memory; the shipped tutorials/how-to/reference/explanation are Phase-5 output governed by the [documentation taxonomy](documentation-taxonomy.md) (Diataxis). A `journal/` entry explains a decision to *the team*; a published Explanation doc explains the system to *users*.
- **Not the code, not git history.** If the fact is derivable from the code or the commit trail, it doesn't need a home here. `journal/` and `learnings/` hold precisely what git *doesn't* record: the rejected alternatives, the rationale, the discoveries.
- **Not a knowledge base.** A KB (see [knowledge-base-architecture](knowledge-base-architecture.md)) is a *product* consumed by agents at runtime; `plans/` is *process* memory consumed by the project's own sessions.

## See also

- [Phase 3: Roadmap](../phases/03-roadmap.md) — the inbox→research/archive lifecycle in the execution loop
- [ROADMAP template](../templates/ROADMAP-TEMPLATE.md) — the plans-directory structure block
- [Session handoff](session-handoff.md) — how handoff notes (an inbox arrival) drive succession across cleared sessions
- [Review lenses](review-lenses.md) — *decision journaling* is a review lens; the `journal/` is where its output lives
- [Documentation taxonomy](documentation-taxonomy.md) — the published-docs axis, distinct from working memory
