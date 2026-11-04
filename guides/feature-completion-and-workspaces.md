# Feature completion and temporary workspaces

## The rule

> A feature is complete when its accepted implementation is integrated into main and usable through the project's normal delivery path. Remaining review, qualification, publication or consumer verification must appear explicitly in the roadmap, with an owner. Temporary worktrees and build caches must be removed or have a recorded reason to remain.

A feature or use case can span several roadmap steps, commits and sessions. An implementation
step can finish before the feature finishes. Report that progress honestly and leave the feature
open while its delivery requirements remain unmet.

For software, main is the normal integration target. Follow an explicitly documented project
policy where another target is required. Use the project's delivery path: a library may need a
published development package; an application may need its normal build or deployment; a private
research tool may need reproducible commands and durable inputs. Do not impose public publication
or a stable release on every project.

## Put delivery in the roadmap

At the top of ROADMAP.md, state the rule and identify the intended integration target and delivery
path. Give each active feature an explicit route through the applicable work:
implementation -> review/qualification -> main integration -> publication/delivery -> fresh
consumer verification -> workspace disposition.

These can be named steps or existing step exit criteria. Do not add a publication step after
every small code change. Do not move an implementation checkbox backward merely because a later
delivery step is still open. The feature's completion remains distinct.

For a blocked transition, record the owning step/session or repository, concrete blocker and next
action. A pushed task branch and a local install are useful checkpoints; they are not ordinary
downstream consumption. Keep source checks, controlled tests, native observations, publication
and consumer acceptance separate.

Use the existing roadmap and owning receipts. Do not create another feature state machine or
copy complete evidence into a second ledger.

## Before creating isolation

Use the normal existing checkout and ordinary dependency repository when they suffice. Verify
the current owner and local work first. A session or roadmap step boundary alone is not a reason
to create a worktree, branch or private cache.

When isolation is necessary, record its path, purpose, owner and closing condition in the current
task/handoff. Examples include an independent review, preserving unrelated local work, or building
different candidate bytes under identical development coordinates.

Never move an active owner's checkout underneath it or create a second writer in its repository.
An accepted feature should not stay indefinitely on an aggregate development branch. Integrate
through the repository's required review/gates, then continue from updated main, using short-lived
branches when its process requires them.

## Dependency repositories and evidence

Do not clone an entire Maven repository for each workspace. Do not use writable hard-linked
copies: changing one linked artifact changes the shared bytes. When builds really need isolation,
populate a bounded repository with the required dependencies and record its closing condition.
Do not overwrite another active build's snapshot inputs or delete shared dependencies.

A build cache is disposable infrastructure, not the durable artifact offer. Preserve the
necessary original evidence, artifact coordinates/checksums, logs, commands and manifests in the
project's durable approved location. Verify backup/content before removing the working copy.
Prefer relative bundle paths and reproducible dependency resolution for new evidence.

Existing frozen evidence may depend on absolute paths or old cache layouts. Preserve its replay
requirements or a verified restoration recipe before cleanup; do not rewrite historical evidence
to make deletion convenient.

## At a session boundary

Update the roadmap before the successor handoff. Account for:
- branch and source/main refs, including pushed WIP and unpushed work;
- review/qualification and delivery still outstanding, with the next owner/action;
- temporary worktrees/private caches and their disposition: removed, actively retained, or blocked
  with a reason and a next review point;
- durable evidence and any restoration/consumer recipe;
- commands still running and actual ownership.

A session may end before feature completion. Commit/push clearly labeled WIP where allowed; never
call a failing or unfinished step complete to satisfy a closeout checklist. Preserve unrelated work.
No automatic deletion, force push, branch removal or publication is authorized by this guide.

## Feature exit

The feature's applicable checks must establish:
- reviewed/qualified accepted work is integrated in the declared target;
- its delivery exists and is usable by an independent fresh consumer, not only the producer's cache;
- remaining limits are explicit and do not contradict the feature's accepted scope;
- temporary resources are removed or explicitly retained with owner, reason and next action.

Reuse valid owning evidence. Final stable-release certification is separate from development
delivery, unless the feature's agreed scope itself requires a stable release.
