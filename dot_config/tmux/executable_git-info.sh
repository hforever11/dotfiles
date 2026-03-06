#!/usr/bin/env bash
cd "$1" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# リポジトリ名 (user/repo)
remote=$(git remote get-url origin 2>/dev/null)
if [ -n "$remote" ]; then
  slug=$(echo "$remote" | sed -E 's#\.git$##' | sed -E 's#.*[:/]([^/]+/[^/]+)$#\1#')
  printf " %s" "$slug"
fi

# セパレータ
printf " %s " "$2"

# ブランチ名
branch=$(git branch --show-current 2>/dev/null)
[ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2>/dev/null)
printf " %s" "$branch"
