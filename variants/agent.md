# Eval-Agent Variant

Building autonomous agents with judge-based evaluation and loss optimization.

## When to Use

Use the eval-agent variant when:

- You're building an AI agent that completes tasks (code generation, classification, planning, etc.)
- Success is measurable through automated judges
- You want iterative improvement guided by a loss function
- The agent interacts with external systems (APIs, tools, environments)

## Key Differences from Other Variants

| Aspect | Eval-Agent | Project |
|--------|-------|----------|
| Phase 4 feedback | Loss optimization loop | QA review loop |
| Success metric | Loss converges below threshold | Zero blocking review findings |
| Evaluation | Automated judges (deterministic + AI) | Human review + automated tests |
| Artifacts | Benchmark cases, judge implementations | Test suites, documentation |

## Discovery Loop (Phases 0-2)

The Discovery Loop is the same as for project variant:

1. **Vision** — Define what the agent does, success criteria, scope
2. **Research** — Investigate similar agents, evaluation approaches, baseline performance
3. **Design** — Specify the agent architecture, including the **Evaluation Architecture** section

### Evaluation Architecture Section

The DESIGN.md for eval-agent projects must include:

```markdown
## Evaluation Architecture

### Agent Loop
| Field | Value |
|-------|-------|
| **Loop type** | turn-limited / evaluator-optimizer / fresh-context |
| **Implements** | AgentLoop<ResultType> |
| **Termination** | all cases pass / max iterations / cost limit |

### Benchmark Cases
- **Format**: YAML / JSON / programmatic
- **Source**: reference test suite / hand-crafted / generated
- **Case model**: description of what each case contains

### Judges
| Judge | Type | Evaluates | Weight |
|-------|------|-----------|--------|
| Test pass rate | Deterministic | correctness | 0.5 |
| Iteration efficiency | Deterministic | cost | 0.2 |
| Output quality | AI | style, completeness | 0.3 |

### Loss Function
loss = 1 - weighted_sum(judge_scores) / max_score
- **Convergence threshold**: loss < 0.1
- **Primary metric**: which judge matters most
```

See [DESIGN-TEMPLATE.md](../templates/DESIGN-TEMPLATE.md) for the full template.

## Execution Pipeline (Phases 3-5)

### Phase 3: Roadmap

Eval-agent roadmaps include additional steps not needed for project variant:

**Stage 1 additions (after test infrastructure):**

- **Step 1.4: Benchmark Case Models** — Implement the case data models
- **Step 1.5: Case Manager** — Load/save cases, track progress across iterations
- **Step 1.6: Judge Interface** — Define the judge contract and result models

**Dedicated benchmark stage (typically near end):**

- **Step N.0: Deterministic Judges** — Implement judges with known outputs
- **Step N.1: AI Judges** — Implement LLM-based judges with mock tests
- **Step N.2: Composite Judge and Loss** — Wire up weighted aggregation
- **Step N.3: End-to-End Benchmark** — Run full benchmark, document results

See [ROADMAP-TEMPLATE.md](../templates/ROADMAP-TEMPLATE.md) for the full template with these sections.

### Phase 4: Optimization Loop

The eval-agent variant centers on a **loss-function optimization loop**. For agents that produce code or other durable artifacts, compose this optimization loop with QA review gates. For non-trivial eval-agent projects, apply the [Improvement Flywheel](../concepts/improvement-flywheel.md).

```
┌──────────────────────────────────────────────────────────────────┐
│                    OPTIMIZATION LOOP                              │
│                                                                   │
│  1. Execute benchmark cases against current agent                 │
│  2. Run judges on each case result                                │
│  3. Compute loss = 1 - weighted_sum(scores) / max_score           │
│  4. Analyze capability gaps (which cases fail? why?)              │
│  5. Modify the agent (prompts, tools, strategy)                   │
│  6. Repeat until loss < convergence_threshold                     │
│                                                                   │
│  Termination: loss converges OR max_iterations OR cost_limit      │
└──────────────────────────────────────────────────────────────────┘
```

**Key activities per iteration:**

1. **Execute** — Run the agent on all unpassed benchmark cases
2. **Evaluate** — Run deterministic and AI judges on results
3. **Analyze** — Identify patterns in failures (which cases, which judges)
4. **Modify** — Change prompts, add tools, adjust strategy
5. **Record** — Log iteration metrics (tokens, cost, duration, cases passed)

### Agent Prompt: Stopping Condition

Every agent prompt must include a **domain-specific stopping condition** — a concrete,
runnable command the agent executes to confirm the task is complete. Without it, the agent
stops when output files exist, not when they are correct.

The stopping condition must be:
- A specific command (not a vague instruction to "verify your work")
- Runnable in the agent's environment without external services or credentials
- Binary: passes or fails with a clear exit code or output
- The same criterion the T0/T1 judges use — same definition of done

Examples by domain:

| Domain | Stopping condition command |
|--------|---------------------------|
| SQL migration | `java -jar validator.jar --validate ./db/migration` (exits 0 = PASS) |
| Java refactoring | `./mvnw test` (exits 0 = all tests pass) |
| Python upgrade | `pytest` (exits 0 = all tests pass) |
| Code coverage | `./mvnw verify` (exits 0 = coverage threshold met) |

If the stopping condition tool does not exist yet, build it before writing the agent prompt.
The agent should not have to guess when it is done.

**Exit criteria:**

- Loss below convergence threshold for N consecutive iterations
- All benchmark cases pass
- OR max iterations reached (document capability ceiling)
- OR cost limit reached (document cost ceiling)

### Phase 5: Documentation

Eval-agent documentation includes:

- How to run the agent
- Expected inputs and outputs
- Benchmark results and capability boundaries
- Known limitations and failure modes
- Cost and performance characteristics

## Concepts

- [Improvement Flywheel](../concepts/improvement-flywheel.md) — Loss-driven iterative improvement using journals, Markov analysis, and variant progression
- [Judges and Evaluation](../concepts/judges-and-evaluation.md) — How to design judges and compute loss
- [Discovery Loop](../concepts/discovery-loop.md) — When to exit the iterative discovery phases
- [Execution Pipeline](../concepts/execution-pipeline.md) — How feedback flows in phases 3-5
- [Hierarchical Reporting](../concepts/hierarchical-reporting.md) — Status reports with experiment results, judge performance, and measurement gaps

## Example

See [examples/agent-project/](../examples/agent-project/) for a minimal eval-agent project structure.
