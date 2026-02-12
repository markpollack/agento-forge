# Getting Started with Forge

This guide walks through applying the Forge methodology to a real problem. By the end, you'll have a structured project with vision, research, design, and a roadmap ready for implementation.

## Prerequisites

- A problem you want to solve (or a project you want to build)
- A directory for your project
- Familiarity with markdown

## Step 0.5: Choose Your Variant

Before diving in, identify which Forge variant fits your project:

| Variant | Use when... | Guide |
|---------|-------------|-------|
| **Agent** | Building an AI agent with automated evaluation | [variants/agent.md](../variants/agent.md) |
| **Software** | Building conventional software | [variants/project.md](../variants/project.md) |
| **Research** | Conducting research (papers, studies) | [variants/research.md](../variants/research.md) |

Not sure? See [variants/README.md](../variants/README.md) for a detailed comparison.

The steps below assume the **software** or **agent** variant. For **research projects**, follow the [research variant guide](../variants/research.md) instead — it uses different templates and a different feedback loop (Vision↔Research iteration rather than QA review).

## Step 0: Gather Your Conversations

If you've been exploring this problem in ChatGPT, Claude.ai, or other AI tools, export those conversations now. They're your raw material for the vision and research phases.

Create a conversations directory and save them there:

```
plans/
└── research/
    └── conversations/
        ├── ChatGPT-initial-brainstorm.md
        ├── ChatGPT-deep-research-on-X.md
        └── Claude-design-alternatives.md
```

Use descriptive filenames. These conversations will be cited as sources in your research document. If you don't have any saved conversations, that's fine — start fresh with Step 1. But going forward, save productive AI conversations as they happen. See [Conversation Bootstrapping](../concepts/conversation-bootstrapping.md) for details.

## Step 1: Set Up the Project Structure

Create the plans directory where Forge artifacts live:

```
my-project/
├── plans/
│   ├── VISION.md
│   ├── RESEARCH.md
│   ├── DESIGN.md
│   ├── ROADMAP.md
│   └── learnings/
│       └── LEARNINGS.md
└── src/  (or whatever your source directory is)
```

Copy the templates from the [templates/](../templates/) directory as starting points.

## Step 2: Write the Vision (Phase 0)

Start with the [Vision Template](../templates/VISION-TEMPLATE.md). Fill in:

1. **Problem statement** — Be specific. "Build a tool that does X" is weak. "Users currently spend Y hours doing Z manually because no tool handles edge case W" is strong.
2. **Success criteria** — Make them measurable. "The tool correctly handles all 47 test cases from the reference implementation."
3. **Scope** — Be explicit about what's out of scope. This prevents creep later.
4. **Unknowns** — List everything you don't know. These become your Phase 1 research agenda.

Don't try to make the vision perfect. It will change — that's the point of the Discovery Loop.

## Step 3: Research (Phase 1)

For each unknown in your vision, investigate:

- **Search broadly** — What exists in this space? What approaches have been tried?
- **Get the code** — Clone reference implementations. Reading source is worth 10x reading blog posts.
- **Document as you go** — Use the [Research Template](../templates/RESEARCH-TEMPLATE.md). Record findings, not just links.

After research, **update your vision**. Research always changes something — a narrower scope, a different approach, or new unknowns.

## Step 4: Design (Phase 2)

With research done, write the technical spec:

- **Interfaces first** — What are the public APIs? What data flows through the system?
- **Decisions with rationale** — For every architectural choice, document why and what alternatives you rejected.
- **Behavioral contracts** — What does each component promise? What are the error cases?

Use the [Design Template](../templates/DESIGN-TEMPLATE.md).

If design reveals you need more research, go back to Step 3. This iteration is normal — it's the Discovery Loop working correctly.

## Step 5: Check for Stability

Before proceeding to the roadmap, verify:

- [ ] Vision, research, and design tell a consistent story
- [ ] No research questions remain that would change the approach
- [ ] The design is specific enough to implement (interfaces, data models, error handling)

If yes, move to the Execution Pipeline. If no, iterate through Steps 2-4 again.

Consider running a [conversational review](../concepts/conversational-review.md) before proceeding — upload your vision, research, and design to a fresh AI session and ask it to check consistency and find gaps. A reviewer without your accumulated context will catch things you've missed.

## Step 6: Create the Roadmap (Phase 3)

Break the design into implementable steps:

1. **Start with standard steps** — Every roadmap's first stage begins with design review, project scaffolding, [quality infrastructure](../concepts/quality-infrastructure.md) setup, and test infrastructure. The [Roadmap Template](../templates/ROADMAP-TEMPLATE.md) includes these.
2. **For agent projects, add evaluation steps** — If your design has an Evaluation Architecture section (judges, loss function, benchmark cases), include Steps 1.4–1.6 (benchmark case models, case manager, judge interface) after test infrastructure, and a dedicated benchmark stage near the end of the roadmap. The template has both.
3. **Identify natural boundaries** — Each step should produce something testable.
4. **Order by dependency** — What must exist first?
5. **Define entry/exit criteria** — How do you know when a step can start? When it's done?
6. **Add stage review steps** — End each group of related steps with a [stage review](../phases/phase-review-template.md).

Use the [Roadmap Template](../templates/ROADMAP-TEMPLATE.md). For language-specific quality tooling, see the [guides/](../guides/) directory.

## Step 7: Execute (Phase 4)

Work through the roadmap. The feedback loop differs based on what you're building:

**For projects** — QA review loop:
1. Implement a roadmap stage
2. Run a stage review at the boundary
3. Fix MUST FIX / SHOULD FIX findings
4. Repeat until zero blocking findings remain

**For agents** — Optimization loop:
1. Execute benchmark cases against the agent
2. Compute loss from judge scores
3. Analyze capability gaps (which cases fail? why?)
4. Modify the agent (prompts, tools, strategy)
5. Repeat until loss converges below threshold

**Both modes share the same structure:**
1. Check entry criteria for the current step
2. Do the work
3. Check exit criteria — quality tools should pass on every step
4. **Capture learnings** — What surprised you? What would you do differently?
5. At stage boundaries, run the stage review (projects) or evaluate loss trajectory (agents)
6. Fix findings or capability gaps, re-evaluate
7. Compact learnings periodically

## Step 8: Document (Phase 5)

With a working implementation:

1. Write a getting-started guide for users
2. Document the public API
3. Create at least one tutorial
4. Test every code example

## Tips

- **Start small.** Apply Forge to a focused project first, not a massive system.
- **The Discovery Loop is the most valuable part.** Most project failures come from skipping it.
- **Learnings are a primary artifact.** Treat them with the same care as code.
- **Phase reviews catch real bugs.** Don't skip them even when you're confident.
- **It's OK to go back.** Returning to an earlier phase isn't failure — it's the methodology working.
