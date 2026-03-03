# Curator Intake Protocol

> Batch-process an inbox of raw deep research results into classified KB entries.

## When to Use

Use this protocol when:
- A `plans/inbox/{topic}/` directory contains multiple raw files from deep research sessions
- Files come from mixed sources (Claude, ChatGPT, Google deep research, web scraping)
- Material needs triage, synthesis, and classification before it belongs in the KB

Do **not** use this protocol when:
- Adding a single known file → use the standard Intake Workflow in CLAUDE.md
- Creating a new KB from scratch → use [forge-kb](../variants/README.md)
- Bootstrapping a new research project → use [forge-research](../variants/README.md)
- Running ongoing health checks → use [Steward](../variants/steward.md) maintenance workflows

## Prerequisites

The target KB must already have:
- `index.md` — root routing hub
- `VOCABULARY.md` — controlled vocabulary
- `CLAUDE.md` — curator prompt with single-file intake workflow

## Inbox Convention

Raw research lands in `plans/inbox/{topic}/`. Files may be unstructured — mixed formats, overlapping topics, no subdirectory convention. The Curator's job is to sort it out.

---

## The Protocol

### Step 1: Survey

Read every file in the inbox. For each file:

1. **Classify by source type** using the Source Precedence Table below
2. **Cluster by topic** — group files that cover the same subject, regardless of source
3. **Identify overlap** — note which topics already have KB coverage

Produce a **manifest** (can be mental or written to `plans/inbox/manifest.md`):

```
Topic: {topic-name}
  Sources: {file1} (deep-research-report), {file2} (reference-catalog), ...
  Existing KB coverage: {domain/file.md} or "none"
  Action: create | update | merge
```

If any inbox file contains URLs worth archiving, fetch and extract content now using available foraging tools.

### Step 2: Map

For each topic cluster:

1. Identify the target KB domain directory
2. Read existing files in that domain
3. Decide the action:
   - **Create** — no existing coverage, new file needed
   - **Update** — existing file covers the topic but is incomplete
   - **Merge** — multiple inbox sources and existing file all cover the same narrow topic

**Scope gate**: If a topic falls under a "Not Covered" exclusion in any index.md, stop and ask the human before proceeding. New domains require explicit approval.

### Step 3: Synthesize

For each output KB file, merge all inbox sources covering that topic.

**Source precedence** (highest to lowest):
1. Official documentation (URLs from reference catalogs)
2. Code-backed context files (generated from actual source code)
3. Deep research reports (AI-generated synthesis with citations)
4. Conversational output (chat transcripts, raw notes)

When sources conflict:
- Higher-precedence source wins by default
- Flag the conflict in the output file as a comment for human review
- Never silently discard information — if a lower-precedence source adds detail not in higher sources, include it with a confidence note

### Step 4: Write

Apply the existing single-file Intake Workflow (from CLAUDE.md) for each output file:

1. Write with full YAML frontmatter (`task_types`, `artifact_type`, `subjects`, `related`)
2. Classify using `VOCABULARY.md` — add new terms if needed
3. Add bidirectional `see_also` links
4. Update domain `index.md` routing tables
5. Update root `index.md` if the file answers a new question type
6. Validate: no untagged files in the domain

### Step 5: Validate

Run the full maintenance checklist:

- [ ] No untagged files (`grep -rL "task_types:" <domain>/`)
- [ ] All `see_also` targets exist as real files
- [ ] All `subjects` values are in `VOCABULARY.md`
- [ ] Bidirectional links complete (A→B implies B→A)
- [ ] Every inbox source was consumed (nothing left unprocessed)
- [ ] Routing test: a navigator can find new content in ≤3 hops from root `index.md`

### Step 6: Clear

Move processed inbox files to archive:

```bash
mv plans/inbox/{topic}/ plans/inbox/archive/{topic}-{YYYY-MM-DD}/
```

Create `plans/inbox/archive/` if it doesn't exist. The date is the processing date, not the source date.

---

## Source Precedence Table

| Source Type | Characteristics | Extract |
|-------------|----------------|---------|
| **Official docs** | URLs, API references, release notes | Facts, API signatures, version-specific behavior |
| **Reference catalog** | Lists of URLs, paper citations, tool inventories | Links to fetch, bibliography entries |
| **Code-backed context** | Generated from source code analysis | Architecture patterns, dependency graphs, API contracts |
| **Deep research report** | AI-synthesized analysis with citations | Claims (verify against higher sources), frameworks, comparisons |
| **Transcript** | Conversation logs, meeting notes | Decisions, action items, rationale |
| **Raw notes** | Unstructured observations, bullet lists | Seeds for further research, open questions |

## Foraging Tools

During Survey (Step 1) or Synthesize (Step 3), inbox files may reference external content worth archiving. Available tools:

- **Transcript extractors** — YouTube, ChatGPT conversation URLs
- **Web fetch** — retrieve and extract content from documentation URLs
- **Browser automation** — navigate dynamic pages, capture rendered content
- **Nested CLI invocations** — delegate sub-tasks to fresh agent sessions

See your project's CLAUDE.md for specific tool paths and invocation patterns.

## Scope Expansion Rule

If inbox material covers a topic listed under "Not Covered" in any index.md:

1. **Stop** — do not ingest
2. **Report** — tell the human what topic was found and which exclusion it hits
3. **Wait** — human decides: expand scope (update "Not Covered"), redirect to another KB, or discard

This prevents KB scope creep. The human owns domain boundaries.

## Relationship to Other Concepts

| Concept | Relationship |
|---------|-------------|
| [KB Architecture](../concepts/knowledge-base-architecture.md) | Defines the structure this protocol populates |
| [Steward Agent](../concepts/steward-agent.md) | Stewards invoke this protocol for batch maintenance |
| [forge-kb](../variants/README.md) | One-shot KB creation; this protocol is for ongoing intake |
| [forge-research](../variants/README.md) | Produces the raw material that lands in inboxes |
| [Documentation Taxonomy](../concepts/documentation-taxonomy.md) | Guides artifact_type classification during Step 4 |
