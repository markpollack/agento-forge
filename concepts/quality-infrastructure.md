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

## Anti-Patterns

- **Deferring quality setup** — "We'll add coverage tracking later." Later never comes, or it reveals a mountain of gaps.
- **Coverage theater** — Setting coverage thresholds without reviewing what's actually covered. 80% line coverage means nothing if all the error paths are in the uncovered 20%.
- **No architecture rules** — Relying on code review to catch layer violations. Humans miss these; tools don't.
- **Ignoring vulnerability scans** — Suppressing all findings instead of addressing them. Each suppression should have a documented rationale.
- **Quality tools without quality culture** — Tools report problems; someone has to fix them. If findings are routinely ignored, the tools become noise.
