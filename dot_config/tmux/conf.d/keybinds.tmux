# ================================================
# keybind
# ================================================

# prefixキーをC-sに変更する
set -g prefix C-s

# C-bのキーバインドを解除する
unbind C-b

# キーストロークのディレイを減らす
set -sg escape-time 1

# キーテーブル切り替え後の待機時間（C-w → h などの入力猶予）
# set -g repeat-time 1000

# 設定ファイルをリロードする
bind r source-file $HOME/.config/tmux/tmux.conf \; display "Reloaded!"

# copy mode with vi keybind
set-window-option -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send -X cancel

# マウスドラッグ終了時にコピーモードを維持（テキスト確認用）
# ドラッグ後にyでコピー、またはマウスを離した時点でコピー
unbind -T copy-mode-vi MouseDragEnd1Pane
bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection

# ================================================
# Vim Tmux Navigator
# ================================================

bind -n C-w switch-client -T NAVIGATOR
bind -T NAVIGATOR C-w send-keys C-w

# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?)$'"
is_vim_or_claude="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|claude)$'"
bind -T NAVIGATOR h if-shell "$is_vim" "send-keys C-w h"  "select-pane -L"
bind -T NAVIGATOR j if-shell "$is_vim" "send-keys C-w j"  "select-pane -D"
bind -T NAVIGATOR k if-shell "$is_vim" "send-keys C-w k"  "select-pane -U"
bind -T NAVIGATOR l if-shell "$is_vim" "send-keys C-w l"  "select-pane -R"

bind -T NAVIGATOR H send-keys C-w H
bind -T NAVIGATOR J send-keys C-w J
bind -T NAVIGATOR K send-keys C-w K
bind -T NAVIGATOR L send-keys C-w L
bind -T NAVIGATOR = send-keys C-w =

# ペイン分割とリサイズは pain-control 相当を手書きで維持
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind \\ split-window -fh -c "#{pane_current_path}"
bind _ split-window -fv -c "#{pane_current_path}"
bind H resize-pane -L 5
bind J resize-pane -D 5
bind K resize-pane -U 5
bind L resize-pane -R 5

# C-h/j/k/l で直接ペイン移動（Vim/Claude内ならアプリに転送）
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim_or_claude" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

# ⌘+hjkl で直接ペイン移動（Ghosttyから独自エスケープシーケンスを受信）
# Vim内ならC-h/j/k/lに変換して転送（vim-tmux-navigator用）
set -s user-keys[0] "\e[104;9u"
set -s user-keys[1] "\e[106;9u"
set -s user-keys[2] "\e[107;9u"
set -s user-keys[3] "\e[108;9u"
bind -n User0 if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n User1 if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n User2 if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n User3 if-shell "$is_vim" "send-keys C-l" "select-pane -R"

bind -T copy-mode-vi C-h select-pane -L
bind -T copy-mode-vi C-j select-pane -D
bind -T copy-mode-vi C-k select-pane -U
bind -T copy-mode-vi C-l select-pane -R
bind -T copy-mode-vi 'C-\' select-pane -l

# ================================================
# Passthrough
# ================================================
bind m send-keys C-t m
