---
name: forge-steward-repo
description: "Bootstrap a private 1:1 steward repository for an existing project (supersedes /forge-steward)"
---

# Forge Steward Repo — Bootstrap a 1:1 Private Steward Repository

Create the private planning and control boundary for an existing project: a **separate repository
paired 1:1 with the project**, holding the authority trio, the inbox, and the audit log.

**This supersedes `/forge-steward`**, which added stewardship content *inside* an existing project.
That model does not work when the project is public — planning cannot live in a repository whose
contents are world-readable — and it is the direct cause of a recurring leak class in which tracked
planning stays exposed long after someone believes it was excluded. Use this command instead. See `Retired predecessor` at the end.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENTO_FORGE_HOME` | `$HOME/projects/agento-forge` | Root of the agento-forge checkout |

Canonical procedure and scaffolds (`{forge}` → `$AGENTO_FORGE_HOME`):

- Procedure: `{forge}/provisional/review-control-loop/STEWARD-REPOSITORY-BOOTSTRAP.md`
- Full scaffold: `{forge}/provisional/review-control-loop/scripts/bootstrap-steward-repository.sh`
- Minimal scaffold: `{forge}/provisional/review-control-loop/scripts/bootstrap-minimal-steward-repository.sh`
- Validator: `{forge}/provisional/review-control-loop/scripts/validate-steward-repository.sh`

**Read the procedure before running anything.** This command orchestrates it; it does not replace it.
The procedure is `PROVISIONAL` by design — revise it from observed failures rather than working
around it.

## Arguments

`$ARGUMENTS` — optional project path or slug. If absent, ask which project needs a steward.

## The staging rule — do not collapse this

The procedure is deliberately staged, and the reason is stated in it: *"A single opaque command must
not create repositories, rewrite the public project, migrate authority, and send mail without
intermediate validation."*

Run the stages as separately inspectable transitions. **Stop between them and report.** Do not chain
Stage 1 through Stage 4 into one action, however routine it looks.

| Stage | Transition |
|---|---|
| 1 | Create and validate the local private boundary |
| 2 | Create and verify the private remote |
| 3 | Migrate the project repository interface (separately) |
| 4 | Prove real transport with the first message |
| 5 | Capture dogfood corrections back into the procedure |

Stages 3 and 4 are **separately authorized**. Finishing 1 and 2 is a complete, useful outcome; say
so plainly rather than implying the steward is fully live.

## Phase 0 — Freeze the inputs

Record these before creating anything. Guessing any of them produces a steward that misrepresents
its project:

- project local checkout and repository slug
- **actual** project visibility (`PUBLIC` or `PRIVATE`) — verify with `gh repo view`, do not assume
- exact committed project source identity to import
- project default or active branch
- new steward local checkout and repository slug
- establishment date
- authoritative planning root, normally `plans`
- any deliberate exception to the singular `plans/{VISION,DESIGN,ROADMAP}.md` layout

## Phase 1 — Choose the scaffold

The choice is determined by evidence, not preference:

**Does the project have a committed active planning trio?**

- **Yes** → `bootstrap-steward-repository.sh`. Planning imports from the **exact committed object
  via `git archive`, never from a dirty working tree.**
- **No** → `bootstrap-minimal-steward-repository.sh`. It requires an exact accepted **seed work
  order from a named private authority repository**, creates a deliberately incomplete minimal trio,
  and refuses to run when a committed trio already exists.

The minimal path is **initialization from explicit authority** — not reconstruction of historical
planning from public documentation or an untracked status summary. If you find yourself inventing
what the project's vision must have been, stop: derive it from cited sources and mark it
`PENDING OWNER RATIFICATION`, which is the established banner for a derived trio awaiting the
owner's sign-off. **A steward whose trio is unratified has no authority. Say so; do not imply otherwise.**

A partial trio is common and is not the same as none. A project with `DESIGN.md` and `ROADMAP.md`
but no `VISION.md` has a design and a roadmap serving a vision nobody wrote down — that is precisely
where the steward earns its keep, and the missing document is the deliverable.

## Phase 2 — Preserve before you create

**Do this first, every time.**

1. Bundle any unpushed commits and untracked planning to `~/backups/`, and `sha256sum` it. If a
   dated backup set already exists, **add to it; never overwrite.**
2. `git log origin/<branch>..HEAD` in the project — confirm what is unpushed and **report it**.
3. Note the checked-out branch and any local-only tags.

Untracked or ignored planning requires an **explicit preliminary preservation act**. The bootstrap
must not silently treat it as committed authority.

**The project repository is read-only during this command.** Do not commit, push, rebase, checkout,
or clean it. Other sessions leave branches checked out with unpushed work; assume they have.

## Phase 3 — Scaffold, then validate

Run the chosen scaffold with the frozen inputs, then:

```
validate-steward-repository.sh --steward-dir ABS --require-continuity
```

`--require-continuity` matters: exact import preserves *evidence*, but it does not preserve
*execution continuity*. **The steward must adjudicate and record the current roadmap frontier before
its first commit** — what is done, what is next, what is filed-but-unauthorized, and what is on hold.

Gitmaildir is enabled by construction: `plans/inbox/{new,cur,archive,dead}/<type>/` plus
`plans/audit/events.jsonl`. Preserved historical content belongs in an archive path such as
`plans/archive/<label>/`, **not** under `plans/inbox/` — content under `inbox/` reads as live
transport. Do not hand-write `events.jsonl`: a faked audit log of a transport that is not running is
worse than none.

## Phase 4 — Remote, and prove it

- `~/bin/gh` **resolves the account by directory**: a repo with no remote resolves by path, so
  anything scaffolded under `~/tuvium/` lands on `mark-tuvium`. Scaffold under `~/projects/` for
  `markpollack`. Check where the project actually lives before creating.
- **PRIVATE.** The whole point is a boundary the public project cannot hold.
- **Prove the push by cloning from the remote** into a temp dir and byte-comparing. `git push &&
  git log -1` reports your local HEAD and proves nothing about the remote.

## Report

1. Steward URL, visibility, proof-by-clone.
2. Which scaffold, and the evidence for that choice.
3. Backup location and checksum status.
4. Confirmation the project repo is untouched: branch, HEAD, tags, untracked files.
5. The recorded roadmap frontier.
6. What is unratified or unknown — stated as such, not smoothed over.
7. Which stages were **not** run (3 and 4 are separately authorized).

## Retired predecessor

`/forge-steward` is **retired**. It bootstrapped stewardship *inside* a project — CLAUDE.md steward
sections, in-repo KB, monitoring config. Retained for historical projects that adopted it; do not
use it for new stewards.

Its failure mode, observed repeatedly: planning content committed inside a public project. A
`.gitignore` entry does not untrack what is already tracked, so the leak persists silently until
someone audits `origin/<default-branch>` directly. The 1:1 private steward repository removes the
possibility rather than relying on discipline.
