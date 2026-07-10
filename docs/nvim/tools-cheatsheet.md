# Neovim Tools Cheatsheet

Neovim から起動するツール系のメモをまとめたもの。

## 汎用キーバインド

### 検索・ナビゲーション

| キー          | モード | 説明                       |
| ------------- | ------ | -------------------------- |
| `/`           | n      | 検索（very magic）         |
| `?`           | n      | リテラル検索（very nomagic）|
| `<leader>nh`  | n      | 検索ハイライトをクリア     |
| `M`           | n, x, o | 対応する括弧にジャンプ   |

### 編集

| キー           | モード | 説明                       |
| -------------- | ------ | -------------------------- |
| `x`            | n      | 削除（レジスタ汚さない）   |
| `X`            | n      | 行末まで削除（レジスタ汚さない）|
| `x`            | x      | 選択削除（レジスタ汚さない）|
| `p`            | x      | ペースト（レジスタ上書きしない）|
| `<`            | x      | インデント左（再選択維持） |
| `>`            | x      | インデント右（再選択維持） |
| `<leader>+`    | n      | 数値をインクリメント       |
| `<leader>-`    | n      | 数値をデクリメント         |
| `<C-g><C-u>`   | i      | 単語を大文字に             |
| `<C-g><C-l>`   | i      | 単語を小文字に             |
| `<C-g><C-k>`   | i      | 単語の先頭文字を大文字に   |
| `<C-g><C-t>`   | i      | 単語の大小文字をトグル     |

### テキストオブジェクト

| キー       | モード | 説明                       |
| ---------- | ------ | -------------------------- |
| `i<space>` | o, x   | inner WORD                 |
| `a"`       | x, o   | ダブルクォート内（`i"` 相当）|
| `a'`       | x, o   | シングルクォート内（`i'` 相当）|
| `` a` ``   | x, o   | バッククォート内（`` i` `` 相当）|

### マクロ

| キー | モード | 説明                       |
| ---- | ------ | -------------------------- |
| `q`  | n      | Q prefix / 録画停止        |
| `Q`  | n      | q レジスタのマクロ実行     |

### パス操作

| キー          | 説明                                 |
| ------------- | ------------------------------------ |
| `<leader>cp`  | 相対パスをコピー                     |
| `<leader>cP`  | 絶対パスをコピー                     |
| `<leader>cn`  | ファイル名をコピー（例: `foo.lua`）  |
| `<leader>cN`  | ファイル名（拡張子なし、例: `foo`） |

### ウィンドウ

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>wv`  | 縦分割                 |
| `<leader>wh`  | 横分割                 |
| `<leader>we`  | 分割を均等化           |
| `<leader>wx`  | 現在の分割を閉じる     |

### タブ

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>to`  | 新規タブ               |
| `<leader>tx`  | タブを閉じる           |
| `<leader>tn`  | 次のタブ               |
| `<leader>tp`  | 前のタブ               |
| `<leader>tf`  | 現在バッファを新規タブで開く |

### ターミナル

| キー           | モード | 説明                   |
| -------------- | ------ | ---------------------- |
| `<Esc><Esc>`   | t      | ターミナルモード終了   |

## LSP

### 基本操作

| キー          | モード | 説明                       |
| ------------- | ------ | -------------------------- |
| `K`           | n      | ホバードキュメント         |
| `<leader>rn`  | n      | シンボルをリネーム         |
| `<leader>ca`  | n, v   | コードアクション           |
| `gl`          | n      | 診断をフロートで表示       |
| `<leader>uh`  | n      | Inlay Hints トグル         |

### ジャンプ（Snacks Picker 経由）

| キー          | 説明                   |
| ------------- | ---------------------- |
| `gd`          | 定義へジャンプ         |
| `gD`          | 宣言へジャンプ         |
| `gr`          | 参照を一覧             |
| `gI`          | 実装へジャンプ         |
| `gy`          | 型定義へジャンプ       |
| `<leader>ss`  | LSP シンボル           |
| `<leader>sS`  | ワークスペースシンボル |

### 補完（nvim-cmp）

| キー        | 説明                   |
| ----------- | ---------------------- |
| `<C-j>`     | 次の候補を選択         |
| `<C-k>`     | 前の候補を選択         |
| `<CR>`      | 候補を確定             |
| `<C-Space>` | 補完メニューを手動表示 |

### Python 仮想環境

| キー         | 説明                   |
| ------------ | ---------------------- |
| `<leader>cv` | 仮想環境を選択         |

## Conform（フォーマッター）

| キー         | 説明                                 |
| ------------ | ------------------------------------ |
| `<leader>fm` | バッファをフォーマット（LSP fallback） |

対応言語:

| 言語                      | フォーマッター             |
| ------------------------- | -------------------------- |
| Python                    | ruff_format + ruff_fix     |
| TypeScript / JavaScript   | biome_check                |
| JSON                      | biome                      |
| YAML / Markdown           | prettier                   |
| Terraform                 | terraform_fmt              |
| Shell / Bash              | shfmt                      |
| Go                        | goimports + gofumpt        |
| Rust                      | rustfmt                    |

## CSV View（csvview.nvim）

CSV / TSV を罫線付きテーブルで表示・編集する。`csv` / `tsv` を開くと自動起動し、編集に追従して非同期で整列する。

### コマンド

| コマンド                    | 説明                               |
| --------------------------- | ---------------------------------- |
| `:CsvViewToggle [options]`  | 表示のオン / オフを切り替え        |
| `:CsvViewEnable [options]`  | 表示を有効化                       |
| `:CsvViewDisable`           | 表示を無効化                       |
| `:CsvViewInfo`              | 区切り文字 / ヘッダー / 行列数を表示 |

`[options]` には `setup()` と同じ設定を `key=value` で渡せる。例: `:CsvViewToggle delimiter=; display_mode=highlight`。

### キーバインド

| キー         | モード | 説明                              |
| ------------ | ------ | --------------------------------- |
| `<leader>uv` | n      | CSV View をトグル（どこでも有効） |

以下は **CSV View 有効時のバッファ内のみ**で効く。

| キー        | モード | 説明                                |
| ----------- | ------ | ----------------------------------- |
| `if`        | o, x   | フィールド内を選択（inner field）   |
| `af`        | o, x   | フィールド全体を選択（区切り含む）  |
| `<Tab>`     | n, v   | 次のフィールド末尾へ                |
| `<S-Tab>`   | n, v   | 前のフィールド末尾へ                |
| `<Enter>`   | n, v   | 同じ列のまま次の行へ                |
| `<S-Enter>` | n, v   | 同じ列のまま前の行へ                |

### 現在の設定

- `display_mode = "border"`（`│` で罫線を引くテーブル表示。色分けだけにするなら `"highlight"`）
- コメント行として `#` と `//` を認識
- 区切り文字はファイルタイプから自動判定（`csv`→`,` / `tsv`→`\t`）。判定に失敗した場合は `,` `\t` `;` `|` `:` 空白 の順で推定

> 設定ファイル: `config/nvim/lua/config/plugins/csvview.lua`。Neovim 0.10+ が必要。

## Markdown（render-markdown.nvim / snacks.image / arto.vim）

`.md` を開くと自動でバッファ内装飾レンダリングが始まる（見出し・テーブル・チェックボックス・
コードブロック・callout）。編集中も描画が持続し、カーソル行だけ生テキストに戻る。

役割分担:

| 用途                                 | ツール                                  |
| ------------------------------------ | --------------------------------------- |
| 編集しながら読む（バッファ内装飾）   | render-markdown.nvim（ft=markdown 自動） |
| 画像のインライン表示                 | snacks.image（kitty graphics。Ghostty/herdr 対応済み） |
| GitHub 完全再現でじっくり読む        | arto.vim（macOS ネイティブの別窓ビューア） |

### コマンド

| コマンド                   | 説明                                     |
| -------------------------- | ---------------------------------------- |
| `:RenderMarkdown toggle`   | 装飾レンダリングの全体トグル             |
| `:RenderMarkdown buf_toggle` | 現在バッファのみトグル                 |
| `:Arto`                    | 現在のファイルを Arto (別窓ビューア) で開く |

> 設定ファイル: `config/nvim/lua/config/plugins/render-markdown.lua` / `arto.lua`。
> 画像表示は `snacks.lua` の `image = { enabled = true }`。treesitter の `markdown` / `markdown_inline` パーサーが前提。

## Gitsigns

### Hunk 移動

| キー  | 説明                 |
| ----- | -------------------- |
| `]h`  | 次の hunk へ         |
| `[h`  | 前の hunk へ         |
| `]H`  | 最後の hunk へ       |
| `[H`  | 最初の hunk へ       |

### Hunk 操作

| キー           | モード | 説明                   |
| -------------- | ------ | ---------------------- |
| `<leader>ghs`  | n, x   | hunk をステージ        |
| `<leader>ghr`  | n, x   | hunk をリセット        |
| `<leader>ghS`  | n      | バッファ全体をステージ |
| `<leader>ghu`  | n      | ステージを取り消し     |
| `<leader>ghR`  | n      | バッファ全体をリセット |

### プレビュー / Blame / Diff

| キー           | 説明                           |
| -------------- | ------------------------------ |
| `<leader>ghp`  | hunk をインラインプレビュー    |
| `<leader>ghb`  | 行の blame（フル表示）         |
| `<leader>ghB`  | バッファ全体の blame           |
| `<leader>ghd`  | このファイルの diff             |
| `<leader>ghD`  | 親コミット（`~`）との diff     |

### テキストオブジェクト

| キー  | モード | 説明           |
| ----- | ------ | -------------- |
| `ih`  | o, x   | hunk を選択    |

## 変更セットのレビュー（hunk）

Diffview は廃止 (複雑すぎた)。変更セット全体のレビューは nvim の外の **hunk**
(herdr の `Prefix + Shift + H`、詳細は [docs/hunk/COMMANDS.md](../hunk/COMMANDS.md)) で行う。
作業中はペインで開きっぱなしにしておくと `--watch` が自分の編集にも追従する。

役割分担:

| 用途                         | ツール                              |
| ---------------------------- | ----------------------------------- |
| 1 ファイルの hunk 単位の確認 | gitsigns (`<leader>ghp` など)       |
| 変更セット全体のレビュー     | hunk (`Prefix + Shift + H`)         |
| ステージング・コミット       | lazygit (`<leader>lg`)              |
| ファイル履歴・コンフリクト   | lazygit                             |

## Trouble（診断 / Quickfix）

| キー         | 説明                       |
| ------------ | -------------------------- |
| `<leader>xw` | ワークスペース診断         |
| `<leader>xd` | 現在バッファの診断         |
| `<leader>xq` | Quickfix リスト            |
| `<leader>xl` | Location リスト            |
| `<leader>xt` | TODO コメント一覧          |

## Overlook（Peek）

### エディタ側

| キー         | 説明                       |
| ------------ | -------------------------- |
| `<leader>pd` | 定義をプレビュー           |
| `<leader>pp` | カーソル位置をプレビュー   |
| `<leader>pc` | 全ポップアップを閉じる     |
| `<leader>pu` | 最後のポップアップを復元   |
| `<leader>pf` | ポップアップとエディタ間でフォーカス切替 |
| `<leader>ps` | ポップアップを横分割で開く |
| `<leader>pv` | ポップアップを縦分割で開く |

### ポップアップ内

| キー              | 説明                     |
| ----------------- | ------------------------ |
| `<CR>`            | 元のウィンドウで開く     |
| `<C-CR>` / `;`   | 縦分割で開く             |

## Noice（メッセージ）

| キー          | 説明                       |
| ------------- | -------------------------- |
| `<leader>snl` | 最後のメッセージを表示     |
| `<leader>snh` | メッセージ履歴             |
| `<leader>sna` | 全メッセージを表示         |
| `<leader>snd` | 全メッセージを dismiss     |

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
| ファイルを開く | `<leader><space>` | Smart Find Files（バッファ + 最近 + ファイル。hidden を含む） |
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
| `<leader><space>`  | Smart Find Files（hidden を含む）                |
| `<leader>,`        | Buffers                                          |
| `<leader>/`        | Grep                                             |
| `<leader>:`        | Command History                                  |
| `<leader>n`        | Notification History                             |

#### Picker Toggles

| キー      | 説明                              |
| --------- | --------------------------------- |
| `<A-h>`   | hidden files の表示を切り替え     |
| `<A-i>`   | ignored files の表示を切り替え    |

`ignored` は既定ではオフ。`node_modules` など `.gitignore` 対象を見たいときだけ `<A-i>` を使う。

#### Find

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>fc`  | Find Config File       |
| `<leader>fp`  | Projects               |

#### Git

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>gb`  | Git Branches           |
| `<leader>gl`  | Git Log                |
| `<leader>gL`  | Git Log Line           |
| `<leader>gs`  | Git Status             |
| `<leader>gS`  | Git Stash              |
| `<leader>gd`  | Git Diff (Hunks)       |
| `<leader>gf`  | Git Log File           |
| `<leader>gB`  | Git Browse（GitHub で開く）|

#### Grep

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>sb`  | Buffer Lines           |
| `<leader>sB`  | Grep Open Buffers      |
| `<leader>sg`  | Grep                   |
| `<leader>sw`  | Visual selection / word |

#### Search

| キー          | 説明                   |
| ------------- | ---------------------- |
| `<leader>s"`  | Registers              |
| `<leader>s/`  | Search History         |
| `<leader>sa`  | Autocmds               |
| `<leader>sC`  | Commands               |
| `<leader>sd`  | Diagnostics            |
| `<leader>sD`  | Buffer Diagnostics     |
| `<leader>sh`  | Help Pages             |
| `<leader>sH`  | Highlights             |
| `<leader>si`  | Icons                  |
| `<leader>sj`  | Jumps                  |
| `<leader>sk`  | Keymaps                |
| `<leader>sl`  | Location List          |
| `<leader>sm`  | Marks                  |
| `<leader>sM`  | Man Pages              |
| `<leader>sp`  | Plugin Spec            |
| `<leader>sq`  | Quickfix List          |
| `<leader>sR`  | Resume（前回の Picker を再開） |
| `<leader>su`  | Undo History           |
| `<leader>uC`  | Colorschemes           |

#### LSP

| キー          | 説明                   |
| ------------- | ---------------------- |
| `gd`          | Go to Definition       |
| `gD`          | Go to Declaration      |
| `gr`          | Find References        |
| `gI`          | Go to Implementation   |
| `gy`          | Go to Type Definition  |
| `<leader>ss`  | LSP Symbols            |
| `<leader>sS`  | Workspace Symbols      |

### Zen Mode

| キー         | 説明                                     |
| ------------ | ---------------------------------------- |
| `<leader>z`  | Zen Mode（集中モード、UI を最小化）      |
| `<leader>Z`  | Zoom（現在のウィンドウを最大化）         |

### Dim

| キー         | 説明                                     |
| ------------ | ---------------------------------------- |
| `<leader>D`  | スコープ外をフェード（トグル）           |

### Rename

| キー          | 説明                                     |
| ------------- | ---------------------------------------- |
| `<leader>cR`  | ファイルリネーム                         |

### Treesitter Context

| キー         | 説明                                     |
| ------------ | ---------------------------------------- |
| `<leader>ut` | Treesitter Context の表示をトグル        |

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
