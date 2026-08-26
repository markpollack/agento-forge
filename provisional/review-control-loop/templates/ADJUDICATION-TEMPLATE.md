# Adjudication — {{review-id}}

> **Candidate:** {{immutable commit/tag and candidate record}}
> **Review:** {{received review record}}
> **Adjudicator:** {{identity/session}}
> **Issuance state:** DRAFT | ISSUED
> **Issuance control recommendation:** CORRECTIONS REQUIRED | HOLD | READY FOR VERIFICATION

## Issuance human checkpoint

- **Current state:**
- **Why work stopped:**
- **What was established:**
- **Decisions needed from the owner:** {{include a recommended default and consequence of deferral}}
- **What changed:**
- **What did not change:**
- **Review coverage:** {{plain counts, for example “122/122 roadmap clauses examined”; do not use
  “denominator” without translating it}}
- **Next authorized action:**

Keep this checkpoint short and place it before detailed evidence. It is a derived view of the ledger,
not a new authority; link to the detailed rows rather than restating project decisions. Freeze it when
the adjudication is issued. Later state and recommendations are appended as dated replacement
checkpoints below; never rewrite this issuance snapshot.

## Finding ledger

| ID | Claimed severity | Category | Priority | Adjudication result | Decision class | Closure state | Exhibit / owner / trigger | Owning package | Contributors / dependencies | Next-candidate change |
|---|---|---|---:|---|---|---|---|---|---|---|
| | | | 1–10 | reproduced / partial / refuted / owner decision | validates / additive / reopens | accepted-open / fixed / refuted / filed / parked | | direct / WP-NN | none / WP-NN | |

`Accepted-open` is non-terminal and must become fixed, filed, parked, or refuted before ratification.
Priority orders controller attention from `1` (first) through `10` (last); it is not severity.
Authority/integrity gates and declared dependencies override the number.

## Work-package routing

Omit this section when every accepted finding can move directly into one bounded correction. Keep this
as the only package board; do not create a second findings ledger or a package roadmap.

| Package | Findings owned | Contributes to | Shared question or invariant | Depends on | Owner checkpoint | Integration targets | Initial state |
|---|---|---|---|---|---|---|---|
| WP-NN | | none / finding / WP-NN | | none / WP-NN / decision | | proposal / VISION / DESIGN / ROADMAP / tests | queued |

Each finding has one owning package or the direct-correction path. Contributors supply an input; they
do not propose that finding's overall closure route. Package state tracks the design-work flow and is
separate from finding closure. `Decided` means the package disposition and required owner choices are
accepted for synthesis; it does not mean any finding is `fixed`. `Briefed` means it appears in the
accepted correction brief. `Candidate-integrated` means the next candidate contains its intended
change, still subject to verification.

## Review coverage — method detail

The denominator is the total finite inventory available to check; `walked` is how much of that
inventory was actually examined. Open-ended searches name attempted scenario families instead.

| Lens | Finite inventory or scenario families | Walked | Findings | Recorded non-finding search | Residual gap |
|---|---|---:|---:|---|---|
| | | | | | |

## Correction boundary

State the exact accepted corrections and explicit exclusions. Do not use this section to introduce new
design work. If coupled questions require adjudication work packages, state the package boundary and
dependency order here; the package dispositions and later correction brief will supply the design
resolution.

### Direct-correction obligations

Use this table only when no work-package/correction-brief path is needed. These numbered obligations
are the exact correction scope an owner may authorize; prose outside the table does not silently add
work.

| Obligation | Findings | Artifact and section | Required semantic change | Accepted source / owner pointer | Acceptance or falsifier | Explicit exclusions |
|---|---|---|---|---|---|---|
| DC-NN | | | | | | |

## Verification request

Name the immutable corrected candidate, restricted inputs, lenses, denominators, and the structural
blockers the verification reviewer must attempt to construct.

## Append-only controller transitions and checkpoints

This section is deliberately last so appending state never shifts citations to issued adjudication
content above. Freeze the finding and routing rows when this adjudication is issued. The controller
appends package, owner, containment, briefing, candidate-integration, and closure transitions at EOF;
it never rewrites an earlier row or a returned package disposition. Current state is the last valid
transition for that subject. A new candidate/review round gets a new adjudication ledger.

Subjects include `finding`, `WP-NN`, `correction brief`, `direct correction boundary`, `routing`, and
`candidate`. Required events include `package-returned`, `owner-accepted`, `owner-rejected`,
`owner-reopened`, `contained`, `brief-issued`, `brief-authorized`, `routing-superseded`,
`candidate-integrated`, `finding-closed`, and `superseded`. An accepted direct correction boundary
transitions to `authorized-for-planning-correction`; rejection or reopening remains equally explicit.
Other resulting states include `returned-for-controller-check`, `contained`, `owner-decision`,
`decided`, `briefed`, `candidate-integrated`, `fixed`, `refuted`, `filed`, `parked`, `rejected`,
`reopened`, and `superseded`.

A `routing-superseded` event names the affected finding/package, old and new owning package,
contributors, dependencies, and reason. It is the only way to apply a package-requested split or merge
without rewriting the issued routing table. Append a replacement human checkpoint in the same event
whenever the operative control recommendation or authorized next action changes. The newest checkpoint
supersedes the prior control view without altering it.

Append each actual event after the prior event at EOF using this shape; do not insert rows into earlier
content:

```markdown
### <transition-id> — <timestamp>

- **Subject:**
- **Event:**
- **Prior state:**
- **Resulting state:**
- **Routing / decision / evidence pointer:**
- **Controller:**

#### Replacement human checkpoint (omit unless control state changed)

- **Derived current state:**
- **Control recommendation:** CORRECTIONS REQUIRED | HOLD | READY FOR VERIFICATION
- **Established facts / owner decisions:**
- **Coverage:**
- **Next authorized action:**
```
