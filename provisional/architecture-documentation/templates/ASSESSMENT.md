# <Project>: architecture documentation assessment

> Mode: <existing code / specification> · Spec revision: <revision or none>
> Date: <YYYY-MM-DD> · Code at: <repository>@<commit> · Assessed by: <who> · Supersedes: <earlier record or none>
> Method: [assess stage](../ASSESS.md) · Palette: [PALETTE.md](../PALETTE.md)

## 1. Readers and their questions

| Reader | After reading, they can… | Their questions |
|---|---|---|
| <e.g. colleague new to the code> | <explain the main mechanism; find where to change X> | <"What does it do, and where does it stop?"> |

## 2. System shape and consequential quality questions

- **Shape**: <library / data product / service / CLI driving processes / agent or workflow / other>
- **Quality questions** (concrete, each answered by a selected view or example):
  1. <"Can cancelling one session affect another?">

## 3. What already exists

| Artifact | Location | Current? | Use |
|---|---|---|---|
| <design document, decision log, contracts, schemas, tests, fixtures, older guide> | <path> | <yes / stale since …> | <link / supersede / mine for content> |

Before document: <link or none> · After guide: <link or pending> · Changes: <link / pending / reason omitted>

## 4. Evidence available

| Kind | Tool and version | Applies to |
|---|---|---|
| Extracted structure | <ArchUnit x.y> | <modules> |
| Enforced policy | <existing gates> | |
| Observed execution | <recorder, or none> | <scenario> |
| Executed checks | <tests, reports> | |

## 5. Selection

Every palette item considered, taken or declined.

| Palette item | Decision | Answers question / reason declined | Evidence label it will carry |
|---|---|---|---|
| Introduction, goals, context | Take | | declared design |
| Constraints | <take / fold into … / decline> | | |
| Solution strategy | | | |
| Building blocks (module view) | | | extracted structure |
| Runtime scenarios | | | observed execution / conceptual |
| Deployment or allocation | | | |
| Crosscutting concepts / data model | | | |
| Decisions | <link to existing log / record here> | | |
| Quality requirements | <take / recast as … / decline> | | |
| Risks, limits, current support | Take | | |
| Glossary | <take / define at first use> | | |
| Worked example end to end | | | executed check |
| Contracts and failure behaviour | | | |
| State / lifecycle view | | | |
| Where to make a change; regeneration | | | |

**Resulting chapter list**, each mapped to the reader questions it answers:

1. <chapter> answers <questions>

## 6. Where it lives

- Public: <path>; readable without private material; links resolve publicly.
- Private: <path>; what is held back and why.
- Diagrams: authored conceptual in Mermaid; generated as PlantUML source plus committed SVG.

## 7. Maintenance triggers

| Change | Views to regenerate or review |
|---|---|
| <a component's responsibility or boundary changes> | <module view, boundary rules> |
