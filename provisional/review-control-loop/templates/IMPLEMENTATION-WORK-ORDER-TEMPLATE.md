# Work order: implement {{roadmap-step-id}} — {{step-title}}

> **Method:** {{path-or-version-of-review-control-loop-protocol}}
> **Steward repository:** {{absolute-steward-path}}
> **Project repository:** {{absolute-project-path}}
> **Ratified candidate:** {{candidate-tag-or-commit}}; {{materialized-candidate-bundle-path}}
> **Ratification:** {{ratification-record-path}}
> **Roadmap step:** {{candidate-bundle-roadmap-path-and-step-id}}
> **Implementation record:** {{steward-output-record-path}}
> **Mode:** bounded implementation of one authorized roadmap step

## Objective

Execute exactly the authorized roadmap step, produce its required project and steward evidence, and
stop at a human checkpoint. Do not begin the next step or self-ratify the implementation.

## Read in order

1. Canonical steward `AGENTS.md`
2. Steward binding
3. Ratification record
4. Materialized candidate bundle `README.md`
5. Materialized candidate VISION, DESIGN, ROADMAP, and the authorized step
6. Candidate decisions and project inputs named by that step
7. Project-local instructions and applicable engineering standards

Read ordinary files from the materialized candidate bundle. Do not reconstruct routine inputs with
`git show` or a worktree. Use Git only for normal repository safety, bounded provenance questions, and
the required implementation commits.

## Authority and reopening rule

- {{Protected decision identifier and pointer; do not restate its substance.}}
- A fresh worker implements the ratified plan; it does not reinterpret settled decisions.
- If implementation exposes a genuine contradiction or new failure case, stop with evidence and
  request adjudication. Do not silently redesign the contract.

## Mutation contract

May modify in the project repository:

- {{authorized project paths or path families}}

May modify in the steward repository:

- {{roadmap checkbox/current-state paths}}
- {{step learning and implementation record paths}}
- canonical `AGENTS.md` only when the durable instruction or current action changes

Must not modify:

- the ratified candidate bundle, received reviews, adjudications, verification, or ratification;
- {{out-of-scope project/consumer paths and repositories}};
- releases, published artifacts, or dependency caches unless the roadmap step explicitly authorizes
  them;
- unrelated user changes.

## Entry and safety checks

- Confirm the exact project branch/commit required by the step.
- Inventory and preserve unrelated working-tree changes before editing.
- Confirm every roadmap entry criterion; stop if one is false.
- Record any external prerequisite without claiming ownership of another repository.

## Execution contract

1. Follow the authorized roadmap work items in order.
2. For every defect-specific fix, create or identify the focused guard and watch it fail for the
   intended reason before changing production behavior.
3. Apply the smallest correction satisfying the ratified contract.
4. Run focused evidence first, then every broader verification gate required by the step.
5. Update public documentation, learnings, roadmap state, and instructions only where the step
   requires them.
6. Commit project implementation and steward state separately. Record the exact cross-repository
   commit identities.
7. Do not push, merge, tag, install, publish, or start another step unless this work order explicitly
   authorizes that operation.

## Required implementation record

Write {{steward-output-record-path}} with:

- entry-criteria results and preserved unrelated state;
- watched-failure exhibit and why it failed;
- implementation summary pointing to the ratified decision and roadmap clauses;
- focused and broad verification commands/results;
- changed-path inventory;
- exact project and steward commit identities, or why a commit is awaiting the checkpoint;
- residual risks and any new failure case; and
- an exit-criterion ledger for the authorized step.

## Front-loaded completion checkpoint

Lead the final report with:

- `STEP READY TO ACCEPT`, `CORRECTION REQUIRED`, or `HOLD`;
- the outcome in plain language;
- what changed and deliberately did not change;
- watched-failure and green verification results;
- exact project/steward state;
- unresolved risks or owner decisions; and
- the next human decision.

The implementer stops here. It does not mark the next roadmap step authorized and does not act as the
independent implementation reviewer.

## Stop conditions

Stop without improvising if an entry criterion is false, a governing authority conflicts, a required
mutation is outside the contract, unrelated user changes overlap the target, or the expected red guard
does not fail for the intended reason. Record the smallest decision or scope correction needed to
resume.
