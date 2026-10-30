# <System>: specification before implementation

> Mode: specification · Revision: <commit or snapshot> · Status: proposed / accepted intent
> Baseline code: <repository@revision or none> · Assessment: <link>
> This before document is retained. After guide: <pending/link> · Changes: <pending/link/decision to omit>

<!-- Choose sections by reader questions. A small change may need one example and a paragraph in
its ordinary design document rather than this separate spec. Usually 2–3 examples cover an ordinary
feature, 3–4 a stateful client; these are starting sizes, not quotas. Delete unused sections and
instructions. Label accepted intent as declared design with a source/decision; mark assumptions.
Authored Mermaid figures are conceptual and also carry their design status. -->

## Purpose, readers and boundary

<Who needs this feature, what they can do, what readers must decide, scope and important constraints.>

## Complete consumer examples or visible flows

<Programs from configuration through operation, result use, ordinary follow-up and cleanup.
Include imports, concrete values and defined helpers. Label invented syntax. Add failure/cancellation
paths where they change the promise. Explain what the result means and where artifacts live.
For a product feature: entry point → action → visible outcome → next action, including stop/retry.>

A complete example may be a callable function with configured dependencies passed in. State who
configures/owns them; do not invent application infrastructure just to make a standalone main method.

### Today versus proposed

For each main consumer task, put today's program or visible flow next to the proposed one. Pin
existing code to its repository revision and source locations. Compare results, follow-up, failure
and cleanup as well as calls. State explicitly when the task has no current path.

| Main task | Today: program/flow and pinned code | Proposed program/flow | Changed promises and migration |
|---|---|---|---|
| | | | |

Place long programs adjacent under each task rather than inside the table.

### Existing-path inventory

Inspect the pinned code for every public way to reach the same capability today, including
lower-level APIs, factories and returned handles absent from the proposed examples. Scope this
by capability, not by what the new API calls; exclude unrelated capabilities.

| Capability | Existing public path / pinned source | Retained / routed through new contract / removed | Contract enforcement or removal; reason |
|---|---|---|---|
| | | | |

For a retained path, explain why it does not bypass the new contract. For a routed path, identify
where the guarantees are enforced. For removal, name the entry points and their replacement or
deliberate loss. Default to **one public way per capability unless a reason is recorded**, including
compatibility exceptions. A single type-migration row cannot settle all public paths to the capability.
If none exist, record the inspected scope and revision (or no baseline for greenfield).

## Public API or visible operation surface

List the complete in-scope public types, constructors, methods/overloads, configuration, result types,
errors and exceptions, including existing entry points the examples use. Give full signatures.
Label **each entry** existing at a named revision or proposed. Accepted or compiled proposals remain
unimplemented until evidence shows otherwise. For product flows, list actions, visible outcomes and
errors instead of inventing an API. Keep mechanism details below this surface.
Link large existing definitions in a pinned appendix. Name relevant inherited/generated members
and compatibility effects of changed/retired entries. Exclude unrelated dependency APIs explicitly.

| Type / full signature or visible action | Existing at revision / proposed | Operation contract |
|---|---|---|
| | | |

## Operation contracts

### <Operation anchor and name>

1. **Accepted:** <request, inputs, preconditions, rejection boundary>
2. **Normal return:** <what is now true, what the result means, what may still be pending>
3. **Failure or cancellation:** <reported outcome, possible prior effects and unsettled work>
4. **Next action:** <what is safe, with any health/ownership/competing-caller conditions>
5. **Ownership:** <remaining resources/artifacts, owner and release duty>

Repeat for significant operations: those changing work, state, ownership or permitted next actions,
or presenting a waiting/failure boundary. Simple accessors can share answers. Submission and result
retrieval have separate return boundaries. Separate required processing from optional observation.
If acquisition can partially fail, state remaining ownership and how diagnostics/cleanup are available
without a successfully returned handle. Distinguish borrowed dependencies from owned resources.

Deliberately absent or deferred surface: <what, why, and when it would be reconsidered>.

## Selected precedent and platform baseline

<Platform/version constraints. Use the relevant research already collected.>

| Consumer problem | Pinned source and actual guarantee | Assumption that differs here | Reuse / adapt / avoid |
|---|---|---|---|
| | | | |

Resolve routine conventions; bring material tradeoffs or conflicting expectations to the owner.

## Requirements and acceptance scenarios

<Inline applicable requirements and scenarios, or link their existing authoritative source. Retain
IDs, strengths and source references where present, including adopted external requirements. Do not
create a separate document simply to fill this section. Every active rule names an operation promise
or a safeguard: a concrete hazard, whom it protects, its rationale and a check. Withdraw untraced
rules with IDs reserved; retain genuine deferrals separately. Scenarios state context, action and
observable outcome. The trace below connects them to mechanisms and evidence.>

## Mechanisms, vocabulary and responsibilities

<Only now describe concepts, ownership, data, state changes, invariants and failure handling needed
to keep the promises. Each mechanism cites its operation contract or safeguard. Choose conceptual
Mermaid class/sequence/state/flowchart views by reader questions; name guards and invariant owners.
Render and inspect figures. Proposed diagrams establish intent, not runtime behavior.>

## Decisions and assumptions

| Choice or assumption | Source and rationale | Alternatives | How the spike could refute it |
|---|---|---|---|
| | | | |

## Trace and acceptance evidence

**Consumer need → operation postcondition → mechanism → test evidence.** A postcondition is what
becomes true on return. Walk both directions: promises need checks; mechanisms and rules need reasons.

| Need / example | Operation promise or safeguard | Requirement / source, if any | Mechanism / decision | Scenario and expected outcome | Evidence / limits |
|---|---|---|---|---|---|
| | | | | | |

Before code exists, name the planned assertion and schedule. After implementation, record what
actually ran, its revision/result and limits. Distinguish prototype compilation, source inspection,
deterministic tests and live conformance. Compiling signatures does not establish proposed behavior.

## Review, readiness and acceptance

Read complete examples before any earlier findings; then contracts, requirements, mechanisms and
checks. Review usability and correctness at this same checkpoint, including consumer-code lens 11
alongside requirements/adversarial fidelity and other applicable lenses. Construct breaking or
confusing cases; record searches that find none. The fresh outside-KB protocol continues to exclude
prior reviews entirely. Retain prior spec revisions and obtain owner acceptance before the spike.

- [ ] A consumer can explain the main result and next permitted action.
- [ ] Each main task compares pinned current code with the proposed program/flow, or records no
      current path. Every existing public path is retained with a non-bypass reason, routed through
      the contract, or removed; multiple public ways to one capability have a recorded reason.
- [ ] Ordinary use needs no internal-state knowledge or unexplained conversions/extra waits.
- [ ] Significant operations answer all five questions; relevant acceptance, completion,
      failure/cancellation, cleanup and ownership boundaries are clear.
- [ ] The complete in-scope surface labels existing/proposed entries, including errors and helpers;
      compilation status is separate from implementation evidence.
- [ ] Important promises and safeguards have verification scenarios and trace. Untraced rules are
      withdrawn with IDs reserved. Limits/deferrals are visible; nothing blocks implementation planning.

<Applicable lenses; pinned outside KB and fresh review prompt/review; reproduced findings and
dispositions; owner's acceptance. Keep the existing applicable Phase 2 gates. Review and planned
checks are not proof that an implementation conforms.>

Intermediate checkpoint, if any: <what is ready for review now; decisions and evidence still blocking
the complete design>. Do not treat this partial checkpoint or a stub compile as full design readiness.
