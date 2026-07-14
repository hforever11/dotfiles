# herdr コマンドリファレンス

## 基本情報

- **Prefixキー**: `Ctrl + s` (tmux と同じ。デフォルトの `Ctrl + b` から変更済み)
- **テーマ**: Catppuccin Latte (ビルトイン)
- **設定ファイル**: `~/.config/herdr/config.toml` (スキーマ全体は `herdr --default-config`)
- **tmux との概念対応**: session → **workspace** / window → **tab** / pane → pane
- サイドバーに各 workspace のエージェント状態が出る (🔴 blocked / 🟡 working / 🔵 done / 🟢 idle)

---

## セッション (アタッチ / デタッチ)

| キー         | 説明                                     |
| ------------ | ---------------------------------------- |
| `Prefix + q` | デタッチ (サーバーとエージェントは生存) |

### コマンドラインから

```bash
herdr                    # 起動 or 既存サーバーにアタッチ
herdr status             # クライアント/サーバーの状態確認
herdr server stop        # サーバー停止
herdr server reload-config  # 設定リロード (tmux の Prefix+r 相当)
herdr --remote <ssh先>   # リモートの herdr サーバーにアタッチ
```

---

## ワークスペース操作 (tmux のセッション相当)

| キー                 | 説明                                 |
| -------------------- | ------------------------------------ |
| `Ctrl + t` (シェル)  | ghq + fzf で workspace を作成/フォーカス |
| `Prefix + w`         | workspace ピッカーを開く (絞り込み入力あり。上下は矢印キー) |
| `Prefix + f`         | navigate モードを開く (`j/k` で workspace 上下、`h/l`・矢印でペイン移動、`Enter` で確定) |
| `Prefix + Shift + n` | 新しい workspace を作成              |
| `Prefix + Shift + w` | workspace 名を変更                   |
| `Prefix + Shift + d` | workspace を閉じる (確認あり)        |
| `Prefix + Shift + g` | git worktree から workspace を作成   |

navigate モード (`Prefix + f`) 中は prefix アクションのキー部分がそのまま**選択中の workspace** に効く:
`j/k` で対象に合わせて `Shift + D` で削除 (確認あり)、`Shift + W` でリネームなど。移動せずに整理できる。

---

## タブ操作 (tmux のウィンドウ相当)

| キー                 | 説明                       |
| -------------------- | -------------------------- |
| `Prefix + c`         | 新しいタブを作成           |
| `Prefix + 1-9`       | 番号でタブを選択           |
| `Prefix + n`         | 次のタブに移動             |
| `Prefix + p`         | 前のタブに移動             |
| `Prefix + Shift + t` | タブ名を変更               |
| `Prefix + Shift + x` | タブを閉じる               |

---

## ペイン操作

| キー                   | 説明                                 |
| ---------------------- | ------------------------------------ |
| `Prefix + v`           | 縦に分割 (左右に並ぶ)                |
| `Prefix + -`           | 横に分割 (上下に並ぶ)                |
| `Ctrl + h/j/k/l`       | ペイン移動 (プレフィックスなし。vim 内はウィンドウ移動、端に達したら herdr ペインへ抜ける) |
| `Prefix + h/j/k/l`     | ペイン移動                           |
| `Prefix + Tab`         | 次のペインへ                         |
| `Prefix + z`           | ペインを最大化/元に戻す (ズーム)     |
| `Prefix + x`           | ペインを閉じる                       |
| `Prefix + r`           | リサイズモード (h/j/k/l でリサイズ)  |
| `Prefix + Shift + p`   | ペイン名を変更                       |
| `Prefix + b`           | サイドバーの表示/非表示              |

マウス操作 (クリックでフォーカス、境界ドラッグでリサイズ、ホイールでスクロール 3 行/ノッチ) にも対応。

分割時の比率は CLI でのみ指定可能 (`herdr pane split --direction right --ratio 0.33`)。
キーバインドの分割は 50/50 固定なので、定番比率は `[[keys.command]]` に焼くとよい。
ペイン間の仕切りは `[ui] pane_gaps = false` で境界線を共有させて薄くしている
(デフォルト true は隙間が太い。特に上下分割はセルの縦横比で約 2 倍太く見える)。

---

## スクロールバック・コピー

| 操作              | 説明                                             |
| ----------------- | ------------------------------------------------ |
| `Prefix + [`      | コピーモード (tmux と同じキー。v0.6.5 で追加)     |
| `Prefix + e`      | スクロールバックを `$EDITOR` (nvim) で開いてコピー |
| マウスドラッグ     | 選択即コピー (コピーモード不要)。ダブルクリックで単語コピー |
| マウスホイール     | ペイン内をスクロール (3 行/ノッチ)               |

コピーモード内のキー: `h/j/k/l` `w/b/e` `{`/`}` `C-u/C-d` `C-f` で移動、`/` `?` で検索 (`n/N` で次へ)、
`v` / Space で選択開始 (`Shift+V` で行選択)、`y` / Enter でクリップボードへコピー、`q` / Esc で抜ける。
prefix (`C-s`) はコピーモード中も生きているのでそのままペイン移動等が可能。

`Prefix + e` の nvim も vi 操作 (`/` 検索、`v` → `y`) がそのまま使える。
ちょい見・ちょいコピーは `Prefix + [`、じっくり検索して抜き出すなら `Prefix + e` という使い分け。
スクロールバック上限は 10MB/ペイン (`[advanced] scrollback_limit_bytes`)。
**サーバー再起動でスクロールバックは消える** (永続化は `[experimental] pane_history` だが秘匿情報がファイルに残るため無効のまま)。

---

## カスタムキーバインド (config.toml で定義)

| キー               | 説明                                         |
| ------------------ | -------------------------------------------- |
| `Prefix + g`       | lazygit をテンポラリペインで開く (閉じると消える) |
| `Prefix + Shift + h` | [hunk](../hunk/COMMANDS.md) (diff レビュー) をテンポラリペインで開く。`--watch` 付きなので Claude の編集に追従 |
| `Ctrl + h/j/k/l`   | ペイン移動 (Karabiner-Elements が Ghostty フロント時のみ横取りし `~/.local/bin/herdr-navigate` を実行) |

※ デフォルトの `goto` (`Prefix + g`) は lazygit に譲り、navigate モードは `Prefix + f` に移設。
picker はフィルタ入力を持つため `j/k` が文字入力になる。vim ライクに workspace を
上下移動したいときは navigate モード (`Prefix + f`) を使う。

herdr 0.7.1 は `[[keys.command]] type = "shell"` の子プロセスを回収せずゾンビが蓄積するため
(詳細: z-ai/herdr-zombie-leak.md)、`Ctrl + h/j/k/l` の横取りは herdr でなく
**Karabiner-Elements** (`config/karabiner/karabiner.json`) が担う。Ghostty
(`com.mitchellh.ghostty`) がフロントの時だけ発火し、`herdr-navigate` が socket API で
最前面プロセスを判定して vim ならキー転送 (vim 内のウィンドウ移動を優先)、
それ以外は `pane focus` する。子プロセスは Karabiner が回収するのでゾンビは出ない。

Ghostty 以外のターミナルや SSH 先用のフォールバックとして、zsh (`.zshrc` の
herdr-focus ウィジェット、プロンプトのみ) と nvim (`keymaps.lua`、ウィンドウ端で
`herdr pane focus` / tmux フォールバック) にも同じ移動が実装してある。

トレードオフ (herdr 横取り時代・tmux 時代と同じ):

- シェルの `C-l` (クリア) は潰れる → `C-x C-l` に移設済み。fzf の `C-j/k` も潰れる → `C-n/C-p` で代替
- herdr なしで Ghostty を使うと `C-h/j/k/l` は no-op (herdr-navigate が黙って失敗する)

---

## その他のデフォルトキー

| キー                 | 説明                             |
| -------------------- | -------------------------------- |
| `Prefix + ?`         | ヘルプ                           |
| `Prefix + s`         | 設定画面 (※ tmux ではセッション一覧だった) |
| `Prefix + Shift + r` | 設定リロード (※ tmux では `Prefix + r`)    |
| `Prefix + o`         | 要対応エージェントへジャンプ (連打で次のエージェントへ巡回) |
| `Prefix + Shift + o` | エージェント巡回 (逆順)         |

`Prefix + o` はデフォルトでは open_notification_target (表示中の in-app トーストのペインへフォーカス)
だが、`delivery = "terminal"` (Ghostty のデスクトップ通知) ではトーストが出ず常に no-op のため、
config.toml で `next_agent` に割り当て直している。`agent_panel_sort = "priority"` により
blocked (入力待ち) のエージェントがサイドバー最上位に来るので、最初の一押しで要対応エージェントへ飛ぶ。

---

## エージェント連携 (socket API)

エージェント状態の把握・操作は CLI からも可能:

```bash
herdr workspace list             # workspace 一覧 (JSON)
herdr agent list                 # エージェントと状態の一覧
herdr pane read <pane_id>        # ペインの画面内容を読む
herdr pane split --direction right --cwd <dir>  # ペイン分割
herdr wait <...>                 # エージェントの状態変化を待つ
```

日本語 IME 対策として、prefix モード中は ASCII 入力ソースへ自動切替する
(`[experimental] switch_ascii_input_source_in_prefix`)。

---

## tmux からの移行メモ

tmux の設定・パッケージは削除済み (2026-07-10)。以下はキー対応の参考記録。

### キーの読み替え

| tmux                     | herdr                          |
| ------------------------ | ------------------------------ |
| `Prefix + \|` / `-` 分割 | `Prefix + v` / `-`             |
| `Ctrl + h/j/k/l` 移動    | `Ctrl + h/j/k/l` (同じ)        |
| `Prefix + d` デタッチ    | `Prefix + q`                   |
| `Prefix + r` リロード    | `Prefix + Shift + r`           |
| copy-mode (`Prefix + [`) | `Prefix + [` (同じ。v0.6.5〜)。nvim で開くなら `Prefix + e` |
| `Prefix + g` lazygit     | `Prefix + g` (同じ)            |
| `Ctrl + t` ghq セッション | `Ctrl + t` ghq workspace (同じ) |

### 未移植 (必要になったら対応)

- **Ghostty の `⌘ + h/j/k/l`**: tmux の user-keys 用エスケープシーケンスのため herdr では効かない
  (herdr 内で押すと制御シーケンスがペインに素通しされる)
- **`Shift + Enter`** (Claude Code の改行): tmux 側で CSI-u に変換していた。herdr 経由で通るか要確認
- **`Prefix + a` / `Prefix + D`** (Claude Code レイアウト)、**`Ctrl + f`** (fzf ファイルピッカー popup):
  workspace 単位の運用でしばらく試し、必要なら `[[keys.command]]` か socket API で再現する
