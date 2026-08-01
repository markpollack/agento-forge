# Review Lenses — A Stakeholder-View Catalog for Design and Contract Review

> **Added**: 2026-07-23 · **Provenance**: distilled from the agent-workflow v3 discovery + Stage-0 arc
> (2026-07; `agent-workflow/plans/v3/` — reviews, gap-hunt, spikes, journals), which rediscovered the
> SEI documentation/evaluation program empirically and extended it.
> **Classical anchors**: Clements, Bachmann, Bass, Garlan, Ivers et al., *Documenting Software
> Architectures: Views and Beyond* (2nd ed., SEI Series) — *choose views by stakeholder concerns; a
> stakeholder without a view has concerns that are silently unmet* · Kruchten's 4+1 view model ·
> ISO/IEC/IEEE 42010 (stakeholder / concern / **viewpoint** = reusable lens template / **view** = its
> application) · SEI ATAM (scenario-based architecture evaluation — the adversarial-review ancestor) ·
> Jacobson/UML use-case **actors** ("As a User, I need to…" — the persona-verb matrix's direct ancestor).

## The principle

**A design review is not one activity. It is a stack of viewpoints, and each catches a failure class
the others structurally cannot.** Validation-framed review is confirmation-shaped: it certifies that
what was asked for is satisfied, and is silent about what was never asked. Completeness therefore
requires *paired* lenses — validating and inverting, describing and commanding, insiders and cold
outsiders. The empirical demonstration (v3, one week): five adversarial review rounds, a gap-hunt, two
spikes, and two audits **each caught something all the others missed** (receipts table below).

## The catalog

| # | Lens (viewpoint) | The question it asks | Failure class it catches | v3 receipt |
|---|---|---|---|---|
| 1 | **Requirements fidelity** (traceability) | Does the design satisfy each *named* requirement, genuinely — cited, not asserted? | Paper-only satisfaction | Reviews 1–2: 5 of 10 requirements found PAPER-ONLY |
| 2 | **Precedent / teardown** | How did systems with decades of production scars solve this? What do we steal/avoid? | Reinvention; unknowingly re-entering known traps | Kestra (config-creep), CDK (token bugs), Dagger (LLM-cache refusal), jury-model reuse |
| 3 | **Inverted gap-hunt** | Enumerate *their* machinery; interrogate *our* silence. Every absence must be a decision, not a blind spot | Blind spots that validation cannot see (it only grades what was asked) | G20 (evolution rule excluded new envelope kinds), the missing control plane, the dropped blob-spill lesson |
| 4 | **Producer-coverage audit** (state/verb closure) | Does every state, status, and event have a contracted producer, an engine-internal marking, or a reserved named owner? | Describable-but-uncommandable states | `WorkflowAborted` carried a required payload field with no producible value |
| 5 | **Persona-verb matrix** (actor-goal closure) | For each persona — author, approver, submitter, observer, recipient, **operator**, **administrator** — is their year-one verb set closed? | Entire missing personas (the ones who never wrote a brief) | Operator/admin personas absent → no cancel/pause/submit/re-drive; two silently open cells (deploy, result-fetch) |
| 6 | **Second implementation** (cold producer/consumer) — protocol: [`../guides/second-implementation-protocol.md`](../guides/second-implementation-protocol.md) | Build a minimal *independent* implementation against the contract — what does a cold reader construct differently? | Hidden assumptions shared by everyone inside the design; interop divergence | The Python spike found the dispatch-input/catalog-schema gap that 5 review rounds + both audits missed |
| 7 | **Adversarial fidelity review** | Ignore the architecture (it's decided): does the normative text faithfully implement the decisions, precisely enough that two independently developed parties interoperate without hidden assumptions? | Precision gaps between decision and normative text | Contract rounds 1–5 (round 1: 3 MUST/8 SHOULD on a "complete" draft) |
| 8 | **Conformance vectors** (narrow byte-level) | For the few places where byte-identity is semantic (hashing, canonicalization): committed normative vectors, dual-attested — implementations byte-compare, never regenerate | Cross-language divergence invisible to schema validation | The non-BMP vector (😀 vs ﬓ) caught Python's code-point sort diverging from JCS UTF-16 order — an ASCII-only corpus could never catch it |
| 9 | **Decision-provenance journaling** | Record *how* each decision was made — the argument, the alternatives declined, the boundary conditions for revisiting | Blind re-litigation; loss of the reasoning when only the conclusion survives | `journal/` — never-migrate (the pointless-or-dangerous argument), the no-design-review verdict |

**The governing protocol across all lenses**: every finding is classified **(a) validates** an
existing decision · **(b) additive** (backlog, with a one-line sketch) · **(c) would touch the
signed-off design/contract** — and only (c) reopens anything, at a deliberately high bar (evidence of
defect or major missed opportunity, not taste). This keeps the lens stack honest in both directions:
findings can neither be ignored nor casually churn settled architecture.

**The evidence standard under every lens**: a finding is an **exhibit**, not an assessment, and a
non-finding is a **recorded search** — see [`refutation-by-counterexample.md`](refutation-by-counterexample.md).
A lens that returns opinions has been pointed correctly and prompted wrongly: ask it to *construct* the
breaking case, not to *judge* the artifact. Where the findings then go — graded, fixed, refuted, filed
or parked, and finally ratified — is [`act-pipeline.md`](act-pipeline.md); what a gate reports when the
lenses are done is [`../phases/phase-review-template.md`](../phases/phase-review-template.md).

## Phase mapping (when to apply which lens)

- **Phase 1 (research)**: lens 2 (teardowns) — and pair every validation-framed research pass with a
  lens-3 inversion pass before declaring the space understood.
- **Phase 2 gate (design)**: lenses 1 + 7; lens 9 continuously.
- **Contract / interface freeze gates**: lenses 4 + 5 + 7 as *standing* gate dimensions, lens 6 as a
  **pre-freeze spike** (the cheapest moment a cold implementation can move the contract), lens 8 for
  the byte-semantic corners.
- **Any "should new research reopen the design?" moment**: lens 3 with the (a)/(b)/(c) protocol.

## The Views-and-Beyond connection, made operational

The book's principle — *documentation is for stakeholders; choose views by their concerns* — is the
**design-time** half. This catalog is the **review-time** half: each stakeholder concern gets not only
a view that documents it but a lens that *interrogates* it. The persona-verb matrix is the use-case
actor table reborn; the adversarial rounds are ATAM's scenario walkthroughs sharpened into verdicts;
the traceability table is the view-to-requirement mapping the book's templates always demanded. What
the classical program lacked — and what agentic execution makes cheap — is lenses 3, 6, and 8: paying
for a *cold independent implementation*, an *inverted enumeration of a neighboring domain's machinery*,
and *committed byte vectors* was prohibitive when reviews were meetings; it is an afternoon when
reviews are sessions.

## References

Clements, Bachmann, Bass, Garlan, Ivers, Little, Merson, Nord, Stafford — *Documenting Software
Architectures: Views and Beyond*, 2nd ed. (Addison-Wesley, SEI Series) · Kruchten, "The 4+1 View Model
of Architecture" (IEEE Software, 1995) · ISO/IEC/IEEE 42010 · Clements, Kazman, Klein — *Evaluating
Software Architectures* (ATAM) · Jacobson — use-case-driven design.

Empirical corpus: the originating effort's planning tree (reviews 1–2, contract rounds 1–5, the
gap-hunt, the two cold spikes, the decision journal, the gap-hunt disposition). **That tree is private
and not readable from this repo** — which is why the receipts above are summarized here rather than
cited by path. Nothing on this page should require opening it.
