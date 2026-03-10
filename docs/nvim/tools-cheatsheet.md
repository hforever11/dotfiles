# Neovim Tools Cheatsheet

Neovim から起動するツール系のメモをまとめたもの。

## Snacks.nvim

### Lazygit

| キー         | 説明             |
| ------------ | ---------------- |
| `<leader>lg` | Lazygit を開く   |
| `<leader>lf` | 現在ファイルのログ |

### Explorer


| キー         | 説明                 |
| ------------ | -------------------- |
| `<leader>e`  | ファイルエクスプローラ（トグル） |

#### ファイルツリーなしの運用ガイド

ファイルツリーを常時表示しなくても、以下の操作で十分にナビゲーションできる。

| やりたいこと | 操作 | 説明 |
| --- | --- | --- |
| ファイルを開く | `<leader><space>` | Smart Find Files（バッファ + 最近 + ファイル） |
| コードを探す | `<leader>/` | grep で全文検索 |
| バッファ切替 | `<leader>,` | 開いているバッファ一覧 |
| 定義ジャンプ | `gd` | LSP で定義元へ |
| 参照検索 | `gr` | LSP で参照元を一覧 |
| フォルダ構成を見たい | `<leader>e` | 一時的にツリーを開いて `q` で閉じる |
| プロジェクト切替 | `<leader>fp` | プロジェクト一覧 |

#### Explorer Window

| キー          | 説明                  |
| ------------- | --------------------- |
| `l` / `<CR>`  | 開く / 展開           |
| `h`           | 閉じる                |
| `<BS>`        | 親へ移動              |
| `a`           | 追加                  |
| `d`           | 削除                  |
| `r`           | リネーム              |
| `c`           | コピー                |
| `m`           | 移動                  |
| `y`           | パスをコピー          |
| `p`           | ペースト              |
| `o`           | システムアプリで開く  |
| `P`           | プレビュー切替        |
| `H`           | 隠しファイル切替      |
| `I`           | ignore 切替           |
| `q`           | 閉じる                |

### Picker

#### Top Pickers

| キー               | 説明                                             |
| ------------------ | ------------------------------------------------ |
| `<leader><space>`  | Smart Find Files                                 |
| `<leader>,`        | Buffers                                          |
| `<leader>/`        | Grep                                             |
| `<leader>:`        | Command History                                  |
| `<leader>n`        | Notification History                             |

#### Find / Git / Search / LSP

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>fc`  | Find Config File       |
| `<leader>fp`  | Projects               |
| `<leader>gb`  | Git Branches           |
| `<leader>gl`  | Git Log                |
| `<leader>gL`  | Git Log Line           |
| `<leader>gs`  | Git Status             |
| `<leader>gS`  | Git Stash              |
| `<leader>gd`  | Git Diff               |
| `<leader>gf`  | Git Log File           |
| `<leader>sb`  | Buffer Lines           |
| `<leader>sB`  | Grep Open Buffers      |
| `<leader>sg`  | Grep                   |
| `<leader>sw`  | Visual selection / word |
| `<leader>sd`  | Diagnostics            |
| `<leader>sh`  | Help Pages             |
| `<leader>sj`  | Jumps                  |
| `<leader>sk`  | Keymaps                |
| `<leader>sm`  | Marks                  |
| `<leader>su`  | Undo History           |
| `<leader>uC`  | Colorschemes           |
| `gd`          | Go to Definition       |
| `gD`          | Go to Declaration      |
| `gr`          | Find References        |
| `gI`          | Go to Implementation   |
| `gy`          | Go to Type Definition  |
| `<leader>ss`  | LSP Symbols            |
| `<leader>sS`  | Workspace Symbols      |

## Lazygit

> `<leader>lg` で起動

### グローバル / パネル移動

| キー      | 説明                     |
| --------- | ------------------------ |
| `?`       | キーバインド一覧         |
| `q`       | 終了                     |
| `<Esc>`   | キャンセル / 戻る        |
| `R`       | リフレッシュ             |
| `:`       | シェルコマンド           |
| `@`       | コマンドログ             |
| `+`       | 画面モード切替           |
| `j` / `k` | リスト内で上下移動       |
| `h` / `l` | パネル移動               |
| `<Tab>`   | パネル切替               |
| `/`       | 検索                     |
| `<Enter>` | 選択 / 展開              |

### よく使う操作

| キー      | 説明                           |
| --------- | ------------------------------ |
| `<Space>` | ステージ / アンステージ        |
| `c`       | コミット                       |
| `A`       | amend                          |
| `d`       | 変更を破棄                     |
| `e`       | エディタで開く                 |
| `o`       | デフォルトアプリで開く         |
| `n`       | 新規ブランチ                   |
| `r`       | リベース                       |
| `P`       | push                           |
| `p`       | pull                           |
| `f`       | fetch                          |

## Sidekick.nvim

### NES

| キー         | モード | 動作                                   |
| ------------ | ------ | -------------------------------------- |
| `<Tab>`      | n      | NES にジャンプ / 適用                  |
| `<leader>uN` | n      | NES の有効 / 無効をトグル              |

### CLI

| キー         | モード     | 動作                      |
| ------------ | ---------- | ------------------------- |
| `<C-.>`      | n, t, i, x | CLI ターミナルをトグル    |
| `<leader>aa` | n          | CLI ターミナルをトグル    |
| `<leader>as` | n          | CLI ツールを選択          |
| `<leader>ad` | n          | CLI セッションを切断      |
| `<leader>af` | n          | 現在ファイルを CLI に送信 |
| `<leader>av` | x          | 選択範囲を CLI に送信     |
| `<leader>ap` | n, x       | プロンプトを選択して送信  |

### セットアップ

```vim
:LspCopilotSignIn
:checkhealth sidekick
```
