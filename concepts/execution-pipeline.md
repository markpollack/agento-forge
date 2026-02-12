# The Execution Pipeline (Phases 3-5)

## What It Is

After the Discovery Loop stabilizes, Phases 3 (Roadmap), 4 (Learning Loop), and 5 (Documentation) execute sequentially. Unlike the iterative discovery phases, these follow a clear order — each phase's output is the next phase's input.

```
┌──────────┐   ┌──────────┐   ┌──────────┐
│ Phase 3  │──>│ Phase 4  │──>│ Phase 5  │
│ Roadmap  │   │ Learning │   │   Docs   │
│          │   │   Loop   │   │          │
└──────────┘   └──────────┘   └──────────┘
```

## Why It's Sequential

The Discovery Loop is iterative because you're exploring unknowns. The Execution Pipeline is sequential because you've committed to an approach:

- **Phase 3 requires a stable design** — You can't break something into implementable steps if the design keeps changing.
- **Phase 4 requires a roadmap** — You can't execute without a plan.
- **Phase 5 requires a working implementation** — You can't document what doesn't exist yet.

## Feedback Within the Pipeline

Sequential doesn't mean no feedback. Each phase has internal iteration:

### Phase 3: Roadmap Refinement
The roadmap may get restructured as you break down the design. Steps get reordered, merged, or split. But the design doesn't change — if it needs to, you're back in the Discovery Loop.

### Phase 4: Learning Loop
This is the most iterative phase. Each roadmap step may take multiple attempts. Stage reviews at the end of each roadmap stage create structured feedback. But the roadmap structure holds — you're iterating on implementation quality, not direction.

### Phase 5: Documentation Iteration
Writing docs often reveals unclear APIs or missing features. Minor fixes go directly into the implementation. Major issues mean something was missed in Phase 4 — escalate rather than silently redesigning.

## When to Go Back to Discovery

Sometimes execution reveals a fundamental problem. Signs you need to return to the Discovery Loop:

- A roadmap step is impossible given the design
- Phase 4 reviews consistently fail on design-level issues, not implementation-level issues
- A new technology or constraint appears that changes the approach

This is not a failure — it's the methodology working correctly. The cost of returning to discovery is always less than pushing forward with a broken design.

## The Learnings Thread

The most important artifact threading through the pipeline is **learnings**:

```
Phase 3: "Breaking down the design revealed complexity in component C"
Phase 4: "Step 2.3 required a different approach than designed because..."
Phase 5: "Users need to understand X before they can use Y"
```

Learnings flow forward but also accumulate. Each phase adds to a growing body of project knowledge. This is captured in a tiered structure:

- **Tier 1: Compacted summary** — Read this first for the current state
- **Tier 2: Per-step details** — Detailed learnings from each implementation step
- **Tier 3: Archive** — Historical records and phase reflections

## Anti-Patterns

- **Roadmap without stable design** — Starting Phase 3 while still iterating on design. The roadmap becomes a moving target.
- **Skipping phase reviews** — Moving through Phase 4 without structured evaluation. Technical debt accumulates silently.
- **Documentation as afterthought** — Treating Phase 5 as optional. If it's worth building, it's worth documenting.
- **Heroic implementation** — Trying to implement the entire roadmap in one pass without capturing learnings. You'll repeat mistakes.
- **Refusing to go back** — Pushing forward when evidence says the design is wrong. Sunk cost fallacy.
