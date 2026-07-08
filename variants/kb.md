# KB Variant

Structure and maintain a knowledge base — a document corpus organized for agent
navigation (routing tables, ≤3-hop lookup), optionally federated for cross-project
consumption.

This variant is a deeper dive into a specific agent type Forge supports: the knowledge
base *is* the agent's deliverable, and the agent's quality is the corpus's
navigability. Where the other variants produce software, agents, or findings, the KB
variant produces a queryable corpus plus the infrastructure that keeps it routable and
fresh.

## When to Use

Use the KB variant when:

- You have an existing document corpus (notes, exports, papers, conversations) you
  want to query across sessions
- You're starting research that **other projects** will query for findings
- Knowledge accumulated inside a project has outgrown its `plans/` directory and a
  second consumer has appeared
- A corpus needs navigation infrastructure: routing tables, negative knowledge,
  session bridge

Do **not** formalize a KB when:

- The knowledge serves exactly one project and lives comfortably in that project's
  `CLAUDE.md` + `plans/` — project-local knowledge is Stage 0 of the lifecycle below,
  and most knowledge should stay there
- The output is a paper or dataset with no ongoing consumers → use the
  [Research variant](research.md)
- You need ongoing project health monitoring with a KB as one part → use the
  [Steward variant](steward.md), whose curator role maintains a project-local KB

## Key Differences from Other Variants

| Aspect | KB | Research | Steward | Project |
|--------|----|----------|---------|---------|
| Phase 4 | Navigation quality loop (≤3-hop validation, routing maintenance) | Knowledge quality loop | Health monitoring loop | QA review loop |
| Lifecycle | **Ongoing** (corpus-centric) | Finite (publish) | Ongoing (project-centric) | Finite (ship) |
| Success metric | Questions answered in ≤3 hops, grounded with citations | Claims supported | Domain health maintained | Zero blocking findings |
| Primary artifact | Navigable corpus + routing infrastructure | Papers/findings | Maintained project + KB | Shipped software |
| KB role | The KB **is** the product | Research-Partner KB emerges | Curator of a project-local KB | None |

The KB variant overlaps with Research (a research-partner KB is a research project
with consumers) and Steward (both maintain knowledge continuously). The distinction:
**Research** converges on findings; **Steward** serves a project; **KB** serves a
corpus and its consumers, indefinitely.

## Bootstrap: Two Commands

The variant's bootstrap procedure is two skills, chosen by federation intent:

| Command | Use when | What it builds |
|---------|----------|----------------|
| `/forge-kb` ([versioned copy](../.claude/commands/forge-kb.md)) | Existing doc corpus, you want to ask it questions — the 80/20 | Root + domain `index.md` routing tables, CLAUDE.md session bridge (Partner Mode), ≤3-hop validation. No frontmatter, no VOCABULARY.md |
| `/forge-research-kb` ([versioned copy](../.claude/commands/forge-research-kb.md)) | New research corpus with **explicit consumer projects** | Superset: adds VISION.md (RQs + Consumers table), paper tracker with RQ coverage map, PARTNER-QUERY-TEMPLATE.md, HANDOFF-FORAGE.md, and federation registration (Phase 6) |

Both implement the KB layout specification — two-level `domain/topic/` hierarchy,
`index.md` at every level — described in
[Knowledge Base Architecture](../concepts/knowledge-base-architecture.md).

## Lifecycle: The Graduation Ladder

Knowledge graduates through stages. Each step has a trigger; don't climb without one.

```
Stage 0: project-local        CLAUDE.md + plans/ in the owning project (the default)
   │  trigger: corpus queried across sessions, or grows past ~20 files
   ▼
Stage 1: standalone KB        /forge-kb — routing tables + session bridge
   │  trigger: a SECOND project needs answers from this corpus
   ▼
Stage 2: federated KB         /forge-research-kb, or register an existing KB
   │                          (catalog row + registry entry — see Registration)
   │  trigger: automated agents consume it during task execution,
   │           or faceted search needed past ~50-100 files
   ▼
Stage 3: Code-Agent KB        frontmatter + VOCABULARY.md + NAVIGATOR-PROMPT.md
                              + Curator/Navigator two-agent split
```

**Stage 3 upgrade path** (when, not just what):

- **YAML frontmatter** (`task_types`, `artifact_type`, `subjects`) — add when agents
  need to *grep by facet* across domains, typically past ~50 files. Before that,
  routing tables alone are cheaper to maintain and sufficient.
- **VOCABULARY.md** — add the moment frontmatter exists. Frontmatter without a
  controlled vocabulary produces tag drift ("spring-security" vs "security" vs
  "spring-sec") that silently breaks faceted search.
- **NAVIGATOR-PROMPT.md** — add when consumer projects (not humans in a session)
  navigate the KB; it's the paste-ready template they embed.
- **Curator/Navigator split** — add when intake volume justifies a resident curator
  agent. See [Knowledge Base Architecture](../concepts/knowledge-base-architecture.md)
  for the two-agent design.

**Demotion is part of the lifecycle.** A KB superseded by another gets a
struck-through catalog row pointing at its successor and a disabled registry entry —
never silent deletion. A KB nobody queries should be archived, not maintained.

## Federation Registration

A federation is a union catalog (`KB-FEDERATION.md`, path via the
`KB_FEDERATION_FILE` environment variable) plus, where one exists, a machine-readable
project registry that runtime tooling reads instead of parsing the catalog. The
catalog serves visiting agents; the registry serves automation. A concrete catalog
format example is in
[Knowledge Base Architecture](../concepts/knowledge-base-architecture.md) ("The Union
Catalog Pattern"). Registering a KB means:

1. **Catalog row** — KB Catalog table: entry point, domains, "Read when..." (task
   descriptions, not topic keywords)
2. **Registry entry** — if the federation maintains a registry: id, path, status
   directory, and a **declared `entryPoint`** for code projects
3. **Cross-KB task routing rows** — 1-2 tasks that should route through this KB
4. **Consumer "See Also" sections** — each consumer project's root index.md or
   CLAUDE.md gets a pointer row
5. **Freshness row** — last-consolidated date; this is also the moment the KB takes
   on the freshness obligations below

`/forge-research-kb` Phase 6 executes these steps for a new research-partner KB.
For an existing standalone KB graduating to Stage 2, perform them directly.

## Freshness Obligations of a Federated KB

Federation membership is not free. The governing principle:

> No entry point is trusted because of its filename — it is trusted because the
> ritual checks it.

A federated KB commits to:

- **A declared entry point** — recorded in the registry, not assumed from a filename.
  Code projects route to the declared entry doc *paired with* the newest status
  report; design docs are planning history unless explicitly marked current.
- **Drift checks** — the entry doc's last commit (git history, never filesystem
  mtime) is checked against substantive commits since; a lagging entry doc gets
  flagged in the federation's sync ritual, and routing recommendations require human
  review to act on.
- **Consolidation dates** — the federation freshness table tracks when the KB was
  last reconciled; structural health checks (broken links, orphans, stale routing
  tables, summary-source drift) advance it.
- **Status reports** — if the KB is also an active project, it participates in the
  status collection/ingestion cycle like any satellite project.

The failure mode these obligations prevent: a federated entry doc rotting while the
federation's freshness bookkeeping stays green — the catalog holding both truths and
routing readers to the stale one. Entry points are cached routing judgments; without a
ritual that invalidates them, they rot.

## Session Handoff: the Standing Forage Order

*(Automated as `/prepare-kb-handoff` —
[versioned copy](../.claude/commands/prepare-kb-handoff.md); template:
[`HANDOFF-KB-TEMPLATE.md`](../templates/HANDOFF-KB-TEMPLATE.md). The general practice is
[Session Handoff](../concepts/session-handoff.md); this section is its KB specialization.)*

KB work is session-shaped like development work — forage sessions fill the corpus,
partner sessions drain questions from consumers — but its next step is a **queue derived
from the tracker**, not a roadmap step. That inverts one piece of the handoff protocol:

- **`HANDOFF-FORAGE.md` at the repo root is a standing order**, regenerated in place at
  every session close. The bootstrap commands (`/forge-kb`, `/forge-research-kb`) write
  the first one; `/prepare-kb-handoff` rewrites it from current tracker state thereafter.
  Superseding is automatic; git history preserves the sequence. Never two forage orders
  at once.
- **Dated `plans/inbox/handoff-*.md` orders remain for non-forage work** — a
  partner-mode answer to deliver, a consolidation sweep, an intake backlog — exactly per
  the base ritual.
- **The currency pass checks corpus truth, not build truth**: tracker statuses advance
  only with the artifact on disk; every acquisition has a manifest row; VISION unknowns
  and the conversation synthesis log are current; and — the federation tie-in — the
  **freshness row advances as part of the closing ritual**, which is how a federated KB
  actually meets the consolidation-date obligation above rather than deferring it to a
  sweep that may be months away.

## Anti-Patterns

### Premature Formalization
Building routing tables, frontmatter, and federation rows for a corpus with one
consumer and a dozen files. Stage 0 is the default for a reason — climb the ladder on
triggers, not ambition.

### Filename Superstition
Trusting `CLAUDE.md` (or `DESIGN.md`, or `index.md`) as an entry point *because of its
name*. Entry points are declared and drift-checked, or they are guesses.

### Frontmatter Without Vocabulary
Faceted metadata with free-form tags. Tag drift makes faceted search silently
unreliable — worse than no facets, because it looks like it works.

### Doc-Federated Rot
Federating a project via a design doc that no one updates after the code moves on.
Status ingestion keeps the *bookkeeping* fresh while the federated entry doc itself
rots. Route to a maintained operational doc paired with status reports instead.

### Routing Tables That Duplicate State
Copying counts, dates, or file lists into routing tables. Route with invariants and
pointers; let the target files own their own state.

### Status Without Artifact
A tracker row marked `Downloaded` or `Summarized` while the file was never on disk (or
the summary never written). Bookkeeping that outruns the corpus is worse than an honest
`Unread`, because the lie is discovered by a *future* session that trusted it. The
closing ritual's grounding spot-check exists to catch this at the session boundary.

## Concepts

- [Knowledge Base Architecture](../concepts/knowledge-base-architecture.md) — two KB
  types, librarian layer, federation (union catalog pattern), scale thresholds
- [Research Agent](../concepts/research-agent.md) — Forage/Partner modes that
  research-partner KBs operate in
- [Session Handoff](../concepts/session-handoff.md) — the general closing ritual this
  variant's standing forage order specializes
- [Steward Agent](../concepts/steward-agent.md) — the curator role, for project-local
  KBs maintained as part of stewardship
- [Documentation Taxonomy](../concepts/documentation-taxonomy.md) — what content types
  each KB type prioritizes
