# Roadmap Controller Checkpoint — {{roadmap-step-id}}

> **Recommendation:** {{STEP ACCEPTED | CORRECTION REQUIRED | HOLD}}
> **Project repository:** {{absolute-path}} at {{branch}} / {{full-commit}}
> **Steward repository:** {{absolute-path}} at {{branch}} / {{full-commit}}
> **Implementation evidence:** {{record-path}}
> **Preserved unrelated state:** {{paths or none}}
> **Next step:** {{not authorized | exact authorized step after later human decision}}

This checkpoint assists the human Project Owner. It accepts no implementation and authorizes no next
step by itself.

## Human checkpoint

{{In plain language: what the step changed, whether its exits hold, whether the project remains on
course, what the controller corrected, and the one decision now requested from the human.}}

## 1. Step evidence audit

| Roadmap obligation | Evidence examined or reproduced | Result |
|---|---|---|
| {{entry/work/exit pointer}} | {{specific exhibit}} | {{PASS | FAIL | HOLD}} |

Record finite coverage in plain counts (`8/8 exit criteria checked`). For open-ended adversarial work,
name the scenario families attempted instead of claiming completeness.

## 2. Repository and mutation audit

- Project entry commit: {{full commit and branch}}
- Project discharge commit: {{full commit and branch}}
- Steward checkpoint input: {{full commit and branch}}
- Changed paths: {{bounded summary}}
- Working-tree state: {{clean or exact preserved exceptions}}
- Unauthorized mutation or publication: {{none or exhibit}}

Repository names qualify every commit and every use of `HEAD`. A dirty but unrelated file is not part
of a committed baseline; disposition it separately before the next dispatch when practical.

## 3. Planning-currency sweep

| Surface | Current-state claims checked | Correction or disposition |
|---|---:|---|
| VISION | {{count}} | {{none or bounded correction}} |
| DESIGN and subsidiary decisions | {{count}} | {{none or bounded correction}} |
| ROADMAP and execution baseline | {{count}} | {{none or bounded correction}} |
| `AGENTS.md` and tool bridges | {{count}} | {{none or bounded correction}} |
| Learnings/indexes | {{count}} | {{none or bounded correction}} |

Do not rewrite immutable candidates, received reviews, adjudications, verifications, ratifications, or
historical step evidence. Record supersession or current truth in active planning and this checkpoint.

## 4. Trajectory and next-step readiness

- Vision alignment: {{assessment and exhibit}}
- Design preservation: {{assessment and exhibit}}
- Roadmap sequencing: {{assessment and exhibit}}
- Next-step entry conditions: {{ready, not ready, or not evaluated—with reason}}
- Additional independent review: {{not needed, requested, or required—with risk basis}}

## 5. Discoveries and controller actions

| Discovery | Classification | Action/evidence |
|---|---|---|
| {{item}} | {{planning currency | implementation defect | owner decision | deferred}} | {{bounded action or route}} |

## 6. Human decision requested

{{One exact decision, normally whether to accept this checkpoint and authorize one named next roadmap
step. State explicitly that silence and acceptance of the completed step do not authorize execution.}}
