# Judges and Evaluation

## What Judges Are

A judge evaluates output against criteria and produces a verdict. In Forge, judges are the feedback mechanism that drives iterative improvement in Phase 4.

Every judge follows the same pattern:

```
Input (what to evaluate) + Criteria (what "good" looks like) → Verdict (pass/fail + details)
```

## Types of Judges

### Deterministic Judges

Rule-based evaluation with binary outcomes. No ambiguity.

**Examples:**
- Test suite passes (all green / any red)
- Code coverage meets threshold (≥ 80% line coverage)
- Architecture rules hold (no circular dependencies, layer violations)
- Linting passes (no warnings at configured severity)
- Build succeeds (compiles without errors)

**When to use:** For objective, automatable criteria. Deterministic judges should be your first line of evaluation — they're fast, reproducible, and unambiguous.

### AI Judges

LLM-based evaluation for subjective or complex criteria that resist deterministic rules.

**Examples:**
- API naming quality ("Are these method names clear and consistent?")
- Documentation clarity ("Can a new user follow this tutorial?")
- Design conformance ("Does the implementation match the specification's behavioral contracts?")
- Code smell detection ("Are there leaky abstractions or god classes?")

**When to use:** For criteria that require understanding intent, context, or nuance. AI judges are slower and less reproducible, but can evaluate things deterministic judges cannot.

### Compound Judges (Juries)

Multiple judges evaluating the same artifact from different angles. The compound verdict combines individual verdicts.

**Example — Phase Review jury:**

| Judge | Type | Evaluates |
|-------|------|-----------|
| API Design | AI | Naming, signatures, encapsulation |
| Code Quality | Hybrid | Unused imports (deterministic) + edge cases (AI) |
| Grammar | AI | Spelling, clarity, consistency |
| Design Conformance | Hybrid | Class existence (deterministic) + behavioral contract (AI) |

The [Phase Review Template](../phases/phase-review-template.md) is a compound judge — it combines all four evaluations into a single review pass.

### Manual vs Automated Operation

Judges can operate at any point on the automation spectrum:

- **Manual** — A human copies the evaluation prompt to a separate AI session and copies findings back. This is how the Phase Review currently operates (see the [operational workflow](../phases/phase-review-template.md#operational-workflow)).
- **Automated** — A judge implementation programmatically spawns an evaluation agent, passes the prompt, receives structured findings, and loops until passing. This is the target state — the manual workflow is designed as a stepping stone, with self-contained prompts and severity-tagged findings that map directly to programmatic verdicts.

The key insight: structure your manual reviews as if they were automated judges. Self-contained prompts, structured outputs, clear pass/fail criteria. When automation arrives, the transition is mechanical.

## Loss Computation

For agent creation, judges produce quantitative feedback:

```
loss = 1 - (score / max_score)
```

- **score**: What the agent achieved (e.g., 7 out of 10 test cases passed)
- **max_score**: The target (e.g., 10 test cases)
- **loss**: How far from the target (0.3 = 30% gap)

The learning loop iterates until loss drops below a threshold. Loss can be computed per judge or aggregated across a jury.

## Severity-Based Verdicts

For project creation, judges produce qualitative feedback with severity levels:

| Severity | Meaning | Action |
|----------|---------|--------|
| **MUST FIX** | Bugs, design violations, incorrect behavior | Blocks progress — fix before continuing |
| **SHOULD FIX** | API issues, naming problems, missing tests | Fix before next phase starts |
| **CONSIDER** | Style preferences, minor improvements | Log in learnings, decide later |

The QA review loop iterates until zero MUST FIX findings remain.

## Building Your Own Judges

When applying Forge to a new project, define judges during Phase 2 (Design):

1. **What must be true?** → Deterministic judges (tests, coverage, lint rules)
2. **What should be true but can't be automated?** → AI judges (review prompts)
3. **How do they combine?** → Compound judge structure

Then wire them into Phase 4:
- Deterministic judges run as part of the build/test pipeline
- AI judges run as phase reviews at roadmap stage boundaries
- Compound verdicts determine whether to iterate or proceed

## Convergence

Both feedback modes have a convergence pattern:

**Loss-based (agents):** Loss decreases over iterations. If loss plateaus above the threshold, analyze capability gaps — the agent may need different tools, better prompts, or a different strategy.

**Severity-based (projects):** MUST FIX count decreases over iterations. If the same categories keep appearing, the root cause is likely a systematic issue (misunderstood requirement, wrong abstraction) rather than individual bugs.

In both cases, if iteration isn't converging, the problem is usually upstream — in the design, the research, or the vision. Return to the Discovery Loop.
