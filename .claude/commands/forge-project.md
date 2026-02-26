---
name: forge-project
description: "Bootstrap a software project (Forge: Vision + Design + Roadmap with QA review loop)"
---

# Forge Project — Bootstrap a Software Project

> **Installation**: Copy this file to `~/.claude/commands/forge-project.md` for global access.
> Then update the paths in the Configuration section below.

You are helping bootstrap a new software project using the Forge methodology's project variant. This skill handles the full lifecycle: understanding the problem, surveying existing solutions and reusable infrastructure, scaffolding the project structure, drafting VISION.md, DESIGN.md, and ROADMAP.md, creating a CLAUDE.md session bridge, and defining the first build stage.

## When to Use

Use this skill when:
- You're building a library, service, application, or tool
- Quality is measured through code review, testing, and documentation
- The output is deployable software with users
- Success means "it works correctly and is maintainable"

Do NOT use this for:
- **Research projects** (gathering papers, building a corpus) → use `/forge-research`
- **Agent evaluation projects** (benchmarks, judges, optimization loops) → use `/forge-eval-agent`
- **Existing projects needing maintenance** → use `/forge-steward`

## Arguments
- `$ARGUMENTS` - Optional: project path, brief file path, reference material paths
  - If `$ARGUMENTS` contains a path to a `*-brief.md` file, treat it as a **pre-filled project brief** (see Brief Format below). Read it first, confirm with user, then proceed to Phase 2.

## Brief Format

A project brief pre-fills Phase 1 answers. When provided:

1. Read the brief file
2. Confirm key details with the user
3. Proceed to Phase 2 using the brief's source material paths

```markdown
# Project Brief: {Project Name}

## Description
{What you're building — 1-2 sentences}

## Problem
{What specific problem does this solve? Who has it?}

## Spark
{What triggered this project}

## Project Path
{Where the project should live}

## Visibility
Private | Community (Apache 2.0)

## Technology
- **Language**: {Java 17+ / Python / TypeScript / etc.}
- **Build tool**: {Maven / Gradle / npm / etc.}
- **Framework**: {Spring Boot / none / etc.}
- **Key dependencies**: {list}

## Source Materials
{Paths to reference implementations, prior work, design discussions}
- {path 1} — {description}

## Existing Infrastructure
{Projects or libraries this project should build on or integrate with}
- {project 1} — {what it provides, path}
- {project 2} — {what it provides, path}

## Success Criteria
1. {measurable outcome, not feature}
2. {measurable outcome}

## Scope
### In Scope
- {item}

### Out of Scope
- {item}

## What This Project Produces
{Deliverables: library JAR, CLI tool, service, documentation}

## What This Project Feeds
{Downstream consumers or integrations}
```

## Configuration

**UPDATE THESE PATHS** to point to your installations:

- **Forge methodology location**: `/path/to/forge-methodology`
- **Templates directory**: `/path/to/forge-methodology/templates`
- **Project variant doc**: `/path/to/forge-methodology/variants/project.md`
- **Phase review template**: `/path/to/forge-methodology/phases/phase-review-template.md`

## Instructions

### Phase 1: Understand the Project

Start by understanding what they're building. Be conversational:

1. **What are you building?** Ask about:
   - The problem it solves and who has that problem
   - What success looks like (measurable outcomes, not features)
   - Technology choices (language, framework, build tool)
   - Whether it's a library, service, CLI tool, or application

2. **What exists already?** Survey:
   - Reference implementations they've seen or used
   - Related projects in their workspace that this should integrate with
   - Libraries or frameworks they want to build on
   - Prior prototypes or design discussions

3. **What infrastructure can you build on?** This is critical — don't reinvent:
   - Read CLAUDE.md files of related projects in the workspace
   - Look for shared libraries, utilities, or frameworks already available
   - Check for community projects (open source) vs private projects
   - Identify interfaces or contracts this project should implement or consume
   - **Ask explicitly**: "Are there existing projects I should look at before designing from scratch?"

4. **Where should the project live?**
   - Project path
   - Private or community (this affects licensing and dependency choices)
   - Git remote (if they want one created)

### Phase 2: Survey Existing Infrastructure

Before designing, understand what's available. This prevents building from scratch when reusable components exist.

1. **Read related projects** identified in Phase 1:
   - Read their CLAUDE.md for scope and architecture
   - Read their DESIGN.md for interfaces and data models
   - Identify what can be depended on vs. what should be copied vs. what's irrelevant

2. **Map the dependency landscape**:
   - What this project depends on (upstream)
   - What depends on this project (downstream consumers)
   - Shared libraries and their current versions
   - Any version conflicts or compatibility constraints

3. **Identify reuse opportunities**:
   - Interfaces to implement (not reinvent)
   - Data models to share (not duplicate)
   - Build patterns to follow (quality infrastructure, test infrastructure)
   - Conventions to match (package naming, error handling, logging)

### Phase 3: Create Structure

Create the project directory:

```bash
mkdir -p {project}/plans/{learnings,prompts}
mkdir -p {project}/src/main/java/{base_package}
mkdir -p {project}/src/test/java/{base_package}
mkdir -p {project}/docs
```

Copy templates from forge-methodology:
- `{forge-methodology}/templates/VISION-TEMPLATE.md` → `{project}/plans/VISION.md`
- `{forge-methodology}/templates/DESIGN-TEMPLATE.md` → `{project}/plans/DESIGN.md`
- `{forge-methodology}/templates/ROADMAP-TEMPLATE.md` → `{project}/plans/ROADMAP.md`

Create build file (pom.xml, build.gradle, etc.) with dependencies identified in Phase 2.

Create `.gitignore` appropriate for the technology.

#### Create CLAUDE.md Session Bridge

Create `{project}/CLAUDE.md` defining:

1. **Project scope and mission** — What this project does, who uses it
2. **Build commands** — How to compile, test, format, verify
3. **Source material routing**:
   | Document | Path | Read when... |
   |----------|------|-------------|
   | VISION.md | `plans/VISION.md` | Always read first |
   | DESIGN.md | `plans/DESIGN.md` | Before implementation |
   | ROADMAP.md | `plans/ROADMAP.md` | Before starting any step |

4. **Key architectural decisions** — Inline the most important design decisions for quick reference
5. **Integration context** — How this project relates to others in the ecosystem
6. **Quality standards** — Test coverage targets, code style, review expectations
7. **Not Covered** — Explicit exclusions
8. **Session behavior** — Follow ROADMAP steps, write tests before implementation, create learnings after each step

### Phase 4: Draft VISION.md, DESIGN.md, and ROADMAP.md

#### VISION.md

- **Problem Statement** — Specific problem, who has it, how they deal with it today
- **Success Criteria** — Measurable outcomes (not features)
- **Scope** — In/out boundaries
- **Unknowns** — What needs investigation (becomes Phase 1 agenda)
- **Assumptions** — Each is a risk if wrong
- **Constraints** — Technology, timeline, compatibility

#### DESIGN.md

Fill in all sections:

- **Build Coordinates** — groupId, artifactId, version, module structure, key dependencies
- **Architecture** — Components, responsibilities, data flow
- **Interfaces** — Contracts with behavioral specifications
- **Data Models** — Fields, types, nullable, descriptions
- **Design Decisions** — Context, decision, alternatives, rationale
- **Error Handling** — Strategy
- **Testing Strategy** — Unit, integration, what's mocked, what's real
- **Skip** the Evaluation Architecture section (that's for eval-agent projects)

When the project integrates with existing infrastructure, reference the upstream project's DESIGN.md for shared interfaces and data models. Don't duplicate definitions — point to the source of truth.

#### ROADMAP.md

Use ROADMAP-TEMPLATE.md. Standard stages:

**Stage 1: Foundation**
- Step 1.0: Design review
- Step 1.1: Project scaffolding (build file, directory structure, dependencies)
- Step 1.2: Quality infrastructure (coverage, formatting, architecture rules)
- Step 1.3: Test infrastructure (fixtures, base classes)

**Stage 2+: Implementation stages** — organized by feature or component, each with entry/exit criteria.

**Last stage: Documentation**
- Getting started guide
- API reference
- At least one tutorial

Each step ends with: run tests → create learnings → update CLAUDE.md → update ROADMAP checkboxes → commit.

### Phase 5: Review and Refine

Present drafts and ask:

1. Does VISION.md capture what you're building and why?
2. Are the success criteria the right targets?
3. Does DESIGN.md cover the architecture — components, interfaces, decisions?
4. Does the ROADMAP order make sense?
5. Are the integration points with existing projects correct?
6. What would you change?

Iterate until satisfied.

### Phase 6: Define First Stage and Handoff

1. **Dependency verification** — Confirm all upstream dependencies are available and at expected versions

2. **Build verification** — If possible, create the scaffold and verify it compiles with all dependencies resolved

3. **Git initialization** — `git init` and first commit, or repo creation

4. **Session handoff** — Write `HANDOFF-BUILD.md`:
   - Mission (implement Stage 1 of ROADMAP.md)
   - "Before You Start" checklist (read CLAUDE.md, VISION.md, DESIGN.md, ROADMAP.md)
   - First roadmap step with entry/exit criteria
   - Key integration context (which projects to reference, which interfaces to implement)
   - "After Each Step" checklist (run tests, update learnings, commit)

5. **QA review setup** — Note when the first QA review should happen (typically after Stage 1 complete). Reference the phase review template from forge-methodology.

## Extraction Patterns

### Project Element Extraction

When reading briefs, conversations, or reference materials:

| Pattern | Extract as |
|---------|------------|
| "The problem is...", "Users need...", "Currently there's no..." | Problem Statement |
| "It should be able to...", "The output is..." | Success Criteria |
| "We need to integrate with...", "It depends on..." | Integration Point |
| "Don't build...", "Out of scope:", "That's for later" | Out of Scope |
| "Use X because...", "We chose Y over Z" | Design Decision |
| "The API should...", "The interface is..." | Interface / Contract |
| "It needs to handle...", "Error case:" | Error Handling Requirement |

### Infrastructure Discovery

When surveying existing projects:

| Pattern | Extract as |
|---------|-----------|
| Interface definitions in DESIGN.md | Contracts to implement |
| Data models in shared libraries | Models to depend on (not duplicate) |
| Build patterns in pom.xml / CLAUDE.md | Conventions to follow |
| Quality thresholds in CLAUDE.md | Standards to match |
| "Not Covered" sections in CLAUDE.md | Integration boundaries |

## Tone

Be practical and grounded. Focus on building something that works correctly, integrates well with existing infrastructure, and is maintainable. Push back on over-engineering — if a simple approach works, use it.

When surveying existing projects, be thorough but selective. Not everything nearby is relevant. Identify the 2-3 projects that actually matter for integration, read their key docs, and move on.

When writing DESIGN.md, be specific enough that an implementation agent can build from it without ambiguity. Interfaces should have behavioral contracts, not just type signatures. Design decisions should explain alternatives and rationale.
