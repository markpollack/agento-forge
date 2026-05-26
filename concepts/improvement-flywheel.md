# Improvement Flywheel

A loss-driven method for iteratively improving agent systems through measured behavioral deltas and targeted interventions. The flywheel connects the pieces that eval-agent projects already have — journal capture, Markov analysis, variant progression — into a repeatable cycle with structured diagnostics and verification.

The core insight: every iteration should identify a measurable gap between desired agent behavior and observed agent behavior. That gap is the loss signal. The flywheel turns the loss signal into a diagnosis, then into a targeted intervention, then into a verification run.

This is gradient-inspired, not gradient-computed. Agent systems are not differentiable, but their journals, scores, state transitions, and failure paths provide directional evidence about where the next intervention should be applied.

This page has two layers: the general flywheel used by any agent improvement process, and the eval-agent implementation that uses journals, Markov analysis, state taxonomy discovery, variant metadata, and verification deltas.

## The Cycle

```
1. RUN        — Execute variants and capture journals
2. MEASURE    — Compute scores, traces, behavioral metrics
3. DIAGNOSE   — Convert signals into hypotheses about causes
4. INTERVENE  — Change prompt, KB, tool, workflow, rubric, or template
5. VERIFY     — Re-run and compare deltas/regressions
```

Each iteration estimates where the system is failing, chooses the most promising improvement direction, applies an intervention, and measures whether the system moved in the intended direction. Variants are **empirically motivated, not pre-planned** — each variant exists because the previous variant's analysis revealed a specific gap.

## Phase 0: State Taxonomy Discovery

For eval-agent projects that use Markov analysis, the flywheel begins with state taxonomy discovery. You need a **state taxonomy** — the named states that `classify_state()` in `make_markov_analysis.py` maps tool calls to. This taxonomy is domain-specific and must be discovered empirically. You cannot define it from first principles.

### Bootstrap procedure

1. **Run control variant 3-5 times.** Generate enough tool-call data to see the agent's natural behavior patterns.
2. **Run discovery mode.** Use `MARKOV_DISCOVERY=true` to see raw tool name + target frequencies.
3. **Inspect clusters.** Look for related tool calls that represent a coherent activity.
4. **Define state taxonomy.** Name the clusters. Each state should represent a distinct *kind of work* the agent does: exploring, building, fixing, verifying, searching, reading knowledge.
5. **Configure classifier.** Write `classify_state()` to map tool calls to your states. Test by re-running Markov analysis in normal mode and verifying the transition matrix looks coherent.
6. **Define cluster groups.** Group states into higher-level categories: productive work (WRITE, BUILD, VERIFY), friction (FIX, SEARCH), knowledge access (READ_KB, READ_SKILL). These groups are what the analysis-to-action step operates on.

### What makes a good taxonomy

- **States are verbs, not nouns.** They describe what the agent is *doing*, not what it's *looking at*. EXPLORE (reading files to understand structure) vs. FIX (editing files after a failure) — same tool, different intent.
- **5-12 states.** Fewer than 5 hides important distinctions. More than 12 makes transition matrices unreadable.
- **States have diagnostic value.** Each state should tell you something about agent quality when its frequency changes. If a state's frequency doesn't matter, it's not a useful state.

> Example from PetClinic coverage experiments — 9-state taxonomy:
> EXPLORE, SHELL, READ_KB, READ_SKILL, JAR_INSPECT, WRITE, BUILD, VERIFY, FIX.
> Clusters: SEARCH = SHELL + JAR_INSPECT (unstructured searching), FIX_LOOP = FIX + BUILD (rework cycle).

## Optimization Target

The loss signal is multi-dimensional. Not every dimension matters for every iteration, but the full surface is:

| Loss dimension | What it measures | Example signal |
|----------------|-----------------|----------------|
| **Outcome loss** | Task failure or low judge score | 3 of 10 benchmark cases fail |
| **Behavioral loss** | Unnecessary exploration or loops | BUILD→FIX loop amplification 3.2 |
| **Knowledge loss** | Repeated search or oracle calls | Repeated fallback inspection (e.g., Maven cache decompilation) |
| **Tooling loss** | Errors reachable from multiple paths | Same exception from 4 different states |
| **Evaluation loss** | Judge variance or malformed output | Non-JSON judge response 2/7 runs |
| **Stability loss** | Large run-to-run variance | Quality scores range 0.28–0.72 |
| **Regression loss** | One metric improves, another worsens | Batch score +0.4 but scheduling score -0.3 |

The MEASURE step quantifies these signals. The DIAGNOSE step identifies which dimension dominates. The INTERVENE step targets that dimension specifically.

### Layered reasoning

| Layer | Question |
|-------|----------|
| **Objective** | What does "better" mean for this agent? |
| **Loss signal** | Where did observed behavior fall short? |
| **Diagnostic lens** | How do we explain the failure? |
| **Intervention** | What change should reduce the loss? |
| **Verification** | Did the loss actually decrease without regressions? |

## Diagnostic Lenses

Multiple analytical tools can illuminate the loss signal. No single lens is the methodology — they are instruments in the measurement apparatus.

| Lens | What it reveals | Best for |
|------|----------------|----------|
| **Markov analysis** | State transition patterns, loop amplification, transition gaps | Behavioral loss — where the agent gets stuck |
| **Judge scores** | Per-criterion quality assessment | Outcome loss — what the agent produces |
| **Reasoning/intent trace analysis** | Intent-to-action policy, planning distribution (via thinking blocks, plan logs, journaled rationales) | Knowledge loss — what the agent is searching for |
| **Oracle call log** | KB gaps the agent couldn't resolve alone | Knowledge loss — what's missing from the KB |
| **Cost/token accounting** | Where the budget goes | Behavioral loss — which states burn tokens |
| **Run-to-run comparison** | Variance across identical inputs | Stability loss — what's nondeterministic |

### Markov analysis as primary diagnostic lens

Markov analysis generates transition matrices, Sankey flows, and loop amplification metrics. These need interpretation.

**Loop amplification** measures how many times the agent revisits a state before moving forward. High amplification means the agent is retrying.

| Signal | Diagnosis | Lever |
|--------|-----------|-------|
| Amplification > 2.0 on BUILD→FIX→BUILD | Agent is in a fix loop — build fails, fix attempt fails, rebuild fails | Lever 2 (knowledge) or Lever 3 (deterministic tool) |
| Amplification > 2.0 on SEARCH states | Agent is searching for something it can't find | Lever 2 (add the target information to `knowledge/`) |
| Amplification > 2.0 on EXPLORE | Agent is reading many files without making progress | Lever 1 (clarify task decomposition in prompt) or Lever 3 (pre-analysis script) |

**Transition gaps** — capability states the agent never reaches, or reaches only rarely.

| Signal | Diagnosis | Lever |
|--------|-----------|-------|
| VERIFY never reached | Agent produces output but doesn't confirm correctness | Lever 1 (add stopping condition to prompt) |
| READ_KB never reached | Agent ignores knowledge files | Lever 1 (reference knowledge files in prompt, improve routing table) |
| WRITE reached late (after many EXPLORE/SEARCH cycles) | Agent spends too long understanding before acting | Lever 3 (templates, scaffolding, explicit first steps) |

**Failure patterns** — states that frequently lead to errors or task abandonment.

| Signal | Diagnosis | Lever |
|--------|-----------|-------|
| Error state reachable from multiple paths | Structural/tooling issue | Lever 3 (fix the tooling, not the agent) |
| Single dominant failure path (BUILD → ERROR 80%) | Invalid strategy | Lever 1 or 2 (change strategy, not retry count) |
| Agent stops after N fix attempts | Capability ceiling | Lever 2 (add fix pattern to knowledge) or Lever 3 (restructure task) |

### Journal capture

The flywheel depends on capturing two layers of agent behavior:

**Outer layer — tool calls.** Every Read, Bash, Write, Edit the agent executes. This is what Markov analysis operates on.

**Inner layer — reasoning/intent traces.** Planning notes, thinking blocks, summaries, or journaled rationales before each action. This reveals *why* the agent chose each action.

> In PetClinic experiments, 73% of all reasoning was orientation (EXPLORE thinking) across every variant. Skills eliminated JAR inspection *actions* but didn't reduce how much the agent *thought* about orienting. The orientation instinct is model-level, not task-level.

Both layers are needed. The outer layer tells you *what* the loops are. The inner layer tells you *why* they differ across variants. The Markov chain is the action-layer projection; the reasoning traces explain the underlying policy.

## Loop Types

Not all loops are problems. The DIAGNOSE step must classify the type of loop before choosing an intervention.

| Loop type | Pattern | Meaning | Action |
|-----------|---------|---------|--------|
| **Productive** | WRITE → VERIFY → FIX → VERIFY | Expected refinement cycle | Leave it alone |
| **Friction** | SEARCH → READ → SEARCH → READ | Agent lacks context or structure | Add knowledge or routing |
| **Failure** | BUILD → FIX → BUILD → FIX (same error) | Agent repeats an invalid strategy | Change strategy, not retry count |
| **Diagnostic** | BUILD → ERROR → READ_LOG → FIX | Agent is gathering useful failure information | Leave it alone |
| **Degenerate** | EXPLORE → EXPLORE → EXPLORE | No new information is being gained | The agent is stuck — intervene |

Optimizing loop amplification to zero is an anti-pattern. Some loops are productive. The goal is to eliminate *friction*, *failure*, and *degenerate* loops while preserving *productive* and *diagnostic* ones.

## Intervention Levers

The flywheel uses five primary levers for modifying agent behavior. The type of loss determines which lever to pull.

### Lever 1: Prompt

Clarify task decomposition, add stopping conditions, add execution ordering. In the PetClinic coverage experiments, the `simple` → `hardened` jump produced the single largest quality gain (+0.07) with no external knowledge — just structure and an explicit stopping condition.

Pull this lever when: diffuse waste, no dominant failure pattern, agent doesn't know when it's done.

### Lever 2: Knowledge and skills

Add domain recipes, examples, routing hints. Targeted KB entries eliminate specific search loops without touching the prompt. Skills don't change what the model thinks — they change what it reaches for when thinking.

Pull this lever when: friction loops around a specific knowledge gap. In one observed code-coverage experiment, a single knowledge package reduced JAR_INSPECT from 18% to under 2% of all steps.

### Lever 3: Execution structure

Three sub-levers that replace exploratory LLM behavior with deterministic execution:

**Deterministic tools.** Replace states that don't require reasoning. A build script that returns structured coverage results eliminates the BUILD/FIX reasoning loop the same way knowledge eliminates search friction.

**Templates and scaffolds.** Pre-generate structure or use cached known-good baselines. When the flywheel reveals the agent consistently discovers the same file structure or output pattern through exploration, codify it as a template. This is the primary mechanism for converting exploratory behavior into deterministic execution.

**Steering.** Runtime hooks that intercept tool calls before execution and enforce behavioral constraints. Works when rules are enumerable — "don't call X before Y." For open-ended tasks, trajectory analysis identifies which constraints to enforce.

Pull this lever when: the measurement apparatus shows loops around states that could be deterministic commands, the agent repeatedly discovers the same answer, or the agent makes predictable wrong choices catchable at the tool-call level.

### Lever 4: Model

Pick a model that clears the capability floor — below it, nothing else helps. But above that floor, don't default to throwing a bigger model at the problem. The other levers are cheaper and often more effective.

Pull this lever when: the agent fundamentally cannot perform the task, even with perfect knowledge and structure.

### Lever 5: Rubric and evaluation

Tighten judge criteria, add anchors with concrete examples of each score level, add per-criterion scoring. A rubric intervention doesn't change the agent — it changes the measurement, which changes what the next iteration optimizes for.

Pull this lever when: evaluation loss dominates (judge variance, malformed output, scores that don't correlate with actual quality).

### The critical distinction

Knowledge can't fix a reasoning gap. Steering can't fix a knowledge gap. A better model can't fix either. Diagnose which problem you have before you reach for a lever.

## The Deterministic-Over-Exploratory Principle

The flywheel's purpose is to **systematically shrink the agent's exploration space**. When the measurement apparatus reveals the agent consistently discovers the same pattern through exploration, that pattern should be codified as a deterministic step.

In observed code-coverage experiments:

| Execution path | Quality range | Reliability |
|----------------|---------------|-------------|
| Cached templates (deterministic) | 0.70 – 0.93 | Stable across runs |
| Expansion path (LLM with constraints) | 0.28 – 0.72 | Varies by run |
| Raw Claude Code (pure exploration) | 0.19 – 0.63 | High variance |

Every decision point the LLM doesn't have to make is a source of variance eliminated. The flywheel finds these decision points and converts them from exploration to execution. LLM steps are reserved for genuinely creative decisions where the search space can't be pre-constrained. The experiment's job is to find which steps are being explored that don't need to be.

| Finding | Codification |
|---------|-------------|
| Agent always discovers the same file structure | Template or scaffold |
| Agent always applies the same fix pattern | Recipe in `knowledge/` |
| Agent always needs the same context | Structured context in the prompt |
| Agent always makes the same tool-call sequence | Deterministic workflow step |
| Agent's orientation thinking dominates | Pre-analysis script that front-loads context |

## Variant Progression

Variants are empirically motivated. Each exists because the previous variant's analysis revealed a specific gap.

```
v0: baseline (control)
    → Run, measure: identify dominant loss dimension
    
v1: address the dominant loss
    → Typically prompt improvement (Lever 1) — clearest signal first
    → Run, measure: did the loss decrease? What's the next loss?

v2: address the next loss
    → Typically knowledge injection (Lever 2) — domain files for remaining gaps
    → Run, measure: repeat

v3+: address remaining losses
    → Structural fixes (Lever 3), rubric tightening (Lever 5)
    → Each variant is motivated by the previous variant's measurement
```

Every variant should link back to its motivating finding and hypothesis. Each variant in `experiment-config.yaml` records this:

```yaml
variants:
  - name: control
    promptFile: v0-naive.txt
    iteration:
      finding: null  # baseline — no prior finding
      hypothesis: "Establish baseline agent behavior"
      
  - name: variant-a
    promptFile: v1-hardened.txt
    iteration:
      finding: "v0 loop amplification 3.2 on BUILD→FIX cycle"
      hypothesis: "Structured execution steps reduce fix loops"
      
  - name: variant-b
    promptFile: v2-with-kb.txt
    iteration:
      finding: "v1 SEARCH amplification 2.8 — agent can't find Spring patterns"
      hypothesis: "Knowledge files eliminate search friction"
```

This creates an audit trail: for every variant you can trace back to the observation that motivated it and verify whether the hypothesis held.

## Verification Discipline

The VERIFY step is not just "re-run and check the score." It requires tracking what changed between iterations and what improved. Some dimensions are measured directly as loss (loop amplification, error rate); others are measured as scores whose improvement corresponds to loss reduction.

### Per-iteration record

```
Iteration: v0 → v1
Change: Added structured execution steps to prompt
Metrics before: batch score 0.519, BUILD→FIX amplification 3.2
Metrics after:  batch score 0.926, BUILD→FIX amplification 1.1
Delta: +0.407 outcome score, -2.1 behavioral amplification
Regression: none detected
```

### What to track

- **Per-criterion scores** — Not just the aggregate. A rising aggregate can hide a regression in a specific criterion.
- **Loop amplification per state** — The primary behavioral metric. Did the friction loop shrink?
- **Transition probabilities** — Did the agent's navigation pattern change as expected?
- **Variant-over-variant delta** — Before/after comparison for the specific change made.
- **Stability** — Run the same variant multiple times to distinguish signal from variance.

### Regression detection

Every improvement can introduce regressions. The VERIFY step must check:

1. Did the targeted loss dimension decrease?
2. Did any other dimension increase?
3. Is the improvement stable across multiple runs (not lucky variance)?

If a fix improves one criterion but degrades another, the diagnosis was incomplete — the fix addressed a symptom, not the root cause.

## Evidence

> Evidence provenance: these are internal experiment summaries. Link each row to the corresponding report, run directory, or handoff note when available. Do not treat numeric ranges as universal constants.

The flywheel has been practiced across multiple experiment projects:

| Project | Iterations | Key finding |
|---------|-----------|-------------|
| experiment-code-coverage v1→v2→v3 | 7 variants, 20 runs | Structure beats knowledge; skills reduce waste but not quality ceiling; pre-analysis + skills compound |
| tuvium-liquibase-flyway-agent | 4 variants | Consumer scaffolding validated; T0/T1 judge pattern established |
| tuvium-ir-experiment | 5 stages | 0% multi-repo overfitting discovery drove infrastructure-over-prompt strategy |
| bud-eval | 6 iterations | Batch 0.519→0.926 (template fix), scheduling oscillation→stable 0.741 (test fix), judge non-JSON→reliable (retry fix) |

Each project followed the same arc: run → observe gap → diagnose cause → fix → verify. The methodology was practiced successfully but lived in handoff notes and human memory.

## Anti-Patterns

- **Skipping taxonomy discovery** — Jumping to Markov analysis with a generic state taxonomy. The taxonomy must be discovered from your agent's actual tool-call patterns.
- **Figures without interpretation** — Running `make_markov_analysis.py` and looking at the pictures without mapping findings to specific interventions. The analysis-to-action step is where the diagnostic value lives.
- **Unmotivated variants** — Creating variants without a clear hypothesis. Each variant should be motivated by either a prior measurement gap *or* a specific technique you want to understand (e.g., "what does plan-act do to thinking distribution?"). Pre-planning variants to test a deliberate hypothesis is legitimate experimentation. Pre-planning variants without knowing what you're testing is not.
- **Aggregate-only scoring** — Tracking only the overall batch score. Per-criterion and per-state metrics are where the diagnostic signal lives.
- **Wrong lever** — Throwing knowledge at a reasoning gap, or a bigger model at a knowledge gap. Diagnose first.
- **Fixing without verifying** — Making an improvement and moving to the next gap without confirming the fix worked. Unverified fixes compound.
- **Over-rotation on a single metric** — Optimizing loop amplification to zero removes productive loops along with wasteful ones.
- **Ignoring the deterministic principle** — Improving agent exploration quality instead of converting exploration into deterministic steps. If the agent consistently discovers the same answer, the answer belongs in a template.

## See Also

- [Learning Loop (Phase 4)](../phases/04-learning-loop.md) — The execution loop the flywheel refines
- [Judges and Evaluation](judges-and-evaluation.md) — Judge design and loss computation
- [Oracle Learning Loop](oracle-learning-loop.md) — Oracle calls as KB gap indicators (a special case of knowledge loss)
- [Eval-Agent Variant](../variants/agent.md) — The project type that uses the flywheel
