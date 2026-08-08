# Ratification {{candidate-number}} — {{review-title}}

> **Candidate:** {{candidate-tag-or-commit}}; {{candidate-bundle-path}}
> **Verification:** {{verification-record-path}}
> **Human decision received:** {{timestamp}}
> **Candidate decision:** {{RATIFIED | REOPEN | REJECTED}}
> **Execution authorization:** {{NOT AUTHORIZED | exact-roadmap-step}}
> **Intended worker:** {{unspecified | tool/model/session selected by human}}

## Human instruction

{{Record the human's operative instruction verbatim or as a confirmed concise statement. Do not infer
ratification or execution authority from a positive reviewer recommendation.}}

## Decision effect

- {{What planning state is now authoritative.}}
- {{Which residual risks the verification record leaves to execution.}}
- {{Whether one exact roadmap step may be dispatched.}}
- Candidate files remain immutable; this record does not modify them.

## Controller transition

{{If execution is not authorized, name the next human decision required. If one step is authorized,
name the implementation work-order path and the canonical AGENTS.md pointer update.}}

## Explicit non-effects

- Ratification is not implementation evidence.
- Worker selection is not independent verification.
- No later roadmap step is authorized implicitly.
- No project, build, dependency cache, release, or external repository changes occur through this
  record alone.
