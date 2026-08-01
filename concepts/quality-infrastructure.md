# Quality Infrastructure

## What It Is

Quality infrastructure is the set of automated checks that act as **deterministic judges** throughout a project's lifecycle. These tools run on every build, catching issues before they reach human review.

Quality infrastructure is set up early — during the first roadmap stage — because:
- It establishes the quality baseline before any production code exists
- Retrofitting quality tools onto existing code is harder than starting clean
- Automated checks free stage reviews to focus on design and behavioral concerns

## Core Quality Concerns

Every project, regardless of language, needs automated checks for these concerns:

| Concern | What It Catches | When It Runs |
|---------|----------------|--------------|
| **Test coverage** | Untested code paths | Every build |
| **Architecture rules** | Layer violations, circular dependencies, naming violations | Every build |
| **Null safety** | NullPointerExceptions and similar null-reference bugs | Compile time |
| **Vulnerability scanning** | Known CVEs in dependencies | Periodic / pre-release |
| **Integration testing** | Unit tests pass but real system interactions fail | `verify` phase (separate from unit tests) |
| **Code formatting** | Inconsistent style | Every build or pre-commit |
| **Documentation** | Missing public API docs | Pre-release |

## Language-Specific Guides

The tooling differs by language, but the concerns are universal:

| Language | Guide |
|----------|-------|
| Java | [Java Library Quality](../guides/java-library-quality.md) — JaCoCo, ArchUnit, JSpecify, OWASP, Failsafe, Javadoc |

## Where Quality Infrastructure Fits in the Methodology

### Phase 2: Design

The design should specify the quality strategy:
- What coverage threshold?
- What architecture rules to enforce?
- What null-safety approach?
- What vulnerability scanning tool?

### Phase 3: Roadmap

Every roadmap should include a **quality infrastructure setup step** early in Stage 1, after project scaffolding but before implementation begins. The standard sequence is: design review → project scaffolding → quality infrastructure → test infrastructure → implementation. See the [Roadmap Template](../templates/ROADMAP-TEMPLATE.md).

### Phase 4: Learning Loop

Quality tools run as part of the build during every step. They act as deterministic judges (see [Judges and Evaluation](judges-and-evaluation.md)):
- **Coverage reports** show which code paths lack tests
- **Architecture rules** catch structural violations immediately
- **Vulnerability scans** flag dependency risks before release
- **Stage reviews** verify that quality checks are passing and thresholds are met

## Relationship to Stage Reviews

Quality infrastructure and stage reviews are complementary, not redundant:

| Quality Infrastructure | Stage Review |
|----------------------|--------------|
| Automated, runs every build | Manual or AI-assisted, runs at stage boundaries |
| Deterministic (pass/fail) | Qualitative (MUST FIX / SHOULD FIX / CONSIDER) |
| Catches: coverage gaps, rule violations, CVEs | Catches: design mismatches, naming quality, documentation clarity |
| Fast feedback loop (seconds) | Thorough evaluation (minutes) |

A stage review that consistently finds coverage gaps or architecture violations is a sign that quality infrastructure is misconfigured or missing.

## Checks That Catch, Not Checks That Pass

> **A check must be demonstrated to fail before it is trusted.** Run it against a fixture carrying each defect class it claims to catch, plus controls that must *not* fire. A check never shown to fail is a decoration, and worse than none: it converts "unenforced" into "falsely believed enforced".

A green check reports one of two things and does not distinguish them: *the defect is absent*, or *the check cannot see it*. Four practices close the gap, in ascending order of how much they cost:

**1. Watch it fail on a replica of the motivating defect.** Before trusting a new check, reproduce the exact defect that motivated it and confirm the check goes red. Not a similar defect — that one. The cheapest version is a revert: apply the check to the commit before the fix.

**2. Sabotage tables for sweeps.** When a check runs across many targets, a single red is weak evidence. Disable the check (or break one target deliberately) and assert **exactly** the expected set of failures — no more, no fewer — while the controls stay green. A sweep that fires on everything and a sweep that fires on the right things look identical from a passing build.

**3. Instrument walks against vacuity.** A check that iterates — over files, fixtures, rules, members — must report its **denominator**. "Clean" from a loop that ran zero times is the most convincing false result available, and it arrives silently when a glob stops matching, a directory moves, or a filter tightens. Make the count part of the output, and assert it is non-zero.

**4. Self-tests that seed a defect.** For a check complex enough to have its own bugs, commit a fixture carrying each defect class plus controls, and run the check against them as part of the build. The check is then itself under test, and the fixtures are a permanent record of what it claims to catch.

The unifying idea: a sabotage is a [counterexample](refutation-by-counterexample.md) aimed at the check. The check is a claim ("this defect class cannot survive here"), and claims are settled by exhibits.

## The Graduation Rule

> **Twice is a practice.** A lesson that bites twice graduates from prose to a script, a probe, or a test.

The first occurrence is bad luck and belongs in a learnings file. The second is evidence of a *class*, and a class deserves a mechanism. Continuing to trust the habit after the second occurrence is a decision to pay for it a third time.

Two rules make the graduation stick:

- **Each rule carries the mistake that produced it.** A check whose failure message explains only *what* is wrong gets suppressed by the next person who does not know *why* it exists. One sentence naming the original defect is the difference between a rule people respect and a rule people route around.
- **The lesson lands in the harness, not in one instance.** Fixing the project you noticed it in leaves every sibling project to rediscover it. The graduation target is the thing that future instances inherit: the template, the scaffolding command, the shared build configuration, the methodology page. A learnings entry that improves only its own project has been filed, not graduated.

This generalizes past code. A **UI exit criterion that is a sentence about the running product** ("the panel stays responsive while the job runs") gets a committed probe, because a sentence is not a gate. A prose convention that has been violated twice — a citation format, a doc cross-reference, an embedded example that must stay valid — becomes a script in the build. Both of those started as things reviewers were trusted to notice, and both were graduated after the second miss.

**Watch the graduated check fail before trusting it**, per the section above. A rule promoted from prose to a script inherits none of the prose's credibility; it is a new claim.

## Anti-Patterns

- **Deferring quality setup** — "We'll add coverage tracking later." Later never comes, or it reveals a mountain of gaps.
- **Coverage theater** — Setting coverage thresholds without reviewing what's actually covered. 80% line coverage means nothing if all the error paths are in the uncovered 20%.
- **No architecture rules** — Relying on code review to catch layer violations. Humans miss these; tools don't.
- **Ignoring vulnerability scans** — Suppressing all findings instead of addressing them. Each suppression should have a documented rationale.
- **Quality tools without quality culture** — Tools report problems; someone has to fix them. If findings are routinely ignored, the tools become noise.
- **Trusting a check that has never been red** — See above. It reports the absence of evidence and gets read as evidence of absence.
- **A walk with no denominator** — "Clean" from an empty loop, which is the failure mode that survives longest because nothing about it looks wrong.
- **Paying for the same lesson a third time** — The second occurrence was the signal to graduate it.

## Related

- [Checks and exhibits](refutation-by-counterexample.md) — why a sabotage settles a question that an argument about the check cannot
- [Registers of absence](registers-of-absence.md) — the inverse instrument: a check that passes *because* something is missing, and fails when it arrives
- [Decision enforcement](decision-enforcement.md) — naming the design decision a check defends
- [Authoring-surface quality](../guides/authoring-surface-quality.md) — the diagnostics-and-conduct standard for surfaces people write into, which ordinary quality tooling does not grade
