# Handoff — {topic} ({date})

> Work order for {the next session in this repo | a session in {satellite repo}}. Written by the ending
> session at a known-good state (docs current, tree clean, pushed). See `concepts/session-handoff.md` for
> the practice; launch with the standard two-line prompt.

## Roles inherited
{What this session IS: e.g. "program coordinator + Lane-B executor, mid-Step-X.Y" — name every hat, not
just the task.}

## Read in order (do not skip)
1. `CLAUDE.md` (auto-loaded) — note {the sections that matter right now}.
2. {The live status surface — board / roadmap / tracker.}
3. {The finding/learnings file that defines the immediate work.}
4. {The governing work order / design doc for the current stage.}
5. {Skim-level context: journals, parent plans.}
{Rule: the session's own conventions first, specifics second. Pull ONLY cited files from other repos.}

## Where things stand ({date})
{Per-lane / per-stage state. Done ✅ / in-progress 🔵 / blocked 🟡 with the blocking gate named. Include
in-flight external things that may report back mid-session (satellite sessions, long-running jobs) and what
to do when they do.}

## Do this now
{The concrete, ordered work list. Each item: what, where, and its acceptance check. End with:}
- **STOP after {checkpoint}** and report back: {the report format — what landed, decisions taken,
  surprises, what the next step needs}.

## Run mechanics (hard-won — do not rediscover)
{Exact commands for long jobs, environment pins (JDKs, tool versions), detach/poll patterns for runs that
outlive command timeouts, build invocations, formatting steps. Anything the predecessor learned the hard
way.}

## Guardrails (standing)
{Commit conventions · honest-measurement rules (what may never be silently claimed or skipped) ·
classify-don't-guess policies · repo visibility constraints · anything the project's CLAUDE.md enforces
that is easy to violate mid-flow.}

> **If this session receives reports from other sessions**, a returned report is a *claim*, not a result:
> verify it independently before accepting it — a re-run, not a skim. Check first the claims a report
> makes about its **own discipline** ("the build is green", "every check was watched failing", "the sweep
> ran after the fixes", "all citations re-verified"). Those are the cheapest to check, the likeliest to
> have been written from intent rather than observation, and everything else in the report rests on them.
> When a returned report and a plan row disagree, **the row wins** until an act changes it — otherwise
> the plan degrades into a description of whatever happened. See `concepts/session-handoff.md`
> § The Supervisor Pattern.

> **Verify the tree before acting on this order.** It describes the repo as it was when it was written:
> check the branch, HEAD, that the named files still exist, and that the build is green — then reconcile
> and report the drift. The order says what to do; the tree says what is there.

## Human-gates (surface only — never decide)
{Decisions reserved for the human, with enough context that the session can RAISE them crisply when they
become load-bearing.}
