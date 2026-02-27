---
name: forge-steward
description: "Bootstrap stewardship for an existing project (Forge Steward Variant)"
---

# Forge Steward — Bootstrap Project Stewardship

> **Installation**: Copy this file to `~/.claude/commands/forge-steward.md` for global access.

You are helping bootstrap stewardship for an existing project using the Forge methodology's steward variant. This skill handles: understanding the project's current state, bootstrapping a knowledge base, writing steward sections for CLAUDE.md, configuring monitoring, and defining accountability boundaries.

## When to Use

Use this skill when:
- A project exists and needs ongoing maintenance, not a fresh build
- The project has passed its build phase (Phase 5 complete, or already live)
- Someone wants a persistent, accountable agent for a domain
- A project's CLAUDE.md needs steward sections added

## Arguments
- `$ARGUMENTS` - Optional: project path, knowledge source paths, brief file path
  - If `$ARGUMENTS` contains a path to a `.md` file named `*-brief.md`, treat it as a pre-filled steward brief. Read it first, confirm with user, then proceed to Phase 2.

## Configuration

**UPDATE THESE PATHS** to point to your installations:

- **Forge methodology location**: `/path/to/forge-methodology`
- **Steward variant doc**: `/path/to/forge-methodology/variants/steward.md`
- **KB architecture doc**: `/path/to/forge-methodology/concepts/knowledge-base-architecture.md`

## Instructions

### Phase 1: Understand the Project

Start by understanding the project's current state. Be conversational:

1. **What project are you stewarding?** Ask for:
   - Project path
   - What the project does (1-2 sentences)
   - Who uses it (internal, open-source community, both)

2. **What's the current state?** Investigate:
   - Read existing CLAUDE.md, README, and build files
   - Run the build if possible (`mvn compile`, `npm build`, etc.)
   - Check git log for recent activity
   - Look for existing plans/, learnings/, or docs/

3. **What knowledge sources exist?** Ask about:
   - Plans, roadmaps, design docs in the project
   - Learnings from the build phase
   - External KBs with related knowledge (for federation cross-refs)
   - Monitoring sources (GitHub issues/PRs, dependency trackers)

4. **What's the accountability scope?** Ask:
   - What does the steward own? (build health, KB, roadmap execution)
   - What does the steward NOT own? (upstream deps, other projects, strategy)
   - Are there related projects the steward should cross-reference but not modify?

### Phase 2: Bootstrap the Knowledge Base

Create the KB directory structure under `plans/knowledge/`:

```bash
mkdir -p {project}/plans/knowledge/{architecture,development,monitoring}
```

For each domain, create an `index.md` routing table:

#### Root index.md

```markdown
# {Project Name} Knowledge Base

> Steward KB for ongoing project health and development.
> **Last updated**: {date}

## Navigation

| If you need... | Start here | Read when... |
|----------------|-----------|--------------|
| Architecture decisions | `architecture/index.md` | Planning changes or understanding design |
| Development state | `development/index.md` | Working on roadmap items or fixing issues |
| Project monitoring | `monitoring/index.md` | Checking health or reviewing changes |

## See Also: External Knowledge

| If you need... | See | Entry point |
|----------------|-----|-------------|
| {external topic} | {external KB name} | {path to entry point} |

## Not Covered

This KB does **not** address:
- {exclusion 1}
- {exclusion 2}
```

#### Curate Content

For each knowledge source identified in Phase 1:
1. Read the source material
2. Extract relevant knowledge into the appropriate domain directory
3. Write routing entries in the domain's index.md
4. Cross-reference related topics

**Key content to extract:**
- Architecture decisions and design philosophy → `architecture/`
- Lessons learned, known issues, current roadmap state → `development/`
- GitHub issue/PR summaries, build status → `monitoring/`

### Phase 3: Write Steward CLAUDE.md Sections

Add steward sections to the project's existing CLAUDE.md. **Augment, don't replace** — keep existing build/test/commit sections.

Add these sections:

#### Steward Mission
One sentence defining what this steward is accountable for.

#### KB Navigation
Routing table to `plans/knowledge/` directories and federation cross-refs.

#### Two Modes

```markdown
## Two Modes

### Development Mode
Triggered when: user asks to build, fix, implement, or execute roadmap items.
- Execute roadmap steps with entry/exit criteria
- Write code, run tests, create commits
- Update CLAUDE.md and KB as work progresses

### Stewardship Mode
Triggered when: user asks to check status, review health, or plan work.
- Run health checklist (build, tests, deps)
- Review monitoring data (github-collector output, new issues/PRs)
- Update KB with new findings
- Propose development actions to the human
```

#### Health Checklist
Project-specific health checks:
```markdown
## Health Checklist
- [ ] Build passes: `{build command}`
- [ ] Tests pass: `{test command}`
- [ ] {domain-specific checks, e.g., "SDK versions current", "No critical issues open"}
```

#### Accountability Boundaries
```markdown
## Accountability Boundaries

### Owns
- {explicit list of what steward is responsible for}

### Does NOT Own
- {explicit list of what's out of scope}
```

### Phase 4: Configure Monitoring (Optional)

If the project is on GitHub and github-collector is available:

1. Set up github-collector for the project's repository
2. Configure output to go to `plans/knowledge/monitoring/github-summary.md`
3. Document the monitoring configuration in CLAUDE.md

If github-collector is not available, note it as a future enhancement and skip.

### Phase 5: Review and Refine

Present the completed setup to the user:

1. **KB structure** — Show the directory tree and routing tables
2. **CLAUDE.md additions** — Show the new steward sections
3. **Monitoring status** — Show what monitoring is configured (or not)
4. **Federation cross-refs** — Show external KB links
5. **Health check** — Run the health checklist once to demonstrate

Ask:
- Does the mission statement capture what you want?
- Are the accountability boundaries right?
- Any missing knowledge domains?
- Any external KBs to add to federation?

Iterate until they're satisfied.

## Tone

Be practical and grounded. Stewardship is about ongoing care, not grand architecture. Focus on what the steward actually needs to know and do, not theoretical completeness. A steward with 5 useful KB entries beats one with 50 stale ones.

When defining accountability boundaries, err on the side of being specific. "Owns the build health" is better than "owns the project." Specific boundaries prevent scope creep.
