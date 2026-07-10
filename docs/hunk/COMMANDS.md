# hunk コマンドリファレンス

エージェントが書いた変更セットのレビューに特化したターミナル diff ビューア。
Diffview.nvim の後継として採用（見るだけのツール。ステージング・コミットは lazygit）。

## 基本情報

- **設定ファイル**: `~/.config/hunk/config.toml`（home-manager が `home/theme.nix` → `home/generated.nix` 経由で生成。暗め Latte に追従）
- **テーマ**: `theme = "custom"` でビルトイン `catppuccin-latte` を継承し、背景系のみ Ghostty/herdr と同じ値に上書き
  （`theme = "auto"` はライト背景だと github-light-default に解決されるため不使用）
- **バージョン確認**: `hunk --version`
- 見た目・レイアウトはメニューバー（マウス選択可）からも変更できる

## この環境での入口

**herdr の `Prefix + Shift + H` に一本化**（`hunk diff --watch` をテンポラリペインで開く）。

基本の型は「作業を始めたらペインで開きっぱなし」。`--watch` で Claude の編集にも
自分の手編集にも自動追従するので、開く動作すら毎回は要らない。

- diff を見ながら隣の nvim で直す → 直した結果が watch で即反映（レビューの基本ループ）
- じっくり読むときは `Prefix + z` でズーム
- nvim 内のちょい見（hunk 単位）は gitsigns の担当

※ nvim フロートで開く案（`<leader>gv`）は試した上で廃止。入口が 2 つあると迷うのと、
フロート内の `e` は nvim がネストするため。

## CLI コマンド

```bash
hunk diff                        # 作業ツリーの変更（untracked 含む）
hunk diff --staged               # ステージ済みの変更
hunk diff main...HEAD            # ブランチで入る変更（PR の中身の事前確認）
hunk diff -- src/                # pathspec で絞り込み
hunk diff a.ts b.ts              # ファイル 2 つを直接比較
hunk show                        # 最新コミット
hunk show HEAD~1                 # 指定コミット
hunk stash show                  # stash の中身
git diff | hunk patch -          # パッチを stdin から
```

主なオプション: `--watch`（自動リロード）/ `--mode auto|split|stack`（レイアウト）/
`--exclude-untracked`（untracked を隠す）

## TUI キー操作

| キー                | 説明                                         |
| ------------------- | -------------------------------------------- |
| `?`                 | キーボードヘルプ（モーダル）                 |
| `j` / `k` / 矢印    | スクロール                                   |
| `Ctrl+d` / `Ctrl+u` | 半ページスクロール                           |
| `g` / `G`           | 先頭 / 末尾へジャンプ                        |
| `s`                 | サイドバー（ファイルツリー）の表示切替       |
| `e`                 | 選択中のファイルを `$EDITOR` で開く          |
| `c`                 | インラインノートを書く（セッションに永続化） |
| `r`                 | 現在の diff をリロード（`--watch` なら不要） |
| `t`                 | テーマセレクタ                               |
| `q`                 | 終了（Escape はダイアログ用で終了しない）    |

マウス対応: クリックでフォーカス、メニューバー操作、`▾ N unchanged lines` クリックで折りたたみ展開。

**注意**: `e` の `$EDITOR` は hunk のペイン内で開く（ネストせず普通に使える）。

## Claude Code 連携（session API）

hunk を開いた状態で Claude に以下を伝えると、Claude が画面を操作しながらレビューを案内できる:

> `hunk skill path` の skill を読んでこのセッションでレビューして

Claude 側ができること（`hunk session` コマンド経由）:

```bash
hunk session list                                   # ライブセッション一覧
hunk session review --repo . --json                 # ファイル/hunk 構造を取得
hunk session navigate --repo . --file <f> --hunk 2  # 人間の画面を該当箇所へジャンプ
hunk session comment add --repo . --file <f> --new-line 10 --summary "..."  # インラインコメント
hunk session reload --repo . -- show HEAD~1         # 表示内容の差し替え
```

エージェントのコメントは code の横にインライン表示される。エージェントは自分のコメントを
消せるが、人間が `c` で書いたノートは消せない。

## 使い分け

| 用途                         | ツール                                     |
| ---------------------------- | ------------------------------------------ |
| 1 ファイルの hunk 単位の確認 | gitsigns (`<leader>ghp` など)              |
| 変更セット全体のレビュー     | hunk (`Prefix + Shift + H`)                |
| ステージング・コミット       | lazygit (`<leader>lg` / `Prefix + g`)      |
| ファイル履歴・コンフリクト   | lazygit                                    |
