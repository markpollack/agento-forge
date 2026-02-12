# Software Project Example

A minimal example of a software project structure using the Forge methodology.

## Structure

```
my-library/
├── plans/
│   ├── VISION.md                    # Problem, success criteria, scope
│   ├── RESEARCH.md                  # Prior art, reference implementations
│   ├── DESIGN.md                    # Architecture, interfaces, decisions
│   ├── ROADMAP.md                   # Implementation steps
│   └── learnings/
│       └── LEARNINGS.md
├── src/
│   └── main/
│       └── java/                    # (or your language)
├── test/
│   └── ...
├── docs/
│   └── getting-started.md
└── pom.xml                          # (or build.gradle, package.json, etc.)
```

## Key Files

### VISION.md

```markdown
# Vision: My Library

## Problem Statement
Developers need to X but existing solutions Y.

## Success Criteria
1. Handles all 47 test cases from reference implementation
2. API is backward-compatible with existing library Z
3. Performance within 10% of baseline

## Scope
### In Scope
- Core API functionality
- Integration with framework F

### Out of Scope
- GUI components
- Real-time streaming (deferred to v2)

## Unknowns
1. How does library Z handle edge case E?
2. What's the performance ceiling on operation O?
```

### DESIGN.md

```markdown
# Design: My Library

## Architecture

### Components
| Component | Responsibility |
|-----------|---------------|
| Parser | Converts input to internal model |
| Processor | Applies transformations |
| Serializer | Outputs result |

## Interfaces

### Parser
\`\`\`java
public interface Parser<T> {
    T parse(InputStream input) throws ParseException;
}
\`\`\`

## Design Decisions

### DD-1: Use streaming parser
**Context**: Input files can be large (>1GB)
**Decision**: Stream-based parsing instead of DOM
**Alternatives**: DOM parsing — rejected due to memory
```

### ROADMAP.md — Standard Steps

```markdown
## Stage 1: Foundation

### Step 1.0: Design Review
- [ ] REVIEW design against vision
- [ ] VERIFY reference patterns apply

### Step 1.1: Project Scaffolding
- [ ] INITIALIZE git repository
- [ ] CREATE build config with dependencies
- [ ] VERIFY empty project compiles

### Step 1.2: Quality Infrastructure
- [ ] CONFIGURE test coverage (JaCoCo/etc.)
- [ ] CONFIGURE architecture rules (ArchUnit/etc.)
- [ ] CONFIGURE formatting

### Step 1.3: Test Infrastructure
- [ ] CREATE test fixtures
- [ ] VERIFY test infrastructure runs

### Step 1.K: Stage 1 Review
- [ ] GENERATE review prompt
- [ ] RUN QA review
- [ ] FIX findings
```

## Phase 4: QA Review Loop

```
1. Implement a roadmap stage
2. Generate review prompt from template
3. Run review (separate session)
4. Receive findings:
   - MUST FIX: Blocks completion
   - SHOULD FIX: Address before next phase
   - CONSIDER: Log in learnings
5. Fix and re-review until zero blocking findings
```

## See Also

- [Software Variant Guide](../../variants/project.md)
- [Phase Review Template](../../phases/phase-review-template.md)
- [Quality Infrastructure](../../concepts/quality-infrastructure.md)
