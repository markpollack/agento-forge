#!/usr/bin/env bash
# Does /ingest-status know about every theme the KB actually has?
#
# The command maps a status report onto a fixed list of themes. When the KB grows a theme the
# command does not know about, content belonging to it lands NOWHERE -- silently, every run. That
# is worse than a command that fails, because a failure announces itself.
#
# This is the announcement. Run it against any KB that /ingest-status writes into.
#
#   scripts/check-ingest-status-themes.sh <kb-dir> [command-file]
#
# Exit 0 = the command covers every theme in the KB. Exit 1 = something would go nowhere.
set -uo pipefail

kb="${1:?usage: check-ingest-status-themes.sh <kb-dir> [command-file]}"
cmd="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.claude/commands/ingest-status.md}"

[[ -d "$kb/synthesis/phase2" ]] || { echo "not a KB: $kb/synthesis/phase2 missing" >&2; exit 2; }
[[ -f "$cmd" ]] || { echo "command file not found: $cmd" >&2; exit 2; }

# Themes the KB actually has, from the theme documents themselves.
mapfile -t kb_themes < <(
  find "$kb/synthesis/phase2" -maxdepth 1 -name 'theme-*.md' -printf '%f\n' \
    | sed -E 's/^theme-([0-9]+)[a-z]?-.*/\1/' | sort -n -u
)

# Themes the command can route to, from its mapping table rows: "| 8. Name | keywords |"
mapfile -t cmd_themes < <(
  grep -oE '^\| *[0-9]+\. ' "$cmd" | grep -oE '[0-9]+' | sort -n -u
)

echo "KB has themes    : ${kb_themes[*]:-none}"
echo "command routes to: ${cmd_themes[*]:-none}"

missing=()
for t in "${kb_themes[@]}"; do
  found=0
  for c in "${cmd_themes[@]}"; do [[ "$t" == "$c" ]] && found=1 && break; done
  [[ $found -eq 0 ]] && missing+=("$t")
done

if ((${#missing[@]})); then
  echo
  echo "DROP RISK: the KB has theme(s) ${missing[*]} that /ingest-status cannot route to."
  for t in "${missing[@]}"; do
    doc=$(find "$kb/synthesis/phase2" -maxdepth 1 -name "theme-$t-*.md" -printf '%f\n' | head -1)
    echo "  theme $t -> $doc : content belonging here lands NOWHERE, silently, on every run."
  done
  echo
  echo "Add the theme to the mapping table in $cmd, with keywords."
  exit 1
fi

echo
echo "OK: every theme in the KB is routable. Nothing goes nowhere."
