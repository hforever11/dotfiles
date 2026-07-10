# herdr 活用ガイド

キー操作の一覧は [COMMANDS.md](COMMANDS.md)。ここでは概念モデルと「どう使うと便利か」をまとめる。

---

## 概念モデル: workspace → tab → pane

herdr の階層は 3 段。tmux とは名前が違うだけで構造は同じ。
「ウィンドウ」という呼び名はなく、tmux の window に当たるものが **tab**。

| herdr     | tmux 相当 | 画面上の見た目                       |
| --------- | --------- | ------------------------------------ |
| workspace | session   | 左サイドバーの 1 行 (エージェント状態付き) |
| tab       | window    | workspace 内のタブバー               |
| pane      | pane      | タブ内の分割                         |

```
herdr サーバー
├─ workspace: dotfiles          ← サイドバーに並ぶ (リポジトリ単位)
│   ├─ tab: 実装                ← タブバーで切替 (Prefix+n/p, Prefix+1-9)
│   │   ├─ pane: nvim           ← C-h/j/k/l で移動
│   │   └─ pane: claude
│   └─ tab: サーバー起動用
└─ workspace: another-repo
    └─ tab ...
```

### 基本の切り方

herdr はエージェント監視が主目的なので **workspace = リポジトリ (ghq) 単位** で切るのが基本。

| 単位      | 使い方                                             | 主な操作 |
| --------- | -------------------------------------------------- | -------- |
| workspace | リポジトリ 1 つ (ghq のディレクトリ)               | `Ctrl + t` で作成/切替、`Prefix + w` でピッカー、`Prefix + f` で navigate モード (`j/k` で上下) |
| tab       | 作業の種類 (実装 / 調査 / サーバー起動しっぱなし等) | `Prefix + c` 作成、`Prefix + 1-9` で直接切替 (`n/p` で順送り) |
| pane      | 画面分割 (nvim + Claude + シェルなど)              | `Prefix + v`/`-` 分割、`C-h/j/k/l` 移動 |

サイドバー (`Prefix + b` で開閉) に全 workspace のエージェント状態が常時出るので、
「別プロジェクトで走らせている Claude が止まっていないか」を作業中に横目で確認できる。

---

## エージェント監視ワークフロー

herdr は pane 内の Claude Code 等を自動検出し、状態をサイドバーに出す。

- 🔴 blocked: 入力待ち (許可プロンプト等) — 対応が必要
- 🟡 working: 実行中 — 放置してよい
- 🔵 done / 🟢 idle: 完了・待機

**`Prefix + o` で「通知のあったペイン」へ直接ジャンプ**できるので、
複数 workspace で Claude を並走させて、blocked になったものから順に対応する運用が基本形。

デスクトップ通知は Ghostty 経由 (`[ui.toast] delivery = "terminal"`) なので、
herdr を見ていなくても状態変化に気づける。

---

## 並列 Claude 運用 (git worktree)

1 ブランチ 1 workspace 1 Claude で並列開発する:

```
Prefix + Shift + g   # 現在の workspace から worktree を作って新 workspace に
```

CLI からも同じことができる:

```bash
herdr worktree create --cwd . --branch feature-x   # worktree 作成 + workspace 化
herdr worktree list --cwd .
herdr worktree remove --workspace <id>             # 後片付け (worktree ごと消す)
```

worktree の実体は `~/.herdr/worktrees` 以下。workspace を閉じるだけでは worktree は
残るので、終わったら `remove` まで行う。

---

## CLI・スクリプトからの操作 (socket API)

herdr の全操作は socket API 経由で CLI から可能。シェルや CI スクリプトに組み込める。

### エージェントの起動と操作

```bash
herdr agent start claude --cwd ~/ghq/github.com/hforever11/dotfiles -- claude
herdr agent list                     # 全エージェントと状態 (JSON)
herdr agent send <target> 'プロンプト'  # 文字列を送る (Enter は含まない)
herdr pane run <pane_id> 'make test'   # コマンド + Enter を送る
herdr agent read <target> --lines 50   # 画面内容を読む
herdr agent focus <target>             # そのペインへジャンプ
```

`<target>` はエージェント名・ペイン ID どちらでも指定できる。

### 状態変化を待つ (自動化の要)

```bash
# Claude が入力待ちになるまでブロック → なったら音を鳴らす等
herdr agent wait <target> --status blocked --timeout 600000 && afplay /System/Library/Sounds/Glass.aiff

# 画面に特定の文字列が出るまで待つ
herdr wait output <pane_id> --match 'All tests passed' --timeout 300000
```

「Claude に長タスクを投げる → wait で完了を検知 → 結果を read で回収」という
パイプラインが herdr だけで組める。

---

## スクロールバックの扱い

copy-mode はなく `Prefix + e` で nvim に開く方式。長い出力から拾うときは
nvim の `/` 検索・visual yank がそのまま使えるので、tmux の copy-mode より速い。

CLI から機械的に取るなら:

```bash
herdr pane read <pane_id> --source recent --lines 200
```

**サーバー再起動でスクロールバックは消える**点だけ注意
(永続化オプションはあるが秘匿情報が残るため無効運用)。

---

## セッション永続とリモート

- `Prefix + d` でデタッチしてもサーバーとエージェントは生き続ける。`herdr` で復帰
- サーバー再起動後も、対応エージェント (Claude Code 等) は元の会話セッションへ
  自動レジューム (`[session] resume_agents_on_restore`、デフォルト有効)
- SSH 先の herdr には `herdr --remote <host>` でローカルのキーバインドのまま
  アタッチできる (サーバー側に herdr が必要)

---

## トラブルシューティング

| 症状                       | 対処                                              |
| -------------------------- | ------------------------------------------------- |
| 設定を変えたのに反映されない | `herdr server reload-config` (診断エラーも出る)   |
| キーバインドが効かない     | reload で診断を確認 → ダメならサーバー再起動      |
| 表示が崩れた               | 外側ターミナルのフォーカスを外して戻す (再描画)   |
| 状態が不明                 | `herdr status` / ログは `~/.config/herdr/*.log`   |
| カスタムキーを全部リセット | `herdr config reset-keys` (バックアップされる)    |
