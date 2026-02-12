# Conversational Review Template

> Ready-to-use prompt templates for reviewing Forge methodology artifacts with conversational AI (Claude.ai, ChatGPT, etc.). See [Conversational Review](../concepts/conversational-review.md) for when and why to use this.

---

## Upload Checklist

Before starting a review, gather the files. Check the row matching your review type:

| Review type | Document under review | Template to include | Context files |
|---|---|---|---|
| Vision review | VISION.md | VISION-TEMPLATE.md | — |
| Research review | RESEARCH.md | RESEARCH-TEMPLATE.md | Key supporting research docs referenced by RESEARCH.md |
| Design review | DESIGN.md | DESIGN-TEMPLATE.md | RESEARCH.md |
| Prerequisite design review | The design doc (e.g., `fixture-extractor.md`) | PREREQUISITE-DESIGN-TEMPLATE.md | RESEARCH.md (relevant sections), supporting research docs the design draws from |
| Discovery loop exit check | VISION.md, RESEARCH.md, DESIGN.md | All three templates | Any prerequisite designs |

Upload all listed files as attachments to the conversation.

---

## Initial Review Prompt

Copy and fill in the placeholders:

```
Review this {{DOCUMENT_TYPE}} ({{DOCUMENT_FILENAME}}) for the {{PROJECT_NAME}} project.

Context files attached:
- {{TEMPLATE_FILENAME}} — the Forge methodology template it should follow
{{#each CONTEXT_FILE}}
- {{CONTEXT_FILENAME}} — {{WHY_ITS_INCLUDED}}
{{/each}}

Review criteria:
1. Does it follow the template structure completely? Flag any missing or reordered sections.
2. Is the content concrete enough to implement against? Flag anything an implementer would need to know but isn't specified.
3. Are design decisions well-reasoned with clear alternatives and rationale?
4. Are there internal inconsistencies — places where one section contradicts another?
5. Are the open questions the right ones? Are there missing unknowns?
6. {{DOMAIN_SPECIFIC_CRITERION}}

Be critical. Flag anything ambiguous, underspecified, or that you'd push back on in a design review.
```

### Example — prerequisite design review:

```
Review this prerequisite design (fixture-extractor.md) for the Refactoring Agent project.

Context files attached:
- PREREQUISITE-DESIGN-TEMPLATE.md — the Forge methodology template it should follow
- RESEARCH.md — the research findings it's based on (see Q1: OpenRewrite Fixture Extraction Feasibility)
- openrewrite-test-extraction.md — detailed extraction strategy research

Review criteria:
1. Does it follow the template structure completely? Flag any missing or reordered sections.
2. Is the output schema concrete enough to implement against? Flag anything an implementer would need to know but isn't specified.
3. Are design decisions well-reasoned with clear alternatives and rationale?
4. Are there internal inconsistencies — places where one section contradicts another?
5. Are the open questions the right ones? Are there missing unknowns?
6. Any issues with the directory layout, fixture ID scheme, or metadata schema?

Be critical. Flag anything ambiguous, underspecified, or that you'd push back on in a design review.
```

---

## Follow-Up Review Prompt

After fixing issues from the initial review, re-upload the updated document and the original review findings. Copy and fill in:

```
Here is an updated {{DOCUMENT_TYPE}} ({{DOCUMENT_FILENAME}}) revised based on your earlier review ({{REVIEW_FILENAME}}).

Changes made:
{{#each CHANGE}}
- {{CHANGE_SUMMARY}}
{{/each}}

Review the updated document against your original findings. For each of your original "must fix" and "should fix" items, confirm whether it's been adequately addressed or still has gaps. Flag anything new that the changes introduced.
```

### Upload checklist for follow-up:

| File | Why |
|---|---|
| Updated document | The revised version being re-reviewed |
| Original review findings | So the reviewer can check each finding against the update |
| Template (same as initial) | Still needed for conformance checking |

Context files from the initial review can be omitted if the reviewer already has conversation history. If starting a fresh session, include them again.

### Example — follow-up after prerequisite design review:

```
Here is an updated prerequisite design (fixture-extractor.md) revised based on your earlier review (Claude-fixture-extractor-review.md).

Changes made:
- Added DD-6 through DD-10 (POM generation, file path inference, error handling, idempotency, prompt design)
- Made slug generation deterministic (camelCase-to-kebab of method name)
- Added noChange, javaVersion fields to fixture.json schema
- Added extraction-summary.json and manifest.json schemas
- Resolved classpath mapping as trivial (short names map directly to Maven coordinates)
- Added validation spike as prerequisite before full extraction
- Added Supersedes section noting this replaces the earlier strategy doc's directory layout

Review the updated document against your original findings. For each of your original "must fix" and "should fix" items, confirm whether it's been adequately addressed or still has gaps. Flag anything new that the changes introduced.
```

---

## Discovery Loop Exit Check Prompt

A special review for the transition from discovery (Phases 0–2) to execution (Phases 3–5). Upload all three discovery loop artifacts plus their templates.

```
I'm preparing to exit the discovery loop and commit to a roadmap. Please review these three documents for consistency and completeness.

Attached:
- VISION.md (and VISION-TEMPLATE.md)
- RESEARCH.md (and RESEARCH-TEMPLATE.md)
- DESIGN.md (and DESIGN-TEMPLATE.md)
{{#if PREREQUISITE_DESIGNS}}
- Prerequisite designs: {{LIST_THEM}}
{{/if}}

Check:
1. **Consistency**: Do all three documents tell the same story? Does the design address everything the vision promises? Does the research support every design decision?
2. **Completeness**: Are all vision unknowns resolved in research? Are all research findings consumed by the design? Are there gaps where the design hand-waves?
3. **Template conformance**: Does each document follow its template?
4. **Readiness**: Is the design specific enough to write a roadmap from? What would an implementer still need to ask?

Flag any inconsistencies, gaps, or reasons to continue iterating before committing to execution.
```

---

## Saving Review Results

Save the reviewer's findings to your project's review directory:

```
plans/research/reviews/{{AI_SYSTEM}}-{{DOCUMENT_SLUG}}-review.md
```

Examples:
- `plans/research/reviews/Claude-fixture-extractor-review.md`
- `plans/research/reviews/ChatGPT-vision-review.md`
- `plans/research/reviews/Claude-discovery-loop-exit-review.md`

Reference the review file from the document's header for traceability:
```markdown
> **Review**: [`reviews/Claude-fixture-extractor-review.md`](../reviews/Claude-fixture-extractor-review.md)
```
