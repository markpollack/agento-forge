# Reference Harvest Guide

> How to use an LLM as a scout to produce structured, scrape-ready reference catalogs for bootstrapping a knowledge base.

## When to Use

- Bootstrapping a new KB domain (e.g., "Spring Security testing")
- Expanding an existing KB into an adjacent topic
- Preparing raw material for the [Curator Intake Protocol](curator-intake.md)
- Future: automated starter KB bootstrapping in Loopy's `/forge-agent`

## The Pattern

Use a conversational LLM (ChatGPT, Claude, etc.) in **normal mode** (not deep research) to scout high-value sources. The LLM knows what's out there — official docs, domain experts, repos, talks — and can organize it for scraping.

### Why Normal Mode, Not Deep Research

Deep research produces synthesized prose. You want **raw references with URLs** — a catalog, not an essay. Normal mode with the right prompt produces exactly this: tiered source lists with scrape-ready URLs.

## Prompt Template

```
You are a reference harvester for building a curated knowledge base.

Domain: {domain}
Focus: {specific_topic_or_task}

Produce a reference harvest with tiered sources:

1. A-tier official docs — canonical reference pages. Put all URLs in ```text``` code blocks for easy scraping.
2. A-tier domain experts — specific people, their affiliations, and search queries to find their work.
3. A-tier GitHub repos — source repositories with in-repo search terms to find relevant code/tests.
4. A-tier conference talks — with YouTube or video links where available.
5. B-tier community — reliable tutorial sites (e.g., Baeldung, Reflectoring) with direct URLs.
6. Consensus vs debate — where practitioners disagree on approach. Name the camps.
7. Specific patterns to extract later — concrete things to pull during synthesis.
8. High-value scrape targets — ready-made search queries for GitHub, YouTube, Google.

Keep descriptions to one sentence per source ("why this matters").
```

### Sprint Structure

For broad domains, break into sprints (one prompt per sub-topic):

```
Sprint 1 = {sub-topic-1} ({specific_framework_or_tool})
Sprint 2 = {sub-topic-2} ({specific_framework_or_tool})
...
Final pass = Cross-domain canonical patterns + anti-patterns
```

The final pass ("pattern-mining mode") extracts concrete code snippets: canonical patterns vs anti-patterns across all sprints.

## Output Structure

Each sprint produces a file with consistent sections:

| Section | What it contains | Scrape priority |
|---------|-----------------|-----------------|
| A-tier official docs | Canonical reference pages with URLs in code blocks | Always scrape |
| A-tier domain experts | People + search queries | Use for targeted search |
| A-tier GitHub repos | Source repos + in-repo search terms | Scrape selectively |
| A-tier conference talks | YouTube/video links | Scrape transcripts if available |
| B-tier community | Tutorial URLs (Baeldung, Reflectoring, etc.) | Scrape if A-tier gaps exist |
| Consensus vs debate | Where practitioners disagree | Don't scrape — this IS the synthesis |
| Patterns to extract | Concrete items for later synthesis | Don't scrape — this is a checklist |
| Scrape targets | Search queries for GitHub, YouTube, Google | Feed to search tools |

## Automation Path (Loopy `/forge-agent`)

The manual workflow that produced this pattern:

1. **Scout** — Ask ChatGPT (normal mode) with the prompt template above
2. **Save** — Drop output files into `plans/inbox/{topic}/`
3. **Scrape** — Use Firecrawl (or WebFetch/Puppeteer) to pull A-tier URLs as clean markdown
4. **Intake** — Run the [Curator Intake Protocol](curator-intake.md) to synthesize into KB files

The automated version in Loopy's `/forge-agent` starter KB bootstrapping:

1. LLM generates reference harvest from the brief's domain description (the scouting step)
2. **Firecrawl** crawls A-tier URLs → clean markdown
3. Curator intake synthesizes into starter KB files
4. Files wired into `knowledge/` with a routing index

Result: experiments runnable out of the box — users curate from a starting point, not a blank page.

## Proven Example

A Spring Testing KB was bootstrapped using this exact pattern:

- **5 sprints**: mvc.md, jpa.md, security.md, webflux.md, patterns.md (cross-domain)
- **ChatGPT mode**: Normal (not deep research), "Mode C" = A-tier + B-tier
- **Consistent A-tier sources found**: Spring official docs, Spring GitHub repos, domain experts (Sam Brannen, Oliver Drotbohm, Mark Paluch, Rob Winch, Rossen Stoyanchev)
- **Consistent B-tier sources found**: Reflectoring, Baeldung, Rieckpil
- **Ingested via**: Curator Intake Protocol → classified KB entries

## Related

- [Curator Intake Protocol](curator-intake.md) — batch-processing inbox into KB entries
- [Knowledge Base Architecture](../concepts/knowledge-base-architecture.md) — KB structure the harvested material feeds into
- Loopy CLAUDE.md → "Starter KB Bootstrapping" section — the product feature this enables
