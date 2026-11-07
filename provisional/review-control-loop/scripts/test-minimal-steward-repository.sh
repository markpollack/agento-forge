#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fixture_root=$(mktemp -d /tmp/minimal-steward-bootstrap-test.XXXXXX)
trap 'rm -rf "$fixture_root"' EXIT
seed="$fixture_root/seed"
established=2026-08-13

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

init_repo() {
  mkdir -p "$1"
  git -C "$1" init -b main >/dev/null
  git -C "$1" config user.name 'Minimal Steward Test'
  git -C "$1" config user.email 'minimal-steward@example.invalid'
}

# make_project DIR [TRIO_MEMBER...] commits README plus the named plans/ trio members and one
# non-trio planning file whenever any member is present.
make_project() {
  local dir=$1; shift
  init_repo "$dir"
  printf '# Project\n' > "$dir/README.md"
  if (($#)); then
    mkdir -p "$dir/plans/learnings"
    printf '# Committed learning\n' > "$dir/plans/learnings/one.md"
    for member in "$@"; do
      printf '# Committed %s\n' "$member" > "$dir/plans/$member"
    done
  fi
  git -C "$dir" add . && git -C "$dir" commit -m project >/dev/null
}

bootstrap() {
  local project=$1 steward=$2
  "$script_dir/bootstrap-minimal-steward-repository.sh" \
    --project-dir "$project" --project-slug example/project --project-visibility PUBLIC \
    --project-branch main --project-commit "$(git -C "$project" rev-parse HEAD)" \
    --seed-dir "$seed" --seed-slug example/seed --seed-commit "$seed_commit" \
    --seed-path work-orders/seed.md --steward-dir "$steward" \
    --steward-slug example/project-steward --established "$established"
}

complete_minimal_authority() {
  local steward=$1
  if "$script_dir/validate-steward-repository.sh" --steward-dir "$steward" \
      --require-continuity >/dev/null 2>&1; then
    fail 'minimal validation accepted unresolved authority'
  fi
  for file in plans/VISION.md plans/DESIGN.md plans/ROADMAP.md \
    plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md; do
    sed -i 's/^\[REQUIRED\].*/Fixture authority recorded./' "$steward/$file"
    sed -i 's/\*\*Status:\*\* \[REQUIRED\]/\*\*Status:\*\* ACTIVE/' "$steward/$file"
  done
  "$script_dir/validate-steward-repository.sh" --steward-dir "$steward" \
    --require-continuity >/dev/null
}

init_repo "$seed"
mkdir -p "$seed/work-orders"
printf '# Accepted work order\n' > "$seed/work-orders/seed.md"
git -C "$seed" add . && git -C "$seed" commit -m seed >/dev/null
seed_commit=$(git -C "$seed" rev-parse HEAD)

# Partial trio (one and two members): accepted, members reported, committed plans/ imported
# from the exact committed object as byte-verified evidence, minimal trio still created and
# still unresolved.
check_partial() {
  local label=$1; shift
  local project="$fixture_root/project-$label" steward="$fixture_root/steward-$label"
  local import="plans/archive/project-planning-$established"
  make_project "$project" "$@"
  local commit; commit=$(git -C "$project" rev-parse HEAD)
  # Dirty and untracked planning must not be imported.
  printf '# DIRTY working tree\n' > "$project/plans/$1"
  printf '# untracked plan\n' > "$project/plans/untracked.md"
  local output
  output=$(bootstrap "$project" "$steward") || fail "$label: partial trio refused"
  grep -q "^Committed project trio members present: $# of 3 (" <<<"$output" ||
    fail "$label: did not report $# of 3"
  for member in "$@"; do
    grep -q "plans/$member" <<<"$output" || fail "$label: did not name plans/$member"
  done
  test -d "$steward/$import" || fail "$label: no planning import directory"
  local expected actual
  expected=$(git -C "$project" ls-tree -r --name-only "$commit" plans | sed 's|^plans/||' | sort)
  actual=$(cd "$steward/$import" && find . -type f | sed 's|^\./||' | sort)
  [[ $expected == "$actual" ]] || fail "$label: imported paths differ from the committed tree"
  for member in "$@"; do
    git -C "$project" show "$commit:plans/$member" | cmp - "$steward/$import/$member" ||
      fail "$label: imported $member is not the committed blob"
  done
  test ! -e "$steward/$import/untracked.md" || fail "$label: untracked planning imported"
  for authority in VISION.md DESIGN.md ROADMAP.md; do
    grep -q '\[REQUIRED\]' "$steward/plans/$authority" ||
      fail "$label: plans/$authority is not the minimal unresolved template"
  done
  grep -q "partial committed trio ($# of 3" \
    "$steward/plans/archive/migration/STEWARD-BOOTSTRAP.md" ||
    fail "$label: provenance does not record the partial trio"
  grep -q 'PENDING OWNER RATIFICATION' \
    "$steward/plans/archive/migration/STEWARD-BOOTSTRAP.md" ||
    fail "$label: provenance does not hold derived authority for ratification"
  complete_minimal_authority "$steward"
  printf 'PASS: minimal bootstrap with partial trio (%s)\n' "$*"
}
check_partial one ROADMAP.md
check_partial two DESIGN.md ROADMAP.md

# Negative control: an import that omits a committed path must be refused, not passed.
project="$fixture_root/project-ignored"; steward="$fixture_root/steward-ignored"
make_project "$project" ROADMAP.md
printf 'learnings/one.md export-ignore\n' > "$project/plans/.gitattributes"
git -C "$project" add . && git -C "$project" commit -m export-ignore >/dev/null
if output=$(bootstrap "$project" "$steward" 2>&1); then
  fail 'import verification accepted an archive that omits a committed path'
fi
grep -q 'missing from the import: plans/learnings/one.md' <<<"$output" ||
  fail 'incomplete-import refusal did not name the path'
printf 'PASS: minimal bootstrap refuses an import that differs from the committed tree\n'

# No committed trio: the original minimal path.
project="$fixture_root/project-none"; steward="$fixture_root/steward-none"
make_project "$project"
printf '# untracked history\n' > "$project/status.md"
output=$(bootstrap "$project" "$steward")
grep -q '^Committed project trio members present: 0 of 3' <<<"$output" ||
  fail 'zero-member bootstrap did not report 0 of 3'
complete_minimal_authority "$steward"
cmp "$seed/work-orders/seed.md" "$steward/plans/archive/migration/accepted-seed-work-order.md"
test ! -e "$steward/status.md" || fail 'untracked project file leaked into steward'
test ! -e "$steward/plans/archive/project-planning-$established" ||
  fail 'zero-member bootstrap created a planning import'
grep -q 'no committed `plans/{VISION,DESIGN,ROADMAP}.md` trio' \
  "$steward/plans/archive/migration/STEWARD-BOOTSTRAP.md" ||
  fail 'zero-member provenance lost its no-trio statement'
printf 'PASS: minimal bootstrap with no committed trio\n'

# Complete trio: still refused, pointing to the import bootstrap, nothing created.
project="$fixture_root/project-full"; steward="$fixture_root/steward-full"
make_project "$project" VISION.md DESIGN.md ROADMAP.md
if output=$(bootstrap "$project" "$steward" 2>&1); then
  fail 'complete trio was accepted by the minimal scaffold'
fi
grep -q 'bootstrap-steward-repository.sh' <<<"$output" ||
  fail 'complete-trio refusal does not point to the import bootstrap'
test ! -e "$steward" || fail 'complete-trio refusal created a steward destination'
printf 'PASS: minimal bootstrap refuses a complete trio\n'

printf 'PASS: reproducible minimal steward bootstrap fixture\n'
