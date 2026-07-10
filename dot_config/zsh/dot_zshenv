# herdr の Prefix+e (スクロールバック編集) は ${EDITOR:-vi} を実行するため必須。
# 未設定だと素の vi が開き、y がシステムクリップボードに届かない
export EDITOR=nvim
export VISUAL=nvim

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Tool-specific XDG paths
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/config"
# fd で .gitignore 準拠かつ隠しファイル込みの高速検索にする
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
# ファイル挿入ウィジェット (^o) のプレビュー。ディレクトリは eza にフォールバック
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {} 2>/dev/null || eza --icons --tree --level=1 {}'"
export DENO_DIR="$XDG_CACHE_HOME/deno"

# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Nix (nix-darwin + home-manager)
# brew shellenv の後に前置して nix 版のツールを brew 版より優先させる。
# nix-darwin の /etc/zshenv が nix パスを後方に入れるケースがあるため、
# 存在チェックでスキップせず常に前置する (重複は zshrc の typeset -U path が先勝ちで除去)
if [ -d /run/current-system/sw/bin ]; then
  export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"
fi

# mise shims (for Neovim/LSP and non-interactive shells)
# Keep this after brew shellenv so runtimes managed by mise win over Homebrew.
# zshenv はネストしたシェルでも毎回読まれるため、重複追加をガードする
case ":$PATH:" in
  *":$HOME/.local/share/mise/shims:"*) ;;
  *) export PATH="$HOME/.local/share/mise/shims:$PATH" ;;
esac
