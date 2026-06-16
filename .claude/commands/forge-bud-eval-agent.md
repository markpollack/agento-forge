---
name: forge-bud-eval-agent
description: "Bootstrap a Bud eval-agent workspace (Forge: consumer of bud-agent-experiment-template — ACP/bud-core, golden-path instrumentation pre-wired)"
---

# Forge Bud Eval-Agent — Bootstrap a Bud Experiment Workspace

> **Installation**: Copy this file to `~/.claude/commands/forge-bud-eval-agent.md` for global access.
> Then update the paths in the Configuration section below.

You are helping bootstrap a new **Bud eval-agent workspace** using the Forge methodology's eval-agent variant. This is the **cousin** of `/forge-eval-agent`: it produces the same kind of consumer project — domain agents, judges, datasets, variant ladders that plug into the experiment framework — but it scaffolds from the **Bud experiment template** (`bud-agent-experiment-template`) rather than the generic agent-experiment template. Use it when the experiment evaluates a **Bud-domain agent** (ACP-driven, bud-core preconditions, studio.json workspace).

> **HARD CONSTRAINT**: This command is **template-as-factory**. The Bud template is a complete, working Maven project — ACP client, WorkflowAgentInvoker, VariantDatasetManager, JuryFactory, golden-path journal/trace wiring are all already present and correct. You **copy the whole template** and perform a fixed set of replacements. NEVER rebuild these files from scratch, never re-derive the pom dependencies inline, never reimplement the golden-path instrumentation. If the template is wrong, fix the template — do not fork its logic into the new workspace.

## Key Design Difference From the Generic Cousin

This is the one thing to internalize before anything else:

| | `/forge-eval-agent` (generic) | `/forge-bud-eval-agent` (this command) |
|---|---|---|
| Bootstrap method | **Generate** — `mkdir` the tree, write pom.xml inline, author each Java file | **Copy** — `cp -r` the entire working template, then replace placeholders |
| pom.xml | Authored from the canonical reference, dependency-by-dependency | Inherited verbatim from the template (agentworks BOM 1.5.0, bud-core 0.4.0, ACP) |
| Invoker / runner / judges | Written per phase | Already present; you swap the *domain* judges, keep the framework wiring |
| Golden-path instrumentation | Wired by hand, verified late | Pre-wired in `WorkflowAgentInvoker` (`Journal.configure` static init + `.traceDir`) |
| VISION / DESIGN / ROADMAP | Authored early by necessity (no scaffold to copy — docs precede code) | Stubbed in Phase 2's FIRST commit (placeholders intact, plus `BOOTSTRAP-CHECKLIST.md`), filled in Phase 5 — working code appears in minutes here, so deferred docs must exist as visible on-disk debt or an interrupted bootstrap orphans them |
| Risk | Drift from the canonical scaffold | Drift from the template if you regenerate instead of replace; orphaned docs if you skip the Phase 2 stubs |

The template is the source of truth. The generic cousin builds file-by-file because there is no single working scaffold to copy; here there is, so **copy and replace** is strictly safer and faster. Treat any urge to "just rewrite it cleanly" as a bug.

## Architecture Context

Bud eval-agent workspaces sit at the **consumer layer** of the experiment stack, same as the generic cousin, but the invocation path runs through ACP and bud-core:

```
agent-experiment (orchestration: AgentExperiment, ResultStore, SessionStore, ComparisonEngine)
  │   consumer implements: AgentInvoker + domain judges + dataset + variant ladder
  ┌────┴───────────────────────────────────────────────┐
  │ bud-agent-experiment-template (this command's source)│
  │   ├── AcpAgentInvoker        — drives a Bud ACP server jar
  │   ├── WorkflowAgentInvoker   — portable agent-client path (golden-path traces)
  │   ├── VariantDatasetManager  — variant ladder → dataset items
  │   ├── PreConditionBuilder    — bud-core ProjectScaffolder fixtures
  │   ├── JuryFactory            — T0/T1 cascade
  │   └── studio.json            — agento.studio.v1 workspace descriptor
  └──────────────────────────────────────────────────────┘
```

**The workspace provides**: studio identity (agentId/workspaceId/targetRepos), domain judges, the variant ladder, externalized prompts, the dataset/preconditions.

**The template provides**: ACP + workflow invokers, the runner/jury/dataset machinery, golden-path journal+trace instrumentation, provenance capture, the CLI (`--variant`/`--phase`/`--paired`/`--summary`/`--compare`).

## Governing Methodology

Same as the generic eval-agent variant: the **Improvement Flywheel** — `RUN → MEASURE → DIAGNOSE → INTERVENE → VERIFY`. Variants are empirically motivated by default; deliberate hypothesis-driven variants declare their hypothesis in `experiment-config.yaml`. See `{agento-forge}/concepts/improvement-flywheel.md` for the loss-signal taxonomy, five levers, and Phase 0 state-taxonomy discovery.

## When to Use

Use this command when:
- The experiment evaluates a **Bud agent** invoked over ACP (a Bud server jar), and/or
- The dataset uses **bud-core preconditions** (`ProjectScaffolder` fixtures), and/or
- You want a workspace that participates in the **agento studio** (studio.json identity, targetRepos)
- You want golden-path instrumentation (JSONL traces + agent-journal) pre-wired and verifiable
- The agent is a **review agent** (reviews a target repo, writes a report, ships an ACP server into the IDE — bud-ddd, bud-spring-advisor) → the phases apply with the deltas in the **Review-Agent Variant** section below

Do NOT use this for:
- **Generic eval-agent projects** (non-Bud agent, agent-experiment-template) → use `/forge-eval-agent`
- **Research projects** → `/forge-research`
- **Standard software projects** → `/forge-project`
- **The Bud platform or template itself** — fix those in place

## Arguments
- `$ARGUMENTS` — Optional: brief file path, target workspace path, reference material paths
  - If `$ARGUMENTS` contains a path to a `*-brief.md` file, treat it as a **pre-filled brief** (same Brief Format as `/forge-eval-agent`, plus the Bud-specific fields below). Read it first, confirm with the user, then proceed to Phase 2.

## Brief Format (Bud additions)

The brief uses the same shape as the generic eval-agent brief (Agent Description, Optimization Goal, Source Materials, Prior Baselines, Judges, Variants, Convergence Criteria). When provided, also extract these Bud-specific fields — they drive the Phase 3 replacement checklist:

```markdown
## Bud Workspace Identity
- groupId:           {e.g. io.github.markpollack}
- base package:      {e.g. io.github.markpollack.budddd}
- workspace name:    {artifactId / directory name, e.g. bud-ddd-agent-workspace}
- studio agentId:    {e.g. bud-ddd}
- studio workspaceId:{e.g. bud-ddd-workspace}
- targetRepos[0].path: {absolute path to the Bud platform / domain repo}

## Domain Judges (replace the Spring scaffolding judges)
| Judge | Tier | Replaces | Evaluates |
|-------|------|----------|-----------|
| {DddPomJudge} | 1 | SpringBootPomJudge | {domain guardrail} |
| {DddDesignJudge} | 3 | CodeQualityJudge | {domain semantic} |
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENTO_FORGE_HOME` | `$HOME/projects/agento-forge` | Root of the agento-forge checkout (forge methodology, templates) |
| `BUD_AGENT_EXPERIMENT_TEMPLATE_HOME` | `$HOME/tuvium/projects/bud-agent-experiment-template` | The working Bud template to copy from |

**Path references in this command use placeholders**:
- `{agento-forge}` → `$AGENTO_FORGE_HOME`
- `{template}` → `$BUD_AGENT_EXPERIMENT_TEMPLATE_HOME`
- `{workspace}` → the new workspace directory

Fail with a clear error if `{template}` is missing — there is nothing to copy without it.

## Instructions

### Phase 1: Understand the Bud Domain (Brief Intake)

Be conversational. If a brief was passed, confirm these rather than asking cold. Gather:

1. **Experiment identity**
   - Experiment name (→ `experiment-config.yaml` `experimentName`)
   - Workspace directory name / artifactId (→ pom `artifactId`, `name`)
   - groupId and base package (→ pom `groupId`, package rename)

2. **Studio identity** (→ `studio.json`)
   - `agentId` (the agent under evaluation, e.g. `bud-ddd`)
   - `workspaceId`
   - `targetRepos[0].path` — absolute path to the Bud platform / domain repo the agent writes to

3. **Domain judges + variant ladder** (from the brief if present)
   - Which judges replace `SpringBootPomJudge` (T1 guardrail) and `CodeQualityJudge` (T3 semantic)
   - The variant ladder (control → hypothesis variants), each with its motivating finding
   - Per-judge convergence thresholds

4. **What the Bud agent does** — task, target repo, what "success" means for one item, optimization goal.

5. **Where the workspace lives** — target path, private/community.

### Phase 2: Copy the Template + Front-Load Doc Stubs + First Commit

Copy the **complete** template into the target directory, excluding `.git/` and `target/`, then initialize a fresh repo:

```bash
# Resolve template; fail loudly if absent
test -d "$BUD_AGENT_EXPERIMENT_TEMPLATE_HOME" \
  || { echo "error: BUD_AGENT_EXPERIMENT_TEMPLATE_HOME not found"; exit 1; }

mkdir -p {workspace}
# Copy everything except the template's own git history and build output
rsync -a --exclude '.git/' --exclude 'target/' \
  "$BUD_AGENT_EXPERIMENT_TEMPLATE_HOME"/ {workspace}/

cd {workspace} && git init
```

**Front-load the forge doc stubs — immediately, placeholders intact.** A `{{PLACEHOLDER}}`-riddled VISION.md in the repo is honest, visible debt; an absent one is invisible debt. Copy the templates AS-IS; Phase 5 fills them in:

```bash
cp {agento-forge}/templates/VISION-TEMPLATE.md  {workspace}/plans/VISION.md
cp {agento-forge}/templates/DESIGN-TEMPLATE.md  {workspace}/plans/DESIGN.md
cp {agento-forge}/templates/ROADMAP-TEMPLATE.md {workspace}/plans/ROADMAP.md
```

**Write the exit checklist to disk** as `{workspace}/plans/BOOTSTRAP-CHECKLIST.md` — the Phase 7 exit criteria as unchecked boxes, grouped by phase. Each phase checks off its items as it completes; an interrupted bootstrap then leaves a file that screams what's left:

```markdown
# Bootstrap Checklist — {workspace-name}

> Created by /forge-bud-eval-agent Phase 2. Each phase checks off its items as it
> completes. The bootstrap-complete commit (Phase 7) requires EVERY box checked.
> Unchecked boxes after an interrupted run are visible debt — repay before any eval wave.

## Phase 2 — Copy + stubs + first commit
- [ ] Template copied (no `.git/`, no `target/`); fresh `git init`
- [ ] `plans/VISION.md` / `plans/DESIGN.md` / `plans/ROADMAP.md` stubs present (placeholders intact)
- [ ] First commit made containing the stubs + this checklist

## Phase 3 — Replacements
- [ ] `grep -rnE 'REPLACE[-_ ](WITH|with)' .` clean (`CUSTOMIZE:` comments and `REPLACE_EXISTING` are not placeholders; scaffold-groupId default exempt)
- [ ] Package tree physically moved; `grep -rn "com.example.experiment" src` clean
- [ ] `studio.json` has real agentId / workspaceId / targetRepos[0].path
- [ ] `experiment-config.yaml` has the real experimentName

## Phase 4 — Domain customization
- [ ] Example judges replaced with domain judges; `JuryFactory` rewired
- [ ] Variant ladder in `experiment-config.yaml` with `iteration` fields
- [ ] Prompts externalized to `plans/prompts/` with runnable stopping conditions

## Phase 5 — Docs filled and finalized
- [ ] VISION.md / DESIGN.md / ROADMAP.md placeholders replaced with real content
- [ ] `grep -rln '{{' plans/` returns nothing

## Phase 6 — Golden-path smoke check
- [ ] Compiles (`./mvnw compile -q`)
- [ ] (a) JSONL traces exist with structured tool input
- [ ] (b) Journal events written
- [ ] (c) Multi-line Write survives the JSONL round-trip
- [ ] (d) agent-control-theory loaders read the traces

## Phase 7 — Bootstrap complete
- [ ] All boxes above checked; bootstrap-complete commit made
```

**Then make the FIRST commit** — stubs and checklist included. This is what makes deferred work visible: if the bootstrap is interrupted at any later phase, the repo already carries the placeholder docs and the unchecked boxes.

```bash
cd {workspace}
git add -A
git commit -m "Scaffold from bud-agent-experiment-template (doc stubs + bootstrap checklist, placeholders intact)"
```

Notes:
- `rsync -a` preserves the executable bit on `mvnw` (do not lose it).
- The template ships `experiments/runs/.gitkeep` and `experiments/traces/.gitkeep` — keep them; that is where traces land.
- The template `.gitignore` already ignores `results/`, `target/`, `.env`, `.campus/`. Do not regenerate it.
- Do NOT fill the doc stubs here, even partially — Phase 2 is mechanical. Filling happens in Phase 5 with the domain knowledge from Phases 3–4 in hand. The stubs' job at this point is purely to exist and be committed.

### Phase 3: Mandatory Replacements (Exact Checklist)

These are the **verified** placeholder locations in the template. Work through every one; nothing here is optional.

1. **`pom.xml`**
   - `<groupId>com.example</groupId>` → `{groupId}`
   - `<artifactId>REPLACE-WITH-WORKSPACE-NAME</artifactId>` → `{workspace-name}`
   - `<name>REPLACE-WITH-WORKSPACE-NAME</name>` → `{workspace-name}`
   - `<description>Bud agent experiment workspace — REPLACE with domain description</description>` → domain description
   - `<mainClass>com.example.experiment.AgentExperimentApp</mainClass>` (≈ line 202) → `{basePackage}.AgentExperimentApp`
   - Leave the BOM, bud-core, ACP, judge, journal, and capture dependencies **untouched**.

2. **Package rename** `com.example.experiment` → `{basePackage}` across all of `src/`:
   - Update every `package` declaration and every `import com.example.experiment.*`.
   - **Move the directory tree**: `src/main/java/com/example/experiment/` → `src/main/java/{basePackage as path}/` (and `src/test/...` if present). Use `git mv` after `git init`, or plain `mkdir -p` + `mv` then `rmdir` the empty `com/example` chain.
   - Verify with `grep -rn "com.example.experiment" src` returning nothing.

3. **`studio.json`**
   - `"agentId": "REPLACE_WITH_AGENT_ID"` → `{agentId}`
   - `"workspaceId": "REPLACE_WITH_WORKSPACE_ID"` → `{workspaceId}`
   - `targetRepos[0].path: "REPLACE_WITH_PLATFORM_REPO_PATH"` → `{targetRepos[0].path}`
   - Adjust `targetRepos[0].id`/`role`/`description` and the `knowledgeStructure.externalReferences` entries only if the domain differs from the default bud-platform/templates layout.

4. **`experiment-config.yaml`**
   - `experimentName: "REPLACE_WITH_EXPERIMENT_NAME"` → `{experimentName}`

5. **`AgentExperimentApp.java`** — there is a second `REPLACE_WITH_EXPERIMENT_NAME` fallback literal in `main()` (used only if the YAML fails to load). Replace it with `{experimentName}` for consistency.

> **Scaffold fixtures note**: when the dataset's preconditions scaffold *fixture* projects (via `PreConditionBuilder` / bud-core `ProjectScaffolder`), their groupId is controlled by the system property `-Dexperiment.scaffold.groupId=...` (default `com.example`). This is the **fixture** project's coordinates, **not** the workspace's — leave it at the default **unless** a domain judge asserts on the generated package name, in which case set it explicitly when invoking.

After replacements: `grep -rnE 'REPLACE[-_ ](WITH|with)|com\.example' {workspace} --include='*.java' --include='*.xml' --include='*.json' --include='*.yaml'` should return nothing (other than the deliberate scaffold-groupId default if you kept it). The pattern is deliberately precise: the template's prose guidance comments use `CUSTOMIZE:` (guidance, not placeholders — leave them), and `StandardCopyOption.REPLACE_EXISTING` is Java API; neither must trip the exit criterion.

### Phase 4: Domain Customization

The template ships **Spring-scaffolding** judges as worked examples. Replace them with the brief's domain judges — keep the framework wiring, swap the domain logic.

1. **Replace the example judges**
   - `judge/SpringBootPomJudge.java` (T1 deterministic guardrail) → `{Domain}` T1 judge
   - `judge/CodeQualityJudge.java` + `CodeQualityResponse.java` + `resources/rubrics/code-quality-rubric.md` (T3 AI semantic) → `{Domain}` T3 judge + rubric
   - Rewire `runner/JuryFactory.java` to build the cascade from your judges (T0 REJECT_ON_ANY_FAIL → T1 → T3 FINAL_TIER). Keep the cascade *shape*; change the judges it contains.

2. **Define the variant ladder**
   - Encode variants in `experiment-config.yaml` (control + hypothesis variants), each with an `iteration` block (`finding`, `hypothesis`) — the audit trail.
   - Align `dataset/VariantCatalog.java` phase groupings with the ladder.

3. **Externalize prompts** to `plans/prompts/` (one `.txt` per variant: `v0-control.txt`, `v1-...txt`, …). Each prompt MUST carry a **domain-specific stopping condition** — a concrete runnable check the agent runs to confirm the task is done (not "verify your work"). For a Bud/Maven domain that is typically `./mvnw test` or `./mvnw verify` passing in the generated project.

### Phase 5: Fill and Finalize VISION / DESIGN / ROADMAP

The stubs already exist — Phase 2 copied them into `plans/` and committed them with placeholders intact. This phase **fills, it does not create**. If the stubs are missing, that is a Phase 2 failure: stop and repair (copy the templates, backfill the checklist) before continuing.

Replace every `{{PLACEHOLDER}}` with real content per the eval-agent conventions:
- **VISION**: problem statement, measurable success criteria (reproduce baseline → exceed by Δ → reproducible), scope, unknowns, assumptions-as-risks.
- **DESIGN**: the Consumer Integration table (what the workspace provides vs. what the template/framework provides), the Judges table, convergence criteria, and the empirically-motivated variant table with `iteration` fields.
- **ROADMAP**: eval-agent stages (Scaffolding → Control Baseline → Phase 0 state-taxonomy discovery → Forge variant → KB development → scale-up), per-step entry/exit criteria that read the prior step's learnings, stage-consolidation steps, and an archival step (GitHub release assets) at the end of each stage producing sweep data. **Step 1.2 of the ROADMAP must be the golden-path smoke check below** — a workspace is not eligible for eval waves until it passes.

**Mechanical exit criterion** (like the Phase 3 placeholder grep — not a judgment call):

```bash
grep -rln '{{' {workspace}/plans/   # MUST return nothing
```

Any hit means a placeholder survived — the docs are not finalized. Check off the Phase 5 boxes in `plans/BOOTSTRAP-CHECKLIST.md` only when this grep comes back empty. Note: a `ROADMAP.md` later produced by some other route (e.g. `/plan-to-roadmap`) does NOT satisfy this phase — VISION and DESIGN must pass the same grep; one finished artifact must not mask two missing ones.

### Phase 6: Golden-Path Smoke Check — REQUIRED Before Any Eval Wave

This is what makes a scaffold a **verifiable** scaffold and not a one-off. Run it after Phase 4 and before any variant runs. **If ANY check fails, stop and fix it. Do not run eval waves on a workspace with broken instrumentation** — broken traces silently corrupt every downstream Markov/analysis result.

1. **Compiles**
   ```bash
   cd {workspace} && ./mvnw compile -q   # must exit 0
   ```

2. **One minimal live run** — invoke a single trivial variant once (smallest prompt that makes the agent write at least one multi-line file), e.g. `./mvnw -q exec:java -Dexec.args="--variant 1"` (or `--paired 1` to also exercise `WorkflowAgentInvoker`). Then verify **all** of:

   (a) **JSONL traces exist with structured tool input**
   ```bash
   ls {workspace}/experiments/traces/*.jsonl            # at least one file
   grep '"type":"tool_use"' {workspace}/experiments/traces/*.jsonl | head -1
   # tool_use lines MUST carry an "input": { ... } OBJECT (not a string, not absent)
   ```

   (b) **Journal events written**
   ```bash
   ls {workspace}/experiments/traces/.agent-journal/     # journal storage populated
   ```

   (c) **Multi-line Write survives the JSONL round-trip** — every line must be valid JSON, and at least one tool_use must be a multi-line `Write` whose content survived escaping:
   ```bash
   # every line parses as JSON (control chars / newlines correctly escaped)
   while IFS= read -r line; do echo "$line" | jq -e . >/dev/null || { echo "BAD LINE"; exit 1; }; done \
     < {workspace}/experiments/traces/<the>.jsonl
   # confirm a multi-line Write is present and round-trips
   jq -e 'select(.type=="tool_use" and .name=="Write") | .input.content | contains("\n")' \
     {workspace}/experiments/traces/<the>.jsonl
   ```
   (Python equivalent: `python -c "import json,sys; [json.loads(l) for l in open(sys.argv[1])]"`.)

   (d) **agent-control-theory loaders can read the traces**
   ```bash
   uv pip install -e ~/projects/agent-control-theory[all]
   # Load the JSONL via the TraceWriter loader and build a chain — must succeed, no parse errors:
   python -c "from agent_control_theory import build_absorbing_chain_from_traces as b; \
     print(b(['{workspace}/experiments/traces']))"
   ```
   (The library was renamed from markov-agent-analysis; `~/tuvium/projects/markov-agent-analysis`
   no longer exists. A `markov_agent_analysis` back-compat shim still imports, but use the new name.)

If (a)–(d) all pass, the golden path is intact: this is what the agent-journal 1.3.0 TraceWriter tool-input + control-char escaping fix (2026-06-03) exists to guarantee. Only now may the ROADMAP eval waves proceed.

### Phase 7: Bootstrap-Complete Commit + Exit Checklist

The exit checklist lives **on disk** at `plans/BOOTSTRAP-CHECKLIST.md` (created in Phase 2) — this phase verifies it, it does not recite it from memory. Walk the file: every box from Phases 2–6 must already be checked, with each criterion actually verified (re-run the greps; do not check boxes on recollection). Then check the Phase 7 box and make the bootstrap-complete commit:

```bash
cd {workspace}
# Verify: no unchecked boxes may remain (other than Phase 7's own, checked in this commit)
grep -n '\- \[ \]' plans/BOOTSTRAP-CHECKLIST.md
git add -A
git commit -m "Complete bootstrap: {workspace-name} (all BOOTSTRAP-CHECKLIST criteria verified)"
```

**The commit is gated on the checklist**: if any box is unchecked, the bootstrap is not complete — either finish the phase that owns the box, or stop and leave the unchecked boxes in place as visible debt. Never check a box to make the commit pass.

**Exit criteria** (mirrored in `plans/BOOTSTRAP-CHECKLIST.md`; all must hold):
- [ ] `{workspace}` is a fresh git repo (template `.git/` excluded, `git init` run, Phase 2 first commit made)
- [ ] `grep -rnE 'REPLACE[-_ ](WITH|with)' {workspace}` returns nothing (except the deliberate scaffold-groupId default)
- [ ] `grep -rn "com.example.experiment" {workspace}/src` returns nothing; package tree physically moved to `{basePackage}`
- [ ] `studio.json` has real agentId / workspaceId / targetRepos[0].path
- [ ] `experiment-config.yaml` has the real `experimentName` and the variant ladder with `iteration` fields
- [ ] Example judges replaced with domain judges; `JuryFactory` rewired; prompts externalized to `plans/prompts/` with stopping conditions
- [ ] VISION.md / DESIGN.md / ROADMAP.md filled (Phase 2 stubs finalized); `grep -rln '{{' plans/` returns nothing
- [ ] **Golden-path smoke check (Phase 6) passed end to end** — compile + (a)/(b)/(c)/(d). This is the gate; do not skip it.
- [ ] `plans/BOOTSTRAP-CHECKLIST.md` has every box checked

## Review-Agent Variant

The phases above assume the *generation*-agent shape (bud-core `ProjectScaffolder` fixtures, judges on generated-project artifacts). When the agent under evaluation **reviews a target repo and writes a report**, apply these deltas. The live review consumers (`~/projects/bud-ddd`, `~/projects/bud-spring-advisor`, and the newest, `~/projects/bud-spring-modernize`) derived all of this by hand — documented here so the next review agent does not re-derive it. **`bud-spring-modernize` is the current newest consumer** — prefer it as the copy source below.

### studio.json shape (Phase 3 delta)

Review targets are read, not written. The workspace also *ships* a KB, registered as owned:

```json
"targetRepos": [{
  "id": "<domain>-corpus",
  "role": "review-target",
  "path": "<workspace-abs-path>/corpus",
  "writePolicy": "read-mostly",
  "description": "<domain> review benchmark corpus — calibration anchor + violation-dense targets"
}],
"knowledgeStructure": {
  "ownedKnowledgeBases": [{
    "id": "<domain>-review",
    "path": "knowledge/<domain>",
    "type": "code-agent",
    "description": "the KB the agent reads at review time"
  }]
}
```

Live examples: `~/projects/bud-spring-modernize/studio.json` (newest), `~/projects/bud-ddd/studio.json`, `~/projects/bud-spring-advisor/studio.json`.

### corpus/ and knowledge/ conventions

- **`corpus/`** — clones of the review-target repos. **Git-ignored** (add `corpus/` to `.gitignore` — verify; the template may not ship this entry). Pair a **calibration anchor** (a known-clean repo, e.g. spring-petclinic) with **violation-dense** targets — the anchor catches judges that hallucinate findings on clean code.
- **`knowledge/<domain>/`** — the shipped KB (the `ownedKnowledgeBases[0].path`). This is workspace content, committed, not corpus.

### The ACP server module

Review agents ship a `<name>-acp-server/` module serving the agent over ACP into the IDE. It is **standalone — deliberately NOT an aggregator module** of the workspace pom. Build it directly:

```bash
./mvnw -f <name>-acp-server/pom.xml package
```

**Adaptation checklist** — copy the module from the **newest** consumer (currently `~/projects/bud-spring-modernize`), then sweep the identity literals (~30 occurrences; this checklist exists until AgentSpec consolidation / `bud-review-core` extraction makes it obsolete — see `~/tuvium/projects/tuvium-research-conversation-agent/plans/inbox/bud-review-core-brief.md`):

| Literal family | Example (bud-ddd) | Where it hides |
|---|---|---|
| Report filename | `ddd-review.md` | translator path heuristics, plan-step label, agent + workflow javadoc/messages |
| KB dir | `knowledge/<domain>` | translator `isKb()`, workflow KB resolution + error messages |
| Trace dir | `~/.bud-ddd/traces` | workflow trace-dir default |
| Log dir / logback | `~/.config/bud-ddd`, `bud-ddd.log` | `logback.xml` property + file names |
| Property prefix | `bud.<domain>.*` (incl. `bud.<domain>.discussion.*`) | `AgentModelFactory`, workflow resolution |
| Env prefix | `BUD_<DOMAIN>_*` | same locations + error messages |
| Plan-step labels | `ReviewProgress.Step` display strings | `ReviewProgress` |
| `@AcpAgent` | `name = "bud-<domain>"`, version, description strings | the agent class |
| Prompts | `prompts/<domain>-review-system.md`, `prompts/<domain>-discussion-system.md` | resources + classpath references |
| Package + classes | `…bud.<domain>.acp`, `<Domain>ReviewAgent` / `<Domain>ReviewWorkflow` / `<Domain>DiscussionWorkflow` / `<Domain>AgentLauncher` | whole module |

Exit grep, mirror of the Phase 3 sweep: `grep -ri '<other-domain>' <name>-acp-server/src` returns nothing.

### Judges (Phase 4 delta)

Review agents judge the **report**, not generated-project poms: T1 deterministic = report exists / required sections / citation format; T3 semantic = finding quality and recall against the violation-dense targets (with the calibration anchor as the false-positive control). `SpringBootPomJudge`-style judges on scaffolded fixtures do not apply, and the `PreConditionBuilder`/`ProjectScaffolder` machinery typically goes unused — preconditions are corpus clones instead.

### Bootstrap checklist additions

When scaffolding a review agent, append to `plans/BOOTSTRAP-CHECKLIST.md` in Phase 2:

```markdown
## Review-agent variant
- [ ] `corpus/` git-ignored; calibration anchor + violation-dense targets cloned
- [ ] `knowledge/<domain>/` present; registered in studio.json `ownedKnowledgeBases`
- [ ] ACP server module adapted from newest consumer; identity-literal sweep clean (`grep -ri` other domains)
- [ ] `./mvnw -f <name>-acp-server/pom.xml package` builds the fat jar
```

## Extraction Patterns

Same as `/forge-eval-agent` — extract baselines, judges, variants, benchmark specs, and failure-mode→gap-category mappings from the brief and source material. Bud-specific cues:

| Pattern | Extract as |
|---------|-----------|
| "the Bud server", "ACP jar", "generate via Bud" | `AcpAgentInvoker` target (acp server jar path) |
| "scaffold a project with…", "precondition fixture" | `PreConditionBuilder` / bud-core `ProjectScaffolder` precondition |
| "compare Bud vs Claude Code", "paired run" | `--paired` mode (Bud ACP vs WorkflowAgentInvoker) |
| "writes to {repo}", "platform repo" | `studio.json` `targetRepos[0].path` |

## Tone

Be precise and empirical. The cardinal rule is **copy-then-replace, never regenerate**: the template is a verified, instrumented, working project — your job is to retarget it to a domain, not to recreate it. Challenge vague success criteria; insist on a runnable stopping condition in every prompt; and never declare the workspace ready until the golden-path smoke check passes, because broken instrumentation is invisible until it has already poisoned an eval wave.

## Notes

- **Template currency**: `bud-agent-experiment-template` is current as of **agentworks BOM 1.5.0 / agent-journal 1.3.0** — the TraceWriter tool-input capture + control-character escaping fix (2026-06-03). The Phase 6 smoke check (a)/(c) exists specifically to verify that fix held: `tool_use` lines carry `"input": {...}` objects and multi-line `Write` content round-trips as valid JSONL.
- **Known template gaps**:
  - **No bundled test suite** — the template ships the working main code but not a regression test harness. The Phase 6 golden-path smoke check compensates: it is the verification gate in lieu of a packaged test suite.
  - **Reference contract**: the `TEMPLATE_CONTRACT.md` reference copy (the canonical description of the placeholder set and the workspace ⇄ template contract) lives at `~/projects/bud-eval/plans/TEMPLATE_CONTRACT.md`. Consult it if a placeholder location here looks stale against the template.
- **Versus the generic cousin**: if you find yourself authoring pom XML inline or hand-wiring the invoker/journal, you are in the wrong command — that is `/forge-eval-agent`. Here, those already exist in the copied template.
