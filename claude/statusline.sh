#!/usr/bin/env bash
# Claude Code の statusline。stdin の JSON を読んで色付きの 1 行を出す
# 色は ANSI 16 色で指定する。実際の色は Ghostty のパレット (home/theme.nix) が決める (starship と同じ)

set -u

# モデル名の "(1M context)" などは剥がす (使用量は % で出すため)。
# プロジェクト名は起動したディレクトリ (project_dir) から取る。Claude が cd しても変わらない。
# context_window.used_percentage は session 初期と /compact 直後に null になるので -1 (表示しない) にする
IFS=$'\t' read -r model cwd project ctx added removed < <(
  jq -r '[
    (.model.display_name // "?" | sub("\\s*\\([^)]*context[^)]*\\)$"; "")),
    .workspace.current_dir // .cwd // ".",
    .workspace.project_dir // .workspace.current_dir // .cwd // ".",
    (.context_window.used_percentage // -1 | floor),
    .cost.total_lines_added // 0,
    .cost.total_lines_removed // 0
  ] | @tsv'
)

# git はブランチ名だけ出す (変更状態は starship と同じく出さない)。今いる場所のブランチで、detached HEAD のときは SHA
branch=$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

magenta=$'\033[35m' blue=$'\033[34m' green=$'\033[32m' yellow=$'\033[33m' red=$'\033[31m' gray=$'\033[90m'
reset=$'\033[0m'
sep="$gray │ $reset"

out="$magenta$model$reset"

if ((ctx > 0)); then
  if ((ctx < 50)); then c=$green; elif ((ctx < 80)); then c=$yellow; else c=$red; fi
  out+="$sep${c}◐ $ctx%$reset"
fi

out+="$sep$blue${project##*/}$reset"

if [ -n "$branch" ]; then
  out+="$sep${green}⎇ $branch$reset"
fi

if ((added || removed)); then
  out+="$sep$green+$added$reset $red-$removed$reset"
fi

printf '%s' "$out"
