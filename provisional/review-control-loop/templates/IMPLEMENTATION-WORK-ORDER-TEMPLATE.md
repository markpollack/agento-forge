# Dispatch: {{roadmap-step-id}} — {{step-title}}

> **Authorized by:** {{ratification-record-path}}
> **Steward:** {{absolute-steward-path}}
> **Project:** {{absolute-project-path}}
> **Planning view:** {{materialized-candidate-bundle | controller-certified active trio}}
> **Roadmap authority:** {{roadmap-path-and-step-id}}
> **Evidence destination:** {{step-learning-or-implementation-record-path}}
> **Worker:** {{fresh-session/tool-selection}}
> **Stop:** {{exact-step-boundary}}

This is a dispatch envelope, not a second implementation plan. VISION owns purpose and boundaries,
DESIGN owns behavior, ROADMAP owns work items and exit criteria, and the ratification record owns
authorization. If those authorities are insufficient or conflict, stop and correct/adjudicate them;
do not expand this work order with substitute requirements.

## Read

1. Canonical steward `AGENTS.md`
2. Steward binding
3. Ratification record
4. The named execution planning view
5. ROADMAP {{roadmap-step-id}}
6. Only the decisions, project inputs, and engineering standard directly referenced by that step

Read ordinary planning files. For a controller-certified legacy planning view, do not reconstruct the
candidate with repeated `git show`, per-file hashes, or a worktree.

## Execute

Execute ROADMAP {{roadmap-step-id}} exactly. ROADMAP owns its sequence, work items, deliverables, and
exit criteria. DESIGN and its referenced decisions own semantics. Stop with a concise exhibit rather
than choosing a new design branch if implementation reveals a conflict or new failure case.

## Mutation boundary

- **Project:** {{authorized project path families needed by the roadmap step}}
- **Steward:** {{roadmap state, step evidence/learning, and current-action pointer}}
- **Preserve:** {{known unrelated working-tree paths or `none`}}
- **Forbidden:** {{external repositories or state specifically at risk in this dispatch}}

Commit project implementation and steward evidence separately when the roadmap requires commits.
{{push/install/publish authorization or explicit prohibition}}

## Completion and stop

Write the evidence required by the ROADMAP exits to {{step-learning-or-implementation-record-path}}.
Report the exit-criterion result and exact repository states, update the current-action pointer to a
human checkpoint, and stop. Do not begin {{next-roadmap-step-id}} or act as the independent reviewer.

Stop earlier if an entry criterion is false, unrelated changes overlap the mutation boundary, a
governing authority conflicts, or satisfying the step requires work outside this dispatch.

The filled dispatch should normally remain one readable page. Do not copy roadmap bullets, design
truth tables, human authorization prose, generic Git instructions, or a second completion checklist
into it.
