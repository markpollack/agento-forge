# Conversation Bootstrapping

## What It Is

Most projects don't start with "write a VISION.md." They start with conversations — brainstorming with ChatGPT, deep research sessions with Claude.ai, back-and-forth design discussions, exploratory questions that gradually reveal the shape of a problem. These conversations contain the raw ideas that eventually become the vision.

Conversation bootstrapping is the practice of **saving these conversations, indexing them by topic, and using them as the raw material for Phase 0 (Vision) and Phase 1 (Research)**.

## Why This Matters

The Forge methodology's phases assume structured artifacts as inputs and outputs. But the *actual* starting point for most people is an unstructured conversation where they explored an idea. Without a bridge between "I had a great conversation about X" and "here's my VISION.md," people either:

1. Lose the ideas (the conversation scrolls away or gets forgotten)
2. Try to recreate the conversation's insights from memory (lossy and frustrating)
3. Skip the methodology entirely because the entry point feels too formal

Saving conversations and treating them as source material eliminates all three failure modes.

## The Practice

### 1. Save conversations as they happen

When you have a productive AI conversation about a project idea, save it immediately:

- **ChatGPT**: Use the "Share" feature to get a link, or copy the conversation to markdown
- **Claude.ai**: Copy the conversation to markdown
- **Other tools**: Whatever export format is available

Save to a `conversations/` directory in your research area:

```
plans/
└── research/
    └── conversations/
        ├── ChatGPT-initial-brainstorm-fixture-extraction.md
        ├── ChatGPT-licensing-deep-research.md
        └── Claude-design-alternatives-discussion.md
```

### 2. Index by topic and phase

Use descriptive filenames that indicate:
- **Source** — which AI system (ChatGPT, Claude, etc.)
- **Topic** — what the conversation was about
- **Date** (optional) — when it happened

When referencing conversations in research documents, cite them as sources:

```markdown
**Sources**:
- `plans/research/conversations/ChatGPT-licensing-deep-research.md` (Chapters 11-13)
- `plans/research/conversations/ChatGPT-openrewrite-takeout.md` (Chapters 1-3, 7-9)
```

### 3. Distill into methodology artifacts

Conversations are raw material, not finished artifacts. The distillation process:

| Conversation content | Becomes | In phase |
|---------------------|---------|----------|
| Problem exploration, "what if we..." | Vision seeds — problem statement, scope ideas | Phase 0 |
| "How does X work?", deep research threads | Research questions and findings | Phase 1 |
| "Should we use A or B?", tradeoff discussions | Design decision candidates | Phase 2 |
| "The hard part is...", constraint discovery | Unknowns and assumptions for the vision | Phase 0 |

A single conversation often feeds multiple phases. That's fine — index it once, reference it from multiple artifacts.

### 4. Attribute the source

When a research finding or design decision originated in a conversation, say so:

```markdown
> **Status**: Draft
> **Source**: Distilled from `ChatGPT-licensing-deep-research.md` (Ch. 11–13),
>            `ChatGPT-openrewrite-takeout.md` (Ch. 1–3, 7–9)
```

This creates a traceable chain from raw exploration to structured artifact.

## The Conversation-to-Vision Pipeline

For users starting from scratch, the typical flow:

1. **Explore** — Have conversations with AI about your problem. Don't worry about structure. Ask questions, explore alternatives, go deep on topics that interest you.
2. **Save** — Export the conversations that contained useful ideas.
3. **Review** — Read through your saved conversations. Highlight the key insights, decisions, and open questions.
4. **Draft** — Use the highlighted material to fill in the [Vision Template](../templates/VISION-TEMPLATE.md). The problem statement comes from your exploration. The unknowns come from questions you couldn't answer. The scope comes from what you decided was and wasn't important.
5. **Continue** — From here, the normal Forge phases take over. Your conversations become research source material.

## Relationship to Other Phases

- **Phase 0 (Vision)**: Conversations are the most natural source of vision seeds. The problem statement, success criteria, and unknowns often emerge directly from exploratory discussions.
- **Phase 1 (Research)**: Deep research conversations (especially ChatGPT's deep research mode) produce findings that can be directly transcribed into the research document with attribution.
- **Phase 2 (Design)**: Design alternative discussions provide the "alternatives considered" sections of design decisions.
- **[Conversational Review](conversational-review.md)**: Once you have structured artifacts, you can use conversations in the opposite direction — uploading artifacts *to* AI for review rather than extracting ideas *from* AI.

## Bootstrapping Tools

Forge provides tools to automate the bootstrapping process:

### Claude Code Skill (recommended)

If using Claude Code, invoke the `/bootstrap-research` skill:

```
/bootstrap-research
```

The skill will conversationally guide you through:
1. **Understanding your research** — What you're investigating, what question you're answering
2. **Gathering materials** — Conversation files, existing directories, references
3. **Creating structure** — Project directories and templates
4. **Drafting VISION.md** — Extracting research questions, hypotheses, unknowns from your materials
5. **Refining** — Iterating until the vision captures your research accurately

**Installation**: Copy `.claude/commands/bootstrap-research.md` to `~/.claude/commands/` for global access.

### Shell Script (portable)

For use outside Claude Code:

```bash
./scripts/bootstrap-research.sh ~/research/my-study --conversation ~/chats/exploration.md
```

This creates the structure and copies templates. You'll then manually extract from the conversation (or ask any AI assistant to help).

See [research variant](../variants/research.md) for the full research project workflow.
