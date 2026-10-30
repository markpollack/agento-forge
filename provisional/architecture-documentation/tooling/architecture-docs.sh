#!/usr/bin/env bash
# Run from the consumer root: bash scripts/architecture/architecture-docs.sh CONFIG [--appmap]
# CONFIG is reviewed Bash source (arrays, not evaluated command strings). No Word export.
set -euo pipefail
[[ $# == 1 || ( $# == 2 && $2 == --appmap ) ]] || {
  echo 'usage: architecture-docs.sh CONFIG [--appmap]' >&2; exit 2;
}
TOOLS=$(cd "$(dirname "$0")" && pwd)
CONFIG=$(realpath "$1")
PLANTUML_VERSION=1.2026.8
APPMAP_AGENT_VERSION=1.30.2
APPMAP_CLI_VERSION=3.204.0
PUMLLINT_VERSION=0.33.0
GENERATE=() RECORD=() EXPAND=() EXPORT_ARGS=() OVERVIEWS=() DETAILS=()
source "$CONFIG"
: "${PROJECT_ROOT:?}" "${OUT:?}" "${PLANTUML_JAR:?}"
cd "$PROJECT_ROOT"
[[ -f $PLANTUML_JAR ]] || { echo 'Resolve the pinned PlantUML jar in CONFIG first' >&2; exit 1; }
# PlantUML reports a nonzero version-query status when optional Graphviz is absent.
VERSION=$(java -Djava.awt.headless=true -jar "$PLANTUML_JAR" -version 2>&1) || true
[[ $VERSION == *"PlantUML version $PLANTUML_VERSION "* ]] || { echo 'PlantUML version mismatch' >&2; exit 1; }
mkdir -p "$OUT"
if (( ${#GENERATE[@]} )); then "${GENERATE[@]}"; fi
if [[ ${2:-} == --appmap ]]; then
  : "${APPMAP_AGENT_JAR:?}" "${SCOPE:?}" "${VIEW:?}" "${SETTINGS:?}" "${SCENARIO:?}"
  [[ $APPMAP_AGENT_JAR == *"appmap-agent-$APPMAP_AGENT_VERSION.jar" && -f $APPMAP_AGENT_JAR ]] || {
    echo 'Resolve the pinned AppMap agent jar in CONFIG first' >&2; exit 1;
  }
  (( ${#RECORD[@]} )) || { echo 'Set RECORD to one scoped scenario command' >&2; exit 1; }
  # A new directory prevents stale or arbitrarily chosen recordings from another scenario.
  mkdir -p target/architecture
  ARCHITECTURE_RECORD_DIR=$(mktemp -d "$PWD/target/architecture/recording.XXXXXX")
  export ARCHITECTURE_RECORD_DIR APPMAP_AGENT_JAR SCOPE
  "${RECORD[@]}"
  mapfile -d '' RECORDINGS < <(find "$ARCHITECTURE_RECORD_DIR" -name '*.appmap.json' -print0)
  [[ ${#RECORDINGS[@]} == 1 ]] || { echo 'Expected exactly one recording for one scenario' >&2; exit 1; }
  for package in "${EXPAND[@]}"; do EXPORT_ARGS+=(--expand "package:$package"); done
  # Exporter can make HTTP theme references; normalization removes them before rendering.
  npx -y "@appland/appmap@$APPMAP_CLI_VERSION" sequence-diagram --format plantuml \
    --output-dir "$ARCHITECTURE_RECORD_DIR/sequence" "${EXPORT_ARGS[@]}" "${RECORDINGS[0]}"
  mapfile -d '' EXPORTS < <(find "$ARCHITECTURE_RECORD_DIR/sequence" -name '*.sequence.uml' -print0)
  [[ ${#EXPORTS[@]} == 1 ]] || { echo 'Expected exactly one sequence export' >&2; exit 1; }
  python3 "$TOOLS/recording-artifacts.py" "${RECORDINGS[0]}" "$SCOPE" "${EXPORTS[0]}" "$OUT" \
    "$SCENARIO" "$APPMAP_AGENT_VERSION" "$APPMAP_CLI_VERSION"
  python3 "$TOOLS/sequence-overview.py" "${RECORDINGS[0]}" "$VIEW" "$OUT/observed-overview.puml" "$SETTINGS"
fi
shopt -s nullglob
DIAGRAMS=("$OUT"/*.puml)
(( ${#DIAGRAMS[@]} )) || { echo 'No PlantUML sources generated' >&2; exit 1; }
# Component diagrams get syntax checks only: pumllint treats them as sequences.
java -Djava.awt.headless=true -jar "$PLANTUML_JAR" -checkonly "${DIAGRAMS[@]}"
for name in "${OVERVIEWS[@]}"; do
  uvx -q --from "pumllint==$PUMLLINT_VERSION" pumllint -c "$TOOLS/pumllint-overview.toml" \
    --fail-on minor "$OUT/$name.puml"
done
for name in "${DETAILS[@]}"; do
  uvx -q --from "pumllint==$PUMLLINT_VERSION" pumllint -c "$TOOLS/pumllint-detail.toml" \
    --fail-on minor "$OUT/$name.puml"
done
java -Djava.awt.headless=true -jar "$PLANTUML_JAR" -tsvg "${DIAGRAMS[@]}"
echo "Rendered diagrams in $OUT; inspect at reading size. Normal builds must check generated-fact drift."
