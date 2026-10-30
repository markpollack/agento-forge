# Before the code: specification mode

> **Status:** PROVISIONAL. The existing-code method has one end-to-end application; this mode has
> one pre-spike design and outside-knowledge review (28 October 2026). Neither establishes a second
> completed Assess → Maintain cycle. Output is Markdown.

## Keep before and after distinct

| Document | Written when | Evidence and maintenance |
|---|---|---|
| **Before: specification** | Before the spike | Proposed interfaces, responsibilities, invariants, scenarios and Mermaid diagrams. Label unapproved choices **proposed**; accepted intent **declared design**, with its decision. Retain this revision after implementation. |
| **After: architecture guide** | Once code exists | A separate document using the [existing-code procedure](README.md#procedure): extracted structure, observed execution and executed checks at named revisions, alongside declared design and policy. Link the spec; do not overwrite it. |
| **Changes: explanation of the difference** | When differences help readers understand the result | A third document linking exact before/after revisions, important differences, reasons, evidence and remaining uncertainty. Use the [change record](templates/CHANGES.md). If unnecessary, record that decision in the assessment. |

Use this optional pack when separate architecture views help the reader. A small change can stay
with one example and a paragraph in the normal design. Do not create these documents merely to fill
a template; once using this mode, preserve the before revision separately from implementation evidence.

Choose chapters using the same [assessment](ASSESS.md). Record **mode: specification**, baseline code
(if any), the proposed scope, intended readers and the decisions they need to make. A system can mix
existing and proposed parts, but identify them separately in text and figures.

## Specify enough to challenge

Use the [specification skeleton](templates/SPECIFICATION.md) in this order:

1. State the scope, readers, baseline and evidence status.
2. Write complete consumer programs or visible flows first: configuration, ordinary action, result,
   next action and cleanup, with consequential failure/cancellation paths. Define helpers and explain
   where the result lives. Usually 2–3 examples cover an ordinary feature, 3–4 a stateful client;
   use fewer when enough. These are starting sizes, not quotas.
   Callable programs may receive configured dependencies; state their setup and ownership boundary.
   **Today versus proposed:** for every main task, put existing code at a pinned repository revision
   and source location beside the proposed program/flow, or state that no current path exists.
3. List the **complete public API before mechanisms**: in-scope types, constructors, methods, overloads,
   configuration, result/error types and exceptions, including existing entry points the programs use.
   Label every entry **existing at a named revision** or **proposed**, with full signatures. For a
   product flow, list user actions, visible outcomes and errors instead of inventing an API.
   Put large existing definitions in a pinned appendix. Account for relevant inherited/generated
   members and changed/retired entry points; do not inventory unrelated dependency APIs.
   Inventory every existing public path to the same capability, including lower-level APIs absent
   from the new examples. Retain with a reason it does not bypass the contract, route through it
   with the enforcement point named, or remove with replacement/loss stated. Use one public way
   per capability unless a reason is recorded; a type-migration row alone is insufficient.
4. For each significant operation answer: what was accepted; what normal return guarantees; what
   happens on failure/cancellation; what the consumer can safely do next; and who owns what remains.
   Give each contract an addressable heading. Submission and result retrieval are different boundaries;
   required processing and optional observation have different responsibilities. Record deliberate absences.
   If startup fails after acquisition, name remaining ownership and diagnostics/cleanup access even
   when no usable handle returns. Distinguish borrowed dependencies from resources the system owns.
5. Summarize selected precedent: actual source guarantee, differing assumption, reuse/adapt/avoid.
   Resolve routine conventions; take material tradeoffs to the owner.
6. Place relevant requirements and acceptance scenarios next, inline or by reference to the project's
   existing source. Keep adopted requirement IDs and sources visible. Every active requirement maps
   to an operation promise or named safeguard; withdraw untraced rules with IDs reserved. A safeguard
   names a hazard, protected party, rationale and check. Preserve explicit deferrals separately.
7. Only then describe ownership, state changes, data, error handling and selected conceptual views.
   Every mechanism cites its promise or safeguard. Record decisions, alternatives and assumptions;
   each assumption has a question for the spike to answer.
8. Plan acceptance evidence and review using **consumer need → operation postcondition → mechanism
   → test evidence**. A postcondition is what is true on return. Before code, name the scenario and
   assertion; after code, cite actual checks, revisions and limits.

This order does not require a separate requirements document or audit tool. Choose section size by
what the feature needs. The [guide](../../guides/consumer-first-design.md) supplies an invented example
and a prompt for a design session.

Draw only the views selected by those questions, in fenced Mermaid blocks:

- **Class:** concepts, identity/value distinctions, ownership and interfaces.
- **Sequence:** one scenario, with error, cancellation or retry branches where consequential.
- **State:** legal transitions, their owner and guards, including failed termination.
- **Flowchart:** decisions and boundaries, especially human approval and model/code control.

Each authored figure is **conceptual** and also names its design status, **proposed** or **declared
design**. Diagrams make a proposal inspectable; they establish what is specified, not that it works.
Compiling a proposed signature checks syntax/types; it remains proposed until implemented.
Do not infer runtime behavior from a stub. Render each diagram and inspect it at
reading size. Check that every arrow and state agrees with the prose; record untested quality claims.

## Review before the spike

1. Read complete examples before any earlier findings, then contracts, mechanisms and checks.
   Select applicable [review lenses](../../concepts/review-lenses.md): requirements fidelity,
   adversarial fidelity and consumer code (1, 7, 11), plus other relevant lenses. Judge usability and
   correctness at this same checkpoint, asking for concrete breaking cases and recorded searches.
2. Run an additional **outside-knowledge review in a fresh Codex session**. Give it the pinned spec,
   authoritative requirements, baseline source for claims about existing behaviour, and a named
   outside knowledge base at a recorded revision or snapshot. Exclude the author's conclusions,
   previous reviews, receipts and journals. Permit only explicit decision references needed to read
   the spec. Use the [review prompt](templates/OUTSIDE-KNOWLEDGE-REVIEW.md).
3. The reviewer cites the knowledge-base passage and the spec section for each finding, constructs
   the conflicting scenario, and states where a pattern does not apply to this system. Knowledge is
   a source of questions, not authority to override requirements.
4. Classify findings **validates / additive / reopens**, and confidence **verified / reasoned /
   uncertain**. Reproduce each material finding in the cited text or baseline code. Record disposition
   and retain prior revisions. The human owner accepts the corrected specification before the spike;
   a machine review cannot ratify it.

The outside-knowledge pass is a **review protocol applied to existing lenses**, especially precedent
and inverted gap-hunt (2 and 3). It is not a separate lens: it changes the reviewer's inputs and
independence, rather than naming a distinct stakeholder concern. Reconsider after another application
shows a failure class the existing lenses cannot express.

This page and the prompt describe how to launch that review. Reading or editing them does not count
as having run a fresh reviewer.

## Ready for the design checkpoint

- A consumer can explain the main result and next action.
- Each main task compares pinned current code with the proposal or records no current path.
  Every existing path has a disposition and non-bypass reasoning where retained; multiple public
  ways to one capability have a recorded reason.
- Ordinary use needs no internal-state knowledge or unexplained conversions/extra waits.
- Significant operations answer all five questions; relevant acceptance, completion,
  failure/cancellation, cleanup and ownership boundaries are clear.
- The complete in-scope surface labels existing/proposed entries, including errors and helpers.
  Syntax compilation and implementation evidence are distinct.
- Important promises and safeguards have verification scenarios and trace. Limits and deferrals
  are visible, untraced rules are withdrawn with IDs reserved, and nothing blocks implementation planning.

This checklist belongs to the existing review, alongside applicable Phase 2 gates. Planned checks
are sufficient before implementation; record actual evidence afterwards. Review does not ratify
implementation behavior or authorize a new project step by itself.
For an intermediate API checkpoint, name what can be reviewed now and which decisions still block
the complete design. Record those limits rather than calling a partially specified feature ready.

## After the spike

Freeze a link to the reviewed before revision. Generate the after guide from the implementation at a
named revision; rerun selected scenarios and report what they establish and leave unexercised.
Compare contracts, ownership, failure/cancellation behaviour and important quality claims. Explain
material differences in the third document, including changed decisions and failed assumptions.
Never relabel a proposed diagram as observed merely because code now exists.

## Evidence behind this mode

A session/concurrency specification and fresh DDD-knowledge review on 28 October 2026 supplied the
first example: proposed API, a sequence diagram, cancellation table and four scenarios. Six findings
were classified as validating or additive; none requested reopening. The record is private and cited
by date. The later implementation and before/after/change cycle are not claimed as completed.
