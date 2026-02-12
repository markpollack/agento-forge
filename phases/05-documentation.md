# Phase 5: Documentation

## Purpose

Create user-facing documentation for the completed implementation. Tutorials, API references, and guides that let someone else use what you built.

## Inputs

- Working implementation from Phase 4
- Learnings documents
- Design documents

## Outputs

- docs/ directory with tutorials, API reference, and guides
- README with quickstart
- Working code examples

## Key Activities

1. **Define the documentation structure** — What does a user need to know? Organize by user journey, not by implementation structure.
2. **Write tutorials** — Step-by-step guides that walk through common use cases. Every code example must work.
3. **Document the API surface** — Public interfaces, configuration options, error handling. Be precise about contracts.
4. **Create a getting-started guide** — The shortest path from zero to working. Minimize prerequisites.
5. **Verify examples** — Run every code example. Broken examples are worse than no examples.
6. **Explain the "why" and "what's happening" before code** — Every code block should be preceded by context: what the code does, why it does it, and what the reader should expect. Don't drop bare code on the reader and assume they'll figure out the mental model. Name specific tools and explain their role (e.g. "This launches Gemini CLI as an ACP agent subprocess" not just `AgentParameters.builder("gemini")`). A reader seeing the code for the first time needs to understand the mechanism, not just the API call.

## Exit Criteria

- Every public API has documentation
- At least one tutorial for the primary use case
- Getting-started guide takes a new user from zero to working
- All code examples tested and working
- No references to internal implementation details that users don't need

## Relationship to Other Phases

- **Consumes Phase 4** — documents the working implementation
- Final phase of the [Execution Pipeline](../concepts/execution-pipeline.md)
- **Benefits from learnings** — common pitfalls discovered in Phase 4 become FAQ entries or warnings in docs

## Anti-Patterns

- **Documenting internals** — Users don't need to know how it works internally unless they're extending it.
- **Untested examples** — Code examples that don't compile or run. Always verify.
- **Implementation-order documentation** — Organizing docs by how you built it rather than how users need it.
- **Missing error documentation** — What errors can occur and what do they mean? Users hit errors; help them.
- **No quickstart** — Forcing users to read everything before they can try anything.
- **Bare code without context** — Showing code without explaining what it does or why. Every example needs a sentence or two above it that orients the reader: what is being demonstrated, what the moving parts are, and what the expected outcome is. Code comments alone are not sufficient — the surrounding prose must carry the explanation.
