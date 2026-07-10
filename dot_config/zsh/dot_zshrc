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
  $HOME/.rd/bin(N-/)
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
# Rancher Desktop の kubectl は brew site-functions に補完が無いので生成してキャッシュ
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

# ghq + fzf で tmux session を作成/アタッチ (herdr 移行前のフォールバック、バインドなし)
function tmux-ghq() {
  local repo=$(_ghq-select)
  [ -z "$repo" ] && { zle accept-line; return; }

  local dir="$(ghq root)/$repo"
  local session_name="${repo//\./_}"

  if [ -z "$TMUX" ]; then
    tmux new-session -A -s "$session_name" -c "$dir"
  else
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -d -s "$session_name" -c "$dir"
    fi
    tmux switch-client -t "$session_name"
  fi
  zle accept-line
}
zle -N tmux-ghq

# Ctrl+t: ghq + fzf で herdr workspace を作成/フォーカス (tmux-ghq の herdr 版)
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
