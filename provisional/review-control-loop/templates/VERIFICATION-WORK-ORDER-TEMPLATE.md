# Work order: verify {{review-id}} Candidate {{candidate-number}}

> **Method:** {{path-or-version-of-review-control-loop-protocol}}
> **Steward repository:** {{absolute-path}}
> **Candidate:** {{immutable-tag-or-commit}}; {{materialized-candidate-bundle-path}}
> **Adjudication ledger:** {{adjudication-ledger-path}}
> **Output record:** {{verification-record-path}}
> **Mode:** independent verification; no correction or implementation

## Objective

Verify that the frozen corrected candidate implements exactly the adjudicated correction boundary,
resolves every owner decision assigned before verification, introduces no new authority conflict or
structural blocker, and is ready for human ratification.

## Read in order

1. {{session-instructions-path}}
2. {{steward-binding-path}}
3. {{method-protocol-path}}
4. {{materialized-candidate-bundle-path}}/README.md
5. {{adjudication-ledger-path}}
6. {{correction-brief-path-or-direct-adjudication-boundary}}
7. {{owner-authorization-transition-pointer}}
8. {{planning-correction-result-path}}
9. {{materialized-reviewed-artifact-paths-in-order}}
10. {{materialized-standing-authority-paths-in-order}}
11. {{additional-authority-pointers-or-none}}

Read candidate artifacts as ordinary files from the numbered materialized bundle, not from mutable
active planning paths. Run one preflight confirming that the candidate tag identifies the committed
bundle and that its README inventory/source references are complete. Do not reproduce tracked files
through repeated `git show` or per-file hash commands. Stop with `HOLD` if candidate integrity fails.

## Evidence permissions

Read-only inspection is allowed under:

- {{project-repository-path}}
- {{additional-evidence-root}}

External research is {{forbidden | allowed only for named finding IDs | allowed}}. Record every external
source used. Use declared coordinates and versions for ordinary released dependencies; use digests
only where the claim concerns exact byte identity.

## Mutation boundary

Edit only:

- {{verification-record-path}}

Do not edit:

- the materialized candidate bundle or candidate-tagged artifacts;
- the adjudication, received review, correction scope, owner transition, or correction result;
- active source artifacts or journal decisions;
- project or consumer files;
- Maven repository content;
- any evidence source.

## Verification procedure

1. Verify the single candidate ref, materialized bundle inventory, and named source commit identities.
2. Verify that the owner transition authorizes the exact correction scope, that the correction result
   accounts for every authorized obligation, and that Candidate {{candidate-number}} materializes the
   resulting source artifacts without unreported change.
3. Walk every finding in the adjudication ledger. For an accepted correction, cite the exact candidate
   exhibit and classify it `verified-corrected` or `still-open`. For a refuted, filed, or parked item,
   verify that Candidate {{candidate-number}} preserves the disposition and trigger/owner. For an
   already-fixed item, verify that its prior exhibit remains present and unregressed and classify it
   `preserved-already-fixed` or `still-open`.
4. Check that the correction stayed within the owner-authorized boundary and did not reopen protected
   decisions or adopt rejected reviewer preferences.
5. Re-run the declared cross-artifact coherence lenses and, when ROADMAP is in scope, the
   roadmap-satisfiability lenses against the corrected candidate.
6. Attempt at least one adversarial scenario per selected lens that could expose a new structural
   blocker. Record scenario families and residual gaps; do not claim open-ended completeness.
7. Separate candidate defects from optional future improvements. A preference without a breaking case
   does not block ratification.

Do not fix anything during verification. A failure produces evidence and a bounded recommendation for
another correction round.

## Coverage accounting

Report finite spaces as plain walked counts and method-level denominators, including:

- {{candidate-ref-and-bundle-inventory-count}} candidate ref and bundle inventory entries;
- {{adjudicated-finding-count}} adjudicated findings;
- {{reviewed-artifact-count}} reviewed candidate artifacts;
- {{standing-authority-count}} materialized authority inputs;
- {{roadmap-clause-or-step-count-or-not-applicable}} roadmap clauses or steps; and
- {{other-finite-lens-or-scenario-family}}.

Record non-finding searches another reviewer can extend. A denominator is the declared space walked,
not a count of findings and not proof that no undeclared defect exists.

## Required front-loaded human checkpoint

Immediately after identity/status metadata—and before detailed evidence—write a concise checkpoint
containing:

- the control recommendation: `READY TO RATIFY`, `CORRECTIONS REQUIRED`, or `HOLD`;
- what Candidate {{candidate-number}} changes and deliberately does not change;
- whether all adjudicated findings reached their expected verified disposition;
- any new structural blocker or owner decision;
- review coverage in plain counts;
- residual risks; and
- the exact next authorized action.

The checkpoint summarizes the evidence ledger; it does not become a second authority or restate
project decisions.

## Required output

The verification record must contain:

1. identity/status metadata and the front-loaded human checkpoint;
2. candidate-integrity evidence;
3. correction-scope, owner-authorization, and correction-result reconciliation;
4. a complete finding-verification ledger;
5. correction-boundary and protected-decision checks;
6. cross-artifact coherence and, when in scope, roadmap-satisfiability results;
7. coverage denominators, scenario families, and recorded non-findings;
8. residual risk; and
9. the final recommendation and next authorized action.

## Stop conditions

Stop the whole verification with `HOLD` if candidate identity fails or governing authorities conflict.
Otherwise finish all independent checks even when one finding remains open. Do not infer permission to
correct the candidate, implement roadmap work, push a project branch, or mutate external state.
