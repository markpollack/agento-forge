# Materialized Candidate Bundle Template

Use this layout for every new review candidate unless the candidate inputs are genuinely too large or
cannot legally be copied. A manifest-only candidate is an exception that must record its reason and
reviewer cost.

```text
plans/reviews/<review-id>/candidate-NN/
├── README.md
├── VISION.md
├── DESIGN.md
├── ROADMAP.md
├── CORRECTIONS.md
├── decisions/
│   └── <decision-files-needed-by-this-candidate>.md
└── project-inputs/
    └── <repository-name>/
        └── <supporting-files-needed-by-this-candidate>
```

## Bundle construction rules

1. Copy the reviewed documents byte-for-byte. Do not prepend snapshot banners to the copies; declare
   their standing once in the bundle README.
2. Include only decisions and supporting inputs needed to interpret the review question. A candidate
   is not a repository archive.
3. In `README.md`, map every copy to its authoritative source path and source repository commit.
4. In `CORRECTIONS.md`, map every accepted adjudication finding to its Candidate NN exhibit. Preserve
   refuted, filed, and parked dispositions without turning them into corrections.
5. Commit and tag the complete bundle. The tag protects the bundle as one tree; do not add redundant
   per-file hashes for tracked bundle contents.
6. Reviewers read the materialized files directly. `git show`, worktrees, and history traversal are
   optional challenge tools, not the normal reading path.
7. Never rewrite a frozen bundle. A correction creates `candidate-(NN+1)`.

Normally commit corrected active steward documents first, then materialize their exact copies in a
separate bundle commit. This makes the source steward commit knowable before the bundle is written.
Never try to embed a candidate commit hash inside that same commit; the candidate tag is the stable
identity for the completed bundle.

## README.md skeleton

```markdown
# Candidate NN — <review title>

> **Standing:** FROZEN FOR REVIEW | CORRECTED, AWAITING VERIFICATION
> **Candidate tag:** <tag>
> **Steward commit:** <commit>
> **Prior candidate:** <candidate/tag or none>
> **Adjudication:** <path or none>

This directory is an immutable review record. Its copies are not competing active authorities; the
authoritative source paths are listed below.

## Bundle inventory and provenance

| Bundle path | Authoritative source | Source repository commit | Purpose |
|---|---|---|---|
| `VISION.md` | `plans/VISION.md` | `<steward-commit>` | Product purpose and boundaries |
| `DESIGN.md` | `plans/DESIGN.md` | `<steward-commit>` | Architecture and decisions |
| `ROADMAP.md` | `plans/ROADMAP.md` | `<steward-commit>` | Execution order and gates |

## Review question

<One bounded question.>

## Explicit exclusions

- <Not reviewed or changed.>

## Reviewer entry point

Read this directory as ordinary files. Run one candidate-ref preflight if required; do not reconstruct
the bundle through repeated Git commands.
```

## CORRECTIONS.md skeleton

```markdown
# Corrections from Candidate NN-1

| Finding | Prior disposition | Candidate NN exhibit | Intended terminal state |
|---|---|---|---|
| `<ID>` | `accepted-open` | `DESIGN.md:<section>` | `verified-corrected` |

## Deliberate non-changes

| Finding/decision | Why unchanged | Reopen trigger or owner |
|---|---|---|
| `<ID>` | Refuted, filed, parked, or protected | `<evidence/trigger/owner>` |
```
