---
name: forge-research
description: "Bootstrap a research project (Forge Phase 0+1: Forage + Vision)"
---

# Forge Research — Bootstrap a Research Project

You are helping bootstrap a new research project using the Forge methodology's research variant. This skill handles the full lifecycle: understanding the research domain, gathering and extracting from source material, scaffolding the project structure, drafting VISION.md, pre-populating the paper tracker, creating a CLAUDE.md session bridge, and defining the foraging mission.

## When to Use This vs `/forge-research-kb`

Use **this skill** for standalone research projects — the output is papers, analysis, or self-contained findings. No other projects need to query this corpus.

Use **`/forge-research-kb`** when the research exists to serve other projects — it has explicit consumers, needs a PARTNER-QUERY-TEMPLATE.md, and integrates into KB-FEDERATION.md. See [Knowledge Base Architecture](concepts/knowledge-base-architecture.md) for the Research-Partner KB pattern.

## Arguments
- `$ARGUMENTS` - Optional: project path, conversation file paths, or existing directories (can be provided interactively)
  - If `$ARGUMENTS` contains a path to a `.md` file named `*-brief.md` or `*-BRIEF.md`, treat it as a **pre-filled research brief** (see Brief Format below). Read it first, use it to accelerate Phase 1 (verify rather than discover), and proceed directly to Phase 2.

## Brief Format

A research brief pre-fills Phase 1 answers so the skill can skip discovery and move straight to material gathering. When a brief is provided:

1. Read the brief file
2. Confirm the key details with the user ("I see you're researching X, with these source materials — does this look right?")
3. **Treat "Prior Conclusions" as hypotheses to investigate**, not settled facts. Frame them in VISION.md as testable claims with confidence levels. The research may confirm, refine, or overturn any of them — that's the point of doing the research.
4. Proceed to Phase 2 (Gather Materials) using the brief's source material paths
5. Use the brief's seed bibliography to accelerate Phase 4 (paper-tracker pre-population)

```markdown
# Research Brief: {Project Name}

## Topic
{What you're researching — 1-2 sentences}

## Research Question
{The core question this research aims to answer}

## Spark
{What triggered this research — a conversation, a gap noticed, a need}

## Project Path
{Where the project should live}

## Visibility
Private | Community

## Source Materials
{Paths to conversations, documents, existing directories to read}
- {path 1} — {brief description}
- {path 2} — {brief description}

## Existing Synthesis
{Paths to any existing summaries, theme docs, or analysis}
- {path 1} — {brief description}

## Prior Conclusions
{Conclusions from earlier analysis. These are starting hypotheses, not settled facts — the research may confirm, refine, or overturn them. Treat as "promising framings to investigate" rather than constraints on the research.}
- {conclusion 1} — {confidence: High/Medium/Low}
- {conclusion 2} — {confidence: High/Medium/Low}

## Seed Bibliography
{Pre-extracted references organized by topic, with priority}

### Topic 1: {name}
| Ref | Type | Priority | Notes |
|-----|------|----------|-------|
| Author et al. (year) — Title | Paper | P0 | {why it matters} |

### Topic 2: {name}
| Ref | Type | Priority | Notes |
|-----|------|----------|-------|
| {reference} | Blog/Framework/Dataset | P1 | {why it matters} |
```

## Configuration

Paths are resolved via environment variables. Set these before running the command,
or add them to your shell profile.

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENTO_FORGE_HOME` | `$HOME/projects/agento-forge` | Root of the agento-forge checkout (forge methodology, templates) |
| `ARXIV_BATCH_PIPELINE` | *(optional)* | Path to `run_arxiv_batch.sh` for batch downloading arXiv papers |

**Path references in this command use placeholders**:
- `{agento-forge}` → `$AGENTO_FORGE_HOME`

## Instructions

### Phase 1: Understand the Research

Start by asking the user about their research. Be conversational:

1. **What are you researching?** Ask them to describe:
   - The topic or problem area
   - What question they're trying to answer
   - What sparked this research (a conversation, a gap they noticed, etc.)

2. **What do you have already?** Ask about:
   - Saved conversations (ChatGPT exports, Claude conversations, notes)
   - Existing directories with related work, data, or notes
   - Any papers or references they've already gathered
   - Existing synthesis or summaries (e.g., from a research-conversation-agent)

3. **Where should the project live?** Ask for:
   - Project path (suggest a reasonable default based on what they described)
   - Whether it should be a private or community project

### Phase 2: Gather Materials and Extract Bibliography

Once you understand what they're researching:

1. **Read their conversations** — If they provided conversation files, read them thoroughly
2. **Survey existing directories** — If they have existing work, explore it to understand what's there
3. **Identify key elements** — Look for:
   - Research questions (explicit or implicit)
   - Hypotheses or claims they're exploring
   - Unknowns they've identified or resolved
   - Constraints or scope boundaries
   - Publication goals (papers, venues)

4. **Extract bibliographic references** — Scan all source material for:
   - Academic papers (author, title, year, venue if mentioned)
   - Industry blog posts and whitepapers (author/org, title, URL if present)
   - Framework and tool documentation (name, URL)
   - Datasets and benchmarks (name, source, size if mentioned)
   - Books or book chapters

   Compile these into a **seed bibliography** organized by topic. Note which references are P0 (must-read, foundational) vs P1-P3 (supporting). Use the Bibliography Extraction Patterns table below.

### Phase 3: Create Structure

Create the research project directory using Bash:

```bash
mkdir -p {project}/plans/{conversations,supporting_docs/summaries,learnings,research}
mkdir -p {project}/data/{raw,curated}
mkdir -p {project}/scripts
mkdir -p {project}/notebooks
mkdir -p {project}/papers
mkdir -p {project}/findings
mkdir -p {project}/docs
```

Copy templates from agento-forge (use paths from Configuration above):
- `{agento-forge}/templates/VISION-TEMPLATE-research.md` → `{project}/plans/VISION.md`
- `{agento-forge}/templates/PAPER-TRACKER-TEMPLATE.md` → `{project}/plans/supporting_docs/paper-tracker.md`

Copy their conversation files to `{project}/plans/conversations/`.

Create a `.gitignore` in the project root:
```
data/raw/
data/expanded/
__pycache__/
*.pyc
.ipynb_checkpoints/
.env
.DS_Store
```

#### Create CLAUDE.md Session Bridge

Create a `{project}/CLAUDE.md` that defines:

1. **Project scope and mission** — What domain this project covers, what it aims to produce
2. **Source material routing** — Table of key documents with line ranges for efficient navigation
3. **Corpus layout** — Where papers live, where summaries live, how findings are organized
4. **Key concepts** — Domain-specific terminology and decisions extracted from source material

5. **Two modes** — The CLAUDE.md must define both named modes that operate in this project:

   **Forage Mode (Intake)**
   Build the corpus — download papers, archive blog posts, summarize, expand bibliography.

   *Claude Code tools (built-in):*
   - `WebSearch` for finding paper URLs, author pages, blog posts
   - `WebFetch` for reading blog posts, framework docs, open-access papers
   - Semantic Scholar API (`https://api.semanticscholar.org/graph/v1/`) via WebFetch — structured paper metadata, citation graphs, PDF links. No auth for basic queries. Key endpoints: `/paper/search`, `/paper/{id}`, `/paper/{id}/citations`, `/paper/{id}/references`
   - ArXiv API (`http://export.arxiv.org/api/query`) via WebFetch — preprint access, search by author/title/category
   - DBLP API (`https://dblp.org/search/publ/api`) via WebFetch — CS bibliography lookup (exact venue, year, co-authors)

   *arXiv batch pipeline (if configured):*
   ```bash
   # Download all arXiv papers from paper-tracker.md
   {arXiv-batch-pipeline-path} --from-tracker

   # Download specific paper by arXiv ID
   {arXiv-ingest-script} --mode download --id {arxiv-id}
   ```
   Use paths from Configuration section above. If not configured, use WebFetch on arXiv HTML/PDF URLs directly.

   *External tools (user invokes separately, saves output to project):*
   - **ChatGPT Deep Research** — Comprehensive literature sweeps. User runs a focused prompt, saves output to `plans/conversations/`. Agent processes saved output in subsequent session. Best for: broad "find everything about X" surveys
   - **Connected Papers** (connectedpapers.com) — Visual citation graph exploration. Best for: discovering related work via citation clusters
   - **Elicit** (elicit.com) — AI-powered paper search with structured extraction. Best for: finding papers that answer specific empirical questions
   - **Perplexity** (perplexity.ai) — AI search with inline citations. Best for: quick fact-checking, finding specific claims
   - **Google Scholar alerts** — Ongoing monitoring after initial foraging is complete

   *When to use which:*
   - Start broad with **ChatGPT Deep Research** or **Elicit** for comprehensive sweeps
   - Use **Connected Papers** to expand from known P0 papers via citation graphs
   - Use **Claude Code WebSearch + Semantic Scholar API** for targeted lookups (specific paper metadata, finding PDFs, citation counts)
   - Use **Perplexity** for quick verification of specific claims
   - Set up **Google Scholar alerts** for long-term monitoring after initial corpus is built

   **Partner Mode (Q&A over corpus)**
   Navigate and query the gathered corpus — answer questions, find connections, identify gaps.

   *How it works:*
   - CLAUDE.md routing table directs Claude to the right file/line range without reading everything
   - `papers/summaries/` contains per-paper structured summaries (searchable via Grep)
   - `paper-tracker.md` provides the master index with status, priority, topic organization
   - `findings/` contains cross-cutting analysis and synthesis
   - Claude Code reads summaries, searches corpus via Grep/Glob, answers questions about gathered literature
   - This IS the RAG — hierarchical agentic RAG with flat files, no vector database needed at research scale

6. **Foraging mission** — The active knowledge-gathering mandate (see Phase 6)

7. **Output expectations** — Per-paper summary format:
   ```markdown
   ## {Author et al. (Year)} — {Short Title}
   **Full title**: {title}
   **Venue**: {venue}
   **URL**: {url}
   **PDF**: {pdf_path or "not downloaded"}
   **Priority**: P0/P1/P2/P3
   **Status**: Unread / Skimmed / Read / Summarized

   ### Key Contribution
   {1-2 sentences}

   ### Relevance to This Project
   {Why this paper matters for our research}

   ### Key Findings
   - {finding 1}
   - {finding 2}

   ### Connections
   - Relates to: {other papers or project concepts}
   ```

8. **Not Covered** — Explicit list of what this project does NOT address. Prevents wasted search. Pull from VISION.md "Out of scope" section. Example:
   ```markdown
   ## Not Covered
   This research does **not** address:
   - {exclusion 1}
   - {exclusion 2}
   ```

9. **Session behavior** — How a Claude Code session in this project should operate (research partner, not just retrieval). Note which mode is active: forage sessions build the corpus, partner sessions query it

### Phase 4: Draft VISION.md and Pre-populate Paper Tracker

Based on what you learned from their description and materials, draft a VISION.md that includes:

**Problem Statement** — Synthesize what gap or question they're addressing

**Research Questions** — Extract or formulate RQs from their description/conversations:
- RQ1, RQ2, etc. — clear, answerable questions

**Hypotheses** — If they have testable claims, structure them:
```markdown
### H1 — {Name}
**Claim**: {precise statement}
**Measurement**: {how to test}
**Status**: Untested
```

**Unknowns Tracking** — Things they need to figure out:
| ID | Unknown | Status | Resolution |
|----|---------|--------|------------|
| U1 | {question} | Open/Answered | {answer if known} |

**Assumptions** — Things they're taking for granted

**Scope** — What's in and out

**Paper Structure** — If they mentioned publication goals

**Key References** — Links to the conversations and existing directories

**Research Loop Status** — Initialize as:
- L₁ (External validity): Unbounded
- L₂ (Reproducibility): Unbounded
- L₃ (Methodological honesty): Unbounded

#### Pre-populate Paper Tracker

Using the seed bibliography from Phase 2, fill in the paper-tracker.md template:

1. **Organize by topic** — Group papers by the research areas/themes identified in the source material
2. **Assign priorities** — P0 for foundational/must-read, P1 for important supporting, P2 for good-to-know, P3 for tangential
3. **Set status** — All start as "Unread" unless the user has already read them
4. **Add relevance notes** — Brief note on why each paper matters for this research
5. **Record known URLs** — If URLs were found in source material, include them
6. **Identify citation chains** — If the source material mentions papers that cite each other, note the relationships
7. **Add Fetch Priority section** — Order P0 papers into Batch 1 (fetch first), P1 into Batch 2, etc. Include download URLs
8. **Add RQ Coverage Map** — A paper-by-RQ matrix showing which papers address which research questions. Mark cells as **Primary** (main source), Yes (relevant), or blank. This becomes the Partner Mode lookup table for answering questions

### Phase 5: Review and Refine

Present the draft VISION.md, CLAUDE.md, and paper-tracker.md to the user and ask:

1. Does the VISION.md capture what you're researching?
2. Are the research questions right?
3. Did I miss any hypotheses or unknowns?
4. Is the paper tracker complete? Any missing references?
5. Does the CLAUDE.md session bridge capture the right scope and tools?
6. What would you change?

Iterate based on their feedback until they're satisfied.

### Phase 6: Define Foraging Mission and Next Steps

After documents are finalized, define the foraging mission and suggest next steps:

1. **Foraging mission** — Write a concrete action plan into CLAUDE.md:
   - Which P0 papers to download and summarize first
   - Which APIs to query (Semantic Scholar for citation graphs, ArXiv for preprints)
   - Which blog posts / industry references to archive
   - Expected output: per-paper summaries in `papers/summaries/`, PDFs in `papers/`
   - Suggest organizing downloaded papers into subdirectories by topic

2. **First roadmap** — Which paper or study to tackle first

3. **Literature expansion** — Beyond the seed bibliography:
   - Citation graph traversal: "read the papers that cite X and that X cites"
   - Keyword searches to run on Semantic Scholar / Google Scholar
   - Conference proceedings to check (specific venues relevant to the domain)

4. **Data collection** — If they need data, what's the first step

5. **Git initialization** — Suggest `git init` and first commit, or repo creation if they want a remote

6. **Session handoff** — Write a `HANDOFF-FORAGE.md` at the project root. This is a paste-ready prompt for starting the first foraging session in a new Claude Code window. It should include:
   - The mission (download and summarize P0 papers)
   - "Before You Start" checklist (read CLAUDE.md, VISION.md, paper-tracker.md)
   - Each P0 paper with: fetch command/URL, RQ coverage, one-sentence relevance
   - Per-paper workflow steps (download → read → summarize → update tracker)
   - "After All Done" checklist (update tracker, note citations, note gaps, commit)

## Extraction Patterns

### Research Element Extraction

When reading conversations, look for:

| Pattern | Extract as |
|---------|------------|
| "The problem is...", "Nobody has...", "The gap is..." | Problem Statement |
| "How does X work?", "What causes Y?", "Can we measure Z?" | Research Questions |
| "I think X because Y", "My hypothesis is...", "We expect..." | Hypotheses |
| "We'd need to find out...", "Unknown:", "Not sure about..." | Unknowns (Open) |
| "Ah, so the answer is...", "Found that...", confirmed findings | Unknowns (Answered) |
| "Assuming that...", "This only works if..." | Assumptions |
| "Out of scope:", "We're not doing...", "That's for later" | Out of Scope |
| "For the paper...", "Submit to...", "Paper 1 would..." | Paper Structure |

### Bibliography Extraction

When reading source material, look for:

| Pattern | Extract as | Example |
|---------|-----------|---------|
| "{Author} et al. ({year})", "{Author} and {Author} ({year})" | Academic paper | "Shinn et al. (2023)" |
| "{Author} et al. — {Title}" | Academic paper (inline) | "Madaan et al. — Self-Refine" |
| "arxiv.org/abs/{id}", "doi.org/{id}" | Paper URL | Direct link to paper |
| "{Org} blog", "{Org} whitepaper", "{Org} documentation" | Industry reference | "Anthropic's building effective agents blog" |
| Framework/library names with docs context | Framework doc | "CrewAI", "LangGraph", "AutoGen" |
| "{Name} dataset", "{Name} benchmark", "{Name} test suite" | Dataset/benchmark | "SWE-bench", "HumanEval", "LAB-Bench" |
| Conference names (ICSE, NeurIPS, ICLR, ACL, etc.) | Venue for search | Target venues for literature sweep |
| "survey of...", "review of...", "taxonomy of..." | Survey paper (high priority) | Survey papers are P0 — they contain more references |

**Tip**: Survey papers are gold mines. When you find one, it usually contains 50-200 references organized by topic — extract those too and add as P2/P3 candidates.

## Tone

Be conversational and helpful. This is the start of a research journey — help them clarify their thinking, not just fill in templates. Ask follow-up questions when their description is vague. Offer suggestions when you see patterns they might not have articulated.

When extracting bibliography, be thorough but not mechanical. Note when references cluster around a theme — that's a signal about what the user cares about most. When you see gaps (e.g., lots of agent architecture papers but no evaluation methodology papers), point them out.
