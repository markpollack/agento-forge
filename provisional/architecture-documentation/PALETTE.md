# The Palette

Everything considered when documenting an architecture, kept whole so each project can choose. Nothing
here is mandatory. The [assess stage](ASSESS.md) selects from it and records what it declined.

These approaches answer different questions and combine. The division of labour that worked for Agent
Journal: **Views and Beyond chooses and completes the explanations; arc42 organizes the content; C4 and
selected UML express it; static analysis and execution recording supply reproducible evidence.**

## 1. Methods and frameworks

| Approach | What it contributes | Use it for | Do not use it for |
|---|---|---|---|
| **Views and Beyond** (Clements et al., SEI, 2nd ed. 2010) | Choose views by stakeholder concerns; three view families (module, component-and-connector, allocation); document interfaces, behaviour, rationale and the relationships *between* views ("beyond"); seven documentation rules | The methodological foundation: deciding which views exist and what surrounds each | A list of diagrams to draw; it prescribes no universal set |
| **4+1 view model** (Kruchten, 1995) | Logical, development, process and physical perspectives, tied together by scenarios | Separating perspectives; using concrete scenarios as the "+1" that connects them | A four-box template; select only the perspectives a reader needs |
| **ISO/IEC/IEEE 42010:2022** | Vocabulary: stakeholder, concern, viewpoint (a reusable lens template), view (its application), correspondence between views | Precise terms when discussing what a view is for | Certification or a compliance programme |
| **arc42** (Starke, Hruschka, 2005–) | Twelve content sections; a practical checklist of places to put information (section 2) | Organizing content and noticing an omitted concern | A form to fill; empty sections are not completeness |
| **Architecture Communication Canvas / Inception Canvas** (arc42) | One-page summaries: the communication canvas for an existing system, the inception canvas for exploring a new design | A one-page introduction, or a design workshop | Replacing the guide |
| **C4 model** (Brown) | Four zoom levels (context, container, component, code) plus dynamic and deployment diagrams; a diagram review checklist | Expressing static structure at a deliberately chosen zoom; container = an application or data store, not a Docker container | Treating its four levels as four required diagrams; C4 itself says context and container suffice for many teams |
| **UML** | Precise notations: component, sequence, state, class, activity, deployment | A specific structural or behavioural relationship where the notation adds precision | A class diagram of every class or a sequence diagram of every test |
| **Architecture Decision Records** (Nygard, 2011) | Context, decision, status, consequences; supersession | Recording significant choices and when they changed | Duplicating a decision history the project already keeps |
| **Docs as code** (Write the Docs) | Version, review, build and check documentation with the code | The maintenance and publication workflow | — |
| **Models as code** (Structurizr) | Several consistent views generated from one explicit model | Consistency across many views when it is worth a model's upkeep | A second architecture model that drifts from the code |
| **Execution-derived documentation** (AppMap and similar) | Sequences observed in a named, recorded scenario | Showing what one scenario actually did | Claiming every path, branch or call |
| **Diataxis** (Procida) | Four document types; architecture documentation is *explanation* | Keeping architecture explanation apart from tutorials, how-to guides and reference ([taxonomy](../../concepts/documentation-taxonomy.md)) | — |

## 2. arc42's twelve sections

Each is a *place* for information, selected when a reader needs it.

| # | Section | Holds | Select when | Fold or skip when |
|---|---|---|---|---|
| 1 | Introduction and goals | Purpose, top quality goals, stakeholders | Always, as the opening | — |
| 2 | Constraints | Technical, organizational, regulatory constraints | A constraint changes how the design must be read | Constraints fit in one paragraph of the opening (fold into 1 or 3) |
| 3 | Context and scope | The system's boundary, its neighbours, what crosses the boundary | Always; it is where a newcomer starts | — |
| 4 | Solution strategy | The few fundamental decisions that shape everything else | The system has a governing idea a reader must hold first | The strategy is the system's main mechanism, better shown as a flow (fold into the runtime chapter) |
| 5 | Building block view | Static decomposition, responsibilities, interfaces | Always for a codebase with more than one component | — |
| 6 | Runtime view | Important scenarios as behaviour over time | A scenario explains something structure cannot: streaming, ordering, cancellation, failure, concurrency | Behaviour is a straight call chain obvious from the structure |
| 7 | Deployment view | Mapping of software to infrastructure | Process boundaries, child processes, persistence locations, trust or failure isolation are consequential | The system is a library that runs in its caller's process; a page about "runs on the local computer" adds nothing |
| 8 | Crosscutting concepts | Domain model, persistence, error handling, security, and similar | A shared concept recurs across components; for a data product, the data model belongs here or gets its own chapter | — |
| 9 | Architecture decisions | Significant decisions and their reasons | Decisions are not already recorded elsewhere | A decision log exists (link it; do not copy it) |
| 10 | Quality requirements | Quality tree, quality scenarios | A quality attribute is consequential and testable | A generic attribute inventory would be filler; state the concrete quality questions inside the views instead |
| 11 | Risks and technical debt | Known risks, debt, open issues | Always as a short honest list of current limits | — |
| 12 | Glossary | Domain and technical terms | The vocabulary is large or contested | Terms can be defined at first use |

## 3. Views and Beyond in detail

**View families.**

| Family | Question it answers | Typical evidence |
|---|---|---|
| Module | Which implementation units own which responsibilities, and what may depend on what? | Compiled classes, reviewed membership, enforced dependency rules |
| Component-and-connector | Which executing participants interact, through which calls, streams, files or protocols? | Recorded scenarios, declared interface and protocol descriptions |
| Allocation | How are software elements assigned to environment, artifacts, files or work ownership, when that matters? | Build, source and ownership facts; only consequential mappings. Allocation is broader than deployment |

Static modules, runtime participants and diagram boxes are not one-to-one. Several classes can form one
documented component; a recording contains instances and invocations of them. Keep that mapping explicit.

**The "beyond".** Information that no single view carries: why the design is this way, the semantics
of the system's main artifact, input/output and failure contracts, cross-view correspondences. Link the
authoritative source rather than copying it.

**View description** (adapted from the book's presentation / element catalog / interface / behaviour /
rationale guidance; see the [view template](templates/VIEW.md)): reader question, scope and evidence
status; the visual with element and relationship meanings; responsibilities and contracts; behaviour
and failure cases; references to code and other views; rationale, quality concerns and limits.

**Seven documentation rules**, used as a review lens: write for the reader; avoid unnecessary repetition;
avoid ambiguity; use a standard organization; record rationale; keep it current but not too current;
review it for fitness of purpose.

## 4. C4 and UML choices

| Notation | Select when |
|---|---|
| C4 system context | Always useful as the boundary picture |
| C4 container | The system has several deployable or runnable units, or data stores |
| C4 component | Inside one container, the responsibilities are the design question (often the case for a library) |
| C4 code | Rarely; prefer a focused UML class diagram |
| C4 dynamic / UML sequence | An ordered interaction explains something; generate it from a recording where possible |
| UML state | A lifecycle is hard to understand otherwise (sessions, turns, executions, connections) |
| UML class (focused) | A type relationship is the explanation |
| C4 / UML deployment | Arc42 section 7's "select when" holds |

## 5. Content beyond views

| Content | Use it for |
|---|---|
| **Worked example traced end to end** | One concrete input followed through every stage to its output and its check. Often teaches more than any class diagram. Show source values, the rule applied, the result, its provenance and the check outcome |
| **Contracts and failure behaviour** | What each boundary promises, what it refuses, what a caller sees on failure |
| **Rationale** | Why, with links to the decision record |
| **Where to make a change** | The maintainer's map: which file to touch for which kind of change |
| **Regeneration and checks** | How the generated material is rebuilt and what checks guard it |
| **Current support and limits** | What is established at this revision, what is proposed, what is unexercised |

## 6. Evidence tools

| Tool | Establishes | Does not establish |
|---|---|---|
| **ArchUnit** | References present in the analyzed bytecode; enforced dependency, layer, cycle, naming and membership rules; executable PlantUML component rules; frozen violation baselines; dependency metrics | That a path executed |
| **Structurizr** (component finder, DSL) | Consistent C4 views from one model; component discovery by matcher | Observed order (its dynamic views are supplied, not recorded) |
| **Spring Modulith** | Generated module diagrams and canvases for applications already modelled as modules | Anything about code not structured that way |
| **Spoon** (source AST), call-graph analysis | Possible relationships under a named analysis | Runtime order, frequency or dispatch |
| **AppMap** (Java agent + CLI) | Calls observed in one recorded scenario within the configured scope; deterministic PlantUML sequence export; sequence diff | Every path; cross-thread order from its event ids |
| **OpenTelemetry method spans** | Selected boundaries in an already-instrumented system | A complete call sequence |
| **JFR / sampling profilers** | Sampled stacks and events | A complete call/return sequence |
| **Coverage** | Lines and branches exercised | Order or correctness |
| **PlantUML** (`-checkonly`, rendering) | Syntax and rendering | Readability or semantics; it accepts an unclosed block |
| **pumllint** | Presentation conventions (declared participants, closed blocks, labels, size) under a calibrated profile | Correctness |
| **Mermaid** | Authored conceptual diagrams that render in GitHub and Typora | Anything extracted |
| **docToolchain, pandoc** | Multi-format publishing if it becomes necessary | — |

## 7. Reading layers

1. **One page**: problem, boundary, key mechanism, main trade-off, one small picture or example.
2. **Short guide**: responsibilities, the main flows, selected scenarios, invariants, limits, a reading path into code.
3. **Linked detail**: requirements, schemas, decisions, execution evidence, operating instructions.

## 8. What research says

- **CIAO** (*Code In Architecture Out*, De Luca et al., 2026 preprint): generating system documentation
  from repositories, informed by 42010, Views and Beyond and C4. 22 developers found it useful for
  repositories they knew, with weaknesses in diagrams, high-level context and deployment views. The
  authors separate perceived usefulness from architectural correctness.
- **Ernst and Robillard** (2023): 65 participants answered architecture questions from narrative versus
  structured documentation; no significant association between format and answer quality, and prior
  exposure to the code mattered more. Evaluate reader understanding, not template completion.

## References

1. Clements et al., *Documenting Software Architectures: Views and Beyond*, 2nd ed., Addison-Wesley/SEI,
   2010, ISBN 978-0321552686; [SEI page](https://www.sei.cmu.edu/library/documenting-software-architectures-views-and-beyond-second-edition/);
   published excerpts on [views](https://www.informit.com/articles/article.aspx?p=1641654&seqNum=3),
   [styles and cross-view relationships](https://www.informit.com/articles/article.aspx?p=1641654&seqNum=4),
   [documentation rules](https://www.informit.com/articles/article.aspx?p=1641654&seqNum=5);
   [author interview](https://www.informit.com/articles/article.aspx?p=1629149).
2. Kruchten, [The 4+1 View Model of Architecture](https://www.cs.ubc.ca/~gregor/teaching/papers/4%2B1view-architecture.pdf), IEEE Software, 1995.
3. [ISO/IEC/IEEE 42010:2022, Architecture description](https://www.iso.org/standard/74393.html).
4. [arc42 overview](https://arc42.org/overview/), [license](https://arc42.org/license/) (check before distributing an adapted template);
   Starke and Hruschka, [Communicating Software Architectures with arc42](https://leanpub.com/arc42inpractice).
5. [Architecture Communication Canvas](https://canvas.arc42.org/architecture-communication-canvas).
6. Brown, C4 model: [diagrams](https://c4model.com/diagrams), [review checklist](https://c4model.com/diagrams/checklist).
7. Nygard, [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions), 2011.
8. Write the Docs, [Docs as code](https://www.writethedocs.org/guide/docs-as-code/).
9. Procida, [Diataxis](https://diataxis.fr/).
10. [ArchUnit user guide](https://www.archunit.org/userguide/html/000_Index.html).
11. Structurizr: [Java component finder](https://docs.structurizr.com/java/component/introduction), [dynamic views](https://docs.structurizr.com/dsl/cookbook/dynamic-view/).
12. AppMap: [Java agent](https://appmap.io/docs/reference/appmap-java.html), [CLI and sequence export](https://appmap.io/docs/reference/appmap-client-cli.html), [PlantUML integration](https://appmap.io/docs/reference/integrations/plantuml.html).
13. [PlantUML sequence diagrams](https://plantuml.com/sequence-diagram); [pumllint](https://github.com/fdurieux/pumllint).
14. [Spring Modulith documentation](https://docs.spring.io/spring-modulith/reference/documentation.html).
15. [Spoon](https://spoon.gforge.inria.fr/); [OpenTelemetry Java annotations](https://opentelemetry.io/docs/zero-code/java/agent/annotations/).
16. [docToolchain](https://doctoolchain.org/docToolchain/v2.0.x/).
17. De Luca et al., [CIAO](https://arxiv.org/abs/2604.08293), 2026.
18. Ernst and Robillard, [A Study of Documentation for Software Architecture](https://arxiv.org/abs/2305.17286), 2023.
19. [Typora diagrams](https://support.typora.io/Draw-Diagrams-With-Markdown/) (Mermaid rendering in the editor used for review).
