# The Model / Code Boundary: judgment to the model, the *when* to code

> Why a rule written into a prompt holds only as long as the model chooses to follow it, and where the line between prompt text and deterministic code belongs.

> **Status: PROVISIONAL — ratified by the Owner 2026-10-23.** Owner-endorsed as a principle 2026-10-22 and ratified as Forge doctrine 2026-10-23, on the forge steward's review.
>
> **Evidence caveat:** one product line (the Bud), one rehearsal, one prior example, 2026-09/10. Suggestive, not established. Ratification does not promote it: the provisional mark stays until a second project applies the practice.

***"A prompt makes the right behaviour likely. Code makes it certain."***

## The observation

A conversational agent that drives a workflow does two different jobs, and they want different homes.

1. **Understanding the human.** *"Fix F1, defer the rest"* means accept F1 and defer the others. *"Go ahead"* means yes. *"Why does F1 matter?"* means explain, and do nothing. This is language and judgment, which is what a model is for.
2. **Deciding the transition.** Is this operation allowed now? Was it asked for this turn? What was the last thing offered? Every one of these is a fact the system already holds. None needs judgment.

Put either job in the other's home and it fails, in a recognisable direction. Bud Spring Optimize did both, one after the other:

| Error | What happened | When |
|---|---|---|
| **Job 1 in code**: a regex router chose the operation from the user's words | It missed *"Go ahead."* as agreement, and it routed *"Do not make any changes yet."* to **execute** | Router review, 2026-09-17 |
| **Job 2 in text**: the router was deleted and a prompt paragraph took over, describing the flow and saying *"after recording decisions, offer to make the plan as the next action and stop"* | In the 2026-09-19 rehearsal, after *"fix F1, defer the rest"*, the model recorded the decision correctly and then, in the same turn and unasked, called the planning tool. The rehearsal operator cancelled it; the harness only checked tools at prompt return, so *"operator intervention enforced the stop here"* | Six-prompt rehearsal, 2026-09-19 |

The prompt was not missing information. The model knew the flow, because the prompt described it, and it advanced anyway, because finishing the task is what it is trained to do. The only test of that paragraph checked that its text was present.

## The mechanism: a structured intent

The model's only output is a typed statement of what the human asked for. Code does everything else.

```
human words ──► model ──► intent: { op: RECORD_DECISIONS, F1: accept, rest: defer }
                           intent: { op: AFFIRM }        ("go ahead", "yes")
                           intent: { op: NONE }          (a question)

intent + state ──► code ──► legal in this state?  one change this turn?  AFFIRM → last offered op
                       └──► result + next offers (generated, not written by the model)
```

*"Go ahead"* shows the split exactly: knowing it means yes is language (model); knowing what it is yes **to** is memory (code — the last offer was recorded).

Two checks are usually enough, and neither needs a framework:

1. **Legal in this state.** Each state-changing operation declares the states it may run in. Derive the state from evidence on disk, never from remembered conversation.
2. **At most one state-changing operation per user turn.** A state machine alone does not catch the rehearsal failure: planning after recorded decisions is a *legal* transition. The failure was a legal move nobody asked for.

A refusal must **point forward**: name the operation refused, the reason, the current state and the next valid operation, so the model reports what it did and offers the step instead of improvising around a bare "no". Disobeying the prompt then becomes harmless, not merely less likely.

## The writing rule

Ask one question of every sentence in a prompt: **if the model ignored this sentence, what would happen?**

- *The reply would read badly* — tone, explanation, how to ask a clarifying question, mapping "make the plan" to an operation. **Keep it as text.** A miss costs a re-ask.
- *State would change without the human asking* — a decision recorded, a plan written, a commit made, a message sent. **Enforce it in code.** A miss costs trust, and it may not be reversible.

**Smell test**: conditional words in a prompt — *only when, after X, unless, stop, in the current turn, not until* — are state written as prose. Move the rule into a table you can test, and leave the prompt the one sentence the model actually needs. Corollary: if you would write a unit test for a rule, it belongs in code.

## Worked example that already does this

Adib Saikali's Spring I/O 2026 workshop, `asaikali/art-of-building-agents` branch `2026-spring-io-workshop`, module `meal-agent/01-intent-alignment`. One message runs a three-step pipeline: an LLM extracts typed `UserRequirements`; Java decides `AlignmentStatus` (gathering → confirming → confirmed); an LLM writes the reply. Its README: *"Java code (not the model) decides whether to gather more info, ask for confirmation, or proceed"*; *"Confirmation is deterministic"* (requirements unchanged after a confirmation prompt); *"Hard gates are code, soft suggestions are model."*

## Scope note

This is about **coordination**: which stage of a workflow runs, and when. It is not an argument for restricting an agent's native tools. Editing files and running commands can stay liberal while stage transitions are enforced (Owner scope, 2026-10-22). Nor does it make the model obey the prompt more often. It makes disobedience safe.

## Cross-references

`decision-enforcement.md` (the same argument one level up: a design decision recorded only as prose holds only as long as the people who remember it touch the code) · `judges-and-evaluation.md` (deterministic judges for what must be true) · `review-lenses.md` lens 10 · `../templates/DESIGN-TEMPLATE.md` § Model / Code Boundary · first application: the shared Bud core's operation admission (2026-10-22).
