# Work order: bounded planning correction {{NN}} — {{review-id}}

> **Method:** {{path-or-version-of-review-control-loop-protocol}}
> **Steward repository:** {{absolute-path}}
> **Review root:** {{review-home}}/reviews/{{review-id}}
> **Prior candidate:** {{immutable-tag-or-commit}}; {{materialized-candidate-bundle-path}}
> **Master adjudication:** {{adjudication-ledger-path}}
> **Correction scope:** {{immutable-correction-brief-path-or-direct-adjudication-boundary}}
> **Owner authorization:** {{exact-adjudication-transition-id-and-pointer}}
> **Correction result:** {{correction-result-path}}
> **Mode:** planning-artifact synthesis; no product implementation, candidate freeze, or ratification

## Objective

Apply exactly the owner-authorized correction scope as one coherent change to the named planning or
proposal artifacts. The scope is either a direct adjudication boundary or a multi-package correction
brief. Produce a correction result for the controller, which will materialize and freeze the next
candidate separately.

## Input contract — read in order

1. {{session-instructions-path}}
2. {{steward-binding-path}}
3. {{method-protocol-path}}
4. {{prior-candidate-bundle-path}}/README.md
5. {{adjudication-ledger-path}}
6. {{correction-brief-path-or-direct-adjudication-boundary}}
7. {{owner-authorization-pointer}}
8. {{exact-authority-and-package-pointers-named-by-the-correction-scope}}

Preflight that the owner transition accepts this exact correction scope and that no later transition
reopens it. Stop if identity, standing, or authorization is ambiguous.

## Authority contract

- **Authority order:** {{exact-pointers-in-order}}
- **Protected decisions:** {{identifiers-and-pointers-or-none}}
- **Correction boundary:** {{brief-or-adjudication-section-pointer}}
- **Explicit exclusions:** {{paths-and-decisions}}

Owner authorization permits this bounded correction. It does not ratify the corrected candidate,
authorize implementation, or allow new design choices. A missing semantic decision returns to the
controller and owner.

## Mutation contract

Edit only:

- {{exact-mutable-active-artifact-paths-or-exact-new-superseding-destinations}}
- {{correction-result-path}}

Do not edit:

- the prior candidate, received review, master adjudication, package records, or correction brief;
- journal records; existing ratified decisions are inputs, and new entries wait for Candidate NN+1
  ratification;
- {{protected-dated-source-records-or-none}};
- project code, tests, schemas, generated artifacts, or implementation work orders;
- an active VISION/DESIGN/ROADMAP file not explicitly named above; or
- the next candidate bundle, verification, or ratification record.

Preserve unrelated working-tree changes. If the reviewed artifact is a dated record, create the
superseding artifact at the exact allowed destination above and list the dated source under protected
records; never rewrite the source record.

## Correction procedure

1. Apply every numbered direct-correction obligation or correction-brief edit-map row and no unlisted
   design change.
2. Resolve only the coherence consequences named by the correction scope. Return any newly discovered
   owner choice instead of deciding it silently.
3. Recheck changed factual claims and citations against their exact sources.
4. Verify that the resulting artifacts are self-contained and do not require package records to supply
   missing semantics.
5. Draft the finding-to-exhibit mapping the controller will place in Candidate NN+1 `CORRECTIONS.md`.
6. Compare the final diff with the mutation contract and explicit exclusions.

## Completion contract

Use `PLANNING-CORRECTION-RESULT-TEMPLATE.md`. The correction result records:

- prior candidate, correction scope, owner transition, and resulting artifact identities;
- changed artifacts and the exact direct-obligation IDs or correction-brief rows they implement;
- every finding's proposed Candidate NN+1 exhibit or terminal non-change;
- citation/source checks performed;
- coherence and scope checks;
- residual risks, unresolved issues, and preserved unrelated state; and
- the controller's next action: `MATERIALIZE CANDIDATE`, `HOLD`, or `REOPEN ADJUDICATION`.

Stop after returning the correction result. The controller independently checks the result,
materializes Candidate NN+1, appends the candidate-integration transitions, and launches fresh
verification. The correction session does none of those control transitions itself.

## Stop conditions

Stop without partial authority edits if the owner transition is absent or stale, authorities conflict,
an accepted finding is absent from the correction scope, a required edit lies outside the mutation
boundary, package dispositions are inconsistent, or coherent correction requires a new product choice.
