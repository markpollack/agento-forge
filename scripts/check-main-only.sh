#!/usr/bin/env bash
# Print MAIN-ONLY when the repository (default: current directory) has one worktree, no branch
# other than main/origin/main, and no stash; otherwise list what remains and exit 1.
set -euo pipefail
repo=${1:-.}
git -C "$repo" fetch --prune -q origin
extra=$(git -C "$repo" for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin |
  grep -vxE 'main|origin/main|origin/HEAD|origin' || true)
if [ "$(git -C "$repo" worktree list | wc -l)" -eq 1 ] && [ -z "$extra" ] &&
   [ -z "$(git -C "$repo" stash list)" ]; then
  echo MAIN-ONLY
else
  echo "NOT main-only:"; git -C "$repo" worktree list; echo "$extra"; git -C "$repo" stash list
  exit 1
fi
