# Phase 4: Learning Loop

## Purpose

Execute the roadmap iteratively with structured feedback. This is where implementation happens — not as a one-shot effort, but as a loop that captures learnings and improves with each iteration.

## Inputs

- ROADMAP.md with ordered steps and entry/exit criteria
- Test cases or evaluation criteria
- Reference implementations (if available)

## Outputs

- Working implementation
- Learnings documents (per-step and compacted summary)
- Phase review records

## Key Activities

1. **Execute roadmap steps** — Work through the roadmap in order. Check entry criteria before starting, exit criteria before moving on.
2. **Capture learnings** — Document what you learn during implementation. Surprises, deviations from design, patterns discovered.
3. **Run phase reviews** — At the end of each roadmap stage, run a structured [phase review](phase-review-template.md) evaluating code quality, design conformance, and documentation.
4. **Fix and iterate** — Address review findings. Repeat reviews until zero blocking findings remain.
5. **Compact learnings** — Periodically distill step-level learnings into a summary document for quick reference.

## The Improvement Flywheel

Phase 4 applies the [Improvement Flywheel](../concepts/improvement-flywheel.md): run the agent, measure the loss signal, diagnose the dominant loss dimension, intervene with the correct lever, and verify the delta. The flywheel is the methodology's answer to "how do I know what to change next?" — it converts observed behavioral gaps into targeted interventions.

## Primary Feedback Modes

Phase 4's inner loop adapts based on what you're building. The agent and project variants are the two primary implementation modes. Research and steward variants adapt the same feedback-loop structure for evidence iteration and ongoing project health monitoring.

### Agent Creation — Optimization Loop

```
Execute tests → Compute loss → Analyze capability gaps → Modify agent → Repeat
                loss = 1 - (score / max_score)
```

Used when building AI agents. The feedback is quantitative — a loss function measures how far the agent's behavior is from the target. You iterate until loss converges below a threshold.

### Project Creation — QA Review Loop

```
Implement phase → QA review → Findings (MUST FIX / SHOULD FIX / CONSIDER) →
Fix issues → Re-review → Repeat until zero blocking findings
```

Used when building conventional software. The feedback is qualitative — a structured review evaluates against the design spec and coding standards. You iterate until no MUST FIX findings remain.

**Current operation**: The review runs manually — the implementation agent generates a populated review prompt, a developer copies it to a separate QA session, and findings are copied back. See the [Phase Review Template](phase-review-template.md) for the full operational workflow including handoff prompts and iteration numbering.

**Target automation**: A `PhaseReviewJudge` programmatically spawns the QA agent via an agent SDK, passes the prompt, receives structured findings, and loops until the phase passes. The manual workflow is structured to make this transition straightforward — the review prompt is already self-contained and the findings are already severity-tagged.

### Composing Feedback Modes

The modes are not mutually exclusive. Eval-agent projects that generate code (Java, Python, etc.) should apply QA reviews alongside loss optimization — best practices, design conformance, and domain-specific reviews (e.g., DDD knowledge base review for domain modeling) still apply. The optimization loop measures whether the agent improves; the QA review ensures the agent's output meets quality standards independent of the loss function.

### What They Share

Both modes use the same roadmap structure, the same learnings capture, and the same phase review gates. They differ only in how "done" is measured.

## Exit Criteria

- All roadmap steps completed (exit criteria met for each)
- Final phase review passes with zero MUST FIX findings
- Learnings documented and compacted
- Implementation matches the design (or deviations are documented and justified)

## Relationship to Other Phases

- **Consumes Phase 3** — executes the roadmap
- **Feeds Phase 5** — the working implementation is what gets documented
- **Produces learnings** — the most valuable non-code artifact of the entire methodology

## Anti-Patterns

- **Skipping phase reviews** — Moving to the next phase without structured evaluation. Bugs compound; catching them early is cheaper.
- **Ignoring learnings** — Implementing without documenting what you learn. The learnings are as valuable as the code.
- **Goldplating** — Adding features not in the roadmap. If it's worth building, add it to the roadmap first.
- **Review fatigue** — Treating reviews as bureaucracy rather than quality gates. If reviews aren't finding real issues, the checklist needs updating.
- **Never exiting the loop** — Perfection is not the goal. The exit criteria define "done," not "perfect."
