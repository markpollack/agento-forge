# Phase 1: Research

## Purpose

Deep investigation of the problem space. Collect reference implementations, papers, documentation, and domain knowledge needed to make informed design decisions.

## Inputs

- VISION.md with identified unknowns and research questions
- Existing domain knowledge

## Outputs

- Research corpus (cloned repos, downloaded docs, notes)
- Answers to vision's research questions
- New questions or revised assumptions for the vision

## Key Activities

1. **Search broadly first** — Survey the landscape. What exists? What approaches have been tried? What failed and why?
2. **Clone reference implementations** — Don't just read about solutions — get the code. Analyze how they work, what tradeoffs they made, what their test suites cover.
3. **Extract patterns** — What patterns appear across multiple implementations? These are likely fundamental to the domain.
4. **Document findings** — Write up what you learned, not just what you found. "Library X uses approach Y because Z" is more useful than a link.
5. **Save research conversations** — Deep research sessions with AI tools (ChatGPT deep research, Claude.ai exploration) produce findings worth preserving. Save these conversations and cite them as sources. See [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md).
6. **Update the vision** — Research always reveals things you didn't expect. Feed discoveries back into Phase 0.

## Exit Criteria

- All research questions from VISION.md have answers (or are explicitly marked as unanswerable with current information)
- At least one reference implementation analyzed in depth
- Findings documented in a format the Design phase can consume
- No remaining questions that would change the fundamental approach

## Relationship to Other Phases

- **Driven by Phase 0** — research questions come from the vision's unknowns
- **Feeds Phase 2** — research findings become design inputs
- **Updates Phase 0** — discoveries that invalidate vision assumptions trigger vision revision
- Part of the [Discovery Loop](../concepts/discovery-loop.md)

## Anti-Patterns

- **Shallow research** — Reading blog posts instead of analyzing source code. Blog posts describe intent; source code reveals reality.
- **Infinite research** — Research can always go deeper. Exit when you have enough to make design decisions, not when you know everything.
- **Research without documentation** — If you didn't write it down, you didn't learn it. Undocumented research gets redone.
- **Ignoring negative results** — "This approach doesn't work because X" is as valuable as "this approach works." Document failures.
- **Confirmation bias** — Only researching approaches that confirm your initial intuition. Deliberately investigate alternatives.

## Prerequisite Designs

Research sometimes reveals that the main project depends on tooling or data artifacts that don't exist yet — a fixture extractor, a commit mining script, a data ingestion pipeline. These prerequisites need their own lightweight design pass before the main DESIGN.md can be written. See [Prerequisite Designs](../concepts/prerequisite-designs.md) for when and how to handle this.
