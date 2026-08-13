#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' 'Usage: validate-steward-repository.sh --steward-dir ABS [--require-continuity] [--require-private-remote OWNER/REPO]'
}

steward_dir=''
private_remote=''
require_continuity=false
while (($#)); do
  case "$1" in
    --steward-dir) steward_dir=${2-}; shift 2 ;;
    --require-continuity) require_continuity=true; shift ;;
    --require-private-remote) private_remote=${2-}; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z $steward_dir || $steward_dir != /* ]]; then
  printf 'An absolute --steward-dir is required.\n' >&2
  exit 2
fi

git -C "$steward_dir" rev-parse --show-toplevel >/dev/null

required_files=(
  AGENTS.md
  BINDING.md
  CLAUDE.md
  README.md
  plans/VISION.md
  plans/DESIGN.md
  plans/ROADMAP.md
  plans/audit/events.jsonl
  plans/archive/migration/STEWARD-BOOTSTRAP.md
  plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md
)
for path in "${required_files[@]}"; do
  if [[ ! -f $steward_dir/$path ]]; then
    printf 'Missing required steward file: %s\n' "$path" >&2
    exit 1
  fi
done

for state in new cur archive dead; do
  for type in steward-follow-up steward-receipt; do
    path="plans/inbox/$state/$type/.gitkeep"
    if [[ ! -f $steward_dir/$path ]]; then
      printf 'Missing required gitmaildir path: %s\n' "$path" >&2
      exit 1
    fi
  done
done

if git -C "$steward_dir" check-ignore -q plans/VISION.md; then
  printf 'Private steward planning is ignored: plans/VISION.md\n' >&2
  exit 1
fi
if ! grep -q 'Visibility.*PRIVATE' "$steward_dir/BINDING.md"; then
  printf 'BINDING.md does not declare PRIVATE visibility.\n' >&2
  exit 1
fi
if ! grep -q 'pairing is 1:1' "$steward_dir/BINDING.md"; then
  printf 'BINDING.md does not declare the 1:1 pairing.\n' >&2
  exit 1
fi
if ! grep -q 'plans/inbox/{new,cur,archive,dead}' "$steward_dir/BINDING.md"; then
  printf 'BINDING.md does not bind the gitmaildir lifecycle.\n' >&2
  exit 1
fi
if ! grep -q 'inbox preflight' "$steward_dir/AGENTS.md"; then
  printf 'AGENTS.md does not require planning/controller inbox preflight.\n' >&2
  exit 1
fi

if [[ $require_continuity == true ]]; then
  continuity="$steward_dir/plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md"
  if grep -q '^\[REQUIRED\]' "$continuity"; then
    printf 'Steward migration continuity is unresolved: %s\n' "$continuity" >&2
    exit 1
  fi
  for heading in \
    'Last accepted or completed work' \
    'Current frontier' \
    'Filed but not authorized' \
    'Owner and release holds' \
    'Planning path disposition'; do
    if ! grep -q "^## $heading$" "$continuity"; then
      printf 'Continuity checkpoint is missing section: %s\n' "$heading" >&2
      exit 1
    fi
  done
  if grep -q '^# Minimal Authority Bootstrap Provenance$' \
      "$steward_dir/plans/archive/migration/STEWARD-BOOTSTRAP.md"; then
    for authority in plans/VISION.md plans/DESIGN.md plans/ROADMAP.md; do
      if grep -q '\[REQUIRED\]' "$steward_dir/$authority"; then
        printf 'Minimal steward authority is unresolved: %s\n' "$authority" >&2
        exit 1
      fi
    done
  fi
fi

if [[ -n $private_remote ]]; then
  command -v gh >/dev/null || { printf 'gh is required for remote privacy validation.\n' >&2; exit 1; }
  visibility=$(gh repo view "$private_remote" --json visibility --jq .visibility)
  if [[ $visibility != PRIVATE ]]; then
    printf 'Steward remote is not PRIVATE: %s (%s)\n' "$private_remote" "$visibility" >&2
    exit 1
  fi
fi

printf 'PASS: steward repository structure and gitmaildir binding are valid: %s\n' "$steward_dir"
if [[ -n $private_remote ]]; then
  printf 'PASS: remote visibility is PRIVATE: %s\n' "$private_remote"
fi
