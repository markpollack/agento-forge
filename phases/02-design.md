# Phase 2: Design

## Purpose

Synthesize vision and research into a technical specification. Make and document architectural decisions with rationale.

## Inputs

- VISION.md (stabilized or stabilizing)
- Research findings from Phase 1
- Reference implementation analysis

## Outputs

- **DESIGN.md** — technical specification (see [template](../templates/DESIGN-TEMPLATE.md))
- **Design decision records** — one per significant architectural choice, with rationale and alternatives considered

## Key Activities

1. **Define interfaces and data models** — What are the public APIs? What data structures flow through the system?
2. **Make architectural decisions** — Choose approaches and document why. Include alternatives considered and why they were rejected.
3. **Identify gaps** — Design often reveals missing knowledge. When it does, loop back to Phase 1 for targeted research.
4. **Specify behavior contracts** — What does each component promise to do? What are the error cases? What's the threading model?
5. **Create architecture diagrams** — Visual representations of component relationships, data flow, and deployment.
6. **Define build coordinates** — For projects that produce build artifacts: group/artifact IDs, module structure, base package, Java version, key dependencies. These are consumed by the scaffolding step during roadmap execution.

## Exit Criteria

- Design document covers all scope items from the vision
- Every significant decision has a recorded rationale
- Interfaces are specified enough to write against (method signatures, data models, error handling)
- No remaining design questions that would block implementation planning
- Build coordinates defined (if producing build artifacts): group/artifact IDs, module structure, dependencies
- Design is consistent with research findings

## Relationship to Other Phases

- **Consumes Phase 0 and Phase 1** outputs
- **Feeds Phase 3** — the design is what the roadmap breaks into steps
- **May trigger Phase 1** — design gaps requiring more research
- **May update Phase 0** — design reveals the vision scope was wrong
- Final phase of the [Discovery Loop](../concepts/discovery-loop.md)

## Anti-Patterns

- **Design without research** — Designing based on assumptions instead of evidence. If you didn't research it, you're guessing.
- **Over-design** — Specifying implementation details that should be decided during coding. Design specifies *what* and *why*, not *how* at the line-of-code level.
- **Missing decision records** — Future you (or your team) will ask "why did we do it this way?" If the rationale isn't recorded, the decision looks arbitrary.
- **Designing for hypothetical requirements** — Design for what the vision says, not for what might be needed someday.
- **Ignoring reference implementations** — If three reference implementations all handle edge case X, your design should address it too.

## Prerequisite Designs

If research identified tooling or data prerequisites that need their own design, those should be completed before or in parallel with the main DESIGN.md. Prerequisite designs use a lighter template and live under `plans/research/designs/`. The main DESIGN.md references their outputs as input contracts. See [Prerequisite Designs](../concepts/prerequisite-designs.md).
