# Research Loop

The Research Loop is the iterative process between vision (what you claim) and research (what the evidence supports). It's the research variant's equivalent of the Discovery Loop, but operates on conceptual artifacts — claims, hypotheses, and positioning — rather than code artifacts.

## The Loop

```
┌─────────────────────────────────────────────────────────────────────┐
│                        RESEARCH LOOP                                 │
│                                                                      │
│   Vision (claims, hypotheses, positioning)                           │
│      │                                                               │
│      ▼                                                               │
│   Research (literature review, data analysis, experiments)           │
│      │                                                               │
│      ▼                                                               │
│   Evaluate: Does the evidence support the claims?                    │
│      │                                                               │
│      ├─── No  ──► Update Vision (refine, add, drop)                  │
│      │                      │                                        │
│      │                      └────────────────────► Repeat            │
│      │                                                               │
│      └─── Yes ──► Claims ready for publication                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

Each cycle sharpens the claims, identifies new threats to validity, and surfaces new questions.

## Research-Phase Loss Function

The research phase applies a conceptual loss function to evaluate whether each claim is ready for publication:

### L₁ — External Validity Gap

How far do the claims generalize beyond the studied context?

**Reduced by:**
- Comparison projects or datasets
- Analytical generalization arguments
- Replication packages
- Explicit scope boundaries

**Example:** A single-ecosystem study (e.g., Spring) has high L₁. Adding a comparison project from another ecosystem reduces L₁. Acknowledging the limitation in threats-to-validity bounds L₁.

### L₂ — Reproducibility Pressure

Can an independent researcher replicate the results?

**Reduced by:**
- Zenodo DOIs for datasets
- Documented environments (conda, Docker)
- Deterministic analysis pipelines
- Version-pinned dependencies

**Example:** Results depend on Claude 3.5 Sonnet responses. L₂ is high if the model version isn't specified. L₂ is bounded by documenting the model version, recording raw responses, and noting that future model versions may differ.

### L₃ — Methodological Honesty

Are the threats to validity properly identified and acknowledged?

**Reduced by:**
- Reviewer simulation (anticipate objections)
- Red-team analysis (actively try to invalidate claims)
- Explicit caveats in the paper
- Separation of claims from speculation

**Example:** A claim about "all GitHub projects" based on 7 Spring repositories has high L₃. Explicitly stating "Spring ecosystem projects" and discussing why this may or may not generalize bounds L₃.

### Readiness Criterion

A claim is ready for publication when all three loss terms are bounded and documented:

```
Claim ready = L₁ bounded + L₂ bounded + L₃ bounded
```

"Bounded" doesn't mean zero — it means the limitation is acknowledged, quantified where possible, and the claim's scope is appropriately hedged.

## Research Activities

The research phase includes several distinct activities:

### Claim Shaping
Refining what you argue. Moving from vague intuitions to precise, testable statements.

**Before:** "Spring labels are better than other projects"
**After:** "Spring issue labels are applied by maintainers at or before close in 95% of cases (H1)"

### Threat Discovery
Finding what could invalidate the claims. Actively looking for ways the research could be wrong.

**Questions to ask:**
- What if the data is biased?
- What if the methodology has a flaw I haven't noticed?
- What if someone has already done this?
- What if the effect disappears on a different dataset?

### Reviewer Simulation
Anticipating objections from peer reviewers. Reading your own work as a skeptical reader.

**Common objections:**
- "This is just one ecosystem, how does it generalize?"
- "The comparison isn't fair because X"
- "You didn't control for Y"
- "Prior work Z already showed this"

### Contribution Ranking
Ordering claims by novelty and defensibility. Not all findings are equally publishable.

| Rank | Characteristic | Example |
|------|---------------|---------|
| High | Novel + defensible | First study of X with rigorous methodology |
| Medium | Incremental + defensible | Replication of Y on a new dataset |
| Low | Novel but weak | Interesting claim but methodological gaps |
| Skip | Already known | Confirms prior work without extension |

### Deep Research Queries
Targeted literature investigation to answer specific unknowns.

**Pattern:**
1. Identify a specific unknown that blocks progress
2. Formulate a precise question
3. Do focused literature search
4. Summarize findings in `supporting_docs/summaries/`
5. Update vision based on what you learned

## Relationship to Discovery Loop

The Research Loop operates within the Discovery Loop structure:

```
Discovery Loop (Phases 0-2)
├── Phase 0: Vision
│   └── Research Loop operates here
│       └── Vision ↔ Research iteration
├── Phase 1: Research
│   └── Literature review, data collection
└── Phase 2: Design
    └── Methodology specification (for research: study design)
```

For research projects, Phases 0-1 often blur together — you're simultaneously refining what you claim and gathering evidence. The Research Loop makes this explicit.

## Exit Criteria

Exit the Research Loop when:

1. **Claims are stable** — Two consecutive research iterations didn't change the core claims
2. **Threats are documented** — All known validity threats are listed with mitigations
3. **Evidence is sufficient** — Each claim has supporting data or analysis
4. **Scope is bounded** — You know what you're claiming and what you're not

## Anti-Patterns

### Infinite Literature Review
Reading forever without committing to claims. Set a timebox; missing papers can be added during revision.

### Claim Inflation
Overstating findings beyond what evidence supports. "Our approach works" vs. "Our approach works on this dataset under these conditions."

### Threat Avoidance
Ignoring inconvenient validity threats. Better to acknowledge and bound than to hope reviewers don't notice.

### Perfectionism
Waiting for L₁/L₂/L₃ to reach zero. They never will. The goal is bounded and documented, not eliminated.

## See Also

- [Research Variant Guide](../variants/research.md) — Full research variant documentation
- [Discovery Loop](discovery-loop.md) — The broader iterative structure
- [VISION-TEMPLATE-research.md](../templates/VISION-TEMPLATE-research.md) — Template with hypothesis tracking
