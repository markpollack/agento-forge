# Reproducible 1:1 Steward Repository Bootstrap

> **Status:** PROVISIONAL — dogfood and revise from observed failures
> **Applies to:** the private one-project/one-steward-repository model in this experiment
> **Canonical scaffold:** `scripts/bootstrap-steward-repository.sh`
> **Canonical validator:** `scripts/validate-steward-repository.sh`

This procedure creates the private planning and control boundary described by `PROTOCOL.md` §9. It
does not use the older `/forge-steward` command, which adds stewardship content inside an existing
project. The output here is a separate repository paired 1:1 with the project.

The procedure is deliberately staged. Local scaffold creation, private remote creation, public
bridge migration, and first-message transport proof are separately inspectable transitions. A
single opaque command must not create repositories, rewrite the public project, migrate authority,
and send mail without intermediate validation.

## Inputs to freeze before creation

Record these values before running the scaffold:

- project local checkout and repository slug;
- exact committed project source identity to import;
- project default or active branch;
- new steward local checkout and repository slug;
- establishment date;
- authoritative planning root, normally `plans`;
- any deliberate exception to the singular `plans/VISION.md`, `plans/DESIGN.md`,
  `plans/ROADMAP.md` layout.

The planning import is from the exact committed object via `git archive`, never from a dirty working
tree. Untracked or ignored planning requires an explicit preliminary preservation/import act; the
bootstrap must not silently treat it as committed authority. Exact import preserves evidence, but it
does not by itself preserve execution continuity: the new steward must also adjudicate and record the
current roadmap frontier before its first commit.

The current scaffold enforces the singular root trio. A multi-effort exception such as
`plans/v3/{VISION,DESIGN,ROADMAP}.md` requires a prior procedure amendment and an explicit binding
deviation; do not create root pointer files or flatten load-bearing paths merely to satisfy the
validator.

## Stage 1 — create and validate the local private boundary

```text
provisional/review-control-loop/scripts/bootstrap-steward-repository.sh \
  --project-dir /absolute/project \
  --project-slug owner/project \
  --project-branch main \
  --project-commit <full-commit> \
  --steward-dir /absolute/project-steward \
  --steward-slug owner/project-steward \
  --established YYYY-MM-DD
```

The destination must not exist or must be empty. The scaffold:

1. verifies the exact project commit and active planning trio;
2. initializes a `main` steward repository;
3. imports the committed planning tree without rewriting paths;
4. creates stable `AGENTS.md`, `BINDING.md`, `CLAUDE.md`, and README interfaces;
5. records project instruction files as migration evidence when they exist at the source commit;
6. installs the tracked gitmaildir layout described below; and
7. creates an intentionally incomplete continuity checkpoint; and
8. runs the structural validator.

It does not commit, create a remote, push, edit the project, or send a message. Inspect the complete
tree, scan it for credentials and accidental generated output, complete the continuity migration
below, and then make one coherent bootstrap commit.

### Preserve the active work frontier

The imported planning tree is migration input. Before the bootstrap commit:

1. read the imported VISION, DESIGN, ROADMAP, and applicable learnings in their established order;
2. identify the last accepted/completed work, the exact next active or paused frontier, every filed
   but unauthorized item, and every owner/release hold;
3. complete `plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md` with those facts and the disposition
   of any path moved while adapting to the steward layout;
4. update the active ROADMAP only enough to declare private steward authority and make the same
   frontier and holds unambiguous; do not reset checkboxes, reopen accepted work, infer authorization,
   or silently reprioritize filed work;
5. keep historical evidence under an explicit archive path and repair relative links if a path move
   is necessary; and
6. run the final continuity gate:

```text
provisional/review-control-loop/scripts/validate-steward-repository.sh \
  --steward-dir /absolute/project-steward --require-continuity
```

The validator refuses unresolved `[REQUIRED]` fields. Semantic continuity remains a reviewed human
judgment; the scaffold makes that judgment mandatory and inspectable rather than pretending it can
derive roadmap meaning from checkbox syntax.

Run the self-contained regression before dogfooding a changed scaffold:

```text
provisional/review-control-loop/scripts/test-bootstrap-steward-repository.sh
```

The fixture proves committed-object import, exclusion of dirty/untracked planning, coexistence with
ordinary Forge inbox intake, mandatory gitmaildir paths, instruction-file provenance, empty initial
audit state, continuity-gate refusal/acceptance, and refusal to reuse a non-empty destination.

## Gitmaildir-enabled by construction

Every new steward has gitmaildir work directory `plans/` and these tracked paths from its first
commit:

```text
plans/
├── audit/events.jsonl
└── inbox/
    ├── new/{steward-follow-up,steward-receipt}/.gitkeep
    ├── cur/{steward-follow-up,steward-receipt}/.gitkeep
    ├── archive/{steward-follow-up,steward-receipt}/.gitkeep
    └── dead/{steward-follow-up,steward-receipt}/.gitkeep
```

`plans/audit/events.jsonl` starts as an empty tracked file. Message types may be added later, but the
two inter-steward types are mandatory. Existing ordinary Forge intake may coexist under other
`plans/inbox/` children; it is not transport merely because it shares the parent directory.
`.worker-heartbeats/` is runtime state and is ignored.

The binding must state the inbox preflight cadence, recipient-owned disposition, receipt lifecycle,
and at-least-once idempotency rule. A directory-only scaffold is not full transport proof.

## Stage 2 — create and verify the private remote

After the local bootstrap commit, create a private repository explicitly and push `main`:

```text
gh repo create <owner/project-steward> --private \
  --source /absolute/project-steward --remote origin --push
gh repo view <owner/project-steward> --json visibility,defaultBranchRef
```

Stop if visibility is not `PRIVATE`, the default branch is not `main`, or the pushed HEAD differs
from the inspected bootstrap commit. Repository privacy is an invariant, not a naming convention.

## Stage 3 — migrate the public repository interface separately

Only after the steward authority is committed and privately pushed may a separately authorized
project change:

- add or reduce tracked `AGENTS.md` to a stable bridge naming the steward binding;
- reduce tool-specific instruction files to minimal bridges;
- remove or archive competing public/ignored planning authority according to the recorded migration;
  and
- preserve project-owned code, tests, builds, releases, and public documentation.

The public bridge contains no current action, candidate identity, roadmap status, message ID,
correlation, checkpoint, dirty-tree exception, or private planning content.

## Stage 4 — prove real transport with the first message

The first inbox request is the transport acceptance test. Use gitmaildir's real `GitPublisher`, not
a hand-shaped JSON file. Prove:

1. the generated `MailboxMessage` lands in `plans/inbox/new/<type>/` through a delivery commit/push;
2. a recipient planning session performs preflight and records exactly one disposition in recipient
   authority;
3. the real receiver moves the immutable message through `cur` to `archive`;
4. the recipient returns a separate `steward-receipt` to the sender;
5. retrying by message/correlation ID cannot duplicate the disposition or receipt; and
6. both repositories retain complete audit events, including final archive events in a follow-up
   commit when required by gitmaildir's current ordering.

Until the operator CLI exists, a project may need a bounded launcher to invoke the Java API. Record
that friction as product evidence; do not weaken the transport proof by manually writing JSON.

## Stage 5 — capture dogfood corrections

Every bootstrap records:

- source project/steward commits and remote visibility check;
- imported path/count and any excluded source state;
- the last completed work, exact resumed frontier, filed-but-unauthorized work, and owner/release
  holds carried across the authority boundary;
- validator result;
- public bridge commit, if separately authorized;
- first message/correlation, disposition authority, receipt, and lifecycle result; and
- every manual repair or ambiguous choice the procedure required.

Fold a repeated repair into this scaffold, validator, or procedure before creating the next steward.
Do not preserve oral folklore as the only fix.

## Stop conditions

Stop without improvising when:

- the source planning authority is uncommitted or contradictory;
- the destination is non-empty;
- an active trio path is missing;
- remote privacy cannot be verified;
- a public bridge would expose private content;
- importing would rewrite load-bearing paths; or
- the first message cannot use the real gitmaildir lifecycle.
