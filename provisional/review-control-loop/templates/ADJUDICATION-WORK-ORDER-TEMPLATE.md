# Work order: adjudicate {{review-id}}

> **Method:** {{path-or-version-of-review-control-loop-protocol}}
> **Steward repository:** {{absolute-path}}
> **Candidate:** {{immutable-tag-or-commit}}; {{candidate-manifest-path}}
> **Received review:** {{review-record-path}}
> **Output ledger:** {{adjudication-ledger-path}}
> **Mode:** evidence gathering and adjudication; no correction

## Objective

Adjudicate every finding in the received review against the immutable candidate, standing authorities,
and reproducible evidence. Produce a bounded correction recommendation without changing the candidate
or implementing any correction.

## Read in order

1. {{session-instructions-path}}
2. {{steward-binding-path}}
3. {{method-protocol-path}}
4. {{candidate-manifest-path}}
5. {{received-review-path}}
6. {{active-vision-path}}
7. {{active-design-path}}
8. {{active-roadmap-path}}
9. {{additional-authority-pointers-or-none}}

Verify that the candidate ref resolves and that the manifest hashes identify the reviewed artifacts.
Stop and report a candidate-integrity blocker if they do not.

## Evidence permissions

Read-only inspection is allowed under:

- {{project-repository-path}}
- {{additional-evidence-root}}

External research is {{forbidden | allowed only for named finding IDs | allowed}}. Record every external
source used. Evidence permissions do not grant authority to change another repository.

## Mutation boundary

Edit only:

- {{adjudication-ledger-path}}

Do not edit:

- the candidate manifest or candidate-tagged artifacts;
- the received review;
- active VISION, DESIGN, or ROADMAP;
- project or consumer code;
- any evidence source.

## Protected decisions and reopening rule

- {{decision-id-and-authoritative-pointer}}

Do not reopen a settled decision without a new failure case meeting the rule stated by its authority.
Do not restate the decision here.

## Adjudication procedure

For every finding:

1. Reproduce, partially reproduce, refute, or identify an owner decision.
2. Record the exact exhibit: immutable file/ref plus line, command and output, or counterexample. Use
   the least expensive evidence that distinguishes the relevant states; do not checksum ordinary
   versioned dependencies when a declared coordinate/version answers the claim.
3. Separate the claimed defect from the reviewer's proposed remedy.
4. Classify it as validating an existing decision, additive, or reopening settled design.
5. Assign the current closure state:
   - `accepted-open` for the next bounded correction;
   - `refuted` with evidence;
   - `filed` with a named owner or roadmap step; or
   - `parked` with an observable trigger.
6. Name the repository that owns any correction.

Do not mark a finding `fixed` during adjudication unless the cited correction already exists in the
candidate being adjudicated. `Accepted-open` is the normal state for a reproduced, not-yet-corrected
defect.

## Coverage accounting

For every selected lens, report its finite denominator and walked count. If the search is open-ended,
name the scenario families attempted and the residual gap instead of claiming completeness. Record
non-finding searches sufficiently for another reviewer to extend them.

Selected lenses:

- {{lens-and-denominator-or-scenario-family}}

## Required decision brief

End the ledger with:

- reproduced blocking findings;
- refuted or downgraded findings;
- owner decisions required;
- the exact next-candidate correction boundary;
- explicit exclusions;
- residual risks; and
- recommendation: `CORRECT`, `HOLD`, or `READY TO VERIFY`.

## Stop conditions

Do not guess or correct artifacts if:

- candidate identity or hashes cannot be verified;
- two authorities conflict;
- required evidence is outside the allowed roots;
- a finding requires an owner decision before it can be classified; or
- the requested output would require changing another repository.

Candidate-integrity failure or a governing authority conflict stops the whole adjudication. An isolated
owner decision or out-of-scope evidence need stop only that finding: record the blocker, continue all
independent findings, and name the smallest decision or authority change needed to resume it.
