# ================================================
# misc
# ================================================

set -g default-shell $SHELL

set -g focus-events on

# ウィンドウ/ペイン番号を1始まりに、閉じたら詰める
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on

# スクロールバック (Claude Code の長い出力を遡れるよう拡張)
set -g history-limit 50000

# メッセージ表示時間 (既定750msでは "Reloaded!" 等が読み切れない)
set -g display-time 2000

# コマンドプロンプトはemacsキー (mode-keys viでもプロンプトのvi操作は使いにくい)
set -g status-keys emacs

# ペイン内アプリのOSC52コピーをシステムクリップボードへ転送 (nvim/SSH先からのヤンク用)
set -g set-clipboard on

# 端末タイトルに「セッション名:ウィンドウ名」を表示 (Ghosttyタブ名に反映)
set -g set-titles on
set -g set-titles-string "#S:#W"

# バックグラウンドのベル通知のみ検知 (音はOSミュート前提で無音、視覚通知もoff)
# 将来音量を上げたいときは visual-bell on にするだけで気付けるようになる
set -g monitor-bell on
set -g visual-bell off
set -g bell-action other

# Claude Code / AI CLI 連携
# - allow-passthrough: デスクトップ通知のエスケープシーケンスを素通し
# - extended-keys:     Shift+Enter で改行入力 (マルチライン プロンプト)
set -g allow-passthrough on
set -s extended-keys on
set -as terminal-features 'xterm*:extkeys'

# ================================================
# appearance
# ================================================

# 256色
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -ag terminal-overrides ",xterm-ghostty:RGB"

# バックグラウンドウィンドウの出力はステータスバーの強調表示のみで通知
# (ベルと同じ思想。visual on だと Claude Code の出力で "Activity in window N" が頻発する)
set-window-option -g monitor-activity on
set -g visual-activity off

# refresh rate (default 15sec)
set -g status-interval 5

# ================================================
# mouse
# ================================================

# マウス操作の有効化
set-option -g mouse on
