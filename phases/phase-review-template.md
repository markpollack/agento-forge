# Phase Review Template

> **Purpose**: Standardized quality gate for Phase 4 (Learning Loop) milestones
> **Created**: January 2026
> **Context**: Extracted from github-explorer Stage 1 review; generalized for all Forge Methodology projects

---

## Where This Fits

In the Forge Methodology, Phase 4 (Learning Loop) executes roadmap steps iteratively. Each **roadmap stage** (a group of related steps) ends with a structured review before proceeding to the next stage. This review is a **compound judge** — it evaluates API design, code quality, documentation grammar, and design conformance in a single pass.

> **Note for research projects**: This template is designed for project and eval-agent variants. Research projects use a **knowledge quality review** instead, evaluating whether claims are supported by evidence, threats to validity are acknowledged, and findings are reproducible. See the [research variant guide](../variants/research.md) and [research loop concept](../concepts/research-loop.md) for the L₁/L₂/L₃ evaluation framework.

```
Phase 4: Learning Loop
  ├── Roadmap Stage N
  │   ├── Step N.0 ... Step N.K (implementation)
  │   └── Step N.(K+1): Stage Review  ◄── THIS TEMPLATE
  ├── Roadmap Stage N+1
  │   ├── ...
  │   └── Stage Review
  └── ...
```

The review produces findings at three severity levels:
- **MUST FIX** — Bugs, incorrect behavior, design contract violations
- **SHOULD FIX** — API issues, naming problems, missing tests, documentation errors
- **CONSIDER** — Style preferences, minor improvements, open questions

MUST FIX items block stage completion. SHOULD FIX items are addressed before the next phase starts. CONSIDER items are logged as learnings.

---

## Generic Review Prompt Template

The template below is parameterized with `{{variables}}`. Fill these in per-project and per-phase.

---

### QA Review: {{STAGE_NAME}} — {{PROJECT_NAME}}

You are reviewing the {{STAGE_NAME}} deliverables of the {{PROJECT_NAME}} project. Your job is to review API design, code quality, and documentation grammar. Be direct and specific — flag issues with file paths and line numbers.

#### Project Context

- **Root**: `{{PROJECT_ROOT}}`
- **Reference implementation**: `{{REFERENCE_IMPL_PATH}}` (if applicable)
- **Design doc**: `{{DESIGN_DOC_PATH}}`
- **Roadmap**: `{{ROADMAP_PATH}}`

#### Source Files to Review

{{SOURCE_FILE_LIST}}

#### Test Files to Review

{{TEST_FILE_LIST}}

#### Config and Docs to Review

{{CONFIG_AND_DOCS_LIST}}

---

#### Review Checklist

##### A. API Design Review

For each public class and method, evaluate:

1. **Naming consistency**: Do Java names align with the reference implementation (if any) and the design doc? Flag mismatches between what the design specifies and what was implemented.
2. **Method signatures**: Are parameter types, return types, and nullability annotations correct? Are there missing `@Nullable` annotations or incorrect throws clauses?
3. **Encapsulation**: Should any public methods be package-private? Are there methods that should be public but are not?
4. **Static vs instance**: For utility classes — is the choice of static methods vs instance methods appropriate for how callers will use the API?
5. **Testability**: Can all code paths be tested without resorting to reflection or mocking static methods? Are there hidden dependencies that should be injected?
6. **Data model alignment**: Do column names, field names, enum values, or record components match the reference implementation? Flag any mismatches with specific values.
7. **Error handling**: Are the right exception types used? Is there a mix of checked and unchecked exceptions that should be unified? Are error messages useful for debugging?
8. **Thread safety**: Are shared mutable objects (caches, registries, static fields) safe for concurrent access?

##### B. Code Quality Review

1. **Unused imports**: Check all source and test files for unused imports.
2. **Magic numbers and strings**: Are there literal values that should be extracted to named constants? Pay attention to thresholds, boundary values, column names, and format strings.
3. **Null safety**: Does every code path handle null inputs correctly? Check optional fields, missing JSON keys, empty collections, and nullable return values.
4. **Edge cases**: What happens with empty inputs, missing fields, malformed data, or boundary values? Are these tested?
5. **Test coverage gaps**: Identify untested branches. Are the uncovered branches meaningful (real error paths) or incidental (defensive guards that cannot trigger)?
6. **Test fixture completeness**: Does the test data adequately cover boundary conditions? Are there missing edge cases that would catch real bugs?
7. **Duplication**: Is there copy-pasted logic that should be extracted? Are there near-identical test methods that could share setup?

##### C. Grammar and Documentation Review

Review all markdown files and all Javadoc/code comments for:

1. **Spelling errors**
2. **Grammar mistakes** (subject-verb agreement, tense consistency, dangling modifiers)
3. **Unclear or ambiguous phrasing**
4. **Inconsistent terminology** (e.g., mixing "field" and "column", "PR" and "pull request", "load" and "parse")
5. **Incorrect technical claims** (wrong version numbers, inaccurate API descriptions, outdated information)
6. **Missing or broken cross-references** between documents

##### D. Design Conformance Review

Compare the implementation against the design doc and roadmap:

1. **Class signatures**: Do public classes match what the design specifies (method names, parameter types, return types)?
2. **Package structure**: Are classes in the packages the design specified?
3. **Behavioral contract**: Does the implementation behave as the design describes? Are there undocumented behavioral differences?
4. **Justified deviations**: If the implementation differs from the design, is the deviation intentional and documented (e.g., in a learnings file)?
5. **Roadmap completeness**: Are all roadmap checkboxes marked? Do the exit criteria actually hold?

---

#### Output Format

Organize findings by severity:

**MUST FIX** — Bugs, incorrect behavior, or violations of the design contract. These block phase completion.

**SHOULD FIX** — API design issues, naming problems, missing tests, or documentation errors that will cause confusion in later phases.

**CONSIDER** — Style preferences, minor improvements, or questions for the developer to think about.

For each finding, include:
- File path and line number(s)
- What the issue is
- Suggested fix (if applicable)

---

## Operational Workflow

The Phase Review runs as an iterative loop between the **implementation agent** (the Claude Code session building the project) and a **QA agent** (a separate Claude Code session that reviews). The human developer orchestrates by copy-pasting between sessions.

### Current Manual Process

```
┌─────────────────────┐     populated prompt      ┌─────────────────────┐
│  IMPLEMENTATION      │ ──────────────────────── > │  QA AGENT            │
│  AGENT               │                            │  (separate Claude    │
│  (Claude Code        │                            │   Code session)      │
│   session building   │ < ──────────────────────── │                      │
│   the project)       │     findings document      │  Reads all files,    │
│                      │                            │  produces MUST FIX / │
│  1. Generates the    │                            │  SHOULD FIX /        │
│     review prompt    │                            │  CONSIDER findings   │
│     from template    │                            │                      │
│  2. Receives         │                            │                      │
│     findings back    │                            │                      │
│  3. Fixes issues     │                            │                      │
│  4. Repeats until    │                            │                      │
│     "all clear"      │                            │                      │
└─────────────────────┘                            └─────────────────────┘
        │                                                   │
        │           human copies prompt / findings          │
        └───────────────────────────────────────────────────┘
```

**Step by step:**

1. **Implementation agent generates the review prompt**: At the end of a roadmap stage's cleanup step, the implementation agent populates the template variables (file lists, project context) and produces a complete, self-contained review prompt. This prompt is saved as a file (e.g., `plans/prompts/phase1-review-prompt.md`) so it can be copy-pasted.

2. **Human copies prompt to QA agent**: The developer opens a separate Claude Code session and pastes the populated prompt. The QA agent reads all listed files and produces findings organized by severity.

3. **Human copies findings back**: The developer copies the QA agent's response and saves it as `plans/learnings/phaseN-qa-review.md` (first iteration) or `plans/learnings/phaseN-qa-review-K.md` (subsequent iterations, where K is the iteration number starting at 2). This file is the handoff artifact — the implementation agent reads it to know what to fix.

4. **Implementation agent fixes issues**: The implementation agent reads the latest findings file and resolves MUST FIX and SHOULD FIX items. CONSIDER items are logged in learnings.

5. **Iterate**: If the implementation agent made changes, copy the same review prompt to a fresh QA session and repeat. The review prompt does not change between iterations — only the findings output gets a new `-K` suffix. The loop exits when the QA agent reports zero MUST FIX and zero SHOULD FIX findings (or the remaining SHOULD FIX items are accepted as-is).

### Prompt Generation Requirement

Each roadmap's cleanup step must include a work item to **generate the populated review prompt as a file**. The implementation agent should:

- Create `plans/prompts/phaseN-review-prompt.md` with all `{{variables}}` filled in
- Include the full file lists (source, test, config/docs) with absolute paths
- Add any project-specific review items beyond the generic checklist
- The prompt must be self-contained — the QA agent session has no prior context

### Handoff Prompt Template

After the QA agent produces findings and the human saves them to a findings file, the human needs a short prompt to paste into the **implementation agent** session. This tells the implementation agent where to find the findings and what to do.

Save as `plans/prompts/phaseN-review-handoff[-K].md` (matching the findings iteration number).

```
{{STAGE_NAME}} QA Review — Iteration {{K}} Handoff

A QA review pass has been completed. The findings are at:

  plans/learnings/phaseN-qa-review[-K].md

{{PREVIOUS_REVIEW_SUMMARY}}

Read the findings file and triage:

1. Resolve all MUST FIX items (blocks phase completion)
2. Resolve all SHOULD FIX items (or document why a specific item is deferred)
3. Acknowledge CONSIDER items in the learnings
4. Update the findings file Status from PENDING to RESOLVED when done
5. Update CLAUDE.md distilled learnings if any fixes produced new insights
```

| Variable | Description | Example |
|----------|-------------|---------|
| `{{STAGE_NAME}}` | Stage being reviewed | `Stage 1` |
| `{{K}}` | Iteration number (omit for first) | `2` |
| `{{PREVIOUS_REVIEW_SUMMARY}}` | One-line status of prior iteration (omit for first) | `The first review (phase1-qa-review.md) had 1 MUST FIX and 10 SHOULD FIX — all resolved.` |

The handoff prompt is deliberately minimal — it points to the findings file rather than duplicating its contents. The findings file has the detailed issues with file paths and line numbers.

### Future: Automated Judge via claude-code-java-sdk

The manual copy-paste workflow is a bootstrap. The target automation is a **Judge implementation** that programmatically:

1. Populates the review prompt template from the project's file system
2. Spawns a QA agent session via `claude-code-java-sdk` (or equivalent agent SDK)
3. Passes the populated prompt programmatically
4. Receives structured findings (parsed into MUST FIX / SHOULD FIX / CONSIDER)
5. Feeds findings back to the implementation agent
6. Loops until the QA agent returns zero blocking findings

This maps to the Judge Framework in the Agent Creator architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                    PHASE REVIEW JUDGE                        │
│                                                              │
│  PhaseReviewJudge implements Judge {                         │
│                                                              │
│    // 1. Collect file lists from project structure           │
│    List<Path> sourceFiles = glob("src/main/java/**/*.java"); │
│    List<Path> testFiles = glob("src/test/java/**/*.java");   │
│                                                              │
│    // 2. Populate prompt template                            │
│    String prompt = template.populate(sourceFiles, ...);      │
│                                                              │
│    // 3. Invoke QA agent via SDK                             │
│    ClaudeCodeSession qa = ClaudeCode.spawn(prompt);          │
│    ReviewFindings findings = qa.run();                       │
│                                                              │
│    // 4. Return structured verdict                           │
│    return new Verdict(findings.mustFix(),                    │
│                       findings.shouldFix(),                  │
│                       findings.consider());                  │
│  }                                                           │
│                                                              │
│  // Outer loop calls this repeatedly until passing           │
│  boolean isBlocking() {                                      │
│    return !findings.mustFix().isEmpty();                     │
│  }                                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

The key insight is that the Phase Review is already structured as a judge — it takes inputs (file lists), applies criteria (the checklist), and produces a verdict (severity-tagged findings). The manual copy-paste workflow is the human acting as the orchestration layer that the SDK will replace.

---

## How to Use This Template

### 1. Populate the Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Human-readable project name | `github-explorer (ghx)` |
| `{{STAGE_NAME}}` | Roadmap stage being reviewed | `Stage 1 — Data Layer` |
| `{{PROJECT_ROOT}}` | Absolute path to project root | `/home/mark/projects/github-explorer` |
| `{{REFERENCE_IMPL_PATH}}` | Path to reference implementation (or "N/A") | `/home/mark/projects/prplot/prplot/data_loader.py` |
| `{{DESIGN_DOC_PATH}}` | Path to design document | `/home/mark/projects/github-explorer/plans/DESIGN.md` |
| `{{ROADMAP_PATH}}` | Path to roadmap | `/home/mark/projects/github-explorer/plans/ROADMAP.md` |
| `{{SOURCE_FILE_LIST}}` | Numbered list of source files with full paths | (see example below) |
| `{{TEST_FILE_LIST}}` | Numbered list of test files with full paths | (see example below) |
| `{{CONFIG_AND_DOCS_LIST}}` | Numbered list of config/doc files with full paths | (see example below) |

### 2. Add Project-Specific Review Items

The generic checklist covers common concerns. Add project-specific items under each section:

- **A. API Design**: Add items specific to the domain (e.g., "Do column names match the Python DataFrame column names?" for a data porting project)
- **B. Code Quality**: Add items for project-specific patterns (e.g., "Is the `Clock` injection pattern used consistently?" for time-dependent code)
- **D. Design Conformance**: Reference specific design doc sections and line numbers

### 3. Run the Review

Pass the populated prompt to a QA agent (a separate Claude session or dedicated review agent). The reviewer should:

1. Read all listed files
2. Evaluate against all checklist items
3. Produce findings organized by severity
4. Include file paths and line numbers for every finding

### 4. Triage Findings

| Severity | Action | Blocks Phase? |
|----------|--------|---------------|
| MUST FIX | Fix before proceeding | Yes |
| SHOULD FIX | Fix before next phase starts | No |
| CONSIDER | Log in learnings doc, decide later | No |

### 5. Record in Learnings

Save QA findings as iteration-numbered files:

```
plans/learnings/phaseN-qa-review.md      # first iteration
plans/learnings/phaseN-qa-review-2.md    # second iteration
plans/learnings/phaseN-qa-review-3.md    # third iteration, etc.
```

The implementation agent always picks up the **highest-numbered** file as the current action item. Each findings file should reference the previous iteration so the chain of reviews is traceable.

Each findings file should follow this structure:

```markdown
# Phase N QA Review — Iteration K

**Date**: YYYY-MM-DD
**Reviewer**: QA agent (Phase Review)
**Status**: PENDING — implementation agent should triage and resolve

**Previous review**: `plans/learnings/phaseN-qa-review[-K-1].md` — [summary of prior status]

## MUST FIX
- [Finding with file path and line number]: [Suggested fix]

## SHOULD FIX
- [Finding with file path and line number]: [Suggested fix]

## CONSIDER
- [Finding with file path and line number]: [Observation]

## Handoff Instructions
Implementation agent should:
1. Read this file at the start of the triage step
2. Resolve MUST FIX items (blocks phase completion)
3. Resolve SHOULD FIX items (or justify deferral)
4. Log CONSIDER items as acknowledged
5. Update this file's Status line from PENDING to RESOLVED
```

**Why iteration numbering matters**: The review prompt (`plans/prompts/phaseN-review-prompt.md`) stays the same across iterations — it describes *what to review*. Only the findings output changes, because the code changes between rounds. Without iteration suffixes, the second review overwrites the first, losing the audit trail of what was found and fixed.

---

## Relationship to Judge Framework

This review template is a **manual judge** — a human-readable evaluation prompt. In the Agent Creator architecture, it maps to the Judge Framework as follows:

| Review Section | Judge Type | Automation Path |
|----------------|-----------|-----------------|
| A. API Design | AI Judge | LLM-based evaluation with design doc as ground truth |
| B. Code Quality | Hybrid | Deterministic (unused imports, coverage) + AI (edge cases, duplication) |
| C. Grammar | AI Judge | LLM-based proofreading |
| D. Design Conformance | Hybrid | Deterministic (class existence, package location) + AI (behavioral contract) |

As the Judge Framework matures, sections of this template will be automated:
- **Deterministic checks** (coverage thresholds, ArchUnit rules, unused imports) run as part of `mvn verify`
- **AI checks** (naming quality, documentation clarity, design conformance) run as Judge implementations
- **The manual template** remains for the compound review that combines all dimensions

---

## Example: File List Format

```
#### Source Files to Review

1. `/home/mark/projects/my-project/src/main/java/com/example/data/DataLoader.java`
2. `/home/mark/projects/my-project/src/main/java/com/example/data/FieldInfo.java`
3. `/home/mark/projects/my-project/src/main/java/com/example/data/package-info.java`

#### Test Files to Review

4. `/home/mark/projects/my-project/src/test/java/com/example/data/DataLoaderTest.java`
5. `/home/mark/projects/my-project/src/test/java/com/example/data/FieldInfoTest.java`
6. `/home/mark/projects/my-project/src/test/java/com/example/ArchitectureTest.java`
7. `/home/mark/projects/my-project/src/test/java/com/example/TestFixtures.java`
8. `/home/mark/projects/my-project/src/test/resources/test-data.json`

#### Config and Docs to Review

9. `/home/mark/projects/my-project/pom.xml`
10. `/home/mark/projects/my-project/CLAUDE.md`
11. `/home/mark/projects/my-project/plans/learnings/step-1.0-topic.md`
12. `/home/mark/projects/my-project/plans/learnings/step-1.1-topic.md`
```

---

## Appendix: Sample Review Response

The following is an actual Phase Review response from the github-explorer project (Stage 1 — Data Layer), preserved as a reference for the expected output quality and structure. The full response is archived at `github-explorer/plans/learnings/phase1-qa-review.md`.

### Response Characteristics

This review found **16 items** across all severity levels:

| Severity | Count | Examples |
|----------|-------|---------|
| MUST FIX | 1 | Design doc method signatures don't match implementation |
| SHOULD FIX | 10 | Stale learnings references, missing error path tests, magic numbers, unused dependency, wrong test comments |
| CONSIDER | 5 | Redundant alias columns, static vs instance FieldInfo, thread safety awareness |

### What Made This Review Effective

1. **Specificity**: Every finding includes file path and line numbers (e.g., `DataLoader.java:170-185`, `CLAUDE.md:43-44`)
2. **Actionable fixes**: Each finding includes a concrete fix, often with code snippets
3. **Cross-file consistency**: Caught stale references across learnings docs, CLAUDE.md, and DESIGN.md that no single-file linter would find
4. **Severity discipline**: Only 1 MUST FIX (genuine design-implementation mismatch); SHOULD FIX items are real but non-blocking; CONSIDER items are observations with no action required
5. **Design awareness**: Compared implementation against both the design doc and the Python reference, flagging intentional deviations separately from bugs
6. **Forward-looking**: CONSIDER items note future-phase implications (e.g., "revisit static FieldInfo in Stage 6", "Table is not thread-safe for Stage 7 ACP agent")

### Anti-Patterns to Avoid

- Inflating severity — cosmetic issues as MUST FIX erodes trust in the review
- Vague findings without file paths — "the naming could be better" is not actionable
- Re-litigating design decisions — the review evaluates implementation against the design, not the design itself
- Missing the cross-file dimension — the highest-value findings (#2, #3) were stale references across documents that individual file reviews would miss

---

## Appendix: Learnings from Practice

### Iteration numbering for findings files (discovered 2026-01-28)

The original template prescribed a single findings file (`phaseN-qa-review.md`) with no provision for multiple review rounds. In practice, github-explorer Stage 1 required two review iterations:

1. First review found 16 items (1 MUST FIX, 10 SHOULD FIX, 5 CONSIDER) → saved as `phase1-qa-review.md`
2. Implementation agent resolved all items
3. Second review found 10 new items (0 MUST FIX, 5 SHOULD FIX, 5 CONSIDER) → needed `phase1-qa-review-2.md`

Without the `-K` suffix, the second review would overwrite the first, losing the record of what was found and fixed. The review prompt stays the same — it describes the files to review, which don't change. Only the findings change because the code improved between rounds.

**Key insight**: The review prompt and the findings output have different lifecycles. The prompt is write-once; the findings iterate. Separate naming conventions reflect this.
