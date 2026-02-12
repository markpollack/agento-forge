# Oracle Learning Loop

An oracle is a tool that an executing agent can call when it gets stuck. Every oracle call is logged as a first-class event. The oracle provides runtime safety — the agent doesn't fail — but each call is a signal that the knowledge base or plan has a gap. The goal is to drive oracle calls per run to zero.

## The Pattern

```
Run 1:  Agent executes plan → gets stuck 12 times → calls oracle 12 times → completes
        └─ Review oracle calls → fix KB/plan gaps

Run 2:  Agent executes plan → gets stuck 8 times → calls oracle 8 times → completes
        └─ Review oracle calls → fix KB/plan gaps

Run N:  Agent executes plan → never stuck → 0 oracle calls → completes
        └─ Plan is complete for this task type
```

The oracle is a **leading indicator** — it tells you what knowledge is missing before the missing knowledge causes a failure. Everything else (tool call counts, cost, latency, verdict scores) is a **lagging indicator** — useful for optimization after the thing works.

## Oracle Query Types

| Type | When | What It Means | Fix |
|------|------|---------------|-----|
| `diagnose` | Unexpected error during execution | Plan missing a failure mode | Add failure mode + fix to KB |
| `lookup` | Unknown pattern encountered | KB missing this case | Add pattern to KB |
| `sequence` | Interdependent changes across components | Plan step ordering wrong | Improve plan generator |
| `escalate` | Stuck after N retries | Genuinely novel situation | Human investigation, then add to KB |

`escalate` calls are the most valuable — they represent the frontier of the knowledge base.

## Telemetry Hierarchy

| Signal | What It Tells You | Priority | When to Act |
|--------|-------------------|----------|-------------|
| **Oracle calls** | KB/plan gaps | **Primary** | Immediately — each call = a missing piece |
| Tool calls | Execution efficiency | Secondary | After oracle calls → 0 |
| LLM calls | Cost/latency | Secondary | After execution is efficient |
| Verdicts | Quality calibration | Secondary | After cost is reasonable |
| Thinking blocks | Reasoning quality | Diagnostic | When agent seems confused |

Work through these top-down. Oracle calls first, then optimize tool calls, then cost, then quality calibration.

## Transport

The oracle is an API call from the executing agent to a knowledge service. Two practical options:

| Transport | Pros | Cons |
|-----------|------|------|
| **HTTP + API token** | Battle-tested auth, works everywhere, trivial to implement | Nothing — this is the default |
| **MCP tool** | Framework integration, tool discovery | Security model immature, adds complexity |

The core logic is the same either way — a function that takes a query and returns an answer from the KB. Wrap it in whichever transport fits the deployment. Start with HTTP; add MCP if the ecosystem demands it.

## Bootstrap to Production

**Phase 1: Bootstrap** — Oracle runs locally. Every call logged. After each run, review calls and fix KB gaps. Re-run. Fewer calls.

**Phase 2: Stabilization** — Oracle calls per run consistently < 3 across test inputs. Plan generator covers 90%+ of common patterns. Oracle is safety net, not primary reasoning.

**Phase 3: Production** — Oracle becomes a remote service. Agent connects via authenticated HTTP. Oracle calls from production deployments feed back into KB improvement.

**Phase 4: Obsolescence (per task type)** — Oracle calls per run = 0 consistently for this task type. Oracle stays available as safety net but never triggered. Move to next task type, restart the cycle.

## Relationship to Trajectory Distillation

Oracle calls ARE trajectory data. The distillation loop:

1. **Baseline run**: Many oracle calls (expensive, successful with help)
2. **Capture**: Each oracle call logged with full context — what the agent asked, what the oracle returned, which KB articles informed the response
3. **Distill**: For each call, determine what KB article or plan step would have prevented it
4. **Optimized re-run**: Add the KB article, fix the plan → fewer calls → faster, cheaper

This is the same structure as the Phase 4 [Learning Loop](../phases/04-learning-loop.md) optimization mode, but with the oracle call count as the loss function instead of a score.

## Key Metric

Track oracle calls per run as a first-class metric alongside cost and verdict:

```
Run   Oracle Calls   Notes
v1    12             Plan barely covers basics
v3     8             Added patterns X, Y to KB
v6     3             Plan handles most cases
v10    0             Plan complete for this task type
```

## Anti-Patterns

- **Oracle as crutch** — If oracle calls per run aren't decreasing over time, you're not learning from them. Every call should trigger a KB/plan improvement.
- **Ignoring escalate calls** — `escalate` is the most valuable signal. Treating it as noise means the KB never grows past its initial boundary.
- **Oracle too generous** — If the oracle answers everything perfectly, the agent never builds plan robustness. The oracle should provide guidance, not do the work.
- **Skipping the review step** — Running with oracle enabled but never reviewing the calls. The loop only works if calls are reviewed and gaps are fixed.
- **Premature optimization** — Optimizing tool calls or cost before oracle calls reach zero. Fix the knowledge gaps first.

## See Also

- [Learning Loop (Phase 4)](../phases/04-learning-loop.md) — The execution loop this pattern enhances
- [Judges and Evaluation](judges-and-evaluation.md) — How verdicts complement oracle signals
- [Execution Pipeline](execution-pipeline.md) — Where the agent runs
- [Research Agent](research-agent.md) — Hierarchical agentic RAG that could power the oracle's KB lookup
