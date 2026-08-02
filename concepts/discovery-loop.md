# The Two Loops: discovery iterates, execution runs in order

> **The rule**: iterate while you are discovering; commit and go in order once you are not — and when
> execution proves the design wrong, go back to discovery rather than pushing forward.

> **Note on this file**: it absorbed `execution-pipeline.md` on 2026-08-02 (concepts-register distill
> act). The two pages stated two halves of one rule and could not be read apart. The filename is
> retained so existing citations resolve; `execution-pipeline.md` remains as a redirect.

```
        DISCOVERY LOOP (Phases 0-2)              EXECUTION PIPELINE (Phases 3-5)
        Iterate until stable                      Sequential after discovery stabilizes

     ┌──────────┐   ┌──────────┐   ┌──────────┐       ┌──────────┐   ┌──────────┐   ┌──────────┐
     │ Phase 0  │<─>│ Phase 1  │<─>│ Phase 2  │ ───>  │ Phase 3  │──>│ Phase 4  │──>│ Phase 5  │
     │ Vision   │   │ Research │   │ Design   │       │ Roadmap  │   │ Learning │   │   Docs   │
     └──────────┘   └──────────┘   └──────────┘       └──────────┘   │   Loop   │   └──────────┘
                                                                      └──────────┘
     <─> = Iterative refinement                       ──> = Sequential execution
```

---

## Part 1: The Discovery Loop (Phases 0-2)

Phases 0 (Vision), 1 (Research), and 2 (Design) form an iterative loop. Unlike the sequential pipeline that follows, these three phases are not meant to be completed in order — they feed back into each other until they stabilize.

### Why it iterates

Building something new is fundamentally a discovery problem. You start with incomplete understanding and refine it through investigation.

**Typical iteration triggers:**

- **Research invalidates a vision assumption** — "I assumed library X handles this, but it doesn't." The vision's scope or approach needs updating.
- **Design reveals missing knowledge** — "To design this component, I need to know how Y works." Back to research.
- **Research discovers a better approach** — "There's an existing solution that handles 80% of what we need." The vision's scope contracts.
- **Design shows the vision is too broad** — "Implementing all of this would require solving three hard problems. Let's scope to one." The vision narrows.

### When to exit

The Discovery Loop stabilizes when:

1. **Consistency** — Vision, research, and design tell the same story. No contradictions.
2. **No new discoveries** — The last research pass didn't surface anything that changes direction.
3. **Designable** — You can write a technical spec without hand-waving. The design answers "how" for everything the vision says "what."
4. **Committable** — You're confident enough to start a roadmap. Not 100% certain — that's impossible — but confident the fundamental approach is sound.

A [conversational review](conversational-review.md) before exiting is a useful stability check — hand your vision, research, and design to a fresh AI session and ask it to find inconsistencies. A reviewer without your accumulated context will catch gaps you've become blind to.

In practice, expect **2-4 iterations** through the Discovery Loop for a moderately complex project.

### Common patterns

#### The Narrowing Spiral

Most projects start too broad and narrow through iteration:
```
Vision v1: "Build X, Y, and Z"
Research: "X is hard, Y is easy, Z is unknown"
Vision v2: "Build Y first, research Z, defer X"
Design v1: "Here's how Y works"
Research: "Found a way to handle Z simply"
Vision v3: "Build Y and Z, defer X"
Design v2: "Here's how Y and Z work together"
→ Stable. Proceed to roadmap.
```

#### The Pivot

Sometimes research reveals the original vision was wrong:
```
Vision v1: "Build custom solution for problem P"
Research: "Library L solves P but lacks feature F"
Vision v2: "Extend library L with feature F"
Design v1: "Here's the extension architecture"
→ Stable. Fundamentally different project than v1.
```

#### The Depth-First Probe

When unknowns are large, a targeted research spike resolves the biggest risk first:
```
Vision v1: "Build agent that does X"
Research: "Can X even be done with current tools?"
→ Spike: Build minimal prototype of X
Research finding: "Yes, with approach A, not B"
Vision v2: (refined with approach A constraint)
Design v1: (built around approach A)
→ Stable.
```

### Anti-patterns

- **One-pass discovery** — Going Vision → Research → Design exactly once. If nothing changed, you either have a trivial problem or didn't look hard enough.
- **Endless discovery** — Iterating forever because you might learn something new. At some point, commit and learn the rest during implementation.
- **Skipping discovery entirely** — Jumping straight to a roadmap. This is the most common failure mode. You end up with a detailed plan for the wrong thing.
- **Design without research** — Designing based on assumptions. Research exists to replace assumptions with evidence.

---

## The seam: exiting discovery is the highest-leverage review point

The transition from iteration to commitment is where a defect is cheapest to catch and most expensive to
miss. A design gap found here costs a revision; the same gap found in Phase 4 costs the roadmap built on
it. This is why the exit gets its own review instruments — a [conversational
review](conversational-review.md) at minimum, and the [lens stack](review-lenses.md) where a contract or
interface is being frozen.

---

## Part 2: The Execution Pipeline (Phases 3-5)

After the Discovery Loop stabilizes, Phases 3 (Roadmap), 4 (Learning Loop), and 5 (Documentation) execute sequentially. Each phase's output is the next phase's input.

### Why it's sequential

The Discovery Loop is iterative because you're exploring unknowns. The Execution Pipeline is sequential because you've committed to an approach:

- **Phase 3 requires a stable design** — You can't break something into implementable steps if the design keeps changing.
- **Phase 4 requires a roadmap** — You can't execute without a plan.
- **Phase 5 requires a working implementation** — You can't document what doesn't exist yet.

### Feedback within the pipeline

Sequential doesn't mean no feedback. Each phase has internal iteration:

**Phase 3: Roadmap refinement.** The roadmap may get restructured as you break down the design. Steps get reordered, merged, or split. But the design doesn't change — if it needs to, you're back in the Discovery Loop.

**Phase 4: Learning Loop.** This is the most iterative phase. Each roadmap step may take multiple attempts. Stage reviews at the end of each roadmap stage create structured feedback. But the roadmap structure holds — you're iterating on implementation quality, not direction.

**Phase 5: Documentation iteration.** Writing docs often reveals unclear APIs or missing features. Minor fixes go directly into the implementation. Major issues mean something was missed in Phase 4 — escalate rather than silently redesigning.

### When to go back to discovery

Sometimes execution reveals a fundamental problem. Signs you need to return to the Discovery Loop:

- A roadmap step is impossible given the design
- Phase 4 reviews consistently fail on design-level issues, not implementation-level issues
- A new technology or constraint appears that changes the approach

This is not a failure — it's the methodology working correctly. The cost of returning to discovery is always less than pushing forward with a broken design.

### The learnings thread

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

Where each kind of knowledge lives — learnings vs. decisions vs. reference vs. intake — is [project
knowledge layout](project-knowledge-layout.md).

### Anti-patterns

- **Roadmap without stable design** — Starting Phase 3 while still iterating on design. The roadmap becomes a moving target.
- **Skipping phase reviews** — Moving through Phase 4 without structured evaluation. Technical debt accumulates silently.
- **Documentation as afterthought** — Treating Phase 5 as optional. If it's worth building, it's worth documenting.
- **Heroic implementation** — Trying to implement the entire roadmap in one pass without capturing learnings. You'll repeat mistakes.
- **Refusing to go back** — Pushing forward when evidence says the design is wrong. Sunk cost fallacy.
