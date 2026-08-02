# The Concepts Register

> **None of this is required reading.** To run Forge you need your project's trio (VISION / DESIGN /
> ROADMAP) and the phase you are in. The concepts are **case law**: why a rule is what it is, and the
> evidence behind it. Every rule that is needed *to act* has been distilled into the templates and phase
> docs already.
>
> **How to use this page**: read the rules column. Each rule is complete on its own — you can act on it
> without opening anything. Open a page only when its *read this when* row describes the situation you
> are actually in. Rows are grouped by the moment the rule bites, not alphabetically.
>
> **If acting correctly ever requires reading one of these pages, that is a defect** — the rule has not
> been distilled into the template where the session meets it. Report it as one.

---

## A. You're starting an effort (Phases 0-2)

| The rule | Read this when | Page |
|---|---|---|
| Iterate vision → research → design until all three tell the same story, then commit and stop iterating; once you have committed, run roadmap → build → docs in order, and when execution proves the design wrong go back to discovery rather than pushing forward. | You have been round the loop once and cannot tell whether to go again or start a roadmap — or a roadmap step has turned out to be impossible as designed. | [discovery-loop.md](discovery-loop.md) — *the two loops* |
| Save the conversations the project started in, cite them by file and section, and distill them into vision and research — don't reconstruct them from memory. | The project began as chat, not as a document. | [conversation-bootstrapping.md](conversation-bootstrapping.md) |
| Give working knowledge four homes — `learnings/` (what a step taught), `journal/` (what we decided and why), `research/` (what we're drawing on), `inbox/` (what arrived) — and never rewrite a record to agree with the present: supersede it, or correct it beside its original words. | You're filing something and don't know where it goes; or a document you wrote has turned out to be wrong. | [project-knowledge-layout.md](project-knowledge-layout.md) |
| A tool the main design depends on gets its own lightweight design *first* — its output format becomes an input contract for the project. | Research revealed you must build or mine something before you can design the real thing. | [prerequisite-designs.md](prerequisite-designs.md) |
| A claim is ready when external validity, reproducibility and methodological honesty are each **bounded and documented** — never when they reach zero. | Research variant: deciding whether a claim is ready to defend. | [research-loop.md](research-loop.md) |
| Navigate a paper corpus through a hierarchy of summaries (overview → cluster → paper → full text); don't chunk and embed. | Phase 1 has more sources than you can read and you are about to reach for a vector store. *(This page is a design proposal for unbuilt tooling — read it for the navigation argument, not as a spec.)* | [research-agent.md](research-agent.md) |

## B. You're deciding something (Phase 2)

| The rule | Read this when | Page |
|---|---|---|
| State a decision as a **predicate over artifacts** — something an observation could contradict — and name it in the exit criterion that defends it (`defends DD-23`); a decision no criterion names is undefended, and you can see that without a taxonomy. | You're writing a design decision, or writing the step that is supposed to keep it true. | [decision-enforcement.md](decision-enforcement.md) |
| One word, one meaning, within one context — and where two contexts legitimately differ, write the translation where they meet. Classify occurrences by *sense* before any sweep, and never re-spell a word inside a quotation. | Two constructs are competing for a name, a rename keeps being re-argued, or someone is about to find-and-replace. | [vocabulary-law.md](vocabulary-law.md) |
| Decide during design what a verdict is: deterministic judges for what must be true, AI judges for what resists automation — and write every manual review as if a program would run it. | You're specifying the Phase-4 feedback loop for an agent or a project. | [judges-and-evaluation.md](judges-and-evaluation.md) |
| Build a knowledge base so any file is reachable in **≤3 hops** from a routing table, and state in every index what the KB does *not* cover. | You're designing knowledge an agent will read at runtime, or a KB has outgrown its index. *(Federation and the curator/navigator split are the second half of this page.)* | [knowledge-base-architecture.md](knowledge-base-architecture.md) |

## C. You're building (Phases 3-4)

| The rule | Read this when | Page |
|---|---|---|
| A check is trusted only after you have **watched it go red** on the defect it claims to catch; and a lesson that bites twice graduates from prose into the harness — the template, the scaffolding, the shared build — not into one project. | You're adding a check; a sweep reports clean; or you're about to write "be careful about X" in a learnings file for the second time. | [quality-infrastructure.md](quality-infrastructure.md) |
| End every session with a written work order — reading order, do-this-now, run mechanics, guardrails, a STOP condition — because sessions are disposable and the repo is the memory. A dispatched report is a claim: re-run it before accepting it, starting with its claims about its own discipline. | A session is ending, or you're dispatching a step to another repo's session. *(§ The Supervisor Pattern for the coordinator role.)* | [session-handoff.md](session-handoff.md) |
| When a step hits a question too big to absorb and too load-bearing to defer, run a **bounded parallel effort** whose deliverable is work items scheduled into the delivery roadmap — and write "adopt nothing" in as a legitimate outcome, in those words. | Delivery is going fine and a step just found something the plan cannot absorb: a circular measurement, an analogy borrowed from the wrong field, a claim nobody can state precisely. | [research-diversion.md](research-diversion.md) |
| Run → measure → diagnose which loss dimension dominates → pull the one lever that fits it (prompt, knowledge, execution structure, model, rubric) → verify the delta *and* check for regressions. Knowledge cannot fix a reasoning gap. | An agent is underperforming and you are choosing what to change next. | [improvement-flywheel.md](improvement-flywheel.md) |
| Give the agent an escape hatch and log every call to it: each call is a knowledge gap, and the metric that matters is calls-per-run falling to zero. | An agent finishes its tasks, but only with hand-holding, and you want to know what it's missing. | [oracle-learning-loop.md](oracle-learning-loop.md) |

## D. You're reviewing — or disposing of what a review found

| The rule | Read this when | Page |
|---|---|---|
| A finding is an **exhibit the receiver can run**, not an assessment; a non-finding is a **recorded search** that states the method which could have found the thing. A MUST without its breaking case is a SHOULD. | You're writing a review prompt, grading findings, or about to claim something is complete. | [refutation-by-counterexample.md](refutation-by-counterexample.md) |
| A review is a stack of viewpoints, each catching a failure class the others structurally cannot — so pair every validating lens with an inverting one, because validation is silent about what was never asked. | You're gating a design or freezing a contract and choosing review coverage. | [review-lenses.md](review-lenses.md) |
| Before committing to a roadmap, hand the trio to a fresh session that has none of your context and ask it for **criticism, not confirmation**. | You think discovery is done. | [conversational-review.md](conversational-review.md) |
| To change something already decided: proposal → cold machine review on **restricted inputs** → fix round with prior revisions retained under supersede banners → humans on the **post-fix artifact only** → one lockstep ratification. | A frozen contract, a ratified decision, or a public API has to move. *(§ Team review for what humans are actually for here.)* | [act-pipeline.md](act-pipeline.md) |
| Write a known gap as a check that **passes because the thing is missing and fails the moment it exists**, naming its owning step; and end every finding in one of four states — fixed with the exhibit committed, refuted with evidence, filed with a named owner, or parked with a trigger. | You're deferring something, or disposing of a review's findings. | [registers-of-absence.md](registers-of-absence.md) |

## E. You're shipping, or maintaining what shipped (Phase 5 and after)

| The rule | Read this when | Page |
|---|---|---|
| Every document is a tutorial, a how-to, a reference, or an explanation — one per document, and split it when it drifts. Agents get most of their value from reference and how-to, and almost none from tutorials. | You're writing Phase-5 docs, or laying out a corpus an agent will read. | [documentation-taxonomy.md](documentation-taxonomy.md) |
| After the build, one agent owns the project — curator and developer in one role, because neither works alone — and proposes rather than silently implements anything significant. | The build phase is finished and the project has users or ongoing change. | [steward-agent.md](steward-agent.md) |
| Each project writes its own dated status report by probing what it actually has; one orchestrator aggregates them, so the human is not the integration point. | You are running more projects than you can hold in your head. | [hierarchical-reporting.md](hierarchical-reporting.md) |

---

## Nearby, not in this register

These carry rules too, but they are instruments and standards rather than concepts:

| If you need... | Go to |
|---|---|
| The Phase-4 stage gate — its checklist, and what a gate exit report must say | [`../phases/phase-review-template.md`](../phases/phase-review-template.md) (§ Gate Exit Is a Measured Report) |
| To run a cold second implementation against your own contract without it cheating | [`../guides/second-implementation-protocol.md`](../guides/second-implementation-protocol.md) |
| To design a surface people author against (DSL, fluent API, CLI) so mistakes get real diagnostics | [`../guides/authoring-surface-quality.md`](../guides/authoring-surface-quality.md) |
| The Java quality bar (JaCoCo, ArchUnit, JSpecify/NullAway, OWASP, Javadoc) | [`../guides/java-library-quality.md`](../guides/java-library-quality.md) |
| To batch-ingest research results into an existing KB, or scout references for a new one | [`../guides/curator-intake.md`](../guides/curator-intake.md) · [`../guides/reference-harvest.md`](../guides/reference-harvest.md) |
| Which variant to use, and how Phase 4 differs across them | [`../variants/README.md`](../variants/README.md) |

## Not covered

This section does **not** include:
- Implementation details for specific languages or frameworks (see `guides/`)
- Fill-in templates for phase outputs (see `templates/`)
- Variant-specific workflows (see `variants/`)
- Example project structures (see `examples/`)

## Status of these pages

Several pages carry **`Status: PROVISIONAL`** — one project, written down because the practice converged
under adversarial review, not because it has been run twice. They are marked in their own headers:
`act-pipeline`, `registers-of-absence`, `refutation-by-counterexample`, `vocabulary-law`,
`decision-enforcement`, `research-diversion`. The trigger for promoting any of them is a **second** effort
running the practice — the graduation rule pointed at this corpus's own pages.
