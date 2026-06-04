#!/usr/bin/env bash
# check-command-drift.sh — deterministic drift check between live global
# Claude Code commands and their versioned copies in this repo.
#
#   live:      ~/.claude/commands/*.md          (what actually runs)
#   versioned: <repo>/.claude/commands/*.md     (durable copies, git-tracked)
#
# States reported, one line per file:
#   IN_SYNC                 — live and versioned copies are identical
#   DRIFTED                 — both exist, contents differ
#   MISSING_VERSIONED_COPY  — live skill has no durable copy here
#   MISSING_LIVE_COPY       — versioned copy has no live counterpart
#
# Exit code: 0 if everything IN_SYNC, 1 otherwise — unless --advisory,
# which always exits 0 (report-only mode for wiring into other rituals).
#
# LIVE_DIR / VERSIONED_DIR are overridable via environment for testing.
#
# Provenance: 2026-06-04 KB health pass — kb-reindex.md was found 2 months
# stale in its versioned copy and ingest-status.md had no versioned copy at
# all, while those very skills police routing drift elsewhere. Same pattern,
# one layer up: a drift signal only matters if a ritual consumes it.

set -euo pipefail

LIVE_DIR="${LIVE_DIR:-$HOME/.claude/commands}"
VERSIONED_DIR="${VERSIONED_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.claude/commands}"
ADVISORY=0
[ "${1:-}" = "--advisory" ] && ADVISORY=1

if [ ! -d "$LIVE_DIR" ] || [ ! -d "$VERSIONED_DIR" ]; then
  echo "error: LIVE_DIR ($LIVE_DIR) or VERSIONED_DIR ($VERSIONED_DIR) does not exist" >&2
  exit 2
fi

issues=0

for f in "$LIVE_DIR"/*.md; do
  [ -e "$f" ] || continue
  b=$(basename "$f")
  v="$VERSIONED_DIR/$b"
  if [ ! -f "$v" ]; then
    echo "MISSING_VERSIONED_COPY $b"
    issues=$((issues + 1))
  elif ! diff -q "$f" "$v" >/dev/null 2>&1; then
    echo "DRIFTED $b"
    issues=$((issues + 1))
  else
    echo "IN_SYNC $b"
  fi
done

for v in "$VERSIONED_DIR"/*.md; do
  [ -e "$v" ] || continue
  b=$(basename "$v")
  if [ ! -f "$LIVE_DIR/$b" ]; then
    echo "MISSING_LIVE_COPY $b"
    issues=$((issues + 1))
  fi
done

echo "---"
echo "issues: $issues"

if [ "$issues" -gt 0 ] && [ "$ADVISORY" -eq 0 ]; then
  exit 1
fi
exit 0
