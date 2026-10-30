# Copy beside architecture-docs.sh; invoke from the consumer repository root.
# Reviewed shell source: replace this example's identifiers and commands before use.
PROJECT_ROOT=$PWD
OUT=$PROJECT_ROOT/docs/architecture/generated
PLANTUML_JAR=${MAVEN_REPO:-$HOME/.m2/repository}/net/sourceforge/plantuml/plantuml/1.2026.8/plantuml-1.2026.8.jar
APPMAP_AGENT_JAR=${MAVEN_REPO:-$HOME/.m2/repository}/com/appland/appmap-agent/1.30.2/appmap-agent-1.30.2.jar
SCOPE=$PROJECT_ROOT/scripts/architecture/appmap.example.yml
VIEW=$OUT/component-view.json
SETTINGS=$PROJECT_ROOT/scripts/architecture/overview.example.json
SCENARIO='Replace: one named scenario, inputs and instrumentation exclusions'
# The consumer's generator and normal-build drift gate are the same tests.
# Replace sample module/test names. Leave empty only for presentation of existing facts.
GENERATE=(./mvnw -q test -pl example-module -Dtest=ComponentViewTest -Darchitecture.regenerate=true)
# Implement this local wrapper to run exactly one test with:
# -DargLine="-javaagent:$APPMAP_AGENT_JAR -Dappmap.config.file=$SCOPE -Dappmap.output.directory=$ARCHITECTURE_RECORD_DIR"
# RECORD runs after those variables are exported, so defer expansion to that wrapper.
RECORD=(bash scripts/architecture/record-one-scenario.sh)
EXPAND=(example/app)
EXPORT_ARGS=()
OVERVIEWS=(observed-overview)
DETAILS=(observed-sequence)
