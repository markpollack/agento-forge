# Decision Enforcement: the design ↔ test contract

> Why a roadmap exit criterion should name the design decision it defends — and why some decisions honestly have none.

> **Status: PROVISIONAL.** One project (`agent-workflow` v3), one week, 2026-07. Suggestive, not established.

## The observation

Forge records decisions well — DESIGN's numbered DDs, `journal/` for ratified choices, review lenses at stage gates. What nothing asks is how a decision **stays true** after the session that made it is cleared.

A decision recorded only as prose holds exactly as long as the people who remember it are the ones touching the code. Every silent defect found in one week of `agent-workflow` v3 traced to a decision recorded in prose and defended by nothing:

| Decision, recorded as prose | How it was violated | How it was found |
|---|---|---|
| "The interpreter owns all control flow including retries" | a `retrying(n, step)` combinator ran three attempts inside one handler | by accident, two stages later |
| "Node ids MUST NOT derive from positions or counters" | the emitter emitted `loop-0`, and it shipped | by accident — it had passed a supervisor verification |
| The IR carried fields for retry, timeout, cost budget, error routing | nothing ever emitted any of them | by an audit commissioned for a different reason |
| *(no rule existed)* — two documents shared a decision-numbering space | the frozen wire contract cited the *parked* document's register normatively | by a reconciliation pass |

## The mechanism: one link, in the roadmap

A step's exit criteria already say what must be true. Name the decision the check defends:

```
- [ ] VERIFY node ids survive an unrelated upstream insertion (defends DD-23)
```

That is the whole obligation. It makes the three-way relation explicit where the work is planned — **DESIGN says what's true · ROADMAP says which step proves it · the test is the proof** — and it makes the gaps visible by absence: a decision no criterion names is undefended, and you can see that without a field, a gate, or a taxonomy.

Undefended is a legitimate state. Many decisions are postures or regimes with no predicate over any artifact ("the freeze is a stabilization, not a coronation"). Recording nothing is the honest outcome there. What costs you is *assuming* protection you never built.

## The one writing rule

Whether a test can exist at all is decided by how the decision is phrased.

- *"No reader needs to know the parked document's numbering exists"* — unfalsifiable; you cannot observe what a reader knows, and satisfying it would mean rewriting received evidence.
- *"No unqualified bare number that resolves outside this register"* — a grep, minus files carrying a header note.

Same intent. **State decisions as predicates over artifacts, not as states of the world or of people's understanding** — where you can. A decision phrased as a state of affairs cannot be defended by anything later, no matter how much effort is spent.

## Scope note

A check defends a *property* of a decision, not the whole of it. The citation check above proves every DD reference resolves and is unambiguous; it cannot prove the sentence meant DD-23 rather than DD-24. Name the check for what it proves, and the residue stays a reader's job.

## Cross-references

`templates/ROADMAP-TEMPLATE.md` (the `defends DD-n` convention) · `templates/DESIGN-TEMPLATE.md` (the phrasing rule) · `quality-infrastructure.md` (a check should be demonstrated to fail before it is trusted) · `project-knowledge-layout.md` (where decisions live — this is what happens after they are written down).
