# Documentation Taxonomy: Diataxis Framework

## Overview

All documentation serves one of four purposes, organized along two axes. Mixing purposes within a single document confuses readers and weakens the content. The Diataxis framework (Daniele Procida) provides a decision tree for classifying every piece of documentation you write.

**Source**: [diataxis.fr](https://diataxis.fr/) | [GitHub](https://github.com/evildmp/diataxis-framework)

## The Two Axes

1. **Action vs. Cognition** — Does this content serve practical doing or theoretical understanding?
2. **Acquisition vs. Application** — Is the reader learning something new or applying existing knowledge?

## The Four Quadrants

|  | **Acquisition** (learning) | **Application** (working) |
|--|---|---|
| **Action** (practical) | **Tutorial** | **How-to Guide** |
| **Cognition** (theoretical) | **Explanation** | **Reference** |

## The Four Document Types

### Tutorial (Action + Acquisition)

A lesson that takes the reader through a series of steps to learn a skill. The reader does things, and through doing them, acquires capability.

**Key rules**:
- The teacher bears responsibility for the learner's success
- Minimize explanation — the reader learns by doing, not by reading about doing
- Eliminate choices — guide toward one path that works
- Deliver early results — the reader should see something working quickly
- Every step must succeed — broken tutorials destroy confidence

**Language**: "We will...", "First, do X. Now, do Y.", "The output should look like..."

**In Forge**: Getting-started guides, worked examples, first-use walkthroughs. Phase 5 output when onboarding new users.

### How-to Guide (Action + Application)

Directions for solving a specific problem. The reader already knows what they want to achieve and needs the steps to get there.

**Key rules**:
- Address a real-world problem, not an abstract concept
- Focus on action — no digressions, no teaching, no theory
- Assume competence — the reader already understands the basics
- Allow adaptation — real problems have variations; acknowledge them
- Name it precisely — "How to integrate performance monitoring," not "Performance"

**Language**: "This guide shows you how to...", "If you want X, do Y."

**In Forge**: Migration recipes, configuration guides, integration steps. The primary content of knowledge stores consumed by agents.

### Reference (Cognition + Application)

Technical description of the machinery. The reader consults reference material while working — they need facts, not guidance.

**Key rules**:
- Describe, and only describe — no instruction, no opinion, no explanation
- Structure mirrors the machinery, not the user's journey
- Consistency is paramount — same format for every entry
- Austere, authoritative, zero ambiguity
- Provide examples that illustrate usage without becoming tutorials

**Language**: Declarative statements. Third person. Present tense.

**In Forge**: API documentation, configuration option tables, data model descriptions, cheatsheets. Templates (VISION-TEMPLATE, DESIGN-TEMPLATE, etc.) are themselves reference documents.

### Explanation (Cognition + Acquisition)

Discursive treatment of a subject. The reader wants to understand why things work the way they do — context, history, design rationale, alternatives considered.

**Key rules**:
- Take a step back from the machinery — explain the bigger picture
- Make connections to other concepts, even outside the immediate domain
- Provide context — design decisions, historical reasons, constraints
- Embrace perspective — all explanation contains viewpoint; acknowledge it
- Maintain boundaries — resist absorbing procedural or reference content

**Language**: "The reason for this is...", "An alternative approach would be...", "This is related to..."

**In Forge**: Concept documents (`concepts/`), design decision rationale sections, "why" sections in VISION.md. Phase 0 output that explains the problem space.

## The Compass Decision Tree

When writing documentation, ask two questions:

1. **Is this about doing (action) or understanding (cognition)?**
   - If the reader needs to DO something → action side
   - If the reader needs to UNDERSTAND something → cognition side

2. **Is the reader learning (acquisition) or working (application)?**
   - If the reader is encountering this for the first time → acquisition side
   - If the reader already knows the domain and needs specific help → application side

The intersection of these two answers tells you which document type you're writing. If you find yourself writing content that belongs in a different quadrant, move it to a separate document and link to it.

## Mapping to Forge Methodology

### Forge's Existing Documentation

| Forge Artifact | Diataxis Type | Notes |
|----------------|---------------|-------|
| Phase guides (`phases/0N-*.md`) | Explanation | Why each phase exists, what it achieves |
| Concept docs (`concepts/*.md`) | Explanation | Theoretical foundations, design rationale |
| Templates (`templates/*.md`) | Reference | Structured descriptions of artifact formats |
| `guides/getting-started.md` | Tutorial | Step-by-step first use |
| `guides/java-library-quality.md` | How-to | Checklist for a specific task |
| `guides/research-project-structure.md` | Reference | Describes directory layout |
| `examples/` | Tutorial | Learning by examining worked examples |
| `variants/*.md` | Reference + Explanation | Mix — could be separated |

### Phase 5 Output Types

Phase 5 should produce documentation in all four quadrants, but the mix depends on the project variant:

| Variant | Primary Types | Secondary Types |
|---------|--------------|-----------------|
| Software | Reference (API docs) + How-to (integration guides) | Tutorial (getting-started) + Explanation (architecture overview) |
| Agent | How-to (usage patterns) + Reference (configuration) | Tutorial (first agent run) + Explanation (design choices) |
| Research | Explanation (findings, methodology) + Reference (data descriptions) | How-to (reproduction steps) + Tutorial (replication guide) |

## Agent-Consumption Weighting

When documentation is consumed by AI agents via file tools (Explore RAG) rather than by human readers, the four types have different utility:

| Type | Agent Value | Why |
|------|------------|-----|
| **Reference** | **Highest** | Structured, predictable, greppable. Consistent format across entries means the agent can Grep for patterns and parse reliably. Agents excel at lookup |
| **How-to** | **High** | Action-oriented recipes map directly to agent tasks. Step-by-step instructions translate into agent actions. Agents don't need motivation or context — just the steps |
| **Explanation** | **Medium** | Provides context when the agent is stuck or needs to make a judgment call. But costs tokens proportional to discursiveness. Best accessed on-demand, not pre-loaded |
| **Tutorial** | **Low** | Agents don't need pedagogical scaffolding. They don't build confidence, they don't learn by repetition, they don't benefit from "we" language. Tutorial content is almost entirely wasted tokens for agents |

### Implications for Knowledge Base Design

Knowledge bases designed for agent consumption should:

1. **Prioritize Reference + How-to** — These are the primary content types. Cheatsheets, migration recipe tables, API change catalogs, configuration option lists
2. **Include Explanation selectively** — Design rationale and "why" content is valuable when agents need to make decisions, but should be in separate files the agent can choose to read (not mixed into reference docs)
3. **Skip Tutorials entirely** — If the KB is for agent consumption only, tutorials add no value. If the KB serves both humans and agents, tutorials live in a separate directory the agent can ignore
4. **Optimize Reference format for Grep** — Consistent headings, predictable structure, machine-parseable tables. The agent's first retrieval pass is typically `Grep` for a keyword, then `Read` of the matching file

### Directory Layout Recommendation

For a KB serving both human and agent consumers:

```
knowledge-store/
├── index.md                    # Reference: what's in this store, navigation
├── reference/                  # Agent-primary: structured lookup
│   ├── api-changes.md
│   ├── configuration.md
│   └── error-codes.md
├── howto/                      # Agent-primary: action recipes
│   ├── migrate-security.md
│   ├── handle-deprecation.md
│   └── configure-logging.md
├── explanation/                # Agent-secondary: context on demand
│   ├── why-api-changed.md
│   └── design-rationale.md
└── tutorials/                  # Human-only: agent should ignore
    └── getting-started.md
```

The `index.md` at the root is the agent's entry point. It lists what's available and where. The agent reads the index, identifies relevant subtrees, and drills down.

## Attribution

The Diataxis framework was created by Daniele Procida and is documented at [diataxis.fr](https://diataxis.fr/). It has been adopted by hundreds of documentation projects including Gatsby, Cloudflare, and Django. The agent-consumption weighting and Forge integration described here extend the framework for AI agent knowledge bases.
