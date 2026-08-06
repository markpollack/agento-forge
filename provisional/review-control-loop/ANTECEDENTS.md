# Quick antecedent check: is the review control loop old methodology rediscovered?

> **Date:** 2026-08-06
> **Depth:** bounded orientation, not a literature review

## Conclusion

Yes. The experiment is mostly a modern composition of established software and systems engineering
disciplines. Its value should be judged by whether it adapts those disciplines to AI-speed authoring
with less ceremony, not by claiming that baselines, independent review, traceability, or change
control are new.

## Antecedent map

| Experimental term | Established antecedent | What AI changes |
|---|---|---|
| Frozen candidate | Configuration baseline / configuration item | Candidates are cheap to produce and can change several times in an hour |
| Cold reviewer | Independent verification and validation (IV&V) | A second model/session is cheap, but model correlation means it is only partially independent |
| Review lenses and breaking scenarios | SEI ATAM and ARID scenario-based evaluation | Many specialized review passes and counterexample searches become affordable |
| Evidence ledger | Verification record, anomaly/problem report | Exhibits can often be generated and replayed automatically |
| Adjudication | Change-control board disposition and impact analysis | The review volume demands fast, explicit filtering rather than accepting every suggestion |
| Bounded correction | Approved baseline change | AI can create excessive controller gain: rapid oscillation around reviewer preferences |
| VISION → DESIGN → ROADMAP traceability | Requirements/design/implementation/verification traceability; V-model lineage | Natural-language artifacts can directly drive agents, tests, and validation |
| Private steward repository | Controlled engineering data/configuration library | Gives persistent agent memory a versioned authority boundary separate from public code |

## What current spec-driven development contributes

Current AI-oriented SDD makes a structured specification the persistent source of intent and commonly
runs `constitution → specify → clarify → plan → tasks → implement → validate`. GitHub Spec Kit also has
cross-artifact analysis for conflicts, gaps, ambiguities, and requirements without tasks. This closely
resembles Forge's VISION/DESIGN/ROADMAP pipeline and confirms that the industry is rediscovering durable
engineering artifacts after prompt-first workflows exposed translation loss.

The useful distinction for this experiment is:

> **SDD governs generation from intent. The review control loop governs confidence in, and controlled
> change to, the intent-bearing artifacts themselves.**

That distinction may narrow as SDD tools mature. The pilot should therefore compare rather than invent
new vocabulary prematurely.

## The likely gap worth testing

Mainstream SDD descriptions are strong on artifact production and downstream validation. They are less
explicit about:

- contradictory or duplicated sources of truth;
- an author and self-review sharing the same blind spots;
- a second AI reviewer being a noisy, correlated sensor rather than an authority;
- adjudicating findings before correction;
- preventing every reviewer preference from reopening settled decisions;
- immutable review candidates and terminal finding dispositions;
- cross-repository ownership of requirements and exit criteria.

This is the bounded research thread: **configuration-managed, independently reviewed, adjudicated SDD
for AI agents**. Agent Judge and Agent Workflow can test it before Forge names or promotes it.

## Primary orientation sources

- [NASA IV&V Overview](https://www.nasa.gov/ivv-overview/) — verification versus validation and
  technical/managerial/financial independence.
- [NASA Requirements Change Management](https://swehb.nasa.gov/spaces/7150/pages/16449679/SWE-053%2B-%2BManage%2BRequirements%2BChanges)
  — baselines, impact analysis, review boards, and disposition before incorporation.
- [NASA Configuration Management](https://www.nasa.gov/reference/6-5-configuration-management/) —
  systematic proposal, justification, evaluation, approval, incorporation, and verification of
  baseline changes.
- [SEI ARID](https://www.sei.cmu.edu/library/active-reviews-for-intermediate-design-arid/) — active,
  stakeholder-centric, scenario-based review of intermediate design specifications.
- [SEI ATAM collection](https://www.sei.cmu.edu/library/architecture-tradeoff-analysis-method-collection/)
  — scenario-based architecture evaluation against quality goals and stakeholder concerns.
- [Microsoft: Spec-Driven Development](https://developer.microsoft.com/blog/spec-driven-development-ai-native-engineering)
  — structured specs as shared source of truth from intent through validation.
- [GitHub Spec Kit](https://github.github.com/spec-kit/index.html) and
  [Agentic SDD flow](https://github.github.com/spec-kit/reference/agentic-sdd.html) — current
  spec/plan/tasks/implementation workflow and read-only cross-artifact consistency analysis.

## Research stop rule

Do not expand this into a historical survey during Pilot 1. Reopen research only if a pilot mechanism
cannot be explained by the antecedents above, or if comparison with an existing SDD tool would avoid
building redundant machinery.

