# Work order: adjudication package {{package-id}} — {{slug}}

> **Method:** {{path-or-version-of-review-control-loop-protocol}}
> **Steward repository:** {{absolute-path}}
> **Review root:** {{review-home}}/reviews/{{review-id}}
> **Candidate:** {{immutable-tag-or-commit}}; {{materialized-candidate-bundle-path}}
> **Master adjudication:** {{adjudication-ledger-path}}
> **Package:** {{package-id}}
> **Output:** {{package-disposition-path}}
> **Mode:** evidence-backed design disposition; no correction or implementation

## Objective

Resolve the one coupled design question below for the owned findings and contributor obligations.
Produce a falsifiable, integration-ready recommendation and expose every owner choice. Do not edit the
reviewed candidate or author a replacement DESIGN or ROADMAP.

## Input contract — read in order

1. {{session-instructions-path}}
2. {{steward-binding-path}}
3. {{method-protocol-path}}
4. {{candidate-bundle-path}}/README.md
5. {{received-review-path}}
6. {{adjudication-ledger-path}}
7. {{named-authority-or-evidence-inputs}}
8. {{accepted-upstream-package-dispositions-or-none}}

The master adjudication owns finding state, priority, and routing. This work order owns only the
question and boundary below. Stop if the two disagree.

## Authority contract

- **Coupled question or invariant:** {{one-question}}
- **Owned findings:** {{finding-ids-whose-overall-route-this-package-owns}}
- **Contributor obligations:** {{other-findings-or-packages-this-package-only-informs-or-none}}
- **Protected decisions:** {{identifiers-and-authoritative-pointers-or-none}}
- **Reopening rule:** {{new-failure-case-required-by-authority}}
- **Evidence permissions:** {{exact-roots-and-whether-external-research-is-allowed}}
- **Dependencies already accepted:** {{package-or-owner-decision-pointers-or-none}}

The received review and this package's output are evidence, not product authority. Separate a
reproduced defect from the reviewer's proposed remedy. Recommend changing a protected decision only
when the named reopening rule is met.

## Mutation contract

Edit only:

- {{package-disposition-path}}
- {{disposable-scratch-root-or-none}}

Do not edit:

- the candidate bundle, received review, or master adjudication ledger;
- active VISION, DESIGN, ROADMAP, or journal records;
- another work package;
- project code, tests, or schemas; and
- generated/build artifacts outside the exact disposable scratch root named above.

Inspection commands must be non-mutating unless the work order names a disposable scratch/build-output
root above. If it does, record clean-tree status before and after and leave no output elsewhere.
Implementation or repository-mutating spikes require their own bounded work order; do not perform them
under the name “analysis.”

## Required analysis

1. Restate the problem in plain language without importing the reviewer's remedy.
2. Establish the current behavior and invariant from authority and reproducible evidence.
3. Compare the smallest viable alternatives, including deliberate deferral when it is safe.
4. Recommend one disposition and give its rejected alternatives and consequences.
5. Define the contract that adjacent packages and final synthesis may rely on.
6. Map every owned finding to `candidate correction proposed`, `refuted`, `filed`, `parked`, or `owner
   decision required`. For contributor obligations, state only the contract or evidence supplied to
   the owning package.
7. Name exact candidate/authority targets and acceptance or falsification scenarios. Include ordering,
   crash, compatibility, and migration boundaries only where this package changes them.
8. State residual risk, downstream dependencies, and anything the synthesizer must not infer.

## Completion contract

Use `ADJUDICATION-WORK-PACKAGE-TEMPLATE.md`. The disposition is complete only when:

- every owned finding has one proposed route and every contributor obligation has one explicit input;
- every claim needed by another package has an exhibit or is labeled an assumption;
- every cross-package input/output contract is explicit;
- every owner decision includes a recommended default and consequence of deferral;
- candidate targets and acceptance scenarios are concrete; and
- the output stops at recommendation and reports back to the controller.

The controller independently checks the returned evidence and appends package/finding transitions to
the master adjudication. The package session does not mark itself accepted, decided, briefed,
candidate-integrated, or fixed.

## Stop conditions

Stop this package and report the smallest blocker if authorities conflict, a required dependency is
not accepted, evidence lies outside the permitted roots, the coupled question must be split or merged,
or the recommendation would require silently deciding another package's subject.
