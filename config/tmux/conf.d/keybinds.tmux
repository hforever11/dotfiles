# ================================================
# keybind
# ================================================

# prefixキーをC-sに変更する
set -g prefix C-s

# C-bのキーバインドを解除する
unbind C-b

# キーストロークのディレイを減らす
set -sg escape-time 1

# キーテーブル切り替え後の待機時間（リサイズ連打用）
set -g repeat-time 1000

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
# ペインの最前面プロセス判定 (実体は pane-runs.sh)
# ================================================
pane_runs="$HOME/.config/tmux/pane-runs.sh"
vim_pat="g?(view|n?vim?x?)(diff)?"
is_vim="$pane_runs '#{pane_tty}' '$vim_pat'"
tui_no_scrollback="$pane_runs '#{pane_tty}' 'claude'"
picker="$HOME/.config/tmux/file-picker.sh"

# ================================================
# マウスホイールでの履歴遡り
# ================================================
# Claude Code 等の inline TUI はマウスを掴むのにスクロールバックを持たず、
# ホイールをアプリへ渡すと履歴を遡れず描画も崩れる。これらは掴みを無視して
# tmux のコピーモードへ直接入れる。less/vim/man 等の本来スクロール可能な
# アプリは従来どおりアプリへ委譲する。
bind -n WheelUpPane if-shell -F -t = "#{pane_in_mode}" \
  "send-keys -M" \
  "if-shell \"$tui_no_scrollback\" \
     'copy-mode -e' \
     'if-shell -F \"#{mouse_any_flag}\" \"send-keys -M\" \"copy-mode -e\"'"

# 1 ティックのスクロール量を 3 行に（既定 5 行は崩れた行を一気に飛ばしやすい）。
# -e で最下段まで戻すと自動でコピーモードを抜け、Claude が画面を再描画して残骸が消える。
bind -T copy-mode-vi WheelUpPane   send-keys -X -N 3 scroll-up
bind -T copy-mode-vi WheelDownPane send-keys -X -N 3 scroll-down

# ================================================
# Vim Tmux Navigator
# ================================================

bind -n C-w switch-client -T NAVIGATOR
bind -T NAVIGATOR C-w send-keys C-w

# See: https://github.com/christoomey/vim-tmux-navigator
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
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# 新規ウィンドウも分割と同様にカレントパスを引き継ぐ
bind c new-window -c "#{pane_current_path}"

# ウィンドウの並び替え
bind -r "<" swap-window -d -t -1
bind -r ">" swap-window -d -t +1

# AIセッション起動: 右ペインにClaude Code (エディタ 70 : AI 30)
# 既に右側に分割済みなら新規分割せずフォーカスのみ移動
bind a if-shell "[ #{window_panes} -eq 1 ]" \
  "split-window -h -l 30% -c '#{pane_current_path}' 'claude'" \
  "select-pane -R"

# 開発レイアウト: 左上=Editor / 左下=Command / 右=AI待機シェル
# 既に分割済みなら左上(Editor)にフォーカスを戻すだけ
bind D if-shell "[ #{window_panes} -eq 1 ]" \
  "split-window -h -l 35% -c '#{pane_current_path}' ; \
   select-pane -L ; \
   split-window -v -l 25% -c '#{pane_current_path}' ; \
   select-pane -t 0" \
  "select-pane -t 0"

# Popup版: pane_current_path 毎にセッションをハッシュ化して永続化
# 閉じても会話が残り、再度開けば同じセッションに復帰
bind A run-shell '\
  SESSION="claude-$(echo #{pane_current_path} | md5 -q | cut -c1-8)"; \
  tmux has-session -t "$SESSION" 2>/dev/null || \
  tmux new-session -d -s "$SESSION" -c "#{pane_current_path}" "claude"; \
  tmux display-popup -w80% -h80% -E "tmux attach-session -t $SESSION"'

# lazygit をポップアップで開く (閉じれば元のペインにそのまま戻る)
# popup は commit 中に閉じられやすく stale index.lock が残るため、guard 経由で自己修復してから起動する
bind g display-popup -E -d "#{pane_current_path}" -w90% -h90% "$HOME/.local/bin/lazygit-guard"

# C-h/j/k/l で直接ペイン移動（Vim内ならアプリに転送）
# Claude Code ペインでも移動を優先する（改行は S-Enter で入力できる）
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

# root の C-l を移動に割り当てた代わりのクリアスクリーン
bind C-l send-keys C-l

# C-f: Vim 内ならページ送り(C-f)を温存、それ以外は popup の fzf ファイルピッカーを開く
# 選択結果は起動元ペインへ書き戻す (実体は file-picker.sh)
bind -n C-f if-shell "$is_vim" \
  "send-keys C-f" \
  "display-popup -E -d '#{pane_current_path}' -w90% -h90% '$picker'"

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
bind -n S-Enter send-keys Escape "[13;2u"

