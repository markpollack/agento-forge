#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: bootstrap-minimal-steward-repository.sh' \
    '  --project-dir ABS --project-slug OWNER/REPO --project-visibility PUBLIC|PRIVATE' \
    '  --project-branch BRANCH --project-commit COMMIT' \
    '  --seed-dir ABS --seed-slug OWNER/REPO --seed-commit COMMIT --seed-path PATH' \
    '  --steward-dir ABS --steward-slug OWNER/REPO --established YYYY-MM-DD'
}

project_dir=''; project_slug=''; project_visibility=''; project_branch=''; project_commit=''
seed_dir=''; seed_slug=''; seed_commit=''; seed_path=''
steward_dir=''; steward_slug=''; established=''

while (($#)); do
  case "$1" in
    --project-dir) project_dir=${2-}; shift 2 ;;
    --project-slug) project_slug=${2-}; shift 2 ;;
    --project-visibility) project_visibility=${2-}; shift 2 ;;
    --project-branch) project_branch=${2-}; shift 2 ;;
    --project-commit) project_commit=${2-}; shift 2 ;;
    --seed-dir) seed_dir=${2-}; shift 2 ;;
    --seed-slug) seed_slug=${2-}; shift 2 ;;
    --seed-commit) seed_commit=${2-}; shift 2 ;;
    --seed-path) seed_path=${2-}; shift 2 ;;
    --steward-dir) steward_dir=${2-}; shift 2 ;;
    --steward-slug) steward_slug=${2-}; shift 2 ;;
    --established) established=${2-}; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

for required in project_dir project_slug project_visibility project_branch project_commit \
  seed_dir seed_slug seed_commit seed_path steward_dir steward_slug established; do
  if [[ -z ${!required} ]]; then
    printf 'Missing required value: %s\n' "$required" >&2
    usage >&2
    exit 2
  fi
done

if [[ $project_dir != /* || $seed_dir != /* || $steward_dir != /* ]]; then
  printf 'Project, seed, and steward directories must be absolute paths.\n' >&2
  exit 2
fi
if [[ $project_visibility != PUBLIC && $project_visibility != PRIVATE ]]; then
  printf 'Project visibility must be PUBLIC or PRIVATE.\n' >&2
  exit 2
fi
for slug in "$project_slug" "$seed_slug" "$steward_slug"; do
  if [[ ! $slug =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
    printf 'Repository slugs must have OWNER/REPO form: %s\n' "$slug" >&2
    exit 2
  fi
done
if [[ ! $project_branch =~ ^[A-Za-z0-9._/-]+$ ||
      ! $seed_path =~ ^[A-Za-z0-9._/-]+$ ||
      ! $established =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  printf 'Branch, seed path, or established date has unsupported form.\n' >&2
  exit 2
fi

for command in awk git sed sha256sum; do
  command -v "$command" >/dev/null || { printf 'Required command missing: %s\n' "$command" >&2; exit 1; }
done

project_root=$(git -C "$project_dir" rev-parse --show-toplevel)
seed_root=$(git -C "$seed_dir" rev-parse --show-toplevel)
if [[ $project_root != "$project_dir" || $seed_root != "$seed_dir" ]]; then
  printf 'Project and seed directories must be repository roots.\n' >&2
  exit 1
fi
project_commit=$(git -C "$project_dir" rev-parse "${project_commit}^{commit}")
seed_commit=$(git -C "$seed_dir" rev-parse "${seed_commit}^{commit}")
git -C "$seed_dir" cat-file -e "$seed_commit:$seed_path"

trio_count=0
for authority in VISION.md DESIGN.md ROADMAP.md; do
  if git -C "$project_dir" cat-file -e "$project_commit:plans/$authority" 2>/dev/null; then
    trio_count=$((trio_count + 1))
  fi
done
if ((trio_count != 0)); then
  printf 'Project contains %d committed active-trio paths; use the import bootstrap or stop.\n' \
    "$trio_count" >&2
  exit 1
fi

if [[ -e $steward_dir ]]; then
  if [[ ! -d $steward_dir || -n $(find "$steward_dir" -mindepth 1 -maxdepth 1 -print -quit) ]]; then
    printf 'Steward destination exists and is not empty: %s\n' "$steward_dir" >&2
    exit 1
  fi
else
  mkdir -p "$steward_dir"
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
template_dir="$script_dir/../templates/steward-repository"
bootstrap_script_sha256=$(sha256sum "$script_dir/bootstrap-minimal-steward-repository.sh" | awk '{print $1}')
excluded_status_count=$(git -C "$project_dir" status --porcelain --untracked-files=all | wc -l)
excluded_status_count=${excluded_status_count//[[:space:]]/}
project_name=${project_slug#*/}; steward_name=${steward_slug#*/}

git -C "$steward_dir" init -b main >/dev/null

render() {
  local source=$1 destination=$2
  sed \
    -e "s|{{PROJECT_NAME}}|$project_name|g" \
    -e "s|{{PROJECT_DIR}}|$project_dir|g" \
    -e "s|{{PROJECT_SLUG}}|$project_slug|g" \
    -e "s|{{PROJECT_VISIBILITY}}|$project_visibility|g" \
    -e "s|{{PROJECT_BRANCH}}|$project_branch|g" \
    -e "s|{{PROJECT_COMMIT}}|$project_commit|g" \
    -e "s|{{STEWARD_NAME}}|$steward_name|g" \
    -e "s|{{STEWARD_DIR}}|$steward_dir|g" \
    -e "s|{{STEWARD_SLUG}}|$steward_slug|g" \
    -e "s|{{ESTABLISHED}}|$established|g" \
    -e "s|{{SEED_SLUG}}|$seed_slug|g" \
    -e "s|{{SEED_COMMIT}}|$seed_commit|g" \
    -e "s|{{SEED_PATH}}|$seed_path|g" \
    -e "s|{{EXCLUDED_STATUS_COUNT}}|$excluded_status_count|g" \
    -e "s|{{BOOTSTRAP_SCRIPT_SHA256}}|$bootstrap_script_sha256|g" \
    "$source" > "$destination"
}

render "$template_dir/AGENTS.md.template" "$steward_dir/AGENTS.md"
render "$template_dir/BINDING-MINIMAL.md.template" "$steward_dir/BINDING.md"
render "$template_dir/CLAUDE.md.template" "$steward_dir/CLAUDE.md"
render "$template_dir/README.md.template" "$steward_dir/README.md"
render "$template_dir/gitignore.template" "$steward_dir/.gitignore"

mkdir -p "$steward_dir/plans/archive/migration" "$steward_dir/plans/checkpoints"
render "$template_dir/MINIMAL-VISION.md.template" "$steward_dir/plans/VISION.md"
render "$template_dir/MINIMAL-DESIGN.md.template" "$steward_dir/plans/DESIGN.md"
render "$template_dir/MINIMAL-ROADMAP.md.template" "$steward_dir/plans/ROADMAP.md"
render "$template_dir/MINIMAL-AUTHORITY-BOOTSTRAP.md.template" \
  "$steward_dir/plans/archive/migration/STEWARD-BOOTSTRAP.md"
render "$template_dir/MINIMAL-CONTINUITY.md.template" \
  "$steward_dir/plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md"
git -C "$seed_dir" show "$seed_commit:$seed_path" \
  > "$steward_dir/plans/archive/migration/accepted-seed-work-order.md"

for instruction in AGENTS.md CLAUDE.md; do
  if git -C "$project_dir" cat-file -e "$project_commit:$instruction" 2>/dev/null; then
    git -C "$project_dir" show "$project_commit:$instruction" \
      > "$steward_dir/plans/archive/migration/project-$instruction"
  fi
done
for state in new cur archive dead; do
  for type in steward-follow-up steward-receipt; do
    mkdir -p "$steward_dir/plans/inbox/$state/$type"
    : > "$steward_dir/plans/inbox/$state/$type/.gitkeep"
  done
done
mkdir -p "$steward_dir/plans/audit"
: > "$steward_dir/plans/audit/events.jsonl"

"$script_dir/validate-steward-repository.sh" --steward-dir "$steward_dir"
printf 'Minimal steward scaffold created: %s\n' "$steward_dir"
printf '%s\n' 'Next: complete the minimal trio and continuity checkpoint, preserve explicit evidence, then validate with --require-continuity.'
