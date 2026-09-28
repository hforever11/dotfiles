#!/usr/bin/env bash
# Claude Code status line.
# Reads a JSON event from stdin and prints a single colored line.
# 色は home/theme.nix から home-manager が生成する palette.sh を読む (58 行目)。編集は theme.nix 側で行うこと

set -u

input=$(cat)

# Parse all input fields in a single jq call (TSV-separated).
# context_window.used_percentage is provided pre-calculated (input + cache tokens);
# it is null early in a session and right after /compact, so fall back to -1 = "no data".
IFS=$'\t' read -r model_raw cwd style lines_added lines_removed ctx_pct < <(
  jq -r '[
    .model.display_name // "?",
    .workspace.current_dir // .cwd // ".",
    .output_style.name // "",
    (.cost.total_lines_added // 0 | tostring),
    (.cost.total_lines_removed // 0 | tostring),
    ((.context_window.used_percentage // -1) | floor | tostring)
  ] | @tsv' <<< "$input"
)

# Strip "(... context)" suffix from the display name; usage is shown as a percentage instead.
model=$(printf '%s' "$model_raw" | sed -E 's/[[:space:]]*\([^)]*context[^)]*\)$//')

project=$(basename "$cwd")

# git: a single porcelain=v2 call gives branch / dirty / ahead-behind / detached SHA.
branch=""
dirty=""
ab=""
gst=$(git -C "$cwd" status --porcelain=v2 --branch 2>/dev/null || true)
if [ -n "$gst" ]; then
  branch=$(printf '%s\n' "$gst" | awk '/^# branch\.head / {print $3; exit}')
  if [ "$branch" = "(detached)" ]; then
    oid=$(printf '%s\n' "$gst" | awk '/^# branch\.oid / {print substr($3,1,7); exit}')
    [ -n "$oid" ] && branch="@${oid}"
  fi
  dirty=$(printf '%s\n' "$gst" | awk '/^[12u?]/ {print "*"; exit}')
  ab=$(printf '%s\n' "$gst" | awk '/^# branch\.ab / {
    a = $3; b = $4;
    sub(/^\+/, "", a); sub(/^-/, "", b);
    s = "";
    if (a + 0 > 0) s = s "↑" a;
    if (b + 0 > 0) s = s "↓" b;
    print s;
    exit
  }')
fi

# "#rrggbb" → ANSI truecolor 前景シーケンス (REPLY に設定)
fg_seq() {
  local h=${1#\#}
  printf -v REPLY '\033[38;2;%d;%d;%dm' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
}
# home-manager が home/theme.nix から生成する palette を読む
source "$HOME/.config/theme/palette.sh"
fg_seq "$THEME_MAUVE"    && c_mauve=$REPLY
fg_seq "$THEME_BLUE"     && c_blue=$REPLY
fg_seq "$THEME_GREEN"    && c_green=$REPLY
fg_seq "$THEME_YELLOW"   && c_yellow=$REPLY
fg_seq "$THEME_RED"      && c_red=$REPLY
fg_seq "$THEME_OVERLAY0" && c_overlay=$REPLY
reset=$'\033[0m'

sep="${c_overlay} │ ${reset}"

out="${c_mauve}${model}${reset}"

# Used context percentage (omitted when unavailable: -1 early in session or after /compact).
if [[ "${ctx_pct}" =~ ^[0-9]+$ ]] && [ "${ctx_pct}" -gt 0 ]; then
  if [ "${ctx_pct}" -lt 50 ]; then
    ctx_color="${c_green}"
  elif [ "${ctx_pct}" -lt 80 ]; then
    ctx_color="${c_yellow}"
  else
    ctx_color="${c_red}"
  fi
  out+="${sep}${ctx_color}◐ ${ctx_pct}%${reset}"
fi

out+="${sep}${c_blue}${project}${reset}"

if [ -n "${branch}" ]; then
  branch_color="${c_green}"
  [ -n "${dirty}" ] && branch_color="${c_yellow}"
  indicators="${dirty}${ab}"
  if [ -n "${indicators}" ]; then
    out+="${sep}${branch_color}⎇ ${branch} ${indicators}${reset}"
  else
    out+="${sep}${branch_color}⎇ ${branch}${reset}"
  fi
fi

if [ "${lines_added}" != "0" ] || [ "${lines_removed}" != "0" ]; then
  out+="${sep}${c_green}+${lines_added}${reset} ${c_red}-${lines_removed}${reset}"
fi

if [ -n "${style}" ] && [ "${style}" != "default" ]; then
  out+="${sep}${c_overlay}${style}${reset}"
fi

printf '%s' "${out}"
