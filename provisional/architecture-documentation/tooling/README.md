# Non-Java architecture evidence tools

> PROVISIONAL templates derived from the public Agent Journal implementation at
> [a64833b83486c07db76027f6f6c075fc7685b17b](https://github.com/markpollack/agent-journal/tree/a64833b83486c07db76027f6f6c075fc7685b17b/scripts/architecture).
> These local files are sufficient to adapt the non-Java pipeline; no checkout of that revision is
> required. This is not a completed second-project application. Markdown and SVG only.

## Adapt in a consumer

Copy this directory to `scripts/architecture/`. Start from `project.example.sh`, `overview.example.json`
and `appmap.example.yml`; replace example packages, commands, scenarios and labels. Project config is
reviewed executable Bash source, loaded from an explicit path, not untrusted input.

1. Choose the view and one existing scenario in the assessment. Install Python 3 (standard library),
   a JDK, the consumer's build wrapper, and `uvx`; recording also needs `npx`. Component
   diagram rendering also needs Graphviz (`dot`) on PATH; sequence diagrams do not. Resolve
   `net.sourceforge.plantuml:plantuml:1.2026.8` and optionally `com.appland:appmap-agent:1.30.2`
   into the configured local jar paths using the consumer's dependency tooling.
2. Set `GENERATE` to the consumer's generator tests. They rewrite JSON/Markdown/PlantUML facts under
   `-Darchitecture.regenerate=true`. The **normal build must compare regenerated facts to committed
   files and fail on differences**, using the same component membership and boundary rules as quality
   gates. This pack does not provide the ArchUnit tests; integrate those through java-guardrails.
3. Name sequence sources in `OVERVIEWS` and `DETAILS`, without `.puml`. Component sources get syntax
   checking and rendering, but not sequence lint. Configure the overview's orchestrator self-message
   allowlist and participant budget in `pumllint-overview.toml`, with reasons for departures.
4. Run `bash scripts/architecture/architecture-docs.sh scripts/architecture/project.sh` from the
   consumer root. It generates configured facts, checks syntax, lints named sequences and renders SVG.
   Missing configured sequences fail; the default path never records. Inspect each SVG at reading size.
5. For opt-in recording, set `RECORD` to a local wrapper that runs **one test** under the pinned agent,
   using exported `APPMAP_AGENT_JAR`, `SCOPE` and `ARCHITECTURE_RECORD_DIR`. Set `EXPAND` to AppMap package
   paths, `SCENARIO` to a public-safe description, and `VIEW`/`SETTINGS` as below. Run the same command
   with `--appmap`. Exactly one recording and one export must result. The exporter and linter are
   pinned to `@appland/appmap@3.204.0` and `pumllint==0.33.0`; first use may download them.

Raw recordings stay in unique directories under `target/architecture/`, which the consumer must ignore.
Commit `observed-recording.json`, `observed-sequence.puml`, `observed-overview.puml` and their SVGs only
when their content is suitable for the destination. The full trace can expose recorded names or values;
inspect it. A manifest records hashes/counts, never raw paths or arguments. Add separately reviewed
scenario-specific evidence when a claim needs receiver identity or return values; the generic manifest
intentionally makes no such claim. Generated trace normalization removes the remote theme and elapsed
times and corrects participant declaration order; it changes no message.

There is no `--docx` mode. `--appmap` is not part of the normal build. This entry point does not install
Java rules, release, or publish anything.

## Component-view input to the condenser

Use fully qualified **top-level** class names, shared by the build's component model. All recorded calls
must resolve to exactly one component, including calls that will be folded. Nested/anonymous classes
map to their top-level class. Component ids must produce distinct PlantUML aliases (`-` becomes `_`).
`external_entry` is reserved. The unused `drawing` key may be omitted.

```json
{
  "components": [
    {"id": "session", "name": "Session admission", "classes": ["example.app.Session"]},
    {"id": "execution", "name": "Execution", "classes": ["example.app.Execution"]}
  ],
  "drawing": {"incoming_edges_not_drawn_to": []}
}
```

`overview.example.json` controls title, scenario, full-trace filename and optional loop labels, keyed
as `component-id|class-name|method`. `class_prefixes` is an explicit compatibility bridge for generators
that emit package-relative class names, such as the original Journal example. It strips the longest
matching prefix from recorded names; do not use it if that would conflate classes from different
packages. New generators should keep fully qualified names. Component membership is not inferred here.

Run independently:

```sh
python3 scripts/architecture/sequence-overview.py recording.appmap.json component-view.json overview.puml overview.json
python3 scripts/architecture/recording-artifacts.py recording.appmap.json appmap.yml exported.sequence.uml docs/architecture/generated 'Named scenario' 1.30.2 3.204.0
```

## Condensation rules and limits

- Fold overload delegation and calls inside the same component, except a thread root's own steps.
  Shared components may be drawn on their caller's lifeline; all call ids remain in comments.
- Replace consecutive sibling blocks of equal component/class/method/child shape with counted loops.
  Choose the largest recorded body for display. Branch details that occur only in other repetitions
  may be absent from the overview: use the full trace and the listed ids for those details.
- Keep every thread root, including roots without children. Draw threads in separate groups labelled
  unordered relative to one another. Per-message ids are qualified by thread; returns match the
  thread-local stack. Reject malformed, incomplete or empty call trees and duplicate ids within a
  thread. The recorder must supply complete nested call/return pairs within each thread.
- This extraction deliberately avoids inferring `par` from receiver identity: calls on one object can
  happen sequentially on different threads. No cross-thread order, overlap or causality is established
  by event ids or diagram placement. An authored concurrency view needs separate evidence.

The original implementation had project names in loop labels, stripped packages, captions and recording
scope. Those now belong to configuration. Its parallel rendering also omitted the matched worker root
and could replace an earlier worker if two matched one loop. Separate groups preserve all roots without
asserting an overlap the generic inputs do not establish.

## Verify after adaptation

`python3 scripts/architecture/test_tooling.py` checks condensation/provenance and rejects invalid inputs.
Set `ARCHITECTURE_PLANTUML_JAR` to the pinned jar to also exercise real rendering and positive/negative
lint controls (requires `uvx`). An unclosed loop and an undeclared participant must fail; a representative
valid overview/detail must pass. These are synthetic unit inputs, not recorded execution evidence.
Calibrate profiles on the consumer's real output; a passing linter says nothing about architectural
correctness. Record what was and was not run in the consumer's review.
