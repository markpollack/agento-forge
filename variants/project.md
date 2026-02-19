# Project Variant

Bootstrapping new software projects through discovery, build, and handoff.

## When to Use

Use the project variant when:

- You're building a library, service, application, or tool
- Quality is measured through code review, testing, and documentation
- The output is deployable software with users
- Success means "it works correctly and is maintainable"

## Key Differences from Other Variants

| Aspect | Project | Eval-Agent |
|--------|---------|-----------|
| Phase 4 feedback | QA review loop | Loss optimization loop |
| Success metric | Zero blocking review findings | Loss converges below threshold |
| Evaluation | Human review + automated tests | Automated judges |
| Artifacts | Test suites, documentation | Benchmark cases, judges |
| Lifecycle | Finite (build + ship) | Finite (converge) |

## Discovery Loop (Phases 0-2)

### Phase 0: Vision

Use [VISION-TEMPLATE.md](../templates/VISION-TEMPLATE.md) to define:

- **Problem statement** — What specific problem does this solve?
- **Success criteria** — Measurable outcomes, not features
- **Scope** — Explicit in/out boundaries
- **Unknowns** — What you need to learn (becomes Phase 1 agenda)
- **Assumptions** — Each is a risk if wrong

### Phase 1: Research

Investigate the problem space:

- What exists in this space?
- What reference implementations can you learn from?
- What approaches have been tried?

Document findings in RESEARCH.md. Update VISION.md when research changes assumptions.

### Phase 2: Design

Use [DESIGN-TEMPLATE.md](../templates/DESIGN-TEMPLATE.md) to specify:

- Architecture and components
- Interfaces and contracts
- Data models
- Design decisions with rationale

**Skip the Evaluation Architecture section** — that's for eval-agent projects only.

## Execution Pipeline (Phases 3-5)

### Phase 3: Roadmap

Use [ROADMAP-TEMPLATE.md](../templates/ROADMAP-TEMPLATE.md). Software projects:

- **Include** Steps 1.0-1.3 (design review, scaffolding, quality infrastructure, test infrastructure)
- **Skip** Steps 1.4-1.6 (benchmark case models, case manager, judge interface)
- **Skip** the benchmark stage template

Each step has entry criteria, work items, and exit criteria. End each stage with a cleanup and review step.

### Phase 4: QA Review Loop

The project variant uses a **QA review loop** for feedback:

```
┌──────────────────────────────────────────────────────────────────┐
│                       QA REVIEW LOOP                              │
│                                                                   │
│  1. Implement a roadmap stage                                     │
│  2. Generate review prompt from template                          │
│  3. Run QA review (separate session or reviewer)                  │
│  4. Receive findings: MUST FIX / SHOULD FIX / CONSIDER            │
│  5. Fix MUST FIX items (blocks stage completion)                  │
│  6. Fix SHOULD FIX items (or justify deferral)                    │
│  7. Log CONSIDER items in learnings                               │
│  8. Repeat until zero blocking findings                           │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

See [phase-review-template.md](../phases/phase-review-template.md) for:

- The review prompt template
- Checklist sections (API design, code quality, grammar, design conformance)
- Severity definitions and triage rules
- Operational workflow (implementation agent ↔ QA agent)

**Exit criteria per stage:**

- Zero MUST FIX findings
- SHOULD FIX items resolved or justified
- Learnings captured and compacted

### Phase 5: Documentation

Document for users:

- Getting started guide
- API reference
- At least one tutorial
- Test every code example

## Concepts

- [Quality Infrastructure](../concepts/quality-infrastructure.md) — Automated checks running on every build
- [Discovery Loop](../concepts/discovery-loop.md) — When to exit the iterative discovery phases
- [Execution Pipeline](../concepts/execution-pipeline.md) — How feedback flows in phases 3-5
- [Conversational Review](../concepts/conversational-review.md) — Using AI to review discovery artifacts
- [Hierarchical Reporting](../concepts/hierarchical-reporting.md) — Status reports with phase progress and blocking issues

## Example

See [examples/software-project/](../examples/software-project/) for a minimal project variant structure.

## Handoff to Steward

The project variant has a finite lifecycle — it ends when Phase 5 (docs) is complete and the software is shipped. For ongoing maintenance, the project transitions to the [Steward variant](steward.md):

```
Project Variant (bootstrap) ──handoff──> Steward Variant (maintain & evolve)
```

**Handoff conditions:**
- Phase 5 (documentation) complete
- Project is live and has users or consumers
- Ongoing development, monitoring, or KB maintenance is expected

**What transfers:**
- Knowledge accumulated during build phases becomes the steward's initial KB
- The build-phase CLAUDE.md is augmented (not replaced) with steward sections
- Roadmap items deferred during build become the steward's initial development queue

See [Steward variant](steward.md) for the ongoing lifecycle.
