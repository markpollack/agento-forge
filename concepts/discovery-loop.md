# The Discovery Loop (Phases 0-2)

## What It Is

Phases 0 (Vision), 1 (Research), and 2 (Design) form an iterative loop. Unlike the sequential Execution Pipeline that follows, these three phases are not meant to be completed in order — they feed back into each other until they stabilize.

```
   ┌─────────────────────────────────────────────┐
   │                                             │
   │  ┌──────────┐   ┌──────────┐   ┌──────────┐ │
   └─>│ Phase 0  │<─>│ Phase 1  │<─>│ Phase 2  │─┘
      │ Vision   │   │ Research │   │ Design   │
      └──────────┘   └──────────┘   └──────────┘
```

## Why It Iterates

Building something new is fundamentally a discovery problem. You start with incomplete understanding and refine it through investigation.

**Typical iteration triggers:**

- **Research invalidates a vision assumption** — "I assumed library X handles this, but it doesn't." The vision's scope or approach needs updating.
- **Design reveals missing knowledge** — "To design this component, I need to know how Y works." Back to research.
- **Research discovers a better approach** — "There's an existing solution that handles 80% of what we need." The vision's scope contracts.
- **Design shows the vision is too broad** — "Implementing all of this would require solving three hard problems. Let's scope to one." The vision narrows.

## When to Exit

The Discovery Loop stabilizes when:

1. **Consistency** — Vision, research, and design tell the same story. No contradictions.
2. **No new discoveries** — The last research pass didn't surface anything that changes direction.
3. **Designable** — You can write a technical spec without hand-waving. The design answers "how" for everything the vision says "what."
4. **Committable** — You're confident enough to start a roadmap. Not 100% certain — that's impossible — but confident the fundamental approach is sound.

A [conversational review](conversational-review.md) before exiting is a useful stability check — upload your vision, research, and design to a fresh AI session and ask it to find inconsistencies. A reviewer without your accumulated context will catch gaps you've become blind to.

In practice, expect **2-4 iterations** through the Discovery Loop for a moderately complex project.

## Common Patterns

### The Narrowing Spiral

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

### The Pivot

Sometimes research reveals the original vision was wrong:
```
Vision v1: "Build custom solution for problem P"
Research: "Library L solves P but lacks feature F"
Vision v2: "Extend library L with feature F"
Design v1: "Here's the extension architecture"
→ Stable. Fundamentally different project than v1.
```

### The Depth-First Probe

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

## Anti-Patterns

- **One-pass discovery** — Going Vision → Research → Design exactly once. If nothing changed, you either have a trivial problem or didn't look hard enough.
- **Endless discovery** — Iterating forever because you might learn something new. At some point, commit and learn the rest during implementation.
- **Skipping discovery entirely** — Jumping straight to a roadmap. This is the most common failure mode. You end up with a detailed plan for the wrong thing.
- **Design without research** — Designing based on assumptions. Research exists to replace assumptions with evidence.
