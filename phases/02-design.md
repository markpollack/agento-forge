# Phase 2: Design

## Purpose

Start with what a consumer should be able to do. Write complete programs or user flows, state what each operation guarantees, then design the machinery that delivers those promises. Record decisions and their reasons.

## Inputs

- VISION.md (stabilized or stabilizing)
- Research findings from Phase 1
- Reference implementation analysis

## Outputs

- **DESIGN.md** — technical specification (see [template](../templates/DESIGN-TEMPLATE.md))
- **Design decision records** — one per significant architectural choice, with rationale and alternatives considered

## Key Activities

1. **Write complete examples first.** Show configuration, one ordinary operation, the result, the next
   action and cleanup. Add failure or cancellation paths where they change what the consumer can do.
   Explain what the result contains and where any saved artifacts live. Define helpers and label
   invented syntax. For a product feature, show entry point → action → visible result → next action.
   A callable example may take configured dependencies from its caller; state their setup and ownership
   boundary instead of inventing application infrastructure to make every example a standalone main.
   **Today versus proposed:** for each main consumer task, put the existing program or visible flow
   beside the proposed one. Pin today's code to a repository revision and source locations; record
   when a task has no existing path. Compare results, follow-up, failure and cleanup, not just syntax.
2. **State the public contract.** List the complete public surface within the feature's scope:
   types, constructors, methods, configuration, results and errors, including existing entry points
   the examples need. Label each **existing at revision** or **proposed**. For a visible flow, list
   user actions, outcomes and errors instead. Answer the five questions below for each significant operation.
   Large existing definitions can live in a pinned appendix. Name inherited/generated members that
   matter and compatibility effects of changed/retired entries; do not inventory unrelated dependencies.
   Build an **existing-path inventory** from that pinned code: every public way to reach the same
   capability today, including lower-level APIs, factories and returned handles even when the new
   examples do not use them. Mark each retained, routed through the new contract, or removed.
   For retained paths, explain why they do not bypass the new contract; for routed paths, name where
   its guarantees are enforced. Default to one public way per capability; record the reason for any
   exception. A single type-migration row does not account for all paths to that capability.
3. **Apply selected precedent.** Use the platform conventions and closely matched references from
   research. Record the actual guarantee, the assumption that differs here, and what to reuse,
   adapt or avoid. Resolve routine conventions; ask the owner about material tradeoffs.
4. **Design the mechanisms.** Choose ownership, data, state changes, error handling and diagrams
   needed to keep those promises. Trace each mechanism and binding requirement to an operation's
   promise or a named safeguard. A safeguard names a concrete hazard, whom it protects and how to
   check it. Withdraw untraced rules, reserving their IDs; retain explicit deferrals separately.
5. **Review and plan verification.** Read complete examples before earlier findings. Review usability
   and correctness at the same design checkpoint (consumer-code lens 11 alongside lenses 1 and 7).
   Define observable checks before implementation; use controlled schedules for important races.
6. **Finish the supporting design.** Record decisions and alternatives, research unresolved gaps,
   and define build coordinates if producing artifacts. Let the questions above determine which
   architecture views and further detail are useful.

### Five questions for each significant operation

1. What operation was accepted, with which inputs and preconditions?
2. What does normal return guarantee, and what does the returned result mean?
3. What happens on failure or cancellation; what may still be happening?
4. What may the consumer safely do next?
5. Which resources or artifacts remain owned, and by whom?

Include a failed-startup path when acquisition can fail after taking resources: what can the caller
inspect or clean up if no usable handle was returned? Distinguish borrowed resources from owned ones.

An operation is significant when it changes work, state, ownership or the next permitted action,
or has a waiting/failure boundary. Simple accessors with identical behavior can share an answer.
Submission and waiting for its result have different return boundaries. Separate required processing
from optional observation: a display callback must not silently acquire responsibility for finishing work.

### Keep it proportional

A small change needs **one complete example and a paragraph** answering the questions and naming its
check. An ordinary feature often needs two or three examples. A stateful client often needs three or
four: success with a follow-up, independent work with targeted cancellation, and retained lifetime or
failure/timeout/close where relevant. These are starting sizes, not quotas. Add an example when it
reveals a different promise; do not create a fixed stack of documents. The
[guide](../guides/consumer-first-design.md) includes a worked example and a design-session prompt.

Use this trace, in a table or a sentence:

**Consumer need → operation postcondition → mechanism → test evidence.**

A postcondition is what becomes true when the operation returns. Before implementation, the evidence
column names the planned scenario and assertion. Afterwards it cites the actual check, revision and
result. A compiled prototype proves syntax and types, not cleanup, cancellation or live behavior.

## Optional provisional architecture specification

When dogfooding architecture documentation before a spike, keep the **before specification** separate
from the later **after guide** and, when useful, a third **changes** document. Select views by reader
questions. Use Markdown with conceptual Mermaid class, sequence, state or flowchart diagrams, labelled
**proposed** or, for accepted intent, **declared design**. Proposed diagrams do not prove runtime behaviour.
Review with applicable lenses and a **fresh Codex session** given the pinned spec, baseline code for
existing claims, and a named outside KB; exclude author conclusions and earlier reviews. Findings cite
passages and breaking scenarios, classified validates / additive / reopens; reproduce them and obtain
owner acceptance before the spike. Retain prior spec revisions. The
[provisional pack](../provisional/architecture-documentation/SPEC-MODE.md) supplies templates; this
opt-in method stays dogfood-only until another project completes and reviews the full cycle.

## Consumer readiness check

Before calling the design ready, check that:

- A consumer can explain the main result and the next permitted action.
- Each main task compares pinned current code with the proposal, or records that no current path
  exists. Every existing public path has a disposition; retained paths cannot silently bypass the
  contract, and multiple public ways to the same capability have a recorded reason.
- Ordinary use needs no internal-state knowledge or unexplained conversions or extra waits.
- Acceptance, normal completion, failure/cancellation, cleanup and ownership are clear where relevant;
  significant operations answer all five questions.
- The complete in-scope surface distinguishes existing behavior from proposals, including errors and
  helper signatures. Compilation status is separate from implementation status.
- Important promises and safeguards have verification scenarios; mechanisms and requirements trace
  back to them. Limits and deferrals are stated; no unresolved issue blocks implementation planning.

This check is part of the existing design gate. It does not claim implementation evidence before code exists.
At an intermediate API checkpoint, state what is ready for review and which decisions still block
the full design. Do not mark the complete design ready merely because its first section compiles.

## Exit Criteria

- Design document covers all scope items from the vision
- The consumer readiness check above passes. Each binding requirement cites an operation promise or
  named safeguard, its design decision/mechanism and its planned check. Use a compact table when
  there are several requirements; assertions without citations remain unverified (lens 1).
- Every significant decision has a recorded rationale; **decisions whose *reasoning* must survive re-litigation get a decision-journal entry** (lens 9)
- Interfaces are specified enough to write against (method signatures, data models, error handling)
- **If the design defines a contract/wire interface**: the **producer-coverage audit** (every state/event has a producer, an internal marking, or a reserved owner — lens 4) and the **persona-verb matrix** (each persona's year-one verb set closed — lens 5) pass; a **cold second-implementation spike** is scheduled pre-freeze (lens 6); byte-semantic corners (hashing/canonicalization) get committed conformance vectors (lens 8)
- **If a model drives workflow steps** (a conversational agent, a skill, an AI step in a workflow): the design's **Model / Code Boundary** section is filled — the model produces a structured intent, code decides every state change — and every prompt rule that would change state if ignored has a behavioural test, reviewed under lens 10 before the first live rehearsal ([model-code-boundary](../concepts/model-code-boundary.md))
- The design gate runs as an **adversarial review** (fidelity framing — lens 7), not a self-assessment — in a session that has *none* of your accumulated context, asked for criticism rather than confirmation ([conversational review](../concepts/conversational-review.md))
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
