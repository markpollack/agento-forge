# Assess: what documentation fits this project

The assess stage decides what a project's architecture documentation contains before anything is
generated or written. Its output is an [assessment record](templates/ASSESSMENT.md) that selects from
the [palette](PALETTE.md) and says why each item was taken or declined. The record is the answer to
"why does this guide have these chapters?", and it is reread when the readers or the system change.

Record the mode first: **existing code** (with a revision) or **specification** (with a proposed scope
and any existing baseline). In specification mode, select the same reader questions and palette, but
use proposed/declared-design evidence and conceptual Mermaid views; plan what the spike must later
extract or exercise. See [specification mode](SPEC-MODE.md).

## The questions

1. **Who reads it, and what must each reader be able to do afterwards?** Name the readers (a capable
   colleague new to the code, a new maintainer, a reviewer judging a guarantee, a downstream consumer, an
   evaluator deciding whether to adopt). Write each one's questions as questions. Every selected chapter
   or view must answer one of them; a chapter that answers none is declined.
2. **What shape is the system?** The shape decides which views carry weight (table below).
3. **Which quality questions are consequential here?** Concrete ones ("does a change in a vendor's format
   stay inside one adapter?", "can cancelling one session affect another?"), not a generic attribute list.
   Views and examples are chosen to answer them.
4. **What already exists?** Decision records, design documents, contracts, schemas, tests, fixtures,
   generated artifacts, older guides. Link them; do not copy them. Note which are stale.
5. **What evidence can be generated?** Static extraction, enforced rules, scenario recording, existing
   checks. The available tools bound which statements can be labelled extracted or observed.
6. **Where does each part live?** Public project documentation must be readable without private material;
   private planning and evidence stay private. Decide what is sanitized and where.
7. **What triggers maintenance?** Which changes (responsibilities, boundaries, contracts, selected
   scenarios) require which views to be regenerated or reviewed.

## Selection by system shape

Starting points, not rules. The assessment records the actual choice.

| Shape | Usually carries the weight | Usually declined or folded |
|---|---|---|
| **Library / SDK** | API concepts and their lifecycle (often a state view); module view with enforced boundaries; runtime scenarios where streaming, ordering, cancellation or failure need explaining; contracts and failure behaviour; change points | Deployment (it runs in the caller's process); a quality-tree section |
| **Data product / format** (a file or event stream others consume) | The data model as its own chapter; the transformation from input to stored output, traced on a worked example; storage, versioning and portability as an allocation view; verification of what is stored | Deployment; a separate solution-strategy section (the transformation *is* the strategy) |
| **Service / application** | Context and containers; deployment (it is consequential); runtime scenarios across services; crosscutting security and persistence concepts; quality scenarios | A code-level view |
| **CLI / tooling that drives other processes** | Process boundaries and child processes (allocation); permissions and trust; failure and cancellation; configuration | Deep module views beyond the main boundaries |
| **Agent or workflow system** | Control flow and state; where the model's judgement ends and code decides ([model/code boundary](../../concepts/model-code-boundary.md)); evaluation and evidence | Generic deployment |

Concurrency earns a place in an overview only when it explains streaming, completion, cancellation or
failure. Thread or virtual-thread mechanics alone do not.

## Worked example: how Agent Journal arrived at eight chapters

Agent Journal records what an AI coding CLI reported during one run as a portable event file, and an
independent checker verifies that file against the native output. Its documentation was assessed twice
in one week; the second assessment is the one to copy, because it corrected the first's blind spots.

### The sequence

| Date | Step | What it decided |
|---|---|---|
| 23 Oct | Research proposal on evidence-derived architecture documentation | Surveyed the whole [palette](PALETTE.md): 4+1, Views and Beyond, 42010, UML, arc42's twelve sections, C4, ADRs, docs as code, models as code, execution-derived documentation. Chose **Views and Beyond as the foundation** and **arc42 only as an organizing aid**, with three reading layers and a minimum set of six views (one-page overview, component responsibility map, definition-to-mapping lineage, executed transformation, observed scenario, failure example). The owner confirmed Views and Beyond as the long-used reference |
| 23 Oct | First build-checked guide (public, `docs/architecture/`) | Dispatched as *"No template-completion exercise"*, asking for a one-page overview, the selected visuals and example, responsibilities, contracts and failure behaviour, rationale and links into code. Result: **nine sections**: the system on one page; two flows kept apart; module view with the enforced boundary; component-and-connector view of one observed run; executed example of one tool call; contracts and failure behaviour; rationale; where to make a change; regenerating and checking the guide |
| 25 Oct | A long-form export reorganized around a verification work plan | Eleven pages of assessment material came before the architecture; the original chapters survived but moved to the back. The investigation called it *"loss of orientation and prominence"*, not deletion |
| 25 Oct | README and architecture-continuity investigation | Listed what both guides under-represented: the system's place among its neighbours, the data product itself (event families, shared objects, usage, provenance), the lifecycle of raw, provisional and final files, and the compatibility and versioning relationships. Proposed **eight chapters**, with the rule *"Use the older context as the backbone… Do not merely prepend another overview"* and the work plan kept as a separate document |
| 26–27 Oct | Architecture-first rewrite | Implemented the eight as chapter sources: purpose, context and boundaries; canonical data model; capture and assembly; storage and portability; module and runtime views; semantic trails; verification and trust; current support and change |

### From the palette to eight

*Reconstructed on 28 October 2026 from the documents above; they do not contain this mapping explicitly.*

| arc42 section | Fate in Journal's eight | Reason |
|---|---|---|
| 1 Introduction and goals | Chapter 1 | Always |
| 2 Constraints | Folded into chapter 1's boundaries, plus *declared policy* labels throughout | Few enough to state inline; the enforced ones are labelled where they apply |
| 3 Context and scope | Chapter 1 | The under-represented item: Journal's place among its sibling projects |
| 4 Solution strategy | Folded into chapter 3 | The strategy is the capture-and-assembly flow itself |
| 5 Building block view | Chapter 5 (module view, extracted) | Always |
| 6 Runtime view | Chapters 3 and 5 | Capture and assembly is a flow; one observed run is the component-and-connector view |
| 7 Deployment view | **Declined**; replaced by chapter 4, an allocation view of files | A local Java library; what matters is which file is raw, provisional or final, and who owns it |
| 8 Crosscutting concepts | Chapter 2, the canonical data model, promoted to its own chapter | For a data product the model is the product |
| 9 Architecture decisions | Linked, not copied; rationale stays beside the views | A decision history already exists |
| 10 Quality requirements | **Recast** as chapter 7, verification and trust | Journal's consequential quality question is whether a stored value can be trusted; a generic quality tree would be filler |
| 11 Risks and technical debt | Chapters 7 and 8 (current limits, current support) | Always, as an honest list |
| 12 Glossary | **Declined**; terms defined at first use | A cold review found undefined terms; defining them where they first appear fixed it |
| *(Views and Beyond / 4+1 scenarios)* | Chapter 6, semantic trails: worked examples traced end to end | The executed transformation explained more than any class diagram |
| *(Maintainer content)* | Chapter 8 absorbs the first guide's "where to make a change" and "regenerating" | Maintainers need the map; it belongs at the end |

### What to take from it

- The eight are **Journal's assessment result**, not a skeleton for other projects. A library such as an
  agent client would likely select a session and execution lifecycle (state view), a concurrency
  scenario, and a contracts chapter, and would decline the data-model and storage chapters.
- Both failures this example records are assessment failures: a guide that opened with a work plan, and a
  guide that explained the writer and checker but not the data product people consume. Asking "who reads
  this, and what must they be able to do?" first would have caught both.
- Keep the assessment record. When the next revision is planned, compare the record to the readers'
  current questions before reorganizing anything.
