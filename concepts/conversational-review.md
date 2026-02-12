# Conversational Review

## What It Is

Using conversational AI systems (Claude.ai, ChatGPT, or similar) as iterative reviewers for discovery loop artifacts — vision documents, research findings, design decisions, and prerequisite designs. You upload your methodology artifacts along with the relevant Forge templates and ask the AI to review conformance, find gaps, and challenge decisions.

This is distinct from the [Phase Review](../phases/phase-review-template.md) used during Phase 4 implementation. Phase reviews evaluate code against a design. Conversational review evaluates *design artifacts* against the methodology and against internal consistency.

## When to Use

- **During the Discovery Loop (Phases 0–2)** — before exiting to the execution pipeline. A fresh AI session reviewing your vision, research, and design catches inconsistencies you've become blind to.
- **After writing a prerequisite design** — upload the design + the template it should follow and ask for a conformance review.
- **Before committing to the roadmap** — the transition from discovery to execution is the highest-leverage review point. Catching a design gap here saves far more than catching it during implementation.

## Why Conversational (Not Claude Code)

The review is about reasoning over documents, not reading or writing code. Conversational interfaces are better suited because they support:

- Back-and-forth clarification ("What did you mean by X in section Y?")
- Follow-up questions ("You mentioned classpath resolution as an open question — have you considered approach Z?")
- Iterative refinement — you can update the document and re-upload for another pass

Claude Code is optimized for filesystem operations and code generation. Conversational review needs neither.

## Operational Pattern

### 1. Gather the files to upload

For each review type, upload:

| Review type | Files to upload |
|-------------|----------------|
| Vision review | VISION.md, VISION-TEMPLATE.md |
| Research review | RESEARCH.md, RESEARCH-TEMPLATE.md, key supporting research docs |
| Design review | DESIGN.md, DESIGN-TEMPLATE.md, RESEARCH.md (for context) |
| Prerequisite design review | The design doc, PREREQUISITE-DESIGN-TEMPLATE.md, relevant research sections |
| Discovery loop exit check | VISION.md, RESEARCH.md, DESIGN.md, all three templates |

### 2. Structure the review prompt

Use the [Conversational Review Template](../templates/CONVERSATIONAL-REVIEW-TEMPLATE.md) for copy-pasteable prompts. A good review prompt includes:

1. **What the document is** — "This is a prerequisite design for X, part of project Y"
2. **What template it follows** — "It should follow the attached PREREQUISITE-DESIGN-TEMPLATE.md"
3. **What context it draws from** — "The research findings it's based on are in the attached RESEARCH.md, section Q1"
4. **Specific review criteria** — What you want the reviewer to check (conformance, completeness, internal consistency, gaps)
5. **Instruction to be critical** — "Flag anything ambiguous, underspecified, or that you'd push back on in a design review"

### 3. Iterate on findings

The reviewer will identify issues. For each:

- **Fix the document** if the issue is valid
- **Push back** if you disagree — explain your reasoning and ask the reviewer to reconsider
- **Add to open questions** if the issue is real but doesn't block progress

Re-upload the updated document for another pass if changes were significant.

### 4. Know when to stop

Stop when:
- No new structural issues found (the reviewer is only suggesting stylistic or minor changes)
- You've addressed or explicitly deferred all substantive findings
- The document is consistent with the methodology templates

One to two review rounds is typical. More than three suggests the document needs rethinking, not polishing.

## What This Is Not

- **Not a formal judge** — Conversational review is informal and iterative. It doesn't produce structured severity-tagged findings like the [Phase Review](../phases/phase-review-template.md). It's a design-time sanity check.
- **Not a substitute for the Discovery Loop** — The review validates artifacts, not the process. You still need to iterate between vision, research, and design.
- **Not a rubber stamp** — If you're only uploading documents to confirm they're fine, you're wasting the review. Ask for criticism.

## Relationship to Other Concepts

- Complements the [Discovery Loop](discovery-loop.md) — use conversational review to check stability before exiting
- Lighter than the [Phase Review](../phases/phase-review-template.md) — no severity tiers, no structured handoff, no iteration counting
- Independent of [Judges and Evaluation](judges-and-evaluation.md) — this is a human-in-the-loop practice, not an automated evaluation framework
