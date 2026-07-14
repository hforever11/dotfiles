# ~/.config/zsh/.zshrc

# ===== Basic settings =====
umask 022
limit coredumpsize 0
bindkey -d
bindkey -e

# ===== PATH =====
typeset -U path
path=(
  /opt/homebrew/opt/libpq/bin(N-/)
  $HOME/.local/bin(N-/)
  $path
)

# ===== History =====
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p -- "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS HIST_VERIFY HIST_FIND_NO_DUPS

# ===== Plugin Manager =====
command -v sheldon >/dev/null && eval "$(sheldon source)"

# ===== Completions =====
# nix の kubectl は補完ファイルを同梱しないので生成してキャッシュ
{
  local comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
  [[ -d $comp_cache ]] || mkdir -p -- "$comp_cache"
  fpath=("$comp_cache" $fpath)
  if command -v kubectl >/dev/null && [[ ! -f $comp_cache/_kubectl ]]; then
    kubectl completion zsh > "$comp_cache/_kubectl"
  fi
}

# 日次でフル compinit、それ以外はキャッシュを信頼（-u は使わない）
autoload -Uz compinit
{
  local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
  [[ -d ${zcompdump:h} ]] || mkdir -p -- "${zcompdump:h}"
  if [[ -n ${zcompdump}(#qN.mh+24) ]]; then
    compinit -d "$zcompdump"
  else
    compinit -C -d "$zcompdump"
  fi
}

# ===== Tools =====
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v mise     >/dev/null && eval "$(mise activate zsh)"
command -v fzf      >/dev/null && source <(fzf --zsh)
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"

# ===== Functions =====

# ghq リポジトリを fzf で選択 (Ctrl+g / Ctrl+t 共用)
function _ghq-select() {
  ghq list | fzf --preview "eza --icons -T -L 2 $(ghq root)/{}"
}

# Ctrl+g: ghq + fzf でリポジトリに cd
function ghq-fzf() {
  local repo=$(_ghq-select)
  if [ -n "$repo" ]; then
    cd "$(ghq root)/$repo"
  fi
  zle accept-line
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

# Ctrl+t: ghq + fzf で herdr workspace を作成/フォーカス
function herdr-ghq() {
  local repo=$(_ghq-select)
  [ -z "$repo" ] && { zle accept-line; return; }

  local dir="$(ghq root)/$repo"
  local label="${repo#*/}" # ホスト名を落として owner/repo に

  # workspace API はソケット経由のため、サーバー未起動なら起動して待つ
  if ! herdr status server 2>/dev/null | grep -q 'status: running'; then
    (herdr server >/dev/null 2>&1 &)
    local _i
    for _i in {1..20}; do
      herdr status server 2>/dev/null | grep -q 'status: running' && break
      sleep 0.1
    done
  fi

  local ws_id=$(herdr workspace list 2>/dev/null |
    jq -r --arg l "$label" '.result.workspaces[] | select(.label == $l) | .workspace_id' |
    head -1)

  if [ -n "$ws_id" ]; then
    herdr workspace focus "$ws_id" >/dev/null 2>&1
  else
    herdr workspace create --cwd "$dir" --label "$label" --focus >/dev/null 2>&1
  fi

  # herdr の外から呼ばれたらそのままアタッチ
  [ -z "$HERDR_PANE_ID" ] && BUFFER="herdr"
  zle accept-line
}
zle -N herdr-ghq
bindkey '^t' herdr-ghq

# Ctrl+o: fzf 標準のファイル挿入ウィジェット（^t は ghq に割り当て済みのため退避）
bindkey '^o' fzf-file-widget

# C-h/j/k/l: herdr のペイン移動 (nvim 側は keymaps.lua が同じ socket API を呼ぶ)。
# herdr の type = "shell" バインドは子プロセスを回収せずゾンビが溜まるため、
# ペイン移動は各アプリ側から herdr CLI を呼ぶ方式にしている (2026-07-13)
if [[ -n $HERDR_PANE_ID ]]; then
  function _herdr-focus() {
    herdr pane focus --direction "$1" --pane "$HERDR_PANE_ID" >/dev/null 2>&1
  }
  function herdr-focus-left()  { _herdr-focus left }
  function herdr-focus-down()  { _herdr-focus down }
  function herdr-focus-up()    { _herdr-focus up }
  function herdr-focus-right() { _herdr-focus right }
  zle -N herdr-focus-left
  zle -N herdr-focus-down
  zle -N herdr-focus-up
  zle -N herdr-focus-right
  bindkey '^h' herdr-focus-left
  bindkey '^j' herdr-focus-down
  bindkey '^k' herdr-focus-up
  bindkey '^l' herdr-focus-right
  # C-l を移動に奪った代わりのクリアスクリーン
  bindkey '^x^l' clear-screen
fi

# 中身検索 (ripgrep) → 選択行を nvim で開く。入力のたびに rg を再実行する live grep
function rg-fzf() {
  local rg_cmd="rg --column --line-number --no-heading --color=always --smart-case"
  local query=${1:-} result
  result=$(
    FZF_DEFAULT_COMMAND="${rg_cmd} -- ${(q)query}" \
    fzf --ansi --disabled --query "$query" \
        --bind "change:reload:${rg_cmd} -- {q} || true" \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window 'right,60%,+{2}+3/3'
  )
  [[ -z $result ]] && return
  local file=${result%%:*}
  local line=${${result#*:}%%:*}
  nvim "$file" +"$line"
}

# git ブランチを fzf で選んで switch（単発の切替は lazygit を開くより速い）
function gco-fzf() {
  local branch
  branch=$(git branch --all | grep -v HEAD | fzf | sed 's/^[* ]*//;s#remotes/[^/]*/##')
  [[ -n $branch ]] && git switch "$branch"
}

# 実行中プロセスを fzf で選んで kill（Tab で複数選択、SIGTERM を送信）
function fkill() {
  local pids
  pids=$(ps -ef | sed 1d | fzf --multi --header='Tab=複数選択 / SIGTERM' | awk '{print $2}')
  [[ -n $pids ]] && echo "$pids" | xargs kill
}

# gh の PR 一覧から選んで checkout
function pr-fzf() {
  local pr
  pr=$(gh pr list | fzf | awk '{print $1}')
  [[ -n $pr ]] && gh pr checkout "$pr"
}

# ===== Alias =====
alias vim='nvim'
alias c='clear'
alias cat='bat'
alias diff='delta'
alias gds='git diff --delta-features="+side-by-side"'
alias rebuild='sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#work'
