# Research Diversion: leaving the roadmap without losing it

> How to spend real effort on an open question mid-delivery, and come back with decisions rather than documents.

> **Status: PROVISIONAL.** One project (`agent-workflow` v3), one day of intensive iteration, 2026-07. Suggestive, not established. The pattern is written down because it converged under adversarial review, not because it has been run twice.

## The situation

A delivery roadmap is executing well. Then a step finds something the plan cannot absorb: a verification approach that turns out to be circular, an analogy that was borrowed from the wrong field, a guarantee nobody can state precisely. It is too large for a work item and too load-bearing to defer.

Two bad options present themselves. **Absorb it** — the step swells, the stage gate slips, and the question gets answered under delivery pressure by whoever happens to be holding it. Or **defer it** — a `## Deferred` entry with a trigger nobody will notice, and the flawed approach ships in the meantime.

A **research diversion** is the third option: a bounded parallel effort with its own vision, design, and roadmap, whose deliverable is *work items in the delivery plan* rather than documents in its own directory.

## Six properties

**1. The framework is presumed correct, never frozen.** The vision and design stabilise early — otherwise every session relitigates them. But *frozen* invites defence, and defence is exactly wrong in R&D. **Presumed correct until evidence says otherwise** invites attack, which is what you want. The operational distinction: a step that finds the framework *wrong* has found something valuable and reports it loudly; a step that finds it *awkwardly worded* leaves it alone.

**2. Open questions live in one file.** Scattered across four documents, "what is still undecided" is a reading exercise. In one file with *why it matters · who owns it · what closes it*, the diversion's end becomes detectable rather than a matter of opinion.

**3. Spike before research, when the precondition is local.** The strongest ordering decision available. Before researching how a technique works, ask whether your system has the preconditions the technique operates on. That is usually a fact about your own code, answerable in hours, and it aims the research — or retires it. Inverting this can cost weeks of literature on something that never transfers.

**3b. The artifact's own genre literature is a primary corpus, not a probe.** If the thing under study is a fluent API, fluent-API design literature belongs in the research plan from the start — not added late as a side question. In the originating project the decisive research answer (mature builders answer silent overwrite with *refusal and naming*, never accounting) came from a genre probe added at the owner's suggestion after the analogous-field corpus (compilers) had been researched at length. The spike still mattered — it created the precise question the genre corpus could answer — but the corpus itself should have been scheduled from day one.

**4. Adoption is optional and must be said so.** *"Adopt nothing new"* has to be written into the roadmap as a legitimate outcome, in those words. Otherwise the diversion acquires an obligation to justify itself, and something plausible gets ratified to show for the time. Pair it with an anti-pattern: **do not conclude early to be efficient.**

**5. Every recommendation states what would make it wrong.** Falsifiability as an exit criterion, not a virtue. A recommendation that cannot be wrong has not been tested.

**6. It terminates by integration.** The diversion's deliverable is **mechanisms scheduled into the delivery roadmap with owners** — not a document set. Everything produced along the way is scaffolding for that act. A diversion that ends with a beautiful design and no roadmap entries has not ended; it has stalled.

## Shape

```
plans/<topic>/
  index.md            routing: task-routing, question-routing, NOT-covered   (≤100 lines)
  HANDOFF.md          what a cold session needs before step one
  OPEN-QUESTIONS.md   the N unresolved questions; closing them ends it
  VISION.md           the problem, the reframe, success, exit conditions
  DESIGN.md           mechanisms + hypotheses, in separate registers
  ROADMAP.md          entry / work / exit per step
  research/  learnings/
```

Two register conventions earn their keep immediately. **Mechanisms and hypotheses are separated** — otherwise a reader carries *"proposed, but only if the research says yes"* in their head for every entry. And the diversion **owns its own decision prefix** (`LD-n`, not `DD-n`), so a bare number never resolves in two registers.

## What it is not

**Not a stage.** It runs in parallel and blocks nothing. If it starts blocking delivery, that is an exit condition, not a scheduling problem.

**Not open-ended.** Exit conditions are written before it starts. The one most often missed: *two consecutive rounds producing nothing that changes a decision* — because someone has to be willing to call it, and it will not be the session doing the work.

**Not a licence to redesign.** Its constraints say what it may not touch. Findings become proposals; a proposal gets its own act in the delivery plan.

## When to reach for it

- A verification or measurement approach turns out to be **circular** — the thing being graded defines the grading.
- The project has been reasoning by **analogy to the wrong field**, and the right one is unfamiliar.
- A claim everyone repeats turns out to be **unstated** — nobody can say precisely what it means.

## When not to

If the question is answerable by reading one file, read the file. If it is answerable by a single spike, run the spike. The overhead here is only justified when the answer will **change how the delivery plan is built**, not merely what one step does.

## Related

`discovery-loop.md` (phases 0–2, which this borrows its shape from) · `decision-enforcement.md` (an exit criterion naming the decision it defends) · `session-handoff.md` (the handoff document a diversion needs like any other work) · `project-knowledge-layout.md` (where a diversion's directory sits among `learnings/`, `journal/`, `research/`)
