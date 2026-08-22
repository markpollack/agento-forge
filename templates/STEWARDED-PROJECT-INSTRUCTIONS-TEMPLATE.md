# Template: instruction files for a project that has gained a steward

> **When to use**: after `bootstrap-steward-repository.sh` or
> `bootstrap-minimal-steward-repository.sh` creates a steward, the **project** repository still
> carries instruction files written for a world where planning lived inside it. This is the
> project-side counterpart the bootstrap does not generate.
>
> **Established from**: `agent-judge` (the first pair), applied to `agent-client` (commit
> `359d281`, 559 lines → 28 + 4).

## The shape

Two files, and the split is deliberate. `AGENTS.md` is canonical and tool-neutral; `CLAUDE.md` is
a bridge that exists only so a Claude Code session lands somewhere and is redirected. Any other
tool's convention file should be the same four-line bridge.

Keep `AGENTS.md` short. It answers one question — *what does an agent working in **this
repository** need that it cannot infer from the code?* Build gates, hard rules, invariants that
erode silently. Everything about **why** the project exists, what it should become, and what is
decided belongs in the steward.

## `AGENTS.md`

```markdown
# {{PROJECT_NAME}} Agent Instructions

This public repository owns code, tests, builds, releases, shipped contracts, and public
documentation. Private planning and control state are authoritative in
`{{STEWARD_DIR}}`; read its `BINDING.md` before planning or executing work.

<!-- Build gate: the exact command, plus anything bound to an early phase that fails
     before compilation. -->

<!-- Hard rules: constraints an agent would otherwise violate reasonably.
     State the rule and the consequence, not just the rule. -->

<!-- Invariants: boundaries that erode without a written reason. Give each one a check
     a session can actually run before committing. -->

Follow `/home/mark/projects/agento-forge/guides/java-library-quality.md`. The project uses a
customized source license; see `LICENSE`. Commit messages contain no AI attribution.

Do not copy private planning, roadmap, checkpoint, or dirty-tree state into public files.
```

## `CLAUDE.md`

```markdown
# {{PROJECT_NAME}} Claude Code Bridge

Read and follow `AGENTS.md`. It is the canonical repository instruction file for all coding agents.
Do not duplicate project guidance or private steward state here.
```

## Also do

- **Delete the project's `plans/` tree.** Once the steward owns planning, a local copy can only
  drift — and an ignored copy is the kind that gets edited by mistake. Confirm the steward's
  preservation is complete first.
- **Annotate `.gitignore`** where `plans/` is ignored, naming the steward, so the next reader
  knows it is a boundary rather than an oversight.
- **Preserve the old instruction file** as migration evidence in
  `<steward>/plans/archive/migration/project-CLAUDE.md`. The bootstrap does this automatically
  when the file exists at the source commit.

## Do not

- Do not re-track `plans/` in the project to "make it durable." That publishes private planning
  and undoes the decision the steward exists to implement.
- Do not carry vision, roadmap or open questions into `AGENTS.md`. If an agent needs them, it
  needs the steward.
- Do not do this while a session is mid-work in the project — rewriting its instruction file
  underneath it is a collision, not a cleanup.
