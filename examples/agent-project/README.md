# Eval-Agent Project Example

A minimal example of an eval-agent project structure using the Forge methodology.

## Structure

```
my-agent/
├── plans/
│   ├── VISION.md                    # What the agent does, success criteria
│   ├── RESEARCH.md                  # Prior art, baseline performance
│   ├── DESIGN.md                    # Architecture + Evaluation Architecture
│   ├── ROADMAP.md                   # Implementation steps
│   └── learnings/
│       └── LEARNINGS.md
├── src/
│   ├── agent/                       # Agent implementation
│   ├── judges/                      # Judge implementations
│   └── benchmark/                   # Benchmark case management
├── benchmark-cases/                 # Benchmark case files
│   └── cases.yaml
└── docs/
    └── getting-started.md
```

## Key Files

### DESIGN.md — Evaluation Architecture Section

```markdown
## Evaluation Architecture

### Agent Loop
| Field | Value |
|-------|-------|
| **Loop type** | evaluator-optimizer |
| **Termination** | loss < 0.1 OR max_iterations = 50 |

### Benchmark Cases
- **Format**: YAML
- **Source**: Hand-crafted from real user requests
- **Case model**: Input task description, expected output, difficulty level

### Judges
| Judge | Type | Evaluates | Weight |
|-------|------|-----------|--------|
| Correctness | Deterministic | Output matches expected | 0.6 |
| Efficiency | Deterministic | Tokens used < budget | 0.2 |
| Quality | AI | Output style and completeness | 0.2 |

### Loss Function
loss = 1 - weighted_sum(judge_scores) / max_score
- **Convergence threshold**: loss < 0.1
```

### ROADMAP.md — Agent-Specific Steps

Include Steps 1.4-1.6 after test infrastructure:

```markdown
### Step 1.4: Benchmark Case Models
- [ ] IMPLEMENT case data model from DESIGN.md
- [ ] IMPLEMENT case query methods (next unpassed, all passed)

### Step 1.5: Case Manager
- [ ] IMPLEMENT case loader (deserialize from YAML)
- [ ] IMPLEMENT case state persistence

### Step 1.6: Judge Interface
- [ ] DEFINE judge interface
- [ ] IMPLEMENT result model with metrics
```

Include benchmark stage near the end:

```markdown
## Stage N: Judges and Benchmarking

### Step N.0: Deterministic Judges
- [ ] IMPLEMENT Correctness judge
- [ ] IMPLEMENT Efficiency judge

### Step N.1: AI Judges
- [ ] IMPLEMENT Quality judge with mock LLM tests

### Step N.2: Composite Judge
- [ ] IMPLEMENT weighted aggregation
- [ ] VERIFY loss computation

### Step N.3: End-to-End Benchmark
- [ ] RUN benchmark with all cases
- [ ] DOCUMENT results and capability gaps
```

## Phase 4: Optimization Loop

```
1. Load benchmark cases
2. For each unpassed case:
   a. Execute agent
   b. Run judges on output
   c. Record scores
3. Compute loss = 1 - weighted_sum / max_score
4. If loss < threshold: done
5. Else: analyze failures, modify agent, repeat
```

## See Also

- [Eval-Agent Variant Guide](../../variants/agent.md)
- [Judges and Evaluation](../../concepts/judges-and-evaluation.md)
- [DESIGN-TEMPLATE.md](../../templates/DESIGN-TEMPLATE.md) — includes Evaluation Architecture section
