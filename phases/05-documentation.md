# Phase 5: Documentation

## Purpose

Create user-facing documentation for the completed implementation, organized by the Diataxis framework's four document types. Each type has different rules for content, style, and structure. Mixing types within a single document weakens it — keep them separate and link between them.

See [Documentation Taxonomy](../concepts/documentation-taxonomy.md) for the full framework reference.

## Inputs

- Working implementation from Phase 4
- Learnings documents
- Design documents

## Outputs

- `docs/` directory organized by Diataxis quadrant
- README with quickstart
- Working code examples in every tutorial and how-to guide

## The Four Document Types

### 1. Tutorials (Action + Acquisition)

Lessons that take the reader through steps to learn a skill. The reader does things, and through doing them, acquires capability.

**Rules**:
- The teacher is responsible for the learner's success — if they fail, the tutorial failed
- Minimize explanation — the reader learns by doing, not by reading theory
- Eliminate choices — guide toward one path that works
- Deliver early results — something visible should work within the first few steps
- Every step must succeed — test the tutorial end-to-end before publishing

**Language**: "We will...", "First, do X. Now, do Y.", "The output should look like..."

**Example**: Getting-started guide, "Build your first agent" walkthrough.

**Minimum**: At least one tutorial for the primary use case.

### 2. How-to Guides (Action + Application)

Directions for solving a specific problem. The reader already knows the basics and needs steps to achieve a goal.

**Rules**:
- Address a real-world problem the reader actually faces
- Focus on action — no digressions, no teaching, no theory
- Assume competence — don't re-explain basics
- Allow adaptation — acknowledge that real problems have variations
- Name it precisely — "How to configure custom judges" not "Judges"

**Language**: "This guide shows you how to...", "If you want X, do Y."

**Example**: "How to add a custom judge", "How to run experiments against a new codebase".

### 3. Reference (Cognition + Application)

Technical descriptions of the machinery. The reader consults reference material while working — they need facts, not guidance.

**Rules**:
- Describe, and only describe — no instruction, no opinion
- Structure mirrors the code, not the user's journey (organize by package/class, not by use case)
- Consistency is paramount — same format for every entry
- Austere, authoritative, zero ambiguity
- Provide examples that illustrate usage without becoming tutorials

**Language**: Declarative. Third person. Present tense.

**Example**: API reference for public interfaces, configuration option tables, error code catalog.

**Minimum**: Every public API must have reference documentation.

### 4. Explanation (Cognition + Acquisition)

Discursive treatment of a subject. The reader wants to understand why things work the way they do.

**Rules**:
- Step back from the machinery — explain the bigger picture
- Make connections to related concepts
- Provide context — design decisions, historical reasons, constraints, alternatives considered
- Embrace perspective — explain trade-offs, not just choices
- Maintain boundaries — resist absorbing procedural or reference content

**Language**: "The reason for this is...", "An alternative approach would be...", "This design choice reflects..."

**Example**: Architecture overview, "Why we chose X over Y", design rationale documents.

## The Decision Tree

When writing documentation, ask two questions:

1. **Is this about doing (action) or understanding (cognition)?**
2. **Is the reader learning (acquisition) or working (application)?**

| | Learning (new to this) | Working (already knows basics) |
|--|---|---|
| **Doing** (practical steps) | **Tutorial** | **How-to Guide** |
| **Understanding** (theory/context) | **Explanation** | **Reference** |

If you find yourself mixing types — explaining why in the middle of a how-to, or teaching basics in a reference page — split the content into separate documents and link between them.

## Key Activities

1. **Classify existing content** — Learnings, design docs, and README content from earlier phases likely contain all four types mixed together. Separate them.
2. **Write tutorials** — Step-by-step lessons that walk through primary use cases. Every code example must work. Explain the "why" and "what's happening" before code — every code block should be preceded by context: what the code does, why it does it, and what the reader should expect. Name specific tools and explain their role (e.g., "This launches Gemini CLI as an ACP agent subprocess" not just `AgentParameters.builder("gemini")`).
3. **Write how-to guides** — Recipes for specific problems users face. Common pitfalls from Phase 4 learnings become how-to guides or warnings.
4. **Document the API surface** — Public interfaces, configuration options, error handling. Structure by code organization. Be precise about contracts.
5. **Write explanations** — Architecture overview, design rationale, trade-offs. Draw from DESIGN.md and decision records.
6. **Verify all code examples** — Run every example. Broken examples are worse than no examples.

## Suggested Directory Layout

```
docs/
├── tutorials/
│   ├── getting-started.md
│   └── first-{domain}.md
├── howto/
│   ├── configure-{feature}.md
│   └── integrate-{tool}.md
├── reference/
│   ├── api/
│   ├── configuration.md
│   └── error-codes.md
└── explanation/
    ├── architecture.md
    └── design-decisions.md
```

The mix varies by project variant:

| Variant | Primary Types | Secondary Types |
|---------|--------------|-----------------|
| Software | Reference + How-to | Tutorial + Explanation |
| Agent | How-to + Reference | Tutorial + Explanation |
| Research | Explanation + Reference | How-to + Tutorial |

## Exit Criteria

- Every public API has reference documentation
- At least one tutorial for the primary use case
- Getting-started guide takes a new user from zero to working
- All code examples tested and working
- No references to internal implementation details that users don't need
- Each document serves one Diataxis type — no mixing of tutorial, how-to, reference, and explanation within a single page

## Relationship to Other Phases

- **Consumes Phase 4** — documents the working implementation
- Final phase of the [Execution Pipeline](../concepts/execution-pipeline.md)
- **Benefits from learnings** — common pitfalls discovered in Phase 4 become how-to guides or warning boxes in tutorials
- **Benefits from design** — DESIGN.md decision records feed directly into explanation documents

## Anti-Patterns

- **Mixing document types** — A reference page that starts teaching, or a tutorial that devolves into API reference. Keep them separate and link between them.
- **Documenting internals** — Users don't need to know how it works internally unless they're extending it.
- **Untested examples** — Code examples that don't compile or run. Always verify.
- **Implementation-order documentation** — Organizing docs by how you built it rather than how users need it. This is the Reference anti-pattern (structure should mirror the machinery's organization, not the development timeline).
- **Missing error documentation** — What errors can occur and what do they mean? Users hit errors; help them. This belongs in Reference.
- **No quickstart** — Forcing users to read everything before they can try anything. The Tutorial quadrant exists specifically to address this.
- **Bare code without context** — Showing code without explaining what it does or why. Every example needs a sentence or two above it that orients the reader: what is being demonstrated, what the moving parts are, and what the expected outcome is. Code comments alone are not sufficient — the surrounding prose must carry the explanation.
