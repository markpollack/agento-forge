#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fixture_root=$(mktemp -d /tmp/steward-bootstrap-test.XXXXXX)
trap 'rm -rf "$fixture_root"' EXIT

project_dir="$fixture_root/project"
steward_dir="$fixture_root/project-steward"
mkdir -p "$project_dir/plans/inbox/review"
git -C "$project_dir" init -b main >/dev/null
git -C "$project_dir" config user.name 'Steward Bootstrap Test'
git -C "$project_dir" config user.email 'steward-bootstrap@example.invalid'

printf '# Vision\ncommitted vision\n' > "$project_dir/plans/VISION.md"
printf '# Design\ncommitted design\n' > "$project_dir/plans/DESIGN.md"
printf '# Roadmap\ncommitted roadmap\n' > "$project_dir/plans/ROADMAP.md"
printf '# Existing review intake\n' > "$project_dir/plans/inbox/review/review-1.md"
printf '# Project instructions\n' > "$project_dir/AGENTS.md"
git -C "$project_dir" add .
git -C "$project_dir" commit -m 'Create project fixture' >/dev/null
project_commit=$(git -C "$project_dir" rev-parse HEAD)

printf '# Vision\ndirty vision must not cross boundary\n' > "$project_dir/plans/VISION.md"
printf '# Untracked status must not cross boundary\n' > "$project_dir/plans/status-local.md"

"$script_dir/bootstrap-steward-repository.sh" \
  --project-dir "$project_dir" \
  --project-slug example/project \
  --project-branch main \
  --project-commit "$project_commit" \
  --steward-dir "$steward_dir" \
  --steward-slug example/project-steward \
  --established 2026-08-13 >/dev/null

"$script_dir/validate-steward-repository.sh" --steward-dir "$steward_dir" >/dev/null

grep -q 'committed vision' "$steward_dir/plans/VISION.md"
if grep -q 'dirty vision' "$steward_dir/plans/VISION.md"; then
  printf 'Dirty planning crossed the steward boundary.\n' >&2
  exit 1
fi
if [[ -e $steward_dir/plans/status-local.md ]]; then
  printf 'Untracked planning crossed the steward boundary.\n' >&2
  exit 1
fi
if [[ ! -f $steward_dir/plans/inbox/review/review-1.md ]]; then
  printf 'Existing ordinary Forge intake was not preserved.\n' >&2
  exit 1
fi
if [[ -s $steward_dir/plans/audit/events.jsonl ]]; then
  printf 'Bootstrap audit log must start empty.\n' >&2
  exit 1
fi
if [[ ! -f $steward_dir/plans/archive/migration/project-AGENTS.md ]]; then
  printf 'Committed project instructions were not preserved as migration evidence.\n' >&2
  exit 1
fi
if "$script_dir/validate-steward-repository.sh" \
    --steward-dir "$steward_dir" --require-continuity >/dev/null 2>&1; then
  printf 'Continuity validation accepted unresolved migration state.\n' >&2
  exit 1
fi
sed -i 's/^\[REQUIRED\].*/Recorded fixture continuity./' \
  "$steward_dir/plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md"
"$script_dir/validate-steward-repository.sh" \
  --steward-dir "$steward_dir" --require-continuity >/dev/null
grep -q '^> \*\*Imported committed paths:\*\* 4$' \
  "$steward_dir/plans/archive/migration/STEWARD-BOOTSTRAP.md"
grep -q '^> \*\*Excluded dirty/untracked status entries at bootstrap:\*\* 2$' \
  "$steward_dir/plans/archive/migration/STEWARD-BOOTSTRAP.md"

if "$script_dir/bootstrap-steward-repository.sh" \
    --project-dir "$project_dir" \
    --project-slug example/project \
    --project-branch main \
    --project-commit "$project_commit" \
    --steward-dir "$steward_dir" \
    --steward-slug example/project-steward \
    --established 2026-08-13 >/dev/null 2>&1; then
  printf 'Bootstrap did not refuse a non-empty destination.\n' >&2
  exit 1
fi

printf 'PASS: reproducible steward bootstrap fixture\n'
