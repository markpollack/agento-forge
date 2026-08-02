# Phase 3: Roadmap Creation

## Purpose

Break the stable design into an ordered sequence of implementable steps, each with clear entry criteria, exit criteria, and deliverables.

## Inputs

- Stabilized DESIGN.md
- Research findings (for complexity estimation)

## Outputs

- **ROADMAP.md** — ordered implementation steps (see [template](../templates/ROADMAP-TEMPLATE.md))

## Key Activities

1. **Decompose the design** — Identify natural implementation boundaries. Each step should produce something testable.
2. **Order by dependency** — What must exist before something else can be built? Data layer before service layer, interfaces before implementations.
3. **Define entry/exit criteria per step** — Entry: what must be true to start. Exit: what must be true to consider it done. Entry criteria must include reading the prior step's learnings file — this prevents context loss between steps and across sessions.
4. **Include standard early steps** — Every roadmap's first stage starts with design review, project scaffolding, [quality infrastructure](../concepts/quality-infrastructure.md) setup, and test infrastructure, before any implementation. See the [Roadmap Template](../templates/ROADMAP-TEMPLATE.md).
5. **Group into stages** — Related steps form roadmap stages. Each stage ends with a consolidation step that compacts per-step learnings into `LEARNINGS.md` and a [stage review](phase-review-template.md).
6. **Identify the learnings structure** — What will you capture along the way? Set up the learnings file structure.

## Exit Criteria

- Every design component has at least one roadmap step
- Stage 1 includes design review, project scaffolding, quality infrastructure, and test infrastructure steps
- **Freeze/contract gates schedule their lenses as steps BEFORE the freeze step** (the pre-freeze window is when fixes are naming-level; after, they are versioned migration events): the cold second-implementation spike, producer-coverage + persona-matrix runs, and conformance-vector attestation all precede the freeze — and the gate step re-runs lenses 4/5 as standing dimensions ([review-lenses](../concepts/review-lenses.md))
- **Mid-execution research arrivals route through the (a)/(b)/(c) classification protocol** — only class-(c) findings may reopen approved design, at a high bar; (b) findings land in a named Deferred list, never silently
- Steps are ordered with no circular dependencies
- Each step has entry criteria, exit criteria, and expected deliverables
- The first step can start immediately (no unmet entry criteria)
- Learnings structure is defined

## Relationship to Other Phases

- **Consumes Phase 2** — translates design into implementation order
- **Feeds Phase 4** — the roadmap is what the learning loop executes
- First phase of the [Execution Pipeline](../concepts/discovery-loop.md#part-2-the-execution-pipeline-phases-3-5) — no more iteration with discovery phases

## Model Capability Considerations

Different AI models vary in how reliably they follow structured process checklists. Roadmaps may need tailoring based on the model executing them:

- **Frontier reasoning models** (e.g., Opus) — Strong at design decisions and architecture, but may skip process artifacts (learnings files, CLAUDE.md updates) in favor of "substance" work. Mitigation: prominent reminders at the top of the roadmap, and in the model's persistent memory.
- **Instruction-following models** (e.g., Sonnet) — More literal with checklists and exit criteria, less likely to skip process steps. May make more conservative design choices.
- **Smaller/local models** (e.g., 17B parameter) — May need even more structure: explicit sub-steps within each step, inline checklists rather than references to conventions sections, and shorter steps with fewer work items.

**Key insight**: The exit criteria convention is easily missed when buried deep in a roadmap document. Place a prominent reminder near the top of the Overview section, not just in a Conventions section at the bottom.

## Plans Directory Lifecycle

During execution, the `plans/` directory accumulates more than just learnings. Research notes, design briefs, handoff documents, and future ideas arrive organically — often faster than they can be incorporated into the roadmap. The **inbox pattern** manages this:

```
plans/
├── ROADMAP.md           # Execution plan
├── DESIGN.md            # Architecture decisions
├── inbox/               # Unprocessed: ideas, research briefs, handoff notes (gitmaildir delivers here)
├── research/            # Active: reference material informing upcoming stages
├── journal/             # Ratified decisions (dated, durable): why we chose X; supersession trail
├── archive/             # Completed/superseded: kept for provenance, not consulted
└── learnings/           # Per-step and compacted learnings
```

**Lifecycle**: Items start in `inbox/`. At stage boundaries (typically during consolidation steps), triage the inbox:
- Items informing upcoming work → move to `research/`, link from roadmap steps
- Completed or superseded items → move to `archive/`
- Items that should become roadmap steps → incorporate into the roadmap, then archive the original

When `inbox/` is empty, delete it. The goal is zero inbox at each wave boundary.

**`journal/` is not part of the inbox lifecycle** — it is the durable decision record (dated `YYYY-MM-DD-<slug>.md` entries: the choice, the rationale, the rejected alternatives; a later entry *supersedes* an earlier one by explicit pointer, and both are kept). A decision goes here when a future session would ask "why is it this way?" and the code/roadmap doesn't answer. Journal entries are never compacted away, unlike `learnings/`.

This inbox pattern emerged from building Loopy — research notes, gap analyses, and design briefs accumulated in inbox during Waves 1-2, then were triaged into research (active reference for Stage 7 steps) and archive (completed Wave 1 handoffs) when the wave completed. The full layout — including `journal/` and the gitmaildir intake binding — is described in [Project Knowledge Layout](../concepts/project-knowledge-layout.md).

## Anti-Patterns

- **Steps without exit criteria** — "Implement the data layer" is not a step. "Data layer passes all schema tests and loads reference dataset" is.
- **Too-large steps** — If a step takes more than a few focused sessions, break it down further.
- **Too-small steps** — If a step produces nothing testable, merge it with the next step.
- **Missing dependencies** — Step N requires something from Step M, but M comes after N.
- **No learnings structure** — If you don't plan where learnings go, they get lost in chat history.
- **No prior-step learnings in entry criteria** — Each step should read the previous step's learnings file. Without this, discoveries and design changes are lost between steps, especially across sessions when context resets.
- **No stage consolidation step** — Per-step learnings are detailed but fragmented. Without a consolidation step that compacts them into `LEARNINGS.md`, the overall narrative is lost and future stages start without accumulated context.
- **Exit criteria buried at the bottom** — If the standard exit criteria convention is only mentioned in a Conventions section at line 600+, models will miss it. Add a prominent callout in the Overview.
