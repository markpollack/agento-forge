---
name: bootstrap-research
description: Bootstrap a new research project from conversations and existing work using the Forge methodology
---

# Bootstrap Research Project

> **Installation**: Copy this file to `~/.claude/commands/bootstrap-research.md` for global access.
> Then update the forge-methodology path in the Configuration section below.

You are helping bootstrap a new research project using the Forge methodology's research variant.

## Arguments
- `$ARGUMENTS` - Optional: project path, conversation file paths, or existing directories (can be provided interactively)

## Configuration

**UPDATE THIS PATH** to point to your forge-methodology installation:

- **Forge methodology location**: `/path/to/forge-methodology`
- **Templates directory**: `/path/to/forge-methodology/templates`

## Instructions

### Phase 1: Understand the Research

Start by asking the user about their research. Be conversational:

1. **What are you researching?** Ask them to describe:
   - The topic or problem area
   - What question they're trying to answer
   - What sparked this research (a conversation, a gap they noticed, etc.)

2. **What do you have already?** Ask about:
   - Saved conversations (ChatGPT exports, Claude conversations, notes)
   - Existing directories with related work, data, or notes
   - Any papers or references they've already gathered

3. **Where should the project live?** Ask for:
   - Project path (suggest a reasonable default based on what they described)

### Phase 2: Gather Materials

Once you understand what they're researching:

1. **Read their conversations** — If they provided conversation files, read them thoroughly
2. **Survey existing directories** — If they have existing work, explore it to understand what's there
3. **Identify key elements** — Look for:
   - Research questions (explicit or implicit)
   - Hypotheses or claims they're exploring
   - Unknowns they've identified or resolved
   - Constraints or scope boundaries
   - Publication goals (papers, venues)

### Phase 3: Create Structure

Create the research project directory using Bash:

```bash
mkdir -p {project}/plans/{conversations,supporting_docs/summaries,learnings}
mkdir -p {project}/data/{raw,curated}
mkdir -p {project}/scripts
mkdir -p {project}/notebooks
mkdir -p {project}/papers
mkdir -p {project}/findings
mkdir -p {project}/docs
```

Copy templates from forge-methodology (use paths from Configuration above):
- `{forge-methodology}/templates/VISION-TEMPLATE-research.md` → `{project}/plans/VISION.md`
- `{forge-methodology}/templates/PAPER-TRACKER-TEMPLATE.md` → `{project}/plans/supporting_docs/paper-tracker.md`

Copy their conversation files to `{project}/plans/conversations/`.

Create a `.gitignore` in the project root:
```
data/raw/
data/expanded/
__pycache__/
*.pyc
.ipynb_checkpoints/
.env
.DS_Store
```

### Phase 4: Draft VISION.md

Based on what you learned from their description and materials, draft a VISION.md that includes:

**Problem Statement** — Synthesize what gap or question they're addressing

**Research Questions** — Extract or formulate RQs from their description/conversations:
- RQ1, RQ2, etc. — clear, answerable questions

**Hypotheses** — If they have testable claims, structure them:
```markdown
### H1 — {Name}
**Claim**: {precise statement}
**Measurement**: {how to test}
**Status**: Untested
```

**Unknowns Tracking** — Things they need to figure out:
| ID | Unknown | Status | Resolution |
|----|---------|--------|------------|
| U1 | {question} | Open/Answered | {answer if known} |

**Assumptions** — Things they're taking for granted

**Scope** — What's in and out

**Paper Structure** — If they mentioned publication goals

**Key References** — Links to the conversations and existing directories

**Research Loop Status** — Initialize as:
- L₁ (External validity): Unbounded
- L₂ (Reproducibility): Unbounded
- L₃ (Methodological honesty): Unbounded

### Phase 5: Review and Refine

Present the draft VISION.md to the user and ask:

1. Does this capture what you're researching?
2. Are the research questions right?
3. Did I miss any hypotheses or unknowns?
4. What would you change?

Iterate based on their feedback until they're satisfied.

### Phase 6: Suggest Next Steps

After VISION.md is finalized, suggest:

1. **First roadmap** — Which paper or study to tackle first
2. **Literature search** — Key papers to find for the paper-tracker
3. **Data collection** — If they need data, what's the first step

## Extraction Patterns

When reading conversations, look for:

| Pattern | Extract as |
|---------|------------|
| "The problem is...", "Nobody has...", "The gap is..." | Problem Statement |
| "How does X work?", "What causes Y?", "Can we measure Z?" | Research Questions |
| "I think X because Y", "My hypothesis is...", "We expect..." | Hypotheses |
| "We'd need to find out...", "Unknown:", "Not sure about..." | Unknowns (Open) |
| "Ah, so the answer is...", "Found that...", confirmed findings | Unknowns (Answered) |
| "Assuming that...", "This only works if..." | Assumptions |
| "Out of scope:", "We're not doing...", "That's for later" | Out of Scope |
| "For the paper...", "Submit to...", "Paper 1 would..." | Paper Structure |

## Tone

Be conversational and helpful. This is the start of a research journey — help them clarify their thinking, not just fill in templates. Ask follow-up questions when their description is vague. Offer suggestions when you see patterns they might not have articulated.
