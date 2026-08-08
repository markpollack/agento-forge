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
6. the materialized candidate-bundle VISION, DESIGN, and ROADMAP
7. {{additional-authority-pointers-or-none}}

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
- the adjudication or received review;
- active VISION, DESIGN, ROADMAP, or journal decisions;
- project or consumer files;
- Maven repository content;
- any evidence source.

## Verification procedure

1. Verify the single candidate ref, materialized bundle inventory, and named source commit identities.
2. Walk every finding in the adjudication ledger. For an accepted correction, cite the exact candidate
   exhibit and classify it `verified-corrected` or `still-open`. For a refuted, filed, or parked item,
   verify that Candidate {{candidate-number}} preserves the disposition and trigger/owner.
3. Check that the correction stayed within the adjudicated boundary and did not reopen protected
   decisions or adopt rejected reviewer preferences.
4. Re-run the declared coherence and roadmap-satisfiability lenses against the corrected candidate.
5. Attempt at least one adversarial scenario per selected lens that could expose a new structural
   blocker. Record scenario families and residual gaps; do not claim open-ended completeness.
6. Separate candidate defects from optional future improvements. A preference without a breaking case
   does not block ratification.

Do not fix anything during verification. A failure produces evidence and a bounded recommendation for
another correction round.

## Coverage accounting

Report finite spaces as plain walked counts and method-level denominators, including:

- {{candidate-ref-and-bundle-inventory-count}} candidate ref and bundle inventory entries;
- {{adjudicated-finding-count}} adjudicated findings;
- {{active-document-count}} active planning documents;
- {{roadmap-clause-or-step-count}} roadmap clauses or steps; and
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
3. a complete finding-verification ledger;
4. correction-boundary and protected-decision checks;
5. cross-document coherence and roadmap-satisfiability results;
6. coverage denominators, scenario families, and recorded non-findings;
7. residual risk; and
8. the final recommendation and next authorized action.

## Stop conditions

Stop the whole verification with `HOLD` if candidate identity fails or governing authorities conflict.
Otherwise finish all independent checks even when one finding remains open. Do not infer permission to
correct the candidate, implement roadmap work, push a project branch, or mutate external state.
