# Roadmap: {{PROJECT_NAME}}

> **Created**: {{DATE}}
> **Design version**: {{DESIGN_VERSION}}

> **Note**: For research projects, use [ROADMAP-TEMPLATE-research.md](ROADMAP-TEMPLATE-research.md) instead. It includes context loading sections, go/no-go decision gates, and the pilot-then-full pattern.

## Overview

{{ONE_PARAGRAPH_DESCRIBING_IMPLEMENTATION_ORDER_AND_RATIONALE}}

## Stage 1: {{STAGE_NAME}}

### Step 1.0: Design Review

**Entry criteria**:
- [ ] Read: `DESIGN.md`
- [ ] Read: `RESEARCH.md`

**Work items**:
- [ ] REVIEW design for completeness against vision
- [ ] VERIFY reference patterns apply
- [ ] DOCUMENT any design changes or open questions

**Exit criteria**:
- [ ] Design reviewed and approved
- [ ] Create: `plans/learnings/step-1.0-design-review.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

---

### Step 1.1: Project Scaffolding

**Entry criteria**:
- [ ] Step 1.0 complete
- [ ] Read: `DESIGN.md` — Build Coordinates section (groupId, artifactId, module structure, base package, dependencies)

**Work items**:
- [ ] INITIALIZE git repository (`git init`)
- [ ] COPY plan artifacts into `plans/` directory
- [ ] CREATE build tool config (pom.xml / build.gradle / pyproject.toml / etc.) with dependencies from DESIGN.md
- [ ] CREATE source directory layout matching the design's package hierarchy
- [ ] CREATE initial `.gitignore`
- [ ] CREATE `CLAUDE.md` with project overview, build commands
- [ ] VERIFY empty project compiles: `./mvnw compile -q` (or equivalent)
- [ ] COMMIT: `git commit`

**Exit criteria**:
- [ ] Git repository initialized with scaffold committed
- [ ] Project compiles with zero source files (scaffold only)
- [ ] All external dependencies declared and resolved
- [ ] Directory structure matches DESIGN.md package hierarchy
- [ ] Create: `plans/learnings/step-1.1-project-scaffolding.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Git repository with plan artifacts and compilable empty project

---

### Step 1.2: Quality Infrastructure Setup

**Entry criteria**:
- [ ] Step 1.1 complete (buildable project exists)

**Work items**:
- [ ] CONFIGURE test coverage tool (see [quality guide](../guides/))
- [ ] CONFIGURE architecture rule enforcement
- [ ] CONFIGURE null safety annotations
- [ ] CONFIGURE dependency vulnerability scanning
- [ ] CONFIGURE code formatting
- [ ] VERIFY all quality checks pass on scaffold project
- [ ] DOCUMENT quality thresholds in `CLAUDE.md`

**Exit criteria**:
- [ ] Build runs with all quality tools enabled
- [ ] Coverage reporting works (baseline established)
- [ ] Architecture rules enforced (even if no production classes yet)
- [ ] Create: `plans/learnings/step-1.2-quality-infrastructure.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Build pipeline with quality tooling active

---

### Step 1.3: Test Infrastructure

**Entry criteria**:
- [ ] Step 1.2 complete

**Work items**:
- [ ] CREATE test fixtures and shared test data
- [ ] CREATE test base classes (if applicable)
- [ ] VERIFY test infrastructure compiles and runs

**Exit criteria**:
- [ ] Test infrastructure ready for implementation steps
- [ ] Create: `plans/learnings/step-1.3-test-infrastructure.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Test scaffolding ready for implementation

---

### Steps 1.4–1.6: Evaluation Infrastructure (Agent Projects Only)

> *Include these steps for agent projects. Skip for conventional software projects. See the [Evaluation Architecture section](../templates/DESIGN-TEMPLATE.md) in the design template.*

```markdown
### Step 1.4: Benchmark Case Models

**Entry criteria**:
- [ ] Step 1.3 complete
- [ ] Read: `DESIGN.md` — Evaluation Architecture section (case model, case format)

**Work items**:
- [ ] IMPLEMENT benchmark case domain models (from DESIGN.md case model)
- [ ] IMPLEMENT case query methods (next unpassed, all passed, completion percentage)
- [ ] WRITE unit tests for case model and query logic

**Exit criteria**:
- [ ] Case models compile and tests pass
- [ ] Create: `plans/learnings/step-1.4-benchmark-cases.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Benchmark case data models
```

```markdown
### Step 1.5: Case Manager

**Entry criteria**:
- [ ] Step 1.4 complete

**Work items**:
- [ ] IMPLEMENT case loader (deserialize from DESIGN.md case format)
- [ ] IMPLEMENT case state persistence (mark passed, track progress across iterations)
- [ ] WRITE unit tests for load/save cycle and state transitions

**Exit criteria**:
- [ ] Case manager reads and writes case files correctly
- [ ] Create: `plans/learnings/step-1.5-case-manager.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Case lifecycle management
```

```markdown
### Step 1.6: Judge Interface and Result Models

**Entry criteria**:
- [ ] Step 1.5 complete
- [ ] Read: `DESIGN.md` — Judges table, Loss Function

**Work items**:
- [ ] DEFINE judge interface (or import from evaluation framework)
- [ ] IMPLEMENT result model (iteration result with metrics from DESIGN.md tracking spec)
- [ ] IMPLEMENT agent config model (max iterations, cost limit, convergence threshold)
- [ ] WRITE unit tests for result model construction

**Exit criteria**:
- [ ] Judge interface and result models compile with full Javadoc
- [ ] Create: `plans/learnings/step-1.6-judge-interface.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes

**Deliverables**: Evaluation interface, result models, agent configuration
```

---

### Step {{NEXT}}: {{STEP_NAME}}

**Entry criteria**:
- [ ] Previous step exit criteria met

**Work items**:
- [ ] {{WORK_ITEM_1}}

**Exit criteria**:
- [ ] {{EXIT_CRITERION_1}}

**Deliverables**: {{WHAT_THIS_STEP_PRODUCES}}

---

### Agent Projects: Benchmark Stage Template

> *Include as a dedicated stage (typically the last or second-to-last) for agent projects.*

```markdown
## Stage N: Judges and Benchmarking

### Step N.0: Deterministic Judges

**Work items**:
- [ ] IMPLEMENT judges from DESIGN.md judges table (deterministic type)
- [ ] WRITE unit tests with known inputs producing known scores

### Step N.1: AI Judges

**Work items**:
- [ ] IMPLEMENT judges from DESIGN.md judges table (AI type)
- [ ] WRITE integration tests with mock LLM

### Step N.2: Composite Judge and Loss Function

**Work items**:
- [ ] IMPLEMENT composite judge aggregating sub-judges with weights from DESIGN.md
- [ ] IMPLEMENT loss computation: loss = 1 - weighted_sum(scores) / max_score
- [ ] WRITE unit test verifying loss computation with known inputs
- [ ] VERIFY convergence threshold from DESIGN.md is wired into termination strategy

### Step N.3: End-to-End Benchmark

**Work items**:
- [ ] CREATE benchmark case files (format from DESIGN.md)
- [ ] INTEGRATE tracking (per-iteration and per-execution metrics from DESIGN.md)
- [ ] RUN end-to-end benchmark with both agent loops (if multiple)
- [ ] DOCUMENT results: loss trajectory, convergence behavior, capability gaps
```

---

### Step 1.K: Stage 1 Cleanup and Review

**Entry criteria**:
- [ ] All Stage 1 steps complete

**Work items**:
- [ ] Generate stage review prompt (`plans/prompts/stage1-review-prompt.md`)
- [ ] Run stage review (see [review template](../phases/phase-review-template.md))
- [ ] Address MUST FIX and SHOULD FIX findings
- [ ] Compact learnings into summary

**Exit criteria**:
- [ ] Stage review passes (zero MUST FIX findings)
- [ ] Learnings compacted

---

## Stage 2: {{STAGE_NAME}}

{{REPEAT_STRUCTURE}}

---

## Learnings Structure

```
plans/learnings/
├── LEARNINGS.md              # Tier 1: Compacted summary
├── step-1.0-{{topic}}.md    # Tier 2: Per-step details
├── step-1.1-{{topic}}.md
├── stage1-qa-review.md       # Stage review findings (iteration 1)
├── stage1-qa-review-2.md     # Stage review findings (iteration 2, if needed)
└── archive/                  # Tier 3: Historical records
```

---

## Conventions

### Commit Convention

Every step ends with a git commit. Use this format:

```
Step X.Y: Brief description of what was done
```

### Step Exit Criteria Convention

Every step's exit criteria must include these items (in addition to step-specific criteria):

```markdown
- [ ] All tests pass: `./mvnw test` (or `./mvnw verify` if integration tests)
- [ ] Create: `plans/learnings/step-X.Y-topic.md`
- [ ] Update `CLAUDE.md` with distilled learnings
- [ ] Update `ROADMAP.md` checkboxes
- [ ] COMMIT
```
