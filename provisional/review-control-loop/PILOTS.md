# Pilot Register

## Agent Judge — Pilot 1

| Field | State |
|---|---|
| Project repository | `markpollack/agent-judge` (public) |
| Steward repository | `markpollack/agent-judge-steward` (private) |
| Effort | Agent Judge 0.14 closure and Agent Workflow adoption readiness |
| Initial candidate | Private steward commit `a7ea488`, tag `review/aj-014-closure/candidate-01`; reviewed trio at project HEAD `8f8391b` plus recorded working-tree state |
| Initial sensor output | `roadmap-readiness-review-2026-08-06`, 16 findings |
| Current phase | Step 1.5 accepted; Agent Workflow Act AJ-14 authorized for a fresh session |
| Ratification state | Candidate 02 ratified; Steps 1.0–1.5 accepted; Agent Judge Step 1.K unauthorized |

### Initial observations

- The public project gitignored its authoritative roadmap and learnings, leaving them without history or
  backup.
- A tracked, completed root roadmap contradicted the active ignored roadmap.
- Two older ignored VISION/DESIGN documents coexist with the newer reviewed root pair. The pilot must
  classify these rather than infer authority from location or filename.
- The review contains cross-repository exit criteria that Agent Judge cannot satisfy, testing ownership
  and work-order routing.
- M5 is a settled decision with corpus evidence; review must not reopen it without a new failure case.

### Next experiment action

Dogfood the bounded correction transition against Step 1.2. Agent Journal consumes its follow-up by
an explicit local pointer because its `plans/` tree is ignored; Agent Workflow's message remains
pending creation of its tracked 1:1 steward and will be the first real gitmaildir delivery. Candidate
02, received sensor records, and prior implementation evidence remain immutable.

### Candidate-packaging observation

Candidates 01 and 02 used numbered manifest directories without materialized copies of the reviewed
documents. Verification therefore required repeated `git show`, per-file hash reproduction, and Git
history comparisons. Integrity held, but the human-readable-numbered-record objective did not. Future
candidates default to materialized bundles; Git remains the backing integrity boundary rather than the
reviewer's document-reading interface.

### Implementation-dispatch observation

The first Step 1.0 implementation work order expanded to 173 lines by repeating ratification, M5
semantics, roadmap work items, exit evidence, generic Git procedure, and stopping rules. Although
bounded, it became a second roadmap and violated the pointer-only handoff rule. Future implementation
work orders are thin, normally one-page dispatch envelopes; missing substantive instruction is fixed
in DESIGN or ROADMAP rather than copied into the dispatch.

### First implementation-checkpoint observation

The Step 1.0 implementer followed its bounded dispatch, preserved unrelated working-tree state, met
the named exits, and stopped before Step 1.1. It also found that active VISION/DESIGN statements and a
tool-specific session pointer still described pre-Step-1.0 state. The dispatch correctly withheld
authority to edit those surfaces, but the method had no explicit post-step role responsible for
accepting evidence, restoring planning currency, checking trajectory, and preparing the next human
decision. The pilot therefore adds an AI Roadmap Controller checkpoint between implementation and any
next-step authorization.

The first filled checkpoint then grew into a detailed evidence report, repeating test results,
changed paths, design reasoning, and the learning record. It did not yet override the roadmap, but it
had the same drift risk as the oversized first implementation dispatch. Controller checkpoints are
therefore thin, one-page state-transition records; detailed evidence stays in the step learning
record.

### First correction-required observation

Step 1.2 satisfied its declared portability checks but exposed a semantic defect in the newly created
model-usage projection: a volatile price estimate was narrowed from `BigDecimal` to `double`, and an
unrepresentable value could disappear silently, while token categories were too weak for known
reasoning/cache accounting. The Roadmap Controller therefore could not accept the step merely because
its original checkboxes were green. This is the first dogfood of the explicit correction path:
reproduce the defect, ratify the smallest coherent contract correction, reopen only Step 1.2, dispatch
that correction, and run a new controller checkpoint before Step 1.3.

The same finding has consequences owned by Agent Journal and Agent Workflow. Agent Journal cannot
receive a real gitmaildir message yet because its `plans/` tree is ignored; force-adding a transport
file would violate its current repository boundary. Its work therefore begins through an explicit
local authority pointer, recorded as a pilot exception. The pending Agent Workflow message is
triggered by creation of its 1:1 steward and will test the real transport. Recipient roadmaps—not the
messages—own acceptance and implementation.

The first method draft called a Markdown envelope under `plans/inbox/` “gitmaildir-compatible”
without reading gitmaildir's implementation. Human challenge exposed the mismatch: the real transport
uses `MailboxMessage` JSON under `inbox/new/<type>/`, with `cur/archive/dead` lifecycle directories,
generated IDs, leases, and a separate audit log. The binding now runs gitmaildir with `plans/` as its
work directory and uses a separate receipt message. Method integrations must inspect the named
external contract before borrowing its name.

### Implementer/controller authorship observation

The Step 1.2 bounded-correction implementer checked completed correction items in ROADMAP and changed
steward `AGENTS.md` to `AWAITING ACCEPTANCE`. That initially looked like controller work, and the
first method correction allowed it because the edits stopped short of acceptance. Agent Workflow
Step 1.5 exposed the remaining hygiene defect: even provisional current-action pointers make
`AGENTS.md` a volatile control-state ledger. The refined boundary is: the implementer records
provisional evidence-backed execution state in ROADMAP and evidence; the controller verifies those
claims, reconciles VISION/DESIGN/ROADMAP, recommends acceptance or correction, and never delegates
next-step authority. `AGENTS.md` stays stable. This is the pilot's concrete form of “trust but
verify.”

### Operational-knowledge promotion observation

Step 1.3 discovered two recurring release-health commands and proved that Javadoc errors must remain
build-breaking. The implementation record correctly surfaced them, but a future session would not
normally reread that step record before changing release infrastructure. The controller therefore
promoted the exact Agent Judge commands and invariant into the public project's canonical
`AGENTS.md`. The reusable method is the promotion rule, not those Maven commands: recurring verified
commands, quality invariants, and diagnostic pitfalls move from per-step evidence into persistent
agent instructions, while one-off transcripts stay in the evidence record.

### Coverage-label observation

The Step 1.4 implementation summary reported “all nine exits,” while the authoritative roadmap
contained nine work items and eight exit criteria. The persistent evidence table listed the correct
eight exits and all were met, so no implementation work was missing; the conversational label had
combined or miscounted two different inventories. The controller reported `9/9 work items` and `8/8
exit criteria` in plain language. This validates the existing denominator rule: every count names the
finite category it counts, because `9/9` without “work items” or “exit criteria” sounds precise while
remaining ambiguous.

## Agent Workflow — Pilot 2

| Field | State |
|---|---|
| Project repository | `markpollack/agent-workflow` |
| Steward repository | `markpollack/agent-workflow-steward` — private, created empty 2026-08-09 |
| Entry trigger | Agent Judge adjudication establishes the cross-repository work order and the Agent Judge artifact is locally installed |
| Current phase | Private steward bootstrapped; Act AJ-14 in authorized bounded correction C1; first deferred-future-work gitmaildir round trip complete |

Pilot 2 will test whether Agent Judge's completed work order can be consumed by reference—without a new
handoff document that restates and drifts from the upstream decisions.

Step 1.5 also tested the public footprint and active-plan size. The controller reduced both public
projects to minimal stable `AGENTS.md` bridges, removed transient current-action state from steward
instructions, and archived Workflow's completed Roadmap Stages 0–2 while leaving Act AJ-14 live.

AJ-14 controller review then exercised the new inbox preflight with non-blocking future work. Agent
Workflow sent one pointer-only framework-adapter finding; Agent Judge filed recipient-owned Act AJ-15
with a trigger, returned a receipt, and both messages completed the real new→cur→archive lifecycle.
The exercise also exposed operator friction: publishing, governed receiving, returning a receipt, and
accepting it required four small temporary Java drivers. That is evidence for a future gitmaildir
operator CLI/SPI shell—generic publish/list mechanics plus a recipient-supplied disposition handler—
not a reason to copy project-specific pilot drivers into the library.

### Multi-package adjudication observation

The Agent Workflow steward's `plans/main-due-diligence/inbox/review-java-line-2026-08-20.md` returned
14 MUST and 5 SHOULD findings across coupled DSL, runtime, persistence, identity, release-scope, and
evidence-integrity questions. Sending all accepted findings directly into one correction session would
require that session to make several owner choices while simultaneously rewriting the whole proposal.
Creating one independent design document per finding would instead lose the shared invariants and
create competing partial authorities.

Agent Workflow's earlier `plans/v3/inbox/cross-check-polyglot-identity-cold-reviews-2026-08-10.md`
supplied an ad hoc positive precedent: de-duplicate the docket, walk owner choices in dependency order,
record topic dispositions, integrate once, and then run fresh cold reviews. Its active state was
scattered through `inbox/`, however, so the pattern was difficult to supervise and reuse.

The provisional method now formalizes that sequence under one review root. One adjudication ledger
retains finding closure, priority, dependencies, and routing; grouped work packages return evidence
and recommendations without editing authority artifacts; the controller checks them and records owner
dispositions; one correction brief maps the accepted whole; the owner then authorizes a separate
planning-correction work order that produces one new candidate. For a cross-cutting integrity finding,
unsafe use is contained first and the finding closes only after synthesis and citation verification.
This observation defines the next Agent Workflow experiment; it does not claim that the Java-line
multi-package correction has already completed.

## Current cold-review sensor profiles

> **Standing:** dated pilot/operator defaults, not stable Forge doctrine
> **As of:** 2026-08-10

Keep the profile names stable and resolve the concrete model names again when generating a launcher.
The owner has found `high` effective as the daily-driver reasoning level for current Claude and Codex
models; reserve the selected `max` configurations for the frozen final pass.

| Profile | CLI/model family | Reasoning | Default use |
|---|---|---|---|
| `ITERATIVE` | Claude Code — current Claude/Anthropic daily-driver model | `high` | Vision, Design, Roadmap, and correction-loop review |
| `ITERATIVE` | Codex CLI — current Codex/OpenAI daily-driver model | `high` | Vision, Design, Roadmap, and correction-loop review |
| `FINAL` | Claude Code — Fable 5 | `max` | One independent final sensor |
| `FINAL` | Codex CLI — GPT-5.6-Sol | `max` | One independent final sensor |

An iterative round may use either daily-driver sensor or both when diversity is useful. The final
profile uses both listed sensors in separate persistent directories against the same frozen packet.
If CLI availability changes, update this dated profile after checking the installed resolver; do not
silently substitute a delegating multi-agent mode for either independent sensor.

## Method-level decision log

| Date | Decision | Standing |
|---|---|---|
| 2026-08-06 | Use a private one-project/one-steward-repository pairing | Pilot decision |
| 2026-08-06 | Use Git integrity plus numbered human-readable candidate/review records | Pilot decision |
| 2026-08-06 | Treat AI review as sensor output requiring adjudication | Pilot decision |
| 2026-08-06 | Keep this method provisional through both pilots | Owner decision |
| 2026-08-08 | Separate reusable work-order instructions from the adjudication output ledger | Pilot decision |
| 2026-08-08 | Add `accepted-open`; `fixed` is valid only after correction exists | Dogfood correction |
| 2026-08-08 | Use proportional evidence: coordinates for released dependencies; digests only when byte identity is disputed | Dogfood correction |
| 2026-08-08 | Front-load a plain-language human checkpoint and replace ambiguous `CORRECT` with `CORRECTIONS REQUIRED` | Dogfood correction |
| 2026-08-08 | Add a distinct verification work-order contract with `READY TO RATIFY` as its positive control state | Dogfood correction |
| 2026-08-08 | Require materialized numbered candidate bundles by default; grandfather Agent Judge Candidates 01/02 without rewriting them | Dogfood correction |
| 2026-08-08 | Separate human ratification, execution authorization, and fresh-session implementation dispatch | Dogfood correction |
| 2026-08-08 | Make implementation work orders thin pointer envelopes; prohibit duplicated design, roadmap, ratification, and completion content | Dogfood correction |
| 2026-08-08 | Add an AI Roadmap Controller checkpoint after every implementation step; the human remains Project Owner and next-step authority | Dogfood correction |
| 2026-08-08 | Keep Roadmap Controller checkpoints to one-page transition records that point to, rather than duplicate, roadmap and implementation evidence | Dogfood correction |
| 2026-08-08 | Make `CORRECTION REQUIRED` an explicit same-step control transition using the thin implementation dispatch in bounded-correction mode | Dogfood correction |
| 2026-08-08 | Bind cross-steward delivery to gitmaildir `MailboxMessage` JSON under `plans/inbox/new/<type>/`; disposition returns in a separate receipt and remains recipient-owned | Dogfood correction |
| 2026-08-08 | Require a named transport binding to match the transport's real on-disk schema and lifecycle; conceptual compatibility is insufficient | Dogfood correction |
| 2026-08-08 | Do not claim gitmaildir delivery into an ignored `plans/` tree; use a declared manual pointer exception or establish the tracked steward boundary first | Dogfood correction |
| 2026-08-08 | Treat implementer roadmap checkmarks and `AGENTS.md` checkpoint pointers as provisional evidence claims; the controller owns verification and acceptance, not exclusive file authorship | **Superseded 2026-08-09** for `AGENTS.md`; roadmap checkmarks remain provisional claims |
| 2026-08-09 | Require the Roadmap Controller to promote newly proved recurring commands, quality invariants, and diagnostic pitfalls into canonical agent instructions without copying step transcripts | Dogfood correction |
| 2026-08-09 | Keep public and steward `AGENTS.md` stable: no current action, candidate/artifact identity, roadmap status, dispatch pointer, pending decision, or checkpoint state; operational state stays in ROADMAP and controller records | Dogfood correction |
| 2026-08-09 | Add an inbox preflight at Roadmap Controller/planning session entry and before dispatch; separate mechanical sensing from recipient-owned disposition, keep implementation sessions isolated, and preserve full stage-boundary inbox triage | Dogfood correction |
| 2026-08-09 | Make named downstream milestones part of trajectory control so an earlier compatibility correction cannot erase prerequisites for later durable behavior | Dogfood correction |
| 2026-08-09 | File gitmaildir operator-CLI extraction after the second real round trip required four temporary Java drivers; keep project-specific governance handlers outside the generic library | Pilot finding filed to gitmaildir |
| 2026-08-13 | Turn 1:1 steward creation into a reproducible provisional bootstrap with committed-source planning import, stable bindings, mandatory gitmaildir layout, privacy validation, and a real first-message acceptance test; revise it from each dogfood run before creating the next steward | gitmaildir-steward bootstrap preparation |
| 2026-08-13 | Require actual project visibility as bootstrap input and record the bootstrap script digest; gitmaildir-steward dogfood showed the first scaffold's public-project default was not a valid invariant | gitmaildir-steward dogfood correction |
| 2026-08-13 | Add a reproducible minimal-authority bootstrap for projects with no committed planning trio; require one exact accepted seed work order and refuse broad history reconstruction | Agent Judge Tutorial steward preparation |
| 2026-08-10 | Use stage-aware review profiles: capable normal/high sensors for iterative artifact correction, then the strongest suitable independent and diverse sensors for the frozen final pass | Agent Workflow dogfood |
| 2026-08-10 | Materialize each CLI cold-review handoff as a reviewer-local launch script with pinned selected configuration, input integrity checks, overwrite refusal, and persistent output | Agent Workflow dogfood |
| 2026-08-10 | Prefer owner-visible interactive CLI startup with the pointer handoff as the initial prompt; reserve unattended print/exec mode for deliberately logged runs | Agent Workflow dogfood |
| 2026-08-21 | Test routing a coupled review through one master adjudication ledger, grouped dependency-ordered work packages, one owner-authorized correction brief, and one coherent next candidate; package outputs remain evidence rather than competing design or implementation authorities | Provisional experiment amendment — Java-line pilot pending |
