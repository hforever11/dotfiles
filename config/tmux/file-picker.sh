#!/usr/bin/env bash
# tmux ファイルピッカー: popup 内で fzf を起動し、選択を呼び出し元ペインへ書き戻す。
# popup 内の display-message は起動元の active pane を指す。引数では渡さない
# (display-popup の shell-command は format 展開されず #{...} が sh のコメントになるため)。
# C-s で Files(fd) ⇄ Grep(rg) を切替。AI CLI ペインへは @path で送る。
set -euo pipefail

pane_id=$(tmux display-message -p '#{pane_id}')
pane_tty=$(tmux display-message -p '#{pane_tty}')
# fd/rg を起動元ペインの cwd で走らせる (-d 展開に依存しない保険)
cd "$(tmux display-message -p '#{pane_current_path}')" 2>/dev/null || true

# 書き戻し時に @path を付ける対象プロセス (comm 一致)。pane-runs.sh を再利用。
# claude はネイティブバイナリで comm=claude (既存 tui_no_scrollback='claude' と同じ前提)
ai_pat='claude|codex|gemini'
pane_runs="$HOME/.config/tmux/pane-runs.sh"

fd_cmd='fd --hidden --follow --type f --type d --exclude .git --exclude .DS_Store --color=always'
rg_cmd='rg --column --line-number --no-heading --color=always --smart-case'

# プレビュー: Grep 中は path:line を bat でハイライト、それ以外は dir=tree / file=bat
preview='
if [[ $FZF_PROMPT == Grep* ]]; then
  bat --style=numbers --color=always --highlight-line {2} -- {1} 2>/dev/null | head -500
elif [[ -d {1} ]]; then
  tree -C {1} 2>/dev/null | head -200
else
  bat --style=numbers --color=always -- {1} 2>/dev/null
fi'

# C-s: Files ⇄ Grep トグル。$FZF_PROMPT で現在モードを判定 (fzf 0.50+)
toggle='
if [[ $FZF_PROMPT == Files* ]]; then
  echo "rebind(change)+change-prompt(Grep> )+disable-search+change-preview-window(right,60%,+{2}+3/3)+reload('"$rg_cmd"' -- {q} || true)"
else
  echo "unbind(change)+change-prompt(Files> )+enable-search+change-preview-window(right,60%)+reload('"$fd_cmd"')"
fi'

selection=$(
  FZF_DEFAULT_COMMAND="$fd_cmd" \
  fzf --ansi --multi --height=100% --layout=reverse --border=none \
      --delimiter : --prompt 'Files> ' \
      --header 'C-s: Files⇄Grep / Tab: 複数選択 / Enter: 確定' \
      --preview "$preview" --preview-window 'right,60%,border-left' \
      --bind 'start:unbind(change)' \
      --bind "change:reload($rg_cmd -- {q} || true)" \
      --bind "ctrl-s:transform:$toggle" \
  || true
)

[[ -z "$selection" ]] && exit 0

# AI ペインなら @path、それ以外は %q エスケープ。Grep 行 (path:line:col:text) は path だけ抽出
ai_mode=false
if "$pane_runs" "$pane_tty" "$ai_pat"; then ai_mode=true; fi

out=""
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if [[ "$line" =~ ^(.+):[0-9]+:[0-9]+:.*$ ]]; then
    path="${BASH_REMATCH[1]}"
  else
    path="$line"
  fi
  if $ai_mode; then
    out+="@$path "
  else
    printf -v esc '%q' "$path"
    out+="$esc "
  fi
done <<<"$selection"

[[ -z "$out" ]] && exit 0
# Enter は送らない (ユーザーが内容を確認してから送信)
tmux send-keys -t "$pane_id" -l -- "$out"
