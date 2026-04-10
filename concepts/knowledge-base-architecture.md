# Knowledge Base Architecture for AI Agents

How to structure on-disk knowledge bases for consumption by AI agents using file tools (Glob, Grep, Read). This concept covers the full lifecycle: single-KB structure, agent navigation, classification, and multi-KB federation.

## Two KB Types

Forge projects produce two distinct kinds of knowledge bases. They differ in purpose, consumer, and structure:

### Code-Agent KB

Structured reference knowledge consumed by AI agents during task execution.

```
knowledge-base/
├── index.md                    # Root routing table (≤100 lines)
├── VOCABULARY.md               # Controlled vocabulary for faceted metadata
├── NAVIGATOR-PROMPT.md         # Paste-ready consumer template
├── {domain}/
│   ├── index.md                # Domain routing table + Negative Knowledge
│   ├── CHEATSHEET.md           # Compact quick reference (~3KB)
│   └── {topic}/
│       ├── index.md            # Topic routing table
│       └── {detail}.md         # L0 detail file
└── findings/                   # Architectural findings (meta-knowledge)
```

**Characteristics:**
- Navigation is task-driven: "I'm doing X, what do I need to know?"
- Optimized for fast lookup: routing tables, cheatsheets, faceted metadata
- Content is stable reference material (API changes, patterns, guides)
- Two-agent maintenance: Curator (read-write) + Navigator (read-only)
- Quality metric: correct file found in ≤3 hops

**When it emerges:** Phase 4 (Learning Loop). As an agent accumulates domain knowledge during iterative implementation, that knowledge crystallizes into a KB. Migration guides, API diff tables, review checklists — these are Learning Loop artifacts that become production knowledge stores.

**Example:** A refactoring agent's knowledge of Spring Boot 2→3 migration: cheatsheets, property change tables, security migration guides, Maven POM patterns.

### Research-Partner KB

Synthesized strategic knowledge consumed by an AI research partner for human thinking.

```
research-kb/
├── CLAUDE.md                   # Session bridge (the orchestrator)
├── synthesis/
│   ├── THEME-INDEX.md          # Thematic routing table
│   ├── MASTER-SUMMARY.md       # Corpus overview
│   ├── phase2/                 # Theme deep-dives
│   └── phase3/                 # Cross-cutting analysis
├── conversations/              # L0 source conversations (immutable)
├── plans/
│   └── supporting_docs/
│       └── paper-tracker.md    # Literature tracking
└── papers/
    └── summaries/              # Per-paper structured summaries
```

**Characteristics:**
- Navigation is question-driven: "What did we learn about X?"
- Optimized for synthesis: theme docs, cross-cutting analysis, action items
- Content evolves through conversation and analysis
- Single-agent: the session bridge (CLAUDE.md) IS the orchestrator
- Quality metric: can the agent connect dots across many source conversations?

**When it emerges:** Phase 1 (Research). As conversations accumulate during the discovery loop, they need synthesis — per-conversation summaries, thematic analysis, cross-cutting insights. This is the Research-Partner KB.

**Example:** A research project synthesizing 60+ conversations about platform architecture: theme documents, action items, strategic decisions, conversation-to-theme matrices.

### Comparison

| Dimension | Code-Agent KB | Research-Partner KB |
|-----------|--------------|-------------------|
| Consumer | Code agents during task execution | AI research partner during planning |
| Navigation | Task routing → domain index → detail file | Theme routing → theme doc → source |
| Content type | Stable reference (API diffs, guides) | Evolving synthesis (themes, decisions) |
| Update cadence | When frameworks/tools change | After every research conversation |
| Metadata | Faceted (task_types, artifact_type, subjects) | Thematic (themes, phases, conversations) |
| Agent roles | Curator + Navigator (two agents) | Session bridge (one agent, modes) |

### Don't Mix Them

The same domain can appear in both types — and that's fine, not duplication. A Code-Agent KB has the migration checklist you follow while upgrading code. A Research-Partner KB has the strategic conversation about why that migration matters. They answer different questions for different consumers.

---

## Single-KB Structure: The Librarian Layer

A well-designed Code-Agent KB has three layers of navigation infrastructure:

### 1. Routing Tables (index.md files)

Every directory has an `index.md` that routes agents to the right file:

```markdown
## Task Routing

| If you are... | Start here | Also read |
|--------------|-----------|-----------|
| Migrating Spring Boot 2.x → 3.x | `CHEATSHEET.md` | `java/`, `maven/` |
| Reviewing DDD code quality | `review-tools/checklist.md` | `expert-references/` |

## Question Routing

| Question | Read |
|----------|------|
| What changed in Security 6.0? | `boot-2-to-3/security-changes.md` |
| What properties changed? | `boot-2-to-3/property-changes.md` |

## Not Covered

This domain does **not** contain: {explicit exclusions}
```

**Routing table types:**
- **Task Routing** — "If you're doing X, start here" (root index.md)
- **Question Routing** — "If you need to know X, read Y" (root + domain indexes)
- **Cross-Domain Routing** — tasks that span multiple domains (root index.md)
- **Negative Knowledge** — what this KB does NOT cover (all indexes)

Negative Knowledge is cheap and high-value. Adding "Not Covered" sections prevents wasted search. An agent that hits Negative Knowledge resolves in 1 hop.

**Line budget:** Root index.md ≤100 lines. Domain indexes ≤80 lines. This follows the "smart zone" principle — keep routing compact so the agent spends context on content, not navigation.

### 2. Faceted Metadata (YAML frontmatter)

Every detail file gets classification metadata in its frontmatter:

```yaml
---
task_types: [migration, troubleshooting]
artifact_type: remediation-guide
subjects: [spring-security, spring-boot-migration]
related:
  see_also:
    - java/type-changes.md
  broader: [spring/boot-2-to-3/index.md]
---
```

Three independent search dimensions:
- **task_types** — what tasks this file helps with (migration, review, configuration...)
- **artifact_type** — what kind of artifact this file is (cheatsheet, guide, catalog...)
- **subjects** — domain-specific topic tags

This is faceted classification (Ranganathan, 1930s): don't force knowledge into one hierarchy. An agent doing "migration" and an agent doing "review" both need the same security-changes file — facets let each find it via their own access pattern.

**Search via grep:** `grep -r "task_types:.*migration" */` finds all migration-relevant files across all domains.

### 3. Controlled Vocabulary (VOCABULARY.md)

A file at the KB root defining all allowed values for each facet:

```markdown
## task_types
migration | review | configuration | troubleshooting | reference | analysis | architecture-design

## artifact_type
cheatsheet | remediation-guide | decision-matrix | expert-opinion | api-diff | catalog | ...

## subjects
### Spring ecosystem
spring-boot-migration | spring-security | spring-data-jpa | ...
### DDD
bounded-context | aggregate | event-sourcing | ...
```

Prevents tag drift ("spring-security" vs "security" vs "spring-sec"). Enables reliable cross-domain search. Also serves as a "what does this KB know about?" overview.

### Two-Agent Design

Code-Agent KBs use two agents with distinct roles:

| Agent | File | Role | Mode |
|-------|------|------|------|
| **Curator** | `CLAUDE.md` | Classify, cross-reference, maintain routing tables | Read-write |
| **Navigator** | `NAVIGATOR-PROMPT.md` | Route queries, follow routing tables, report gaps | Read-only |

The **Curator** is the resident agent. It owns the KB — classifies new content, maintains cross-references, updates routing tables, enforces the controlled vocabulary. Its prompt (CLAUDE.md) contains intake workflows, maintenance workflows, and quality checklists. The Curator also handles batch intake — processing inbox directories of raw research results into classified KB entries. See [Curator Intake Protocol](../guides/curator-intake.md) for the repeatable workflow.

The **Navigator** is a paste-ready template for consumer projects. It defines a 6-step navigation algorithm: read root index → follow routing → read cheatsheet → read detail files → search by facet → report gaps. Consumer projects paste this into their CLAUDE.md with a path substitution.

**Why two agents?** Conflicting context needs. The Curator needs classification rules and vocabulary. The Navigator needs task context and routing tables. Combining them pushes both into the "dumb zone" faster (Horthy's smart zone principle).

---

## Multi-KB Federation

When a project ecosystem has multiple KBs, a federation layer provides cross-KB routing.

### The Union Catalog Pattern

A `KB-FEDERATION.md` file catalogs all KBs in the ecosystem:

```markdown
# Knowledge Federation

## KB Catalog

| KB | Entry Point | Read when... |
|----|------------|--------------|
| domain-knowledge | `.../domain-knowledge/index.md` | Task involves code changes, API migration |
| research-corpus | `.../research/CLAUDE.md` (lines X-Y) | Question involves academic patterns |
| strategic-synthesis | `.../synthesis/THEME-INDEX.md` | Question involves decisions, strategy |

## Cross-KB Task Routing

| Task | KBs Needed | Start With | Then Read |
|------|-----------|-----------|-----------|
| Evaluate KB layout for new project | domain-knowledge | `findings/kb-layout-spec.md` | research-corpus for lit context |

## Not Federated

These topics don't exist in any KB: {explicit exclusions}
```

### Per-KB Cross-References

Each KB's root index.md gets a compact "See Also: Other KBs" section:

```markdown
## See Also: Other KBs

For topics outside this KB's scope, consult:
`/path/to/KB-FEDERATION.md`

| If you need... | See |
|----------------|-----|
| Agent architecture patterns | research-corpus |
| Strategic context | strategic-synthesis |
```

### Design Principles

1. **Entry point for cross-KB reads: root index.md, not CLAUDE.md.** A visiting agent uses the public navigation interface (index.md routing tables), not the resident agent's operational instructions (CLAUDE.md).

2. **The federation index is infrastructure, not synthesis.** It lives in the broadest project but is a standalone file any project can read by absolute path. It shouldn't be embedded in a project's CLAUDE.md.

3. **"Read when..." uses task descriptions, not topic keywords.** "Task involves code migration" is more useful than "Spring, Java, Maven" because agents know their task but may not know which keywords map to which KB.

4. **Freshness via frontmatter dates.** Each KB's root index.md has a `last_consolidated` date. The federation index tracks these. No automated synchronization — convention-based, matching the zero-infrastructure constraint.

---

## Scale Thresholds

| File Count | Status | Recommendation |
|------------|--------|----------------|
| < 30 | Comfortable | Flat domain with index.md works fine |
| 30-100 | Optimal | Two-level `domain/topic/` hierarchy |
| 100-400 | Attention | Strong routing tables needed. May need hierarchical delegation in root index.md |
| 400+ | Split | Consider splitting into multiple KBs connected via federation |

Within a single KB, the two-level hierarchy (`domain/topic/`) is the maximum. Never go deeper than `domain/topic/detail.md`. If you need more depth, split into more domains or more KBs.

Across KBs, the federation index adds one level: federation → KB root → domain → detail. Four levels total is acceptable because the federation index is consulted only when the agent leaves its home KB.

---

## Relationship to Other Concepts

- **[Documentation Taxonomy](documentation-taxonomy.md)** — Code-Agent KBs prioritize Reference + How-to content (highest agent value). Research-Partner KBs prioritize Explanation content.
- **[Research Agent](research-agent.md)** — The hierarchical agentic RAG concept (L0-L3) applies to both KB types. Code-Agent KBs: L3=root index, L2=domain index, L1=detail, L0=n/a. Research KBs: L3=MASTER-SUMMARY, L2=theme docs, L1=per-paper summaries, L0=raw papers.
- **[Research Loop](research-loop.md)** — Research-Partner KBs emerge during the Vision↔Research loop as conversation synthesis accumulates.
- **[Execution Pipeline](execution-pipeline.md)** — Code-Agent KBs emerge during Phase 4 as domain knowledge crystallizes from iterative implementation.

## Provenance

This concept is grounded in findings from dedicated knowledge-architecture research:

| Finding | Description |
|---------|-------------|
| KB Layout Specification v1.0 | Two-level domain/topic hierarchy, index.md at every level |
| Dual-Mode Pattern | Experiment-driver (knowledgeRefs) vs production (root index.md routing) |
| knowledgeRefs Integration Spec | 1-5 directory refs per DatasetItem, relative to knowledgeBaseDir |
| Scalability Analysis | File count thresholds, routing table saturation signals |
| Cross-KB Orchestration Architecture | Federation routing, union catalog, per-KB cross-references |
| Two KB Types | Code-Agent (task-driven) vs Research-Partner (question-driven) |
| Librarian Layer Summary | Routing tables, faceted metadata, controlled vocabulary |

Design influences: Ranganathan (faceted classification), SKOS/Dublin Core (controlled vocabulary), GraphRAG (community summaries as index.md), Anthropic Skills (progressive disclosure), Dex Horthy (smart zone context engineering), Amp/Sourcegraph (Finder/Librarian sub-agent split).
