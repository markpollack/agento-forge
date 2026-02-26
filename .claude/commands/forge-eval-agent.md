---
name: forge-eval-agent
description: "Bootstrap an eval-agent project (Forge: consumer of experiment-driver with domain judges and benchmarks)"
---

# Forge Eval-Agent — Bootstrap an Agent Evaluation Project

> **Installation**: Copy this file to `~/.claude/commands/forge-eval-agent.md` for global access.
> Then update the paths in the Configuration section below.

You are helping bootstrap a new eval-agent project using the Forge methodology's eval-agent variant. Eval-agent projects are **consumer projects** that plug into the `tuvium-experiment-driver` orchestration framework. They provide domain-specific agents, judges, datasets, and knowledge bases — the framework handles orchestration, result persistence, comparison, and the optimization loop.

## Architecture Context

Eval-agent projects sit at the **consumer layer** of the experiment stack:

```
tuvium-experiment-driver (orchestration framework)
  ├── ExperimentRunner   — dataset → workspace → invoke → judge → persist
  ├── CascadedJury       — 3-tier: deterministic → structural → semantic LLM
  ├── DatasetManager     — versioned datasets with item filtering
  ├── ResultStore        — experiment results with verdict traces
  ├── KnowledgeManifest  — KB state snapshots for ablation
  └── Pipeline           — analyze → plan → execute (optional)
         │
         │ consumer implements: AgentInvoker + domain judges + dataset
         │
    ┌────┴──────────────────┬──────────────────────┐
    │                       │                      │
 refactoring-agent    YOUR PROJECT           (future)
 (exemplar consumer)  (new consumer)
```

**The consumer provides**: AgentInvoker implementation, domain-specific judges, dataset in DatasetManager format, knowledge base, experiment configuration.

**The framework provides**: Orchestration loop, jury cascading, result persistence, workspace isolation, cost tracking, comparison engine, diagnostic feedback.

## When to Use

Use this skill when:
- You're building a project that evaluates AI agent performance on a domain
- Success is measurable through automated judges (deterministic + AI)
- You want iterative improvement via the experiment-driver optimization loop
- The project consumes experiment-driver infrastructure (not standalone)

Do NOT use this for:
- **Research projects** (gathering papers, building a corpus) → use `/forge-research`
- **Standard software projects** (libraries, services, tools) → use `/forge-project`
- **Existing projects needing maintenance** → use `/forge-steward`
- **The experiment framework itself** — that's tuvium-experiment-driver

## Arguments
- `$ARGUMENTS` - Optional: project path, brief file path, reference material paths
  - If `$ARGUMENTS` contains a path to a `*-brief.md` file, treat it as a **pre-filled eval-agent brief** (see Brief Format below). Read it first, confirm with user, then proceed to Phase 2.

## Brief Format

An eval-agent brief pre-fills Phase 1 answers. When provided:

1. Read the brief file
2. Confirm key details with the user
3. **Treat "Prior Baselines" as targets to reproduce and exceed**, not constraints
4. Proceed to Phase 2 using the brief's source material paths
5. Use the brief's evaluation design to accelerate Phase 4

```markdown
# Eval-Agent Brief: {Project Name}

## Agent Description
{What the agent does — 1-2 sentences}

## Optimization Goal
{What you're trying to improve — resolve rate, accuracy, cost, quality}

## Spark
{What triggered this project}

## Project Path
{Where the project should live}

## Visibility
Private | Community

## Source Materials
{Paths to reference implementations, prior work, datasets}
- {path 1} — {description}

## Existing Synthesis
{Paths to research, analysis, or prior experiment results}
- {path 1} — {description}

## Prior Baselines
{Known results from other approaches — targets to reproduce and exceed}
- {baseline 1} — {result, source, confidence}

## Evaluation Design (Seed)

### Benchmark
- **Dataset**: {name, size, format}
- **Task**: {what the agent does per case}
- **Case model**: {what each case contains}

### Judges (Draft)
| Judge | Tier | Type | Evaluates |
|-------|------|------|-----------|
| {judge 1} | 1 | Deterministic | {criteria — guardrail} |
| {judge 2} | 2 | Deterministic | {criteria — structural grader} |
| {judge 3} | 3 | AI | {criteria — semantic} |

### Convergence Criteria
- {criterion 1}: {threshold}
- {criterion 2}: {threshold}

## Experiment Variants
- Control: {description}
- Variant A: {description}
- Variant B: {description}

## Infrastructure Dependencies
{What experiment-driver components this project needs}
- [ ] KnowledgeManifest (for ablation)
- [ ] CascadedJury (3-tier)
- [ ] ComparisonEngine (for multi-variant analysis)
- [ ] {other}

## What This Project Produces
{Expected outputs}

## What This Project Feeds
{Downstream publications, decisions, or projects}
```

## Configuration

**UPDATE THESE PATHS** to point to your installations:

- **Forge methodology location**: `/path/to/forge-methodology`
- **Templates directory**: `/path/to/forge-methodology/templates`
- **Eval-agent variant doc**: `/path/to/forge-methodology/variants/agent.md`
- **Experiment-driver location**: `/path/to/tuvium-experiment-driver`
- **Refactoring-agent location** (exemplar consumer): `/path/to/refactoring-agent`

## Instructions

### Phase 1: Understand the Agent Domain

Start by understanding the domain. Be conversational:

1. **What agent are you evaluating?** Ask about:
   - What task the agent performs (code generation, migration, classification, etc.)
   - What system(s) it interacts with (codebases, APIs, tools)
   - What "success" looks like for a single execution
   - What optimization goal they're pursuing

2. **What baselines exist?** Ask about:
   - Published results to reproduce or beat
   - Reference implementations to study or fork
   - Known ceilings or limitations of existing approaches

3. **What infrastructure do you need from experiment-driver?** Survey:
   - Read `{experiment-driver}/plans/status.md` for current state
   - Read `{experiment-driver}/plans/DESIGN-jury.md` for jury system architecture
   - Check if the domain needs features that are designed but not yet built (diagnostic feedback, ComparisonEngine, non-Maven dataset support)
   - If there are gaps, document them as prerequisites

4. **How does the exemplar consumer (refactoring-agent) work?** Read:
   - `{refactoring-agent}/CLAUDE.md` for the consumer pattern
   - Look at how it implements AgentInvoker, provides judges, wires datasets
   - This is the architectural template your new project follows

5. **Where should the project live?** Ask for:
   - Project path
   - Private or community
   - Whether there's a companion research project feeding this one

### Phase 2: Gather Materials

1. **Read the experiment-driver architecture** to understand what's available:
   - `{experiment-driver}/plans/DESIGN.md` — core abstractions (AgentInvoker, DatasetManager, ExperimentRunner)
   - `{experiment-driver}/plans/DESIGN-jury.md` — CascadedJury, TierPolicy, scoring model
   - `{experiment-driver}/plans/DESIGN-diagnostic-feedback.md` — gap taxonomy (KB_GAP, TOOL_GAP, etc.)

2. **Read the exemplar consumer** to understand the pattern:
   - How AgentInvoker is implemented
   - How domain-specific judges are structured
   - How fixtures/datasets are organized
   - How the knowledge base is referenced

3. **Read reference implementations** for the new domain:
   - Published baselines, their code, their methodology
   - Benchmark datasets and evaluation harnesses

4. **Identify what's domain-specific vs. what comes from the framework**:
   - Framework: ExperimentRunner loop, CascadedJury, ResultStore, KnowledgeManifest
   - Domain: AgentInvoker impl, judges, dataset adapter, knowledge base, prompts

### Phase 3: Create Structure

Create the consumer project directory:

```bash
mkdir -p {project}/plans/{learnings,prompts,research}
mkdir -p {project}/src/main/java/{base_package}/{agent,judge,dataset,config}
mkdir -p {project}/src/test/java/{base_package}
mkdir -p {project}/datasets
mkdir -p {project}/knowledge
mkdir -p {project}/results
mkdir -p {project}/scripts
```

Copy templates from forge-methodology:
- `{forge-methodology}/templates/VISION-TEMPLATE.md` → `{project}/plans/VISION.md`
- `{forge-methodology}/templates/DESIGN-TEMPLATE.md` → `{project}/plans/DESIGN.md`
- `{forge-methodology}/templates/ROADMAP-TEMPLATE.md` → `{project}/plans/ROADMAP.md`

Create build file (pom.xml or equivalent) with dependencies:
```xml
<!-- Core experiment infrastructure -->
<dependency>
    <groupId>ai.tuvium</groupId>
    <artifactId>experiment-core</artifactId>
</dependency>

<!-- Claude SDK integration (if using Claude as the agent) -->
<dependency>
    <groupId>ai.tuvium</groupId>
    <artifactId>experiment-claude</artifactId>
</dependency>

<!-- Judge infrastructure -->
<dependency>
    <groupId>org.springaicommunity</groupId>
    <artifactId>agent-judge-core</artifactId>
</dependency>

<!-- Tracking / observability -->
<dependency>
    <groupId>ai.tuvium</groupId>
    <artifactId>tracking-core</artifactId>
</dependency>
```

Create `.gitignore`:
```
results/
knowledge/
.env
.DS_Store
target/
```

#### Create CLAUDE.md Session Bridge

Create `{project}/CLAUDE.md` defining:

1. **Project scope and mission** — What this consumer evaluates, what benchmark it uses, what improvement target it pursues

2. **Architecture context** — The consumer pattern diagram showing this project's relationship to experiment-driver

3. **Source material routing**:
   | Document | Path | Read when... |
   |----------|------|-------------|
   | VISION.md | `plans/VISION.md` | Always read first |
   | DESIGN.md | `plans/DESIGN.md` | Before implementation |
   | ROADMAP.md | `plans/ROADMAP.md` | Before starting any step |
   | Experiment-driver DESIGN-jury.md | `{experiment-driver}/plans/DESIGN-jury.md` | Understanding jury system |

4. **Two modes**:

   **Build Mode** — Implementing roadmap steps, writing agent code, building judges.

   **Optimize Mode** — Running benchmark iterations, analyzing results, modifying agent variables (KB content, tool config, prompt, scaffold).

5. **Consumer integration points**:
   - Which AgentInvoker this project implements
   - Which judges this project provides
   - How datasets are loaded (adapter pattern if non-standard)
   - Where the knowledge base lives and how it's referenced

6. **Build and benchmark commands**

7. **Not Covered** — What belongs in experiment-driver vs. this project

### Phase 4: Draft VISION.md, DESIGN.md, and ROADMAP.md

#### VISION.md

- **Problem Statement** — What gap this experiment addresses
- **Success Criteria** — Measurable:
  ```markdown
  1. Reproduce baseline X on benchmark Y (validates methodology)
  2. Variant A exceeds baseline by Z% (tests core hypothesis)
  3. Results documented for reproduction
  ```
- **Scope** — In/out
- **Unknowns** — What needs investigation
- **Assumptions** — Each is a risk

#### DESIGN.md

Fill in all sections. Pay special attention to:

**Evaluation Architecture** — Reference experiment-driver, don't reinvent:

```markdown
## Evaluation Architecture

> This project is a consumer of `tuvium-experiment-driver`.
> See `{experiment-driver}/plans/DESIGN-jury.md` for the CascadedJury framework.

### Consumer Integration

| Integration Point | This Project Provides | Framework Provides |
|---|---|---|
| Agent invocation | `{Domain}AgentInvoker implements AgentInvoker` | ExperimentRunner orchestration |
| Tier 1 judges | {DomainGuardrailJudge} | CascadedJury cascading logic |
| Tier 2 judges | {DomainStructuralJudge} | TierPolicy (ACCEPT_ON_ALL_PASS) |
| Tier 3 judge | Reuse SemanticDiffJudge or custom | CascadedJury FINAL_TIER policy |
| Dataset | {DomainDatasetAdapter} or standard layout | DatasetManager, workspace isolation |
| Results | Domain-specific analysis | ResultStore, ExperimentResult |
| KB ablation | Domain knowledge base | KnowledgeManifest snapshots |

### Judges

| Judge | Tier | Type | Evaluates |
|-------|------|------|-----------|
| {judge 1} | 1 (guardrail) | Deterministic | {fail-fast criterion} |
| {judge 2} | 2 (grader) | Deterministic | {structural invariant, NumericalScore 0-1} |
| {judge 3} | 3 (semantic) | AI | {SemanticDiffJudge or custom} |

### Convergence Criteria

Per-judge thresholds (preferred over composite loss):
- {judge 1}: > {threshold}
- {judge 2}: > {threshold}

### Experiment Variants

| Variant | What Changes | What's Constant | Hypothesis |
|---------|-------------|-----------------|------------|
| Control | Nothing (reproduce baseline) | Everything | Match published result |
| A | {variable} | {constants} | {expectation} |
| B | {variable} | {constants} | {expectation} |
| C | A + B | {constants} | {synergy} |
```

#### ROADMAP.md

Use ROADMAP-TEMPLATE.md. For consumer projects, the stages are:

**Stage 1: Consumer Scaffolding**
- Step 1.0: Design review (read experiment-driver DESIGN docs)
- Step 1.1: Project scaffolding (Maven, dependencies on experiment-core)
- Step 1.2: Quality infrastructure
- Step 1.3: Test infrastructure
- Step 1.4: AgentInvoker implementation (the domain agent wrapper)
- Step 1.5: Dataset adapter (load domain benchmark into DatasetManager format)
- Step 1.6: Domain judges (Tier 1 guardrails at minimum)

**Stage 2: Baseline Reproduction**
- Step 2.0: End-to-end smoke test (1-3 benchmark cases)
- Step 2.1: Full baseline run (reproduce published result)
- Step 2.2: Baseline analysis (per-judge scores, failure classification)

**Stage 3: Infrastructure-Level Variants**
- Step 3.0: Build domain knowledge base (mini-KBs)
- Step 3.1: Run Variant A (KB only, no prompt optimization)
- Step 3.2: Run Variant B (KB + judges-as-process)
- Step 3.3: Run Variant C (prompt + infrastructure combined)
- Step 3.4: Cross-variant comparison and analysis

**Stage N: Judges and Benchmarking** (from ROADMAP-TEMPLATE)
- Deterministic judges, AI judges, composite jury, end-to-end benchmark

### Phase 5: Review and Refine

Present drafts and ask:

1. Does VISION.md capture what you're trying to prove?
2. Is the consumer integration in DESIGN.md right — which experiment-driver components?
3. Are the judges appropriate for the domain?
4. Does the ROADMAP stage order make sense — scaffold → reproduce → variants?
5. Are there experiment-driver prerequisites that need to be completed first?
6. What would you change?

Iterate until satisfied.

### Phase 6: Define First Iteration and Handoff

1. **Prerequisites check** — Identify what experiment-driver features must be completed first. Write a prerequisites document listing:
   - What's needed, why, effort, whether it blocks
   - Recommended implementation order
   - Decision points (e.g., which agent to use, which benchmark variant)

2. **Infrastructure checklist**:
   - [ ] experiment-driver dependencies resolve (Maven)
   - [ ] Benchmark dataset accessible
   - [ ] Agent environment configured
   - [ ] At least Tier 1 judge implemented
   - [ ] Results directory writable
   - [ ] Cost estimate reviewed

3. **Git initialization** — `git init` and first commit, or repo creation

4. **Session handoff** — Write `HANDOFF-BUILD.md`:
   - Mission (implement Stage 1 of ROADMAP.md)
   - "Before You Start" checklist (read CLAUDE.md, VISION.md, DESIGN.md, ROADMAP.md, experiment-driver DESIGN docs)
   - First roadmap step with entry/exit criteria
   - "After Each Step" checklist

5. **Companion project links**:
   - experiment-driver: what it provides, current status, prerequisites
   - Research project (if any): what it produces, what this project consumes
   - Knowledge base project (if any): where domain KBs live

## Extraction Patterns

### Agent Domain Extraction

| Pattern | Extract as |
|---------|------------|
| "The baseline is...", "They achieved..." | Baseline target |
| "We should measure...", "Success means..." | Judge / convergence criterion |
| "If we change X...", "The hypothesis is..." | Experiment variant |
| "The benchmark uses...", "Dataset:" | Benchmark specification |
| "The agent does...", "It takes X and produces Y" | AgentInvoker description |
| "The ceiling is...", "Saturates at..." | Performance ceiling |
| "This fails because...", "The limitation is..." | Known failure mode → gap category |

### Baseline Extraction

| Pattern | Extract as |
|---------|-----------|
| "{N}% on {benchmark}" | Baseline result |
| "+{N}% improvement" | Improvement delta |
| "from {X}% to {Y}%" | Before/after pair |
| "{N} tasks", "{N} examples" | Dataset size |
| "cost: ${N} per run" | Cost per iteration |
| "{tool} optimization" | What was optimized |

## Tone

Be precise and empirical. Help the user define exactly what they're measuring, against what baseline, with what judges, and what "better" means quantitatively. Challenge vague success criteria.

When designing the consumer integration, reference the exemplar (refactoring-agent) concretely. Show how it implements AgentInvoker, provides judges, wires datasets — then ask "how should yours differ?"

When identifying experiment-driver prerequisites, be honest about what's ready vs. what's still in progress. Don't assume infrastructure that isn't built yet.
