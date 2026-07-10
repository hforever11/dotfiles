# ================================================
# appearance
# ================================================
# Catppuccin Latte (home/theme.nix と同じ値を焼き込み)。
# tmux は herdr 移行後の fallback のためテーマ自動連動はしない

%hidden thm_fg="#4c4f69"
%hidden thm_mantle="#d3d8e2"
%hidden thm_surface0="#ccd0da"
%hidden thm_overlay0="#9ca0b0"
%hidden thm_blue="#1e66f5"
%hidden thm_mauve="#8839ef"

%hidden separator="#[fg=${thm_surface0},bg=default,none]▕#[default]"

set -g message-command-style "align=right,fg=${thm_blue}"
set -g message-style "align=right,fg=${thm_blue},align=centre"
set -g pane-active-border-style "fg=${thm_mauve}"
set -g pane-border-style "fg=${thm_surface0}"
set -g window-active-style "bg=default"
set -g window-style "bg=default"
set -g mode-style "bg=${thm_blue},fg=${thm_mantle},bold"
set -g popup-border-lines "rounded"
set -g popup-border-style "fg=${thm_mauve}"

# status bar
# ================================================
set -g status "on"
set -g status-position "top"
set -g status-justify "right"
set -g status-style "none"

# left panel: リポジトリ + ブランチ
set -g status-left-length 100
set -g status-left-style "none,fg=${thm_overlay0}"
set -g status-left "#(~/.config/tmux/git-info.sh #{pane_current_path} '▕') ${separator}"

# right panel: なし (tmux-continuum が自動保存フックをここに追記する)
set -g status-right-style "none"
set -g status-right ""

# window
# ================================================
setw -g window-status-current-style "bold,fg=${thm_fg}"
setw -g window-status-activity-style "none,fg=${thm_overlay0}"
setw -g window-status-style "none,fg=${thm_overlay0}"
setw -g window-status-current-format "  #I #W#{?window_zoomed_flag, 󰊓,} ${separator}"
setw -g window-status-format "  #I #W ${separator}"
setw -g window-status-separator ""
