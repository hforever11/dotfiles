# ================================================
# misc
# ================================================

set -g default-shell $SHELL

# ================================================
# appearance
# ================================================

# 256色
set -g default-terminal "tmux-256color"
# set -ag terminal-overrides ",alacritty:RGB"
set -ag terminal-overrides ",xterm-256color:RGB"
set -ag terminal-overrides ",xterm-ghostty:RGB"

# enable visual notification
set-window-option -g monitor-activity on
set -g visual-activity on

# refresh rate (default 15sec)
set -g status-interval 5

# ================================================
# mouse
# ================================================

# マウス操作の有効化
set-option -g mouse on
