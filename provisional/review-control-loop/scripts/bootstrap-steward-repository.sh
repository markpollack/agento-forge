#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: bootstrap-steward-repository.sh' \
    '  --project-dir ABS --project-slug OWNER/REPO --project-branch BRANCH' \
    '  --project-commit COMMIT --steward-dir ABS --steward-slug OWNER/REPO' \
    '  --established YYYY-MM-DD [--planning-root plans]'
}

project_dir=''
project_slug=''
project_branch=''
project_commit=''
steward_dir=''
steward_slug=''
established=''
planning_root='plans'

while (($#)); do
  case "$1" in
    --project-dir) project_dir=${2-}; shift 2 ;;
    --project-slug) project_slug=${2-}; shift 2 ;;
    --project-branch) project_branch=${2-}; shift 2 ;;
    --project-commit) project_commit=${2-}; shift 2 ;;
    --steward-dir) steward_dir=${2-}; shift 2 ;;
    --steward-slug) steward_slug=${2-}; shift 2 ;;
    --established) established=${2-}; shift 2 ;;
    --planning-root) planning_root=${2-}; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

for required in project_dir project_slug project_branch project_commit steward_dir steward_slug established; do
  if [[ -z ${!required} ]]; then
    printf 'Missing required value: %s\n' "$required" >&2
    usage >&2
    exit 2
  fi
done

if [[ $project_dir != /* || $steward_dir != /* ]]; then
  printf 'Project and steward directories must be absolute paths.\n' >&2
  exit 2
fi
if [[ ! $project_slug =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ||
      ! $steward_slug =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  printf 'Repository slugs must have OWNER/REPO form.\n' >&2
  exit 2
fi
if [[ ! $project_branch =~ ^[A-Za-z0-9._/-]+$ || ! $planning_root =~ ^[A-Za-z0-9._/-]+$ ]]; then
  printf 'Branch and planning-root values contain unsupported characters.\n' >&2
  exit 2
fi
if [[ ! $established =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  printf 'Established date must have YYYY-MM-DD form.\n' >&2
  exit 2
fi

for command in git sed tar; do
  command -v "$command" >/dev/null || { printf 'Required command missing: %s\n' "$command" >&2; exit 1; }
done

project_root=$(git -C "$project_dir" rev-parse --show-toplevel)
if [[ $project_root != "$project_dir" ]]; then
  printf 'Project directory must be the repository root: %s\n' "$project_root" >&2
  exit 1
fi
project_commit=$(git -C "$project_dir" rev-parse "${project_commit}^{commit}")
imported_path_count=$(git -C "$project_dir" ls-tree -r --name-only "$project_commit" "$planning_root" | wc -l)
imported_path_count=${imported_path_count//[[:space:]]/}
excluded_status_count=$(git -C "$project_dir" status --porcelain --untracked-files=all | wc -l)
excluded_status_count=${excluded_status_count//[[:space:]]/}

for authority in VISION.md DESIGN.md ROADMAP.md; do
  if ! git -C "$project_dir" cat-file -e "$project_commit:$planning_root/$authority"; then
    printf 'Missing committed authority: %s/%s at %s\n' "$planning_root" "$authority" "$project_commit" >&2
    exit 1
  fi
done

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
project_name=${project_slug#*/}
steward_name=${steward_slug#*/}

git -C "$steward_dir" init -b main >/dev/null
git -C "$project_dir" archive "$project_commit" "$planning_root" | tar -x -C "$steward_dir"

render() {
  local source=$1
  local destination=$2
  sed \
    -e "s|{{PROJECT_NAME}}|$project_name|g" \
    -e "s|{{PROJECT_DIR}}|$project_dir|g" \
    -e "s|{{PROJECT_SLUG}}|$project_slug|g" \
    -e "s|{{PROJECT_BRANCH}}|$project_branch|g" \
    -e "s|{{PROJECT_COMMIT}}|$project_commit|g" \
    -e "s|{{STEWARD_NAME}}|$steward_name|g" \
    -e "s|{{STEWARD_DIR}}|$steward_dir|g" \
    -e "s|{{STEWARD_SLUG}}|$steward_slug|g" \
    -e "s|{{ESTABLISHED}}|$established|g" \
    -e "s|{{PLANNING_ROOT}}|$planning_root|g" \
    -e "s|{{IMPORTED_PATH_COUNT}}|$imported_path_count|g" \
    -e "s|{{EXCLUDED_STATUS_COUNT}}|$excluded_status_count|g" \
    "$source" > "$destination"
}

render "$template_dir/AGENTS.md.template" "$steward_dir/AGENTS.md"
render "$template_dir/BINDING.md.template" "$steward_dir/BINDING.md"
render "$template_dir/CLAUDE.md.template" "$steward_dir/CLAUDE.md"
render "$template_dir/README.md.template" "$steward_dir/README.md"
render "$template_dir/gitignore.template" "$steward_dir/.gitignore"

mkdir -p "$steward_dir/plans/archive/migration"
render "$template_dir/BOOTSTRAP-PROVENANCE.md.template" \
  "$steward_dir/plans/archive/migration/STEWARD-BOOTSTRAP.md"
mkdir -p "$steward_dir/plans/checkpoints"
render "$template_dir/STEWARD-MIGRATION-CONTINUITY.md.template" \
  "$steward_dir/plans/checkpoints/STEWARD-MIGRATION-CONTINUITY.md"

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

printf 'Steward scaffold created and structurally validated: %s\n' "$steward_dir"
printf 'Source project commit: %s\n' "$project_commit"
printf '%s\n' 'Next: inspect, credential-scan, complete the continuity checkpoint, validate with --require-continuity, then commit.'
