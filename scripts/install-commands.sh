#!/usr/bin/env bash
# Install forge-methodology slash commands to ~/.claude/commands/
#
# Usage: ./scripts/install-commands.sh [FORGE_PATH]
#   FORGE_PATH defaults to the directory containing this script's parent.
#
# What it does:
#   1. Copies all .md files from .claude/commands/ to ~/.claude/commands/
#   2. Replaces /path/to/forge-methodology with the actual FORGE_PATH
#   3. Reports what was installed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORGE_PATH="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"
SOURCE_DIR="$FORGE_PATH/.claude/commands"
TARGET_DIR="$HOME/.claude/commands"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory not found: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"

installed=0
for cmd in "$SOURCE_DIR"/*.md; do
  [ -f "$cmd" ] || continue
  name="$(basename "$cmd")"
  # Copy and substitute placeholder paths
  sed "s|/path/to/forge-methodology|$FORGE_PATH|g" "$cmd" > "$TARGET_DIR/$name"
  echo "  Installed: $name"
  installed=$((installed + 1))
done

echo ""
echo "Installed $installed commands to $TARGET_DIR"
echo "Forge methodology path: $FORGE_PATH"
