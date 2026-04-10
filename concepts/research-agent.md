# Research Agent

The Research Agent automates Phase 1 (Research) of the Forge methodology. It replaces manual literature search and note-taking with a tiered system: automated discovery via deep research APIs, structured corpus management via DuckDB, and deep reasoning via hierarchical agentic RAG.

## The Problem

Phase 1 research has three manual bottlenecks:

1. **Discovery** — Finding relevant papers, repos, and prior art. Currently done via ChatGPT Deep Research or manual Google Scholar searches.
2. **Comprehension** — Reading papers, extracting key findings, understanding methodology. Currently done by reading PDFs and taking notes.
3. **Synthesis** — Connecting ideas across papers, identifying patterns, answering vision unknowns. Currently done in conversation sessions that get saved but not systematically indexed.

Traditional RAG (chunk + embed + retrieve top-k) partially addresses comprehension but destroys cross-document reasoning through chunking. Deep research APIs address discovery but return summaries, not deep understanding.

## The Solution: Hierarchical Agentic RAG

Instead of chunking documents and embedding fragments, build a **hierarchy of LLM-generated summaries cached on disk** and let an agent navigate the hierarchy, drilling into full text only when needed.

```
Level 3: Corpus overview          (~2 pages, fits in one message)
    |
Level 2: Topic cluster summaries  (~10-20 clusters, ~1 page each)
    |
Level 1: Per-paper summaries      (~500 words each, cached on disk)
    |
Level 0: Raw papers               (full PDFs/text on disk)

DuckDB: citation graph + metadata + topic assignments + search API results
```

### How the Agent Navigates

1. Reads **Level 3** (corpus overview) — understands the landscape
2. Queries **DuckDB** — "which papers cite X?", "papers about topic Y after 2023?"
3. Reads **Level 2** (relevant cluster summaries) — understands themes
4. Reads **Level 1** (specific paper summaries) — identifies the papers that matter
5. Reads **Level 0** (full text) — deep comprehension of 2-5 key papers

Total cost per research question: equivalent to reading ~5-10 full papers, but with awareness of the entire corpus (hundreds of papers).

### Why This Works Better Than Traditional RAG

| | Traditional RAG | Hierarchical Agentic RAG |
|---|---|---|
| **Chunking** | Destroys context at document boundaries | No chunking — summaries preserve meaning |
| **Retrieval** | Top-k fragments, arbitrary cutoff | Agent decides what to read, follows chains |
| **Cross-document reasoning** | Poor — sees fragments from different papers | Excellent — citation graph + cluster summaries |
| **"Which papers disagree?"** | Can't express this query | Agent reads both sides, compares |
| **Vocabulary normalization** | Depends on embedding similarity | LLM-generated summaries already normalize vocabulary |
| **Incremental updates** | Re-embed new chunks | Summarize new paper, update cluster, update overview |

### Why Not Embeddings?

Embeddings are still useful for one thing: **fuzzy semantic discovery** when exact keywords fail. But LLM-generated summaries mostly solve this — the LLM normalizes vocabulary when writing summaries. For the rare case where keyword search on summaries fails, a single embedding per paper (of the summary, not the full text) provides semantic fallback with a 500-row vector search, not a 50,000-chunk one.

## Three-Tier Discovery Pipeline

The Research Agent composes three tiers, each good at what the others can't do:

### Tier 1: Deep Research APIs (Discovery)

Automated literature discovery. Returns cited reports. $2-5 per question.

| API | Model | Cost | Output |
|---|---|---|---|
| **Google Gemini Deep Research** | Gemini 3 Pro via Interactions API | ~$2-5/task | Cited research reports |
| **OpenAI Deep Research** | o3-deep-research via Responses API | Standard token rates | Structured reports + source metadata |
| **Perplexity Sonar Pro** | Sonar via API | $5/1K searches + tokens | Markdown with citations |

```python
# Google Gemini Deep Research
interaction = client.interactions.create(
    input="What approaches exist for automated issue classification in software engineering?",
    agent='deep-research-pro-preview-12-2025',
    background=True
)

# OpenAI Deep Research
response = client.responses.create(
    model="o3-deep-research-2025-06-26",
    input="Survey LLM-based approaches to software issue triage",
    background=True
)
```

### Tier 2: Targeted Search APIs (Specific Queries)

Cheaper, faster, for targeted lookups. No synthesis, just results.

| API | Cost | Best For |
|---|---|---|
| **Tavily** | Free 1K/mo, $0.01/search | LLM grounding, quick lookups |
| **Exa** | $5/1K operations | Semantic "find similar" discovery |
| **Brave Search** | Free 2K/mo, $3/1K | High-volume, privacy-focused |
| **Semantic Scholar** | Free with key | Academic paper metadata + citations |

### Tier 3: Hierarchical Corpus Engine (Deep Reasoning)

Papers collected from Tiers 1-2 get indexed into the local corpus for deep agentic reasoning. This is the corpus engine component.

```
Tier 1 discovers papers → download PDFs → Tier 3 indexes and summarizes →
Research Agent reasons deeply over full text with corpus-wide awareness
```

## DuckDB Schema

The corpus metadata lives in a single DuckDB file. Zero infrastructure — embedded, single file, SQL query language that agents already understand.

```sql
-- Core paper metadata
CREATE TABLE papers (
    id VARCHAR PRIMARY KEY,           -- content hash or DOI-based
    file_path VARCHAR NOT NULL,       -- path to raw file on disk
    title VARCHAR NOT NULL,
    authors VARCHAR[],
    year INTEGER,
    venue VARCHAR,
    doi VARCHAR,
    abstract TEXT,
    summary TEXT,                     -- LLM-generated, ~500 words
    key_findings TEXT,                -- LLM-extracted bullet points
    methodology VARCHAR,             -- LLM-extracted approach category
    limitations TEXT,                 -- LLM-extracted limitations
    cluster_id INTEGER REFERENCES clusters(id),
    page_count INTEGER,
    word_count INTEGER,
    source VARCHAR,                  -- 'manual', 'deep_research', 'semantic_scholar'
    source_query TEXT,               -- the query that found this paper
    indexed_at TIMESTAMP DEFAULT current_timestamp,
    summary_model VARCHAR,           -- which LLM generated the summary
    summary_version INTEGER DEFAULT 1
);

-- Citation graph (within and beyond corpus)
CREATE TABLE citations (
    citing_paper_id VARCHAR REFERENCES papers(id),
    cited_paper_id VARCHAR,          -- NULL if cited paper not in corpus
    cited_title VARCHAR NOT NULL,    -- always populated
    cited_doi VARCHAR,
    cited_authors VARCHAR[],
    cited_year INTEGER,
    context TEXT,                    -- the sentence containing the citation
    section VARCHAR,                 -- which section of the citing paper
    PRIMARY KEY (citing_paper_id, cited_title)
);

-- Topic clusters (LLM-generated groupings)
CREATE TABLE clusters (
    id INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,           -- e.g., 'prompt optimization', 'issue classification'
    description TEXT,
    summary TEXT,                    -- LLM-generated from member paper summaries
    paper_count INTEGER,
    created_at TIMESTAMP DEFAULT current_timestamp,
    summary_version INTEGER DEFAULT 1
);

-- Research questions and their resolution status
CREATE TABLE research_questions (
    id VARCHAR PRIMARY KEY,
    question TEXT NOT NULL,
    source VARCHAR,                  -- 'vision.md', 'emerged_during_research'
    status VARCHAR DEFAULT 'open',   -- 'open', 'answered', 'unanswerable'
    answer TEXT,
    supporting_paper_ids VARCHAR[],  -- papers that helped answer
    created_at TIMESTAMP DEFAULT current_timestamp,
    resolved_at TIMESTAMP
);

-- Deep research API results (cached)
CREATE TABLE discovery_runs (
    id VARCHAR PRIMARY KEY,
    api VARCHAR NOT NULL,            -- 'gemini', 'openai', 'perplexity'
    query TEXT NOT NULL,
    result_markdown TEXT,            -- raw API response
    papers_found INTEGER,
    cost_usd DOUBLE,
    run_at TIMESTAMP DEFAULT current_timestamp
);

-- Useful analytical views
CREATE VIEW citation_counts AS
SELECT cited_title, cited_doi, cited_year, COUNT(*) as times_cited
FROM citations
GROUP BY cited_title, cited_doi, cited_year
ORDER BY times_cited DESC;

CREATE VIEW bibliographic_coupling AS
SELECT
    a.citing_paper_id AS paper_a,
    b.citing_paper_id AS paper_b,
    COUNT(*) AS shared_citations
FROM citations a
JOIN citations b ON a.cited_title = b.cited_title
    AND a.citing_paper_id < b.citing_paper_id
GROUP BY a.citing_paper_id, b.citing_paper_id
HAVING shared_citations >= 2
ORDER BY shared_citations DESC;

CREATE VIEW cluster_overview AS
SELECT c.name, c.paper_count, c.description,
    STRING_AGG(p.title, '; ' ORDER BY p.year DESC) AS recent_papers
FROM clusters c
JOIN papers p ON p.cluster_id = c.id
GROUP BY c.id, c.name, c.paper_count, c.description;
```

### Example Agent Queries

```sql
-- "What papers cite Smith 2023?"
SELECT p.title, p.year, c.context
FROM citations c JOIN papers p ON c.citing_paper_id = p.id
WHERE c.cited_title LIKE '%Smith%' AND c.cited_year = 2023;

-- "Which papers in the 'issue classification' cluster were published after 2024?"
SELECT p.title, p.year, p.summary
FROM papers p JOIN clusters cl ON p.cluster_id = cl.id
WHERE cl.name = 'issue classification' AND p.year > 2024;

-- "Which papers share the most references with paper X?" (bibliographic coupling)
SELECT paper_b, shared_citations
FROM bibliographic_coupling WHERE paper_a = 'paper-x-id'
ORDER BY shared_citations DESC LIMIT 10;

-- "What research questions are still open?"
SELECT question, source FROM research_questions WHERE status = 'open';
```

## Agent Tool Set

The Research Agent has five tools — no chunking, no embeddings, no top-k cutoff:

```
1. query_corpus(sql)        → runs SQL against DuckDB, returns results
2. read_summary(paper_id)   → returns cached Level 1 summary from disk
3. read_cluster(cluster_id) → returns Level 2 cluster summary
4. read_full_text(paper_id) → reads actual file from disk
5. read_overview()          → returns Level 3 corpus overview
```

The agent decides its own navigation path. For discovery (adding new papers), additional tools invoke the Tier 1/2 APIs:

```
6. deep_research(query)     → calls Gemini/OpenAI Deep Research API
7. search_papers(query)     → calls Semantic Scholar / Exa / Tavily
8. download_paper(doi_or_url) → fetches PDF, extracts text, triggers indexing
```

## Build Pipeline

### Per-Paper Indexing (Triggered on Add)

```
1. PDF/text dropped into papers/ directory (or downloaded via tool)
2. Text extraction (pymupdf or docling)
3. LLM generates: summary, key_findings, methodology, limitations, extracted_citations
4. Insert into DuckDB (papers + citations tables)
5. Cost: ~$0.03-0.06 per paper
```

### Periodic Corpus Maintenance

```
1. Re-cluster papers by topic (LLM reads all summaries, assigns clusters)
2. Generate cluster summaries (LLM reads member summaries per cluster)
3. Generate corpus overview (LLM reads all cluster summaries)
4. Cost: ~$0.50-1.00 for 500 papers
5. Frequency: after adding 10+ papers, or on demand
```

### Cost Model

| Operation | Cost (500 papers) |
|---|---|
| Initial indexing (summarize all) | $15-30 (one-time) |
| Corpus maintenance (re-cluster) | $0.50-1.00 |
| Per research question (agent session) | $0.50-2.00 |
| Deep Research API call (Tier 1) | $2-5 per question |
| Adding a new paper | $0.03-0.06 |

Compare to traditional RAG embedding cost: ~$5 for 500 papers. The hierarchical approach costs more upfront ($15-30) but provides dramatically better reasoning quality.

## Integration with Forge Methodology

### Phase 1 (Research) Workflow

1. **Vision unknowns** become entries in `research_questions` table
2. For each open question:
   a. Agent checks corpus — has this already been answered?
   b. If not: Tier 1 deep research API call for discovery
   c. Download relevant papers, index into corpus
   d. Agent navigates hierarchy to synthesize an answer
3. Write findings to `plans/learnings/research-question-{id}.md` with citations
4. Update `research_questions` table with answer + supporting papers
5. Feed new questions discovered during research back to the table

### Relationship to Existing Concepts

- Extends the [Research Loop](research-loop.md) with automated tooling
- Provides the evidence base for [Conversational Review](conversational-review.md)
- Supports [Prerequisite Designs](prerequisite-designs.md) by discovering prior art
- Captures findings for [Conversation Bootstrapping](conversation-bootstrapping.md)

### Relationship to Paper-QA

Paper-QA (Future House) uses a two-stage pipeline: Tantivy full-text search to find documents, then embedding-based chunk retrieval for evidence. The Research Agent replaces both stages:

- **Tantivy's role** (document discovery) is replaced by DuckDB SQL queries over metadata + LLM-generated summaries
- **Embedding retrieval's role** (chunk finding) is replaced by agent-directed full-text reading after navigating the summary hierarchy

Paper-QA's automatic citation tracking is a feature worth adopting — the Research Agent should track which papers and page numbers support each finding.

## Open Design Questions

1. **Summary invalidation** — When should summaries be regenerated? When the summarization model improves? When the research question changes and needs different emphasis?
2. **Cluster stability** — Re-clustering after adding papers may reassign existing papers to different clusters, invalidating cluster summaries. Should clusters be append-only with manual splits?
3. **Cross-corpus search** — Each Forge project has its own corpus. Cross-corpus queries are handled by a federation index (`KB-FEDERATION.md`) that routes agents to the right KB. See [Knowledge Base Architecture](knowledge-base-architecture.md) for the federation pattern.
4. **Embedding fallback** — Is one embedding vector per paper (of the summary) worth maintaining for semantic fuzzy search, or does keyword search on LLM summaries suffice?
5. **Implementation language** — Python (DuckDB + LLM APIs + PDF extraction all have Python-first libraries) or Java (consistency with your existing stack)?
