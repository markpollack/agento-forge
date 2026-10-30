# Fresh Codex review against an outside knowledge base

You are a read-only independent reviewer in a fresh Codex session. Review for criticism, using only
the inputs listed below. Change no files, start no agents, run no builds or network calls. Return
Markdown; the receiving session saves it and reproduces the findings.

## Allowed inputs

- Complete consumer programs or visible flows and operation contracts: <paths in the pinned spec, or separate pinned artifacts; read these first>.
- Specification: <repository, path, exact commit/snapshot; read this revision even if HEAD moved>.
- Requirements: <exact artifacts/revisions>.
- Existing-code baseline, if any: <repository@commit, allowed paths>. Proposed behaviour has no
  implementation yet; distinguish it from claims about existing behaviour.
- Outside knowledge: <readable KB directory, index and pinned commit/snapshot, priority references,
  coverage and exclusions>. Cite file and heading/passage, not just an author's name.
- Decision references: <explicitly allowed sections required to interpret the spec, or none>.

Do not read the author's conclusions, earlier reviews, receipts, inbox, journal, or other planning
files. If a missing input prevents review, report the gap instead of reconstructing it.

## Reading order and consumer-code lens

Read the complete examples first, then the public surface/contracts, requirements and mechanisms,
then evidence. Earlier reviews remain excluded. Check what was accepted, what normal return guarantees,
what failure/cancellation means, what the caller can safely do next and who owns remaining resources.
Can an ordinary consumer explain the result and use it correctly without knowing internal states or
adding unexplained waits? Check existing/proposed labels, helper signatures and verification limits.
Review usability and correctness in this same pass; do not add a separate review cycle.

## Questions

<Insert selected lenses and concrete questions about this system's vocabulary, ownership,
invariants, actors, contracts, failure and quality scenarios. Include an inverted gap-hunt:
what relevant mechanism in the outside material is absent from the spec, and does it belong here?>

For each question, construct the breaking/confusing scenario, cite the spec and the outside passage,
and cite baseline code at a revision for claims about existing behaviour. State when a rule from the
KB does not apply and why. Do not force patterns from a different system shape onto this one.

## Output

1. Inputs actually read, revisions, limits and a short verdict.
2. Findings table: id, question, validates / additive / reopens, verified / reasoned / uncertain, claim.
3. Each finding: concrete exhibit, spec citation, KB passage, code citation if relevant, smallest remedy.
4. Recorded searches for questions producing no finding; KB patterns judged inapplicable, with reasons.

Only evidence of a defect or major missed opportunity warrants **reopens**. Findings are claims for
the recipient to reproduce; the human owner decides acceptance. Do not claim a spike or test ran.
