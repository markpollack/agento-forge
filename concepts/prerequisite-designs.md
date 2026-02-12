# Prerequisite Designs

## What They Are

Sometimes research reveals that the main project depends on tooling or data artifacts that don't exist yet. These prerequisites need their own design pass — but they aren't the project itself. They're enablers.

Examples:
- A **fixture extractor** that mines test cases from an existing codebase to build a validation corpus
- A **commit mining script** that extracts before/after snapshots from a repository's history
- A **data ingestion pipeline** that parses structured documents into a knowledge base format
- A **code generation tool** that scaffolds boilerplate from a schema

These emerge during Phase 1 (Research) when you realize "I can't design the main system until I have this data/tool, and building that data/tool requires its own design decisions."

## Why They Need Design

A prerequisite tool is small, but it still involves:
- **Input/output decisions** — What format does the output take? What's the schema?
- **Approach decisions** — Parse the AST or use regex? Walk git history or diff snapshots?
- **Scope decisions** — Extract everything or just the high-value subset?

Without a written design, these decisions get made ad-hoc during implementation, often inconsistently. The output format of a prerequisite tool becomes an input contract for the main project — it deserves the same rigor as any other interface.

## Where They Live

Prerequisite designs live under the project's research directory, not alongside the main DESIGN.md:

```
plans/
├── VISION.md
├── RESEARCH.md
├── DESIGN.md                          # Main project design
└── research/
    └── designs/                       # Prerequisite designs
        ├── fixture-extractor.md
        └── commit-mining.md
```

This placement signals:
- They emerged from research (not from the main design)
- They feed into the main design (the main DESIGN.md references their outputs)
- They are scoped to a tool or pipeline, not the project architecture

## When Prerequisites Need Their Own Roadmap

Normally, prerequisite implementation is folded into Stage 1 of the main project's ROADMAP.md. But sometimes a prerequisite must be built *before* the main design exists — the prerequisite's output is needed to inform the main design, not just to implement it. In this case, the prerequisite needs its own roadmap.

The roadmap lives alongside its design:

```
plans/
├── VISION.md
├── RESEARCH.md
├── DESIGN.md                          # Main project design (future)
├── ROADMAP.md                         # Main project roadmap (future)
└── research/
    └── designs/
        ├── fixture-extractor.md           # Prerequisite design
        └── fixture-extractor-roadmap.md   # Its own roadmap
```

When the main ROADMAP.md is created later, it can reference the prerequisite roadmap as completed prior work rather than duplicating it.

**Use a separate prerequisite roadmap when**:
- The main DESIGN.md doesn't exist yet and depends on the prerequisite's output
- The prerequisite is complex enough to have multiple stages (not just a single script)
- The prerequisite has its own scaffolding, testing, and quality concerns

**Fold into the main roadmap when**:
- The main DESIGN.md and ROADMAP.md already exist
- The prerequisite is simple enough to be one or two steps in Stage 1

The prerequisite roadmap follows the same structure as the main [ROADMAP-TEMPLATE.md](../templates/ROADMAP-TEMPLATE.md), but references the prerequisite design instead of DESIGN.md, and is typically smaller (one or two stages).

## Relationship to the Discovery Loop

Prerequisite designs are a natural part of the [Discovery Loop](discovery-loop.md). They represent a common iteration pattern:

```
Research: "We need corpus X to design the main system"
    → Prerequisite design: "Here's how to build corpus X"
    → Prerequisite implementation: Build the tool, produce the corpus
    → Back to main design: "Now that we have corpus X, here's the architecture"
```

This is the **Depth-First Probe** pattern applied to data/tooling prerequisites rather than feasibility questions. The prerequisite must stabilize before the main design can proceed.

## Lightweight Design Template

Prerequisite designs use a subset of the full [DESIGN-TEMPLATE.md](../templates/DESIGN-TEMPLATE.md). See [PREREQUISITE-DESIGN-TEMPLATE.md](../templates/PREREQUISITE-DESIGN-TEMPLATE.md) for the template.

The key sections are:
- **Overview** — One paragraph, what it does and why it's needed
- **Inputs / Outputs** — What goes in, what comes out, with formats and schemas
- **Design Decisions** — Key choices with rationale and alternatives considered
- **Data Model** — The output schema (this becomes an input contract for the main project)
- **Testing Strategy** — How you verify the tool works correctly
- **Open Questions** — Unresolved issues that don't block implementation

Sections from the full template that are typically **not needed**:
- Build coordinates (these are usually scripts or single-module tools)
- Module structure (single module)
- Evaluation architecture (not an agent)
- Error handling strategy (usually straightforward)

## When to Use a Prerequisite Design vs. Just Building It

Use a prerequisite design when:
- The output format matters (it becomes an input to the main project)
- There are genuine design choices (multiple valid approaches)
- Someone else might need to understand or modify the tool later
- The tool will process a non-trivial amount of data

Skip the design and just build it when:
- It's a one-off script with obvious implementation
- The output is consumed once and discarded
- There are no meaningful design choices to make

## Anti-Patterns

- **Promoting to main design** — Putting prerequisite tool designs in the project's DESIGN.md. This clutters the main architecture document with tooling concerns.
- **Skipping the design** — Building the tool ad-hoc and then discovering the output format doesn't work for the main project. The output schema is the most important thing to design upfront.
- **Over-designing prerequisites** — Applying the full DESIGN-TEMPLATE.md to a script. Keep it proportional to the tool's complexity.
- **Treating prerequisites as the project** — The prerequisite exists to enable the main project. Don't let prerequisite tooling expand in scope or become a project of its own.
