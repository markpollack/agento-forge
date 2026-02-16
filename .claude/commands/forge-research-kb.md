---
name: forge-research-kb
description: "Bootstrap a research-partner KB — a federated research project consumed by other projects"
---

# Forge Research KB — Bootstrap a Research-Partner Knowledge Base

> **Installation**: Copy this file to `~/.claude/commands/forge-research-kb.md` for global access.
> Then update the paths in the Configuration section below.

You are bootstrapping a **research-partner knowledge base** — a research project specifically designed to be consumed by other projects via federation. This differs from a generic research project (`/forge-research`) in that it has explicit consumers, produces findings that feed into downstream projects, and integrates into a multi-KB federation.

See [Knowledge Base Architecture](concepts/knowledge-base-architecture.md) in forge-methodology for the full conceptual foundation.

## When to Use This vs `/forge-research`

| Use this (`/forge-research-kb`) when... | Use `/forge-research` when... |
|-----------------------------------------|-------------------------------|
| Other projects will query this KB | The research is self-contained |
| You need a PARTNER-QUERY-TEMPLATE.md | No consumer projects exist |
| Findings feed into downstream design | Output is a paper, dataset, or analysis |
| It should appear in KB-FEDERATION.md | It doesn't need federation |
| Multiple projects need answers from this corpus | One person/team uses the results |

## Arguments

- `$ARGUMENTS` - Optional: path to a research brief (`*-brief.md`), or project path
  - If a brief is provided, read it first to accelerate Phase 1 (verify rather than discover)
  - Briefs for research-partner KBs should include a **Consumer Projects** section (see Brief Format below)

## Brief Format

Extends the `forge-research` brief with consumer and federation fields:

```markdown
# Research Brief: {Project Name}

## Topic
{What you're researching — 1-2 sentences}

## Research Questions
{The core questions this research aims to answer — number them RQ1, RQ2, etc.}

## Spark
{What triggered this research — a conversation, a gap noticed, a need}

## Consumer Projects
{Projects that will query this KB for findings}
- {project-name} — {what it needs from this research}
- {project-name} — {what it needs}

## Project Path
{Where the project should live, e.g., ~/tuvium/projects/tuvium-{name}/}

## Visibility
Private | Community (Apache 2.0)

## Source Materials
- {path 1} — {brief description}
- {path 2} — {brief description}

## External References
{Other projects/files this KB should cross-reference}
- {path} — {relevance}

## Prior Conclusions
- {conclusion 1} — {confidence: High/Medium/Low}

## Seed Bibliography
### Topic 1: {name}
| Ref | Type | Priority | Notes |
|-----|------|----------|-------|
| Author et al. (year) — Title | Paper | P0 | {why it matters} |
```

## Configuration

**UPDATE THESE PATHS** to point to your installations:

- **Forge methodology**: `/home/mark/tuvium/projects/forge-methodology`
- **KB Federation file**: `/home/mark/tuvium/projects/tuvium-research-conversation-agent/KB-FEDERATION.md`
- **arXiv batch pipeline**: `/home/mark/tuvium/projects/tuvium-agentic-patterns-research/scripts/run_arxiv_batch.sh`
- **arXiv ingest docs**: `/home/mark/tuvium/projects/tuvium-agentic-patterns-research/docs/arxiv-ingest.md`

## Instructions

### Phase 1: Understand the Research and Its Consumers

Start conversationally. Research-partner KBs exist to serve other projects, so consumer needs are first-class:

1. **What are you researching?**
   - The topic or problem area
   - What question(s) you're trying to answer
   - What sparked this research

2. **Who consumes this research?** (This is what makes it a KB, not just a project)
   - Which projects will query this KB for findings?
   - What specific questions do those projects need answered?
   - Are there existing designs or implementations that this research informs?

3. **What do you have already?**
   - Papers, blog posts, references already gathered
   - Existing conversations or analysis
   - Related KBs that already exist in the federation

4. **Where should the project live?**
   - Project path (suggest `~/tuvium/projects/tuvium-{topic}-research/`)
   - Private or community visibility

### Phase 2: Gather Materials and Extract Bibliography

Same as `/forge-research` Phase 2, with one addition:

- **Map references to research questions** — As you extract the bibliography, note which RQs each reference addresses. This becomes the RQ Coverage Map in the paper tracker.

Use the Bibliography Extraction Patterns from `/forge-research`.

### Phase 3: Create Structure

#### 3.1: Directory scaffolding

```bash
mkdir -p {project}/plans/{conversations,supporting_docs/summaries,learnings,research}
mkdir -p {project}/data/{raw,curated}
mkdir -p {project}/scripts
mkdir -p {project}/notebooks
mkdir -p {project}/papers/summaries
mkdir -p {project}/findings
mkdir -p {project}/docs
```

#### 3.2: .gitignore

```
data/raw/
data/expanded/
__pycache__/
*.pyc
.ipynb_checkpoints/
.env
.DS_Store
```

#### 3.3: CLAUDE.md — Session Bridge

The CLAUDE.md for a research-partner KB has a specific structure. Write it with these sections:

```markdown
# {project-name} — {One-Line Description}

{2-3 sentence mission: what this research covers, who consumes it}

## Two Modes

### Forage Mode (Intake)
Build the research corpus — download papers, fetch blog posts, write structured summaries.

1. Check paper-tracker.md for next P0 paper to process
2. **Download arXiv papers** using the batch pipeline (see Tooling below)
3. For non-arXiv papers, fetch via WebFetch or note for manual download
4. Read and write structured summary to `papers/summaries/`
5. Update paper-tracker.md status (Unread → Summarized)
6. Note connections to other papers and to RQs in VISION.md
7. Repeat until all P0 papers are summarized

#### Tooling: arXiv Paper Download
{Include batch pipeline commands from Configuration above}

### Partner Mode (Q&A)
Answer research questions grounded in the corpus.

1. Read VISION.md for the question context (RQ1-RQN)
2. Check paper-tracker.md RQ Coverage Map for relevant papers
3. Read relevant summaries from `papers/summaries/`
4. Search corpus with Grep if needed
5. Synthesize answer with citations to specific papers
6. Write findings to `findings/` with grounded recommendations
7. Note gaps — questions the corpus can't answer

## Source Material Routing
| Document | Path | Key Content |
|----------|------|-------------|
| VISION.md | `plans/VISION.md` | Research questions, hypotheses, unknowns, scope |
| Paper tracker | `plans/supporting_docs/paper-tracker.md` | References by topic, priority, RQ coverage map |
| Paper summaries | `papers/summaries/` | Per-paper structured summaries |
| Findings | `findings/` | Cross-cutting analysis and recommendations |

## External References
| Document | Path | Relevance |
|----------|------|-----------|
{Table of consumer project files and other KBs this research references}

## Corpus Layout
{Directory tree}

## Per-Paper Summary Format
{Template — must include "Applicable to RQs" and "Implications for {consumer}"}

## Not Covered
This research does **not** address:
{Explicit exclusions — 5+ items}

## See Also: Other KBs
For topics outside this research's scope, consult:
`{path to KB-FEDERATION.md}`

| If you need... | See |
|----------------|-----|
{Cross-references to sibling KBs}
```

**Critical sections that differentiate this from generic research:**
- **External References** — links to consumer project files
- **Not Covered** — explicit negative knowledge (prevents wasted search)
- **See Also** — federation pointer and sibling KB cross-references
- **Per-Paper Summary Format** — must include "Applicable to RQs" and "Implications for {consumer-project}"

#### 3.4: PARTNER-QUERY-TEMPLATE.md

Write a paste-ready template that consumer projects can add to their CLAUDE.md:

```markdown
# {Research Name} — Query Template

> Paste this section into your project's CLAUDE.md to enable research queries.

## {Research Name}

Research corpus for {topic} is at:
`{absolute-path-to-project}/`

**Query algorithm:**

1. **Read paper-tracker.md** — `{PATH}/plans/supporting_docs/paper-tracker.md`
   - Check RQ Coverage Map: which papers address your question?
   - Check topic tables for relevant summaries

2. **Read relevant summaries** — `{PATH}/papers/summaries/`
   - Each summary has "Applicable to RQs" and "Implications for {consumer}"

3. **Check findings/** — `{PATH}/findings/`
   - Cross-cutting analysis and concrete recommendations

4. **Check VISION.md** — `{PATH}/plans/VISION.md`
   - Does your question map to an RQ? If so, findings may already exist.

5. **Report gaps** — if the corpus doesn't answer your question:
   - Note what you looked for
   - Check "Not Covered" in CLAUDE.md
   - Report so Forage Mode can fetch additional papers

## Example Queries
| Query | Path Taken | Hops |
|-------|-----------|------|
{3-4 realistic example queries showing expected navigation}
```

### Phase 4: Draft VISION.md and Paper Tracker

#### 4.1: VISION.md

Structure:

```markdown
# VISION: {Title}

> **Created**: {date}
> **Status**: Active research
> **Consumers**: {project1} ({what it needs}), {project2} ({what it needs})

## Problem Statement
{What gap this research addresses}

## Research Questions

### Architecture & Design
**RQ1**: {question}
**RQ2**: {question}

### {Category 2}
**RQ3**: {question}

## Hypotheses
### H1 — {Name}
**Claim**: {precise statement}
**Measurement**: {how to test}
**Status**: Untested

## Unknowns
| ID | Unknown | Status | Resolution |
|----|---------|--------|------------|
| U1 | {question} | Open | {context} |

## Scope
**In scope:** {bulleted list}
**Out of scope:** {bulleted list — these become CLAUDE.md "Not Covered"}

## Consumers
| Project | What it needs from this research |
|---------|--------------------------------|
| {project} | {specific needs} |
```

The **Consumers** table is required — it's what makes this a KB, not just a project.

#### 4.2: Paper Tracker

The paper tracker for a research-partner KB has one critical addition: the **RQ Coverage Map**.

```markdown
# Paper Tracker: {Topic}

> **Last updated**: {date}
> **Corpus size**: 0 summarized / {N} tracked
> **Focus**: {keywords}

## Topic 1: {name}
| Ref | Type | Priority | Status | Summary File | Notes |
|-----|------|----------|--------|--------------|-------|

## Topic 2: {name}
| Ref | Type | Priority | Status | Summary File | Notes |
|-----|------|----------|--------|--------------|-------|

## Fetch Priority

**Batch 1** (P0 — fetch and deep-read first):
1. {paper} — {URL}

**Batch 2** (P1 — fetch after Batch 1):
...

## RQ Coverage Map

| Paper | RQ1 | RQ2 | RQ3 | ... |
|-------|-----|-----|-----|-----|
| {paper} | **Primary** | Yes | | |
```

The RQ Coverage Map lets Partner Mode quickly find which papers to read for any given research question. Mark cells as **Primary** (main source), Yes (relevant), or blank (not relevant).

### Phase 5: Review and Refine

Present VISION.md, CLAUDE.md, paper-tracker.md, and PARTNER-QUERY-TEMPLATE.md to the user:

1. Does the VISION.md capture what you're researching?
2. Are the research questions right? Do they cover what the consumers need?
3. Is the paper tracker complete? Any missing references?
4. Does the RQ Coverage Map look right?
5. Is the "Not Covered" section accurate?
6. Does the PARTNER-QUERY-TEMPLATE.md work for your consumer projects?

Iterate until satisfied.

### Phase 6: Integrate and Ship

This phase handles everything that connects the new KB to the ecosystem:

#### 6.1: Git initialization

```bash
cd {project}
git init
git branch -m main
git add -A
git commit -m "Bootstrap {project-name} research KB"
```

#### 6.2: Create GitHub remote

```bash
GITHUB_TOKEN="" gh auth switch --user mark-tuvium
GITHUB_TOKEN="" gh repo create tuvium/{project-name} --private --source=. --push
```

#### 6.3: Add to KB-FEDERATION.md

Read the federation file (path from Configuration). Add:

1. **KB Catalog entry** — new row with entry point, domains, "Read when..." description
2. **Cross-KB Task Routing** — 1-2 new rows for tasks that involve this KB
3. **KB Freshness** — new row with `last_consolidated` date and "Bootstrapped — 0/N papers summarized"
4. **Update "Not Federated"** — remove any topic that this KB now covers

#### 6.4: Add to consumer project See Also sections

For each consumer project's root index.md or CLAUDE.md, add a row to the "See Also" table pointing to this new KB.

#### 6.5: Write HANDOFF-FORAGE.md

Write a handoff prompt that can be pasted into a new Claude Code session to start foraging:

```markdown
# Handoff: Forage Mode — Download and Summarize P0 Papers

> Paste this into a new Claude Code session opened inside `{project-name}/`.

## Mission
Download and summarize the {N} P0 papers. Corpus: 0/{total} summarized.

## Before You Start
1. Read `CLAUDE.md`
2. Read `plans/VISION.md`
3. Read `plans/supporting_docs/paper-tracker.md`

## Papers to Process
{For each P0 paper:}
### {N}. {Paper Name} (arXiv {ID} or URL)
- **Fetch**: {specific download command or WebFetch URL}
- **RQ coverage**: {which RQs this paper addresses}
- **Why**: {one sentence on relevance}

## Per-Paper Workflow
1. Download PDF to `papers/`
2. Read thoroughly
3. Write summary to `papers/summaries/{filename}.md`
4. Map to RQs in "Applicable to RQs" section
5. Note implications for consumer projects
6. Update paper-tracker.md status and Summary File column
7. Update corpus size in tracker header

## After All Done
- Update paper-tracker.md header
- Note new papers discovered via citations
- Note RQ coverage gaps after Batch 1
- Commit
```

#### 6.6: Commit and push federation changes

Commit the KB-FEDERATION.md updates and consumer project See Also changes. Push all affected repos.

## Per-Paper Summary Format (Research-Partner KB Variant)

This extends the generic forge-research format with consumer-facing sections:

```markdown
## {Author et al. (Year)} — {Short Title}
**Full title**: {title}
**Venue**: {venue}
**URL**: {url}
**Priority**: P0/P1/P2/P3
**Status**: Summarized

### Key Contribution
{1-2 sentences}

### Relevance to This Research
{How this paper informs the research questions}

### Key Findings
- {finding 1}
- {finding 2}

### Applicable to RQs
- RQ{N}: {how this paper informs this question}
- RQ{M}: {how this paper informs this question}

### Connections
- Relates to: {other papers in the tracker}
- Implications for {consumer-project}: {concrete design implications}
```

The **Applicable to RQs** and **Implications for {consumer}** sections are what make Partner Mode useful — they let consumers find answers without reading full papers.

## Checklist (Verify Before Done)

Before declaring the bootstrap complete, verify:

- [ ] CLAUDE.md has: Two Modes, External References, Not Covered, See Also
- [ ] PARTNER-QUERY-TEMPLATE.md exists and is self-contained
- [ ] VISION.md has: Research Questions, Consumers table, Scope
- [ ] paper-tracker.md has: RQ Coverage Map, Fetch Priority batches
- [ ] HANDOFF-FORAGE.md exists with per-paper instructions
- [ ] KB-FEDERATION.md updated with new entry
- [ ] Consumer project See Also sections updated
- [ ] GitHub remote created (private)
- [ ] All files committed and pushed

## Relationship to Other Forge Concepts

- **[Knowledge Base Architecture](concepts/knowledge-base-architecture.md)** — This skill implements the Research-Partner KB pattern
- **[`/forge-research`](.claude/commands/forge-research.md)** — Parent skill for generic research projects. This skill extends it with federation and consumer awareness
- **[Research Agent](concepts/research-agent.md)** — The two modes (Forage + Partner) map to the Research Agent concept
- **[Research Project Structure](guides/research-project-structure.md)** — Directory conventions this skill follows

## Tone

Same as `/forge-research`: conversational, helpful, research partner. But with extra emphasis on the consumer perspective — always ask "who needs this?" and "what questions do they need answered?" The KB exists to serve its consumers, not just to collect papers.
