#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fixture_root=$(mktemp -d /tmp/minimal-steward-bootstrap-test.XXXXXX)
trap 'rm -rf "$fixture_root"' EXIT
project="$fixture_root/project"; seed="$fixture_root/seed"; steward="$fixture_root/steward"

for repo in "$project" "$seed"; do
  mkdir -p "$repo"
  git -C "$repo" init -b main >/dev/null
  git -C "$repo" config user.name 'Minimal Steward Test'
  git -C "$repo" config user.email 'minimal-steward@example.invalid'
done
printf '# Project\n' > "$project/README.md"
git -C "$project" add . && git -C "$project" commit -m project >/dev/null
project_commit=$(git -C "$project" rev-parse HEAD)
mkdir -p "$seed/work-orders"
printf '# Accepted work order\n' > "$seed/work-orders/seed.md"
git -C "$seed" add . && git -C "$seed" commit -m seed >/dev/null
seed_commit=$(git -C "$seed" rev-parse HEAD)
printf '# untracked history\n' > "$project/status.md"

"$script_dir/bootstrap-minimal-steward-repository.sh" \
  --project-dir "$project" --project-slug example/project --project-visibility PUBLIC \
  --project-branch main --project-commit "$project_commit" \
  --seed-dir "$seed" --seed-slug example/seed --seed-commit "$seed_commit" \
  --seed-path work-orders/seed.md --steward-dir "$steward" \
  --steward-slug example/project-steward --established 2026-08-13 >/dev/null

if "$script_dir/validate-steward-repository.sh" --steward-dir "$steward" \
    --require-continuity >/dev/null 2>&1; then
  printf 'Minimal validation accepted unresolved authority.\n' >&2
  exit 1
fi
for file in plans/VISION.md plans/DESIGN.md plans/ROADMAP.md \
  plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md; do
  sed -i 's/^\[REQUIRED\].*/Fixture authority recorded./' "$steward/$file"
  sed -i 's/\*\*Status:\*\* \[REQUIRED\]/\*\*Status:\*\* ACTIVE/' "$steward/$file"
done
"$script_dir/validate-steward-repository.sh" --steward-dir "$steward" \
  --require-continuity >/dev/null
cmp "$seed/work-orders/seed.md" "$steward/plans/archive/migration/accepted-seed-work-order.md"
test ! -e "$steward/status.md"
printf 'PASS: reproducible minimal steward bootstrap fixture\n'
