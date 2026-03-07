#!/usr/bin/env bash

set -eu

main() {
  # from https://github.com/catppuccin/tmux/blob/5ed4e8a/catppuccin-frappe.tmuxtheme#L4-L17
  # --> Catppuccin (Frappe)
  thm_bg="#303446"
  thm_fg="#c6d0f5"
  thm_black="#292c3c"
  thm_surface0="#414559"
  thm_magenta="#ca9ee6"
  thm_pink="#f4b8e4"
  thm_red="#e78284"
  thm_green="#a6d189"
  thm_yellow="#e5c890"
  thm_blue="#8caaee"
  thm_orange="#ef9f76"
  thm_surface2="#626880"

  separator="#[fg=${thm_surface0},bg=default,none]▕#[default]"

  tmux set -g message-command-style "align=right,fg=${thm_blue}"
  tmux set -g message-style "align=right,fg=${thm_blue},align=centre"
  tmux set -g pane-active-border-style "fg=${thm_magenta}"
  tmux set -g pane-border-style "fg=${thm_black}"
  tmux set -g window-active-style "bg=default"
  tmux set -g window-style "bg=${thm_black}"
  tmux set -u pane-border-status
  tmux set -u pane-border-format

  # status bar
  # ================================================
  tmux set -g status "on"
  tmux set -g status-position "top"
  tmux set -g status-justify "right"
  tmux set -g status-style "none"

  # left panel: リポジトリ + ブランチ
  tmux set -g status-left-length 100
  tmux set -g status-left-style "none,fg=${thm_surface2}"
  tmux set -g status-left "#(~/.config/tmux/git-info.sh #{pane_current_path} '▕') ${separator}"

  # right panel: なし
  tmux set -g status-right-style "none"
  tmux set -g status-right ""

  # window
  # ================================================
  tmux setw -g window-status-current-style "bold,fg=${thm_fg}"
  tmux setw -g window-status-activity-style "none,fg=${thm_surface2}"
  tmux setw -g window-status-style "none,fg=${thm_surface2}"
  tmux setw -g window-status-current-format "  #I #W ${separator}"
  tmux setw -g window-status-format "  #I #W ${separator}"
  tmux setw -g window-status-separator ""
}

main
