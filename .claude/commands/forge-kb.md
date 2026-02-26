---
name: forge-kb
description: "Structure a document corpus for JIT context Q&A via Claude Code (Forge KB Builder)"
---

# Forge KB — Structure a Corpus for JIT Context Q&A

> **Installation**: Copy this file to `~/.claude/commands/forge-kb.md` for global access.
> Then update the forge-methodology path in the Configuration section below.

You are helping structure an existing collection of documents into a queryable knowledge base that Claude Code can navigate using its built-in file tools (Glob, Grep, Read). No vector database, no embeddings — just flat files with routing tables that enable hierarchical agentic RAG.

The user has already collected documents. Your job is to survey what's there, identify the natural structure, build navigation infrastructure (routing tables, indexes, session bridge), and validate that questions can be answered in ≤3 hops.

## When to Use This

Use this skill when:
- You have a directory with collected documents (markdown, text, PDFs, notes, exported conversations)
- You want to ask questions of that corpus using Claude Code
- You want structured navigation, not keyword search
- You want the same corpus queryable across multiple sessions

Do **not** use this for:
- Starting a new research project from scratch → use `/forge-research` or `/forge-research-kb`
- Building a code-agent KB consumed by automated agents during task execution → that needs the full Curator/Navigator two-agent pattern from [Knowledge Base Architecture](concepts/knowledge-base-architecture.md); this skill builds the foundation but the two-agent split requires additional specialization
- Bootstrapping a software project → use `/forge-project`

## Arguments

- `$ARGUMENTS` - Required: path to the directory containing the document corpus. Optionally followed by a one-sentence description of what the corpus covers.

## Configuration

**UPDATE THIS PATH** to point to your installation:

- **Forge methodology**: `/home/mark/tuvium/projects/forge-methodology`

## How This Relates to Forge Concepts

This skill implements the **Research-Partner KB** pattern from [Knowledge Base Architecture](concepts/knowledge-base-architecture.md), optimized for the common case: "I have docs, I want to chat with them."

The key infrastructure it builds:
- **CLAUDE.md** — Session bridge defining Partner Mode (Q&A over corpus)
- **Routing tables** (index.md files) — Question routing, topic routing, negative knowledge
- **Corpus map** — What's where, organized by topic

It does NOT build (but can be extended to):
- YAML frontmatter faceted metadata (Code-Agent KB pattern)
- VOCABULARY.md controlled vocabulary
- NAVIGATOR-PROMPT.md consumer template
- Curator/Navigator two-agent split

Those are Phase 2 concerns. This skill gets you from "pile of docs" to "I can ask questions" — the 80/20 of KB structuring.

## Instructions

### Phase 1: Survey the Corpus

Start by understanding what's in the directory.

1. **Count and catalog** — Use Glob and Bash to understand the corpus:
   - How many files? What types (.md, .txt, .pdf, .html)?
   - How are they currently organized (flat? subdirectories? naming conventions)?
   - Total size — is this 10 files or 500?

2. **Sample the content** — Read 5-8 representative files to understand:
   - What domain(s) does this corpus cover?
   - What's the typical document structure? (headers, sections, format)
   - Are there already any index files, READMEs, or table-of-contents docs?
   - Is there existing metadata (YAML frontmatter, tags, dates)?
   - What quality level? (polished articles vs rough notes vs raw exports)

3. **Identify natural clusters** — Look for:
   - Subdirectory groupings (existing organization)
   - Topic clusters (documents that cover the same subject)
   - Document types (reference docs, how-to guides, analysis, raw data, conversations)
   - Naming patterns that reveal organization

4. **Report findings to the user** — Present a concise summary:
   - "{N} files across {M} directories covering {topics}"
   - Existing organization: what works, what's missing
   - Proposed domain/topic groupings
   - Any files that seem like outliers or don't fit

Ask the user: "Does this grouping make sense? Are there topics I'm missing or grouping wrong?"

### Phase 2: Design the Navigation Structure

Based on what you found, design the routing infrastructure. The principle: **an agent should find the right file in ≤3 hops** (root index → domain index → detail file).

1. **Determine hierarchy depth** based on corpus size:

   | Corpus Size | Structure |
   |-------------|-----------|
   | < 20 files | Flat: root index.md only, no subdirectories needed |
   | 20-50 files | One level: root index.md + topic groupings |
   | 50-200 files | Two levels: root index.md → domain/index.md → files |
   | 200+ files | Two levels with CHEATSHEET.md per domain; consider splitting |

2. **Plan the routing tables** — For each level, identify:
   - **Question routing**: "If you're asking X, read Y" — the most common questions someone would ask this corpus
   - **Topic routing**: "Documents about X are in Y/" — where things live
   - **Cross-topic routing**: Questions that need files from multiple areas
   - **Negative knowledge**: What this corpus does NOT cover — prevents wasted search

3. **Plan file reorganization** (if needed) — Propose moves only if the current layout actively hinders navigation. Don't reorganize for aesthetics. Ask the user before moving anything.

4. **Present the plan** — Show the user:
   - Proposed directory structure (tree diagram)
   - Routing table draft for root index.md
   - Which index.md files will be created
   - Any proposed file moves
   - What the CLAUDE.md will contain

Get user approval before proceeding.

### Phase 3: Build Navigation Infrastructure

Create the routing infrastructure. Work from leaves to root — understand the details before writing the routing.

#### 3.1: Create domain/topic index.md files (if multi-level)

For each domain or topic directory, create an `index.md`:

```markdown
# {Domain/Topic Name}

> {One-sentence description of what knowledge lives here}

## Question Routing

| Question | Read |
|----------|------|
| {Common question about this topic} | `{file.md}` |
| {Another question} | `{file.md}` |

## Contents

| File | Purpose | Read when... |
|------|---------|--------------|
| `{file.md}` | {1-sentence description} | {when an agent should read this} |

## Not Covered

This topic does **not** include:
- {Explicit exclusion 1}
- {Explicit exclusion 2}
```

**Routing table guidelines:**
- Question Routing entries should be real questions someone would ask, not abstract topic labels
- "Read when..." should be task-oriented ("you need to understand X", "you're debugging Y")
- Not Covered should include things someone might reasonably expect to find here but won't
- Keep each index.md ≤80 lines

#### 3.2: Create root index.md

The root index is the entry point for all navigation:

```markdown
# {Corpus Name}

> {One-sentence description of the corpus and its purpose}

## Question Routing

| Question | Read |
|----------|------|
| {Most common question 1} | `{path}` |
| {Most common question 2} | `{path}` |
| {Question spanning topics} | `{path1}` then `{path2}` |

## Topic Routing

| Topic | Location | Contains |
|-------|----------|----------|
| {Topic 1} | `{dir}/` | {1-sentence description} |
| {Topic 2} | `{dir}/` | {1-sentence description} |

## Cross-Topic Questions

| Question | Start with | Also read |
|----------|-----------|-----------|
| {Question needing multiple areas} | `{primary path}` | `{secondary path}` |

## Not Covered

This corpus does **not** contain:
- {Explicit exclusion 1}
- {Explicit exclusion 2}
- {Explicit exclusion 3}
```

**Root index guidelines:**
- ≤100 lines total
- 8-15 question routing entries (cover the most common questions)
- Every directory in the corpus should appear in Topic Routing
- Not Covered should have ≥3 entries — think about what someone might assume is here but isn't

#### 3.3: Create CLAUDE.md (Session Bridge)

The CLAUDE.md defines how a Claude Code session operates in this project. For a Q&A corpus, it establishes **Partner Mode**:

```markdown
# {Corpus Name}

{2-3 sentence mission: what this corpus covers, what questions it can answer, what it's for}

## Partner Mode (Q&A)

Answer questions grounded in this corpus. Navigate using routing tables, not brute-force search.

**Query algorithm:**
1. Read `index.md` — check Question Routing for a direct match
2. If no direct match, check Topic Routing for the relevant domain
3. Read the domain's `index.md` for more specific routing
4. Read the target file(s)
5. If Grep is needed, search with specific terms (not broad patterns)
6. Synthesize the answer with citations to specific files
7. If the corpus doesn't answer the question, say so — check Not Covered sections

**Response guidelines:**
- Ground every answer in specific files. Cite paths.
- Distinguish what the corpus says from your own interpretation.
- If a question spans multiple topics, show how the pieces connect.
- Note gaps — questions the corpus can't fully answer.

## Source Material Routing

| Document / Area | Path | Key Content |
|----------------|------|-------------|
| {description} | `{path}` | {what you'll find there} |
| {description} | `{path}` | {what you'll find there} |

## Corpus Layout

```
{directory tree showing structure}
```

## Key Concepts

{3-5 bullet points capturing the most important domain-specific terms, distinctions, or framings that help an agent understand queries in context}

## Not Covered

This corpus does **not** address:
- {exclusion 1}
- {exclusion 2}
- {exclusion 3}
```

**CLAUDE.md guidelines:**
- Target ≤150 lines (the "smart zone" — enough context to be useful, not so much it crowds out actual content)
- Source Material Routing table should cover every major area with enough detail to route without reading index.md first
- Key Concepts section is critical — it teaches the agent the domain vocabulary so it can interpret questions correctly
- Not Covered must match root index.md Not Covered (single source of truth is fine; duplication for fast access is also fine)

### Phase 4: Validate

Test the navigation infrastructure against real questions.

1. **Generate 5-6 test questions** — questions someone would actually ask this corpus. Include:
   - 1-2 simple lookups (should resolve in 1 hop)
   - 2-3 questions requiring navigation (should resolve in 2-3 hops)
   - 1 question the corpus should NOT be able to answer (should hit Negative Knowledge)

2. **Walk through each question** using only the routing tables:
   - Start at root index.md
   - Follow Question Routing or Topic Routing
   - Count hops to reach the answer
   - Note any dead ends or wrong routes

3. **Report results** to the user:
   - Which questions resolved correctly and in how many hops
   - Any routing gaps found (questions that should route but don't)
   - Any missing Not Covered entries
   - Suggested fixes

4. **Fix routing gaps** — Update index.md and CLAUDE.md based on validation findings.

### Phase 5: Handoff

Summarize what was built and how to use it:

1. **What was created** — List all new files (index.md files, CLAUDE.md)
2. **How to use it** — "Open a Claude Code session in this directory. Read CLAUDE.md. Ask questions."
3. **Maintenance** — When new documents are added:
   - Add them to the relevant directory
   - Update the directory's index.md (add to Contents table, add Question Routing entries if the new doc answers new questions)
   - Update root index.md if the new doc covers a new topic area
4. **Growth path** — If the corpus grows significantly:
   - 50+ files: consider YAML frontmatter for faceted search (grep by task_types, subjects)
   - 100+ files: consider VOCABULARY.md for controlled metadata
   - Consumer agents need access: consider NAVIGATOR-PROMPT.md (paste-ready template)
   - Multiple corpora need coordination: consider KB-FEDERATION.md

## Scale Adaptation

The skill adapts its output based on corpus size:

**Small corpus (< 20 files):**
- Root index.md only (no subdirectory indexes needed)
- CLAUDE.md with compact routing table
- Flat structure — don't over-engineer

**Medium corpus (20-100 files):**
- Root index.md + domain index.md files
- CLAUDE.md with Source Material Routing table
- Two-level hierarchy where natural groupings exist

**Large corpus (100+ files):**
- Full two-level hierarchy with index.md at every directory
- CLAUDE.md with comprehensive routing
- Consider recommending CHEATSHEET.md files for dense domains
- Consider recommending YAML frontmatter as a follow-up

## What Makes This Different from Vector RAG

This approach — which we call **JIT Retrieval** or **Explore RAG** — uses Claude Code's native file tools (Glob, Grep, Read) to navigate structured flat files. It works because:

1. **Routing tables are human-authored rerankers** — they encode domain expertise about what's relevant to what, beating statistical similarity
2. **Negative Knowledge saves more time than positive routing** — knowing what ISN'T here prevents the most wasteful searches
3. **Hierarchical navigation scales** — root index → domain index → file is O(log n), not O(n)
4. **No infrastructure required** — no embedding models, no vector stores, no indexing pipeline. Just markdown files in git
5. **Works up to ~500 files per KB** — beyond that, consider splitting into federated KBs

The trade-off: this requires someone (or this skill) to build the routing tables. Vector RAG is automatic but dumber. Structured routing is manual but dramatically more accurate for domain-specific Q&A.

## Tone

Be practical and efficient. The user has docs and wants to chat with them — get to that outcome quickly. Don't over-structure small corpora. Don't propose reorganization unless the current layout is genuinely broken. Respect what's already there and build navigation on top of it.
