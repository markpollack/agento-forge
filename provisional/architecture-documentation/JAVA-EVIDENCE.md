# Java Evidence Pipeline

How a JVM project generates the facts its architecture guide is written around. Each piece is optional;
the [assessment](ASSESS.md) decides which views need it. The non-Java pipeline is available locally
in [tooling/](tooling/README.md). The Java sections below describe a worked example, not a second
ArchUnit installation: use the quality kit
[java-guardrails](https://github.com/markpollack/java-guardrails) as the intended home for shared rules;
a generic Java extraction is not shipped by this pack.

The reference implementation is [Agent Journal at
`a64833b83486c07db76027f6f6c075fc7685b17b`](https://github.com/markpollack/agent-journal/tree/a64833b83486c07db76027f6f6c075fc7685b17b),
the first complete version. Example paths below are relative to that revision. Commit URLs need an
upstream retained reference to survive branch removal; the local non-Java tools do not depend on it.

Coordinate with the project's other gates ([Java library quality](../../guides/java-library-quality.md),
the java-guardrails kit). ArchUnit installed as a quality gate and ArchUnit used for documentation should
be the same rules over the same component grouping, not two copies.

## 1. Declare component membership once

`journal-ocsf-writer/src/test/java/io/github/markpollack/journal/architecture/ArchitectureComponents.java`

- One class lists the documentation components. Each has a stable id, a display name, its module, an
  authored one-sentence responsibility, a membership description written into the generated facts, and a
  membership predicate over top-level compiled classes.
- Membership is decided in a preferred order: a package root, implementation of a declared interface,
  then an explicit list for justified exceptions. Nested and anonymous classes belong to their top-level
  class. Test classes are outside the analyzed scope.
- **Declared flows** cover data that crosses through a file or protocol, which no bytecode dependency
  shows (in Journal, the writer and checker share no code, only bytes on disk). They are drawn dashed and
  labelled *declared*, never *extracted*, and each names the class whose documentation states it.
- Responsibilities are authored summaries of each class's own documentation, and the generated facts say
  so.

## 2. Generate the component view and fail on drift

`ComponentViewTest.java` → `docs/architecture/generated/component-view.{json,md,puml,svg}`

- Imports the production bytecode with ArchUnit, checks that **every analyzed class belongs to exactly
  one component** (so a new class cannot silently fall out of the documentation), and extracts each
  component-to-component dependency with the class pairs that establish it.
- Writes machine-readable facts (JSON), a readable table (Markdown, marked *GENERATED… do not edit*), and
  PlantUML source. Components can be listed but marked *(not drawn)* for readability; their rows remain in
  the facts.
- Run with a regeneration property (`-Darchitecture.regenerate=true`) to rewrite the files. The **normal
  build fails** while the committed files differ from what the classes yield.

## 3. Enforce boundary rules that prove they can fail

`ArchitectureBoundaryTest.java`, negative controls in `architecture/control/`

- Rules use the same packages as the grouping, each with a `because` that cites the requirement it
  enforces.
- One test asserts **every rule selects its intended classes** (non-empty, test sources excluded).
- **Negative controls**: small classes in test sources that commit an otherwise valid forbidden
  dependency. A test evaluates the rule against each control and asserts it is rejected.
- Include an acyclicity rule over the slices that matter.
- A direct `dependOnClassesThat` rule is not a transitive isolation proof. Reflection, service loading,
  process invocation and data-mediated reuse need separate controls or stated limits. The Maven runtime
  classpath is a separate boundary from the architecture test's inspection classpath.

## 4. Record one scenario, scoped (opt-in)

`scripts/architecture/appmap.yml`, `scripts/architecture-docs.sh --appmap`

- Record **one existing test** under the AppMap Java agent; never the whole suite. List only the entry
  methods of each component in the scope file; say in the file why the scope is narrow.
- Export with the AppMap CLI's deterministic `sequence-diagram --format plantuml`, with package expansion.
- **Normalize presentation only**: remove the remote unpinned theme include and per-call elapsed times,
  rewrite participants into the alias form the linter reads correctly, add provenance comments, a title
  and a legend that states the scope. Change no message.
- Do **not** commit the recording (it can hold paths and arguments). Commit a small **manifest** instead:
  the recording's hash, size, event and call counts, threads, recorder and exporter versions, the scope
  file's hash, and any facts a claim relies on (for concurrency: receiver object identity and return
  values, not event ids).
- Derive a **compact overview** from the same recording and the component grouping
  using the [local condenser](tooling/sequence-overview.py): fold within-component and delegating
  calls, keep each thread root's own steps, block loops with counts and label `Class.method`. Unlike
  the reference version's receiver-matched `par`, the local tool keeps separate threads in explicitly
  unordered groups and preserves every root. Receiver identity alone does not prove overlapping
  lifetimes or cross-thread order. Link the full trace.

## 5. Check presentation

`scripts/architecture-docs.sh`, `scripts/architecture/pumllint-{overview,detail}.toml`

- PlantUML `-checkonly` on every `.puml` (syntax; it accepts an unclosed block).
- pumllint with a separate profile per diagram kind, at `--fail-on minor`. Overview: inline styling off,
  participant naming set to component-id aliases, self-messages allowed only on named orchestrators, a
  participant cap. Detail (recorded trace): self-messages and size rules off, because the trace records
  real self-calls and is complete by design.
- Keep negative copies that fail as intended (unclosed loop, undeclared participant).
- Render SVG and read it at full size.

Known tool behaviour at the pinned versions (pumllint 0.33.0, AppMap Java agent 1.30.2, `@appland/appmap`
3.204.0, PlantUML 1.2026.8):

| Tool | Behaviour | Workaround |
|---|---|---|
| pumllint | Reads `participant Alias as "Name"` with the name as the alias | Emit `participant "Name" as Alias` |
| pumllint | Lints component diagrams as sequence diagrams | Syntax-check component diagrams only |
| pumllint | Named profiles cannot disable rules | One config file per profile |
| AppMap | Event ids repeat across threads; the event array is not in id order | Never infer cross-thread order from ids |
| PlantUML | `-checkonly` accepts an unclosed block | pumllint catches it |

## 6. One command, pinned

Journal's `scripts/architecture-docs.sh`: a single entry point that regenerates the extracted view
and the worked example, optionally records the scenario, runs the presentation checks and renders. Tool versions are
pinned at the top; Maven resolves the jars, `npx` the AppMap CLI and `uvx` pumllint. The default part runs
in seconds in the reference application; recording is opt-in and never part of the normal build.
The [generic entry point](tooling/README.md) configures project commands and labels explicitly and
provides no Word export. Recording duration depends on the selected scenario.

## 7. Generate the worked example from real artifacts

`ToolCallStoryTest` in the checker module → `docs/architecture/generated/tool-call-story.md`

The end-to-end example is generated from a committed fixture, the executed code's stored output and the
independent check results, plus the counterexamples the checker rejects. It is regenerated and
drift-checked like the component view, so the example in the guide cannot silently go stale.
