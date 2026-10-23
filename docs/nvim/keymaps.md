# キーマップ辞書

この設定で定義・上書きしているキーの一覧。Neovim 標準の操作は [editing.md](editing.md) を参照。
Leader は `<Space>`。押して待つと which-key が続きの候補を出す。

定義の場所 (`config/nvim/lua/config/` 以下):

- 素のキーの上書き・ウィンドウ・タブ・パスのコピー: `core/keymaps.lua`
- picker・Git の picker・LSP ジャンプ: `plugins/snacks.lua`
- LSP (`K` `<leader>rn` など): `plugins/lsp/init.lua`
- それ以外: `plugins/` の各プラグインのファイル
- `<leader>` のグループ名 (which-key に出る名前): `plugins/which-key.lua`。このページの見出しと揃える

## プラグイン別の索引

このページは用途別 (prefix 別) に並べているので、プラグインから引くときはここを見る。

| プラグイン                  | キー                                                                                                  | 詳しくは                                                         |
| --------------------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| snacks.nvim (picker)        | `<leader><space>` `<leader>,` `<leader>/` `<leader>:` `<leader>f*` `<leader>s*`                       | [Leader キー](#leader-キー)、[Picker](#picker)                   |
| snacks.nvim (LSP・Git)      | `gd` `gD` `gr` `gI` `gy`、`<leader>g*` (`<leader>gh*` 以外)、`<leader>lg` `<leader>lf`                | [LSP](#lsp)、[Leader キー](#leader-キー)                         |
| snacks.nvim (その他)        | `<leader>e` explorer、`<leader>z` `<leader>Z` `<leader>D`、`<leader>cR`、`ii` `ai` `[i` `]i` (scope)  | [Explorer](#explorer)、[ダッシュボード](#ダッシュボード)         |
| nvim-treesitter-textobjects | `af` `if` `ac` `ic` `aa` `ia`、`]f` `[f` `]c` `[c` `]a` `[a` (大文字で末尾)、`;` `,` (移動の繰り返し) | [テキストオブジェクト](#テキストオブジェクト)、[Normal](#normal) |
| nvim-treesitter-context     | `<leader>ut`                                                                                          |                                                                  |
| gitsigns.nvim               | `]h` `[h` `]H` `[H`、`<leader>gh*`、`ih`                                                              | [Leader キー](#leader-キー)                                      |
| nvim-surround               | `ys{motion}{c}` `yss{c}` `ds{c}` `cs{old}{new}`、Visual `S{c}` `gS{c}`、Insert `<C-g>s`               | [editing.md](editing.md#surround)                                |
| Comment.nvim                | `gcc` `gc{motion}` `gbc` `gb{motion}` `gco` `gcO` `gcA`                                               | [editing.md](editing.md#コメント)                                |
| dial.nvim                   | `<C-a>` `<C-x>` (Normal・Visual)、Visual `g<C-a>` `g<C-x>`、`<leader>+` `<leader>-`                   | [editing.md](editing.md#増減と切り替え)                          |
| yanky.nvim                  | `y`、`<C-p>` `<C-n>` (貼った直後)、`<leader>y`                                                        | [Normal](#normal)                                                |
| undo-glow.nvim              | `u` `U`、`p` `P` `gp` `gP` `]p` `[p` (yanky の貼り付けを光らせる)                                     | [Normal](#normal)                                                |
| vim-matchup                 | `M` (自前のラッパー)、`%` `g%` `[%` `]%`、`i%` `a%`                                                   | [Normal](#normal)                                                |
| better-escape.nvim          | `jk`                                                                                                  | [Insert](#insert)                                                |
| nvim-lspconfig (LSP)        | `K` `gl` `<leader>rn` `<leader>ca` `<leader>uh` `<leader>lR`                                          | [LSP](#lsp)                                                      |
| blink.cmp                   | 補完メニューの中の `<C-j>` `<C-k>` `<CR>` `<C-e>` など                                                | [補完](#補完-blinkcmp)                                           |
| conform.nvim                | `<leader>fm`                                                                                          | [整形](#整形-conform)                                            |
| trouble.nvim                | `<leader>xw` `<leader>xd` `<leader>xq` `<leader>xl` `<leader>xt`                                      | [Trouble](#trouble)                                              |
| todo-comments.nvim          | `]t` `[t` (`<leader>xt` の一覧もこれが前提)                                                           |                                                                  |
| overlook.nvim               | `<leader>p*`                                                                                          | [Leader キー](#leader-キー)                                      |
| noice.nvim                  | `<leader>sn*`                                                                                         | [Leader キー](#leader-キー)                                      |
| csvview.nvim                | `<leader>uv`、CSV の中の `if` `af` `<Tab>` `<Enter>`                                                  | [CSV View](#csv-view)                                            |
| venv-selector.nvim          | `<leader>cv`                                                                                          |                                                                  |
| claudecode.nvim             | `<leader>a*`                                                                                          | [Claude Code](#leadera-claude-code)                              |
| arto.vim                    | `<leader>m` (Markdown のときだけ)、`:Arto`                                                            | [Markdown](#markdown)                                            |
| lazy.nvim / mason.nvim      | キーなし。`:Lazy` / `:Mason` で開く                                                                   | [lazy.nvim](#lazynvim-lazy)、[Mason](#mason-mason)               |

キーを持たず自動で動くもの: nvim-autopairs (括弧を閉じる)、nvim-ts-autotag (タグを閉じる)、which-key (候補を出す)、incline (右下のファイル名)、satellite (スクロールバー)、vimade (非アクティブなウィンドウを薄く)、modes (モードで色を変える)、nvim-early-retirement (古いバッファを閉じる)、fidget (LSP の進捗)、vimdoc-ja (`:h` を日本語で開く)、nvim-highlight-colors (色コードの手前に色見本)。

## 上書きしているキー

### Normal

| キー                            | 動作                                                                                      | 素の Vim          |
| ------------------------------- | ----------------------------------------------------------------------------------------- | ----------------- |
| `x`                             | レジスタを汚さない削除オペレータ (`xx` で行、`xiw` で単語、`xl` で 1 文字)                | 1 文字削除        |
| `X`                             | 行末までレジスタを汚さず削除                                                              | 前の 1 文字を削除 |
| `y`                             | ヤンク (ヤンク履歴に記録)                                                                 |                   |
| `p` / `P`                       | 後ろ / 前に貼る (貼った範囲がハイライト)                                                  |                   |
| `gp` / `gP`                     | 貼って、カーソルを貼った範囲の直後へ (続けて貼れる)                                       |                   |
| `]p` / `[p`                     | 今の行のインデントに揃えて下 / 上に行単位で貼る                                           |                   |
| `<C-p>` / `<C-n>`               | 貼った直後に、ヤンク履歴の前 / 次の項目へ差し替える (カーソルを動かすと解除)              | 上下移動          |
| `u` / `U`                       | undo / redo (変わった範囲がハイライト)                                                    | `U` は行の undo   |
| `q`                             | prefix。`qq` で記録開始、`qo` で `:only!`、`qt` で直前のバッファ。記録中は停止            | 記録開始          |
| `Q`                             | `@q` を再生 (`3Q` で 3 回)。記録中に押すと停止してすぐ 1 回再生                           | Ex モード         |
| `M`                             | 対応する括弧・`if` / `else` / `end` へ (`if` からは `end` へ直行)                         | 画面中央の行へ    |
| `;` / `,`                       | 直前の移動を同じ向き / 逆向きに繰り返す。`f` `t` に加えて `]h` `]t` `]f` `]c` `]a` も対象 | `f` `t` だけ      |
| `/`                             | very magic で前方検索 (`/\v`)                                                             |                   |
| `?`                             | リテラルで後方検索 (`?\V`)                                                                |                   |
| `n` / `N`                       | 次 / 前の一致へ移動して画面中央に                                                         |                   |
| `<Esc>`                         | 検索ハイライトを消す (`<leader>nh` も同じ)                                                |                   |
| `<C-d>` / `<C-u>`               | 半ページ移動して画面中央に                                                                |                   |
| `J`                             | 行を結合してもカーソルを動かさない                                                        |                   |
| `i` / `A`                       | 空行ならインデント位置から書き始める                                                      |                   |
| `<C-a>` / `<C-x>`               | カーソル下の値を増減・切り替え ([対象](editing.md#増減と切り替え))                        | 数値のみ          |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | ウィンドウ移動。端なら herdr のペインへ (Terminal モードでも有効)                         |                   |

### Visual

| キー                | 動作                                   |
| ------------------- | -------------------------------------- |
| `x`                 | 選択範囲をレジスタを汚さず削除         |
| `p` / `P`           | 選択範囲を置き換える。レジスタは残る   |
| `y`                 | ヤンク (ヤンク履歴に記録)              |
| `<` / `>`           | インデントして選択を保つ               |
| `<C-a>` / `<C-x>`   | 選択内の数値をまとめて増減             |
| `g<C-a>` / `g<C-x>` | 選択した行を 1, 2, 3 … と連番にする    |
| `/` / `?`           | Normal と同じ                          |
| `S{char}`           | 選択範囲を囲む (`gS` だと別の行に置く) |

### Insert

| キー         | 動作                       |
| ------------ | -------------------------- |
| `jk`         | `<Esc>`                    |
| `<C-g><C-u>` | カーソル位置の単語を大文字 |
| `<C-g><C-l>` | カーソル位置の単語を小文字 |
| `<C-g><C-k>` | 単語の先頭だけ大文字       |
| `<C-g><C-t>` | 単語の大文字・小文字を反転 |

補完メニューが出ているときのキーは [補完](#補完-blinkcmp) を参照。

### Terminal

| キー                            | 動作                                                  |
| ------------------------------- | ----------------------------------------------------- |
| `jk`                            | Normal モードへ (lazygit の中では `k` をそのまま送る) |
| `<Esc><Esc>`                    | Normal モードへ                                       |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | ウィンドウ / ペイン移動                               |

## LSP

| キー                        | 動作                                                     |
| --------------------------- | -------------------------------------------------------- |
| `gd`                        | 定義へ (候補が複数あれば picker)                         |
| `gD`                        | 宣言へ                                                   |
| `gr`                        | 参照一覧                                                 |
| `gI`                        | 実装へ                                                   |
| `gy`                        | 型定義へ                                                 |
| `K`                         | ホバー (ドキュメント)                                    |
| `gl`                        | カーソル位置の診断をフロートで表示                       |
| `]d` / `[d`                 | 次 / 前の診断へ (`]D` `[D` で最後 / 最初。Neovim 標準)   |
| `<leader>rn`                | シンボルをリネーム                                       |
| `<leader>ca`                | コードアクション (Visual でも可)                         |
| `<leader>ss` / `<leader>sS` | シンボル一覧 (ファイル / ワークスペース)                 |
| `<leader>uh`                | inlay hints の表示を切り替え (対応するサーバーのみ)      |
| `<leader>lR`                | LSP を再起動 (※ 現状は動かない。代わりに `:lsp restart`) |

`gr` は待たずに発動する (`nowait`) ので、Neovim 標準の `grn` `gra` `grr` `gri` `grt` は使えない。

## `[` / `]` で始まる移動

| キー                    | 移動先                                                            | 提供元        |
| ----------------------- | ----------------------------------------------------------------- | ------------- |
| `]f` / `[f`             | 次 / 前の関数の先頭 (`]F` `[F` で末尾)                            | treesitter    |
| `]c` / `[c`             | 次 / 前のクラスの先頭 (`]C` `[C` で末尾)                          | treesitter    |
| `]a` / `[a`             | 次 / 前の引数                                                     | treesitter    |
| `]h` / `[h`             | 次 / 前の hunk (`]H` `[H` で最後 / 最初)。diff モードでは変更箇所 | gitsigns      |
| `]t` / `[t`             | 次 / 前の `TODO:` `FIXME:` などのコメント (コロン付きのもの)      | todo-comments |
| `]i` / `[i`             | インデントブロックの下端 / 上端                                   | snacks scope  |
| `]%` / `[%`             | 囲んでいるブロックの終わり / 始まりのキーワード                   | vim-matchup   |
| `]d` / `[d`             | 次 / 前の診断                                                     | Neovim 標準   |
| `]q` / `[q`             | quickfix の次 / 前 (`]Q` `[Q` で最後 / 最初)                      | Neovim 標準   |
| `]b` / `[b`             | 次 / 前のバッファ                                                 | Neovim 標準   |
| `]<Space>` / `[<Space>` | 下 / 上に空行を足す                                               | Neovim 標準   |
| `]p` / `[p`             | インデントを揃えて貼る (移動ではない)                             | yanky         |
| `]n` / `[n` (Visual)    | 次 / 前の構文ノードを選択                                         | Neovim 標準   |

`]c` `[c` (diff の変更箇所)、`]a` `[a` (引数リスト)、`]t` `[t` (タグ) は Neovim 標準を上書きしている。

`]h` `[h`・`]t` `[t` と、提供元が treesitter の移動は、続けて `;` (同じ向き) / `,` (逆向き) で繰り返せる。

## テキストオブジェクト

`d` `c` `y` `v` などの後に続ける。標準の `iw` `i"` `i(` `it` `ip` などは [editing.md](editing.md#テキストオブジェクト) を参照。

| キー               | 対象                                                      | 提供元       |
| ------------------ | --------------------------------------------------------- | ------------ |
| `if` / `af`        | 関数の中身 / 関数全体                                     | treesitter   |
| `ic` / `ac`        | クラスの中身 / クラス全体                                 | treesitter   |
| `ia` / `aa`        | 引数 / 引数 (区切りのカンマ込み)                          | treesitter   |
| `ii` / `ai`        | インデントブロック / 前後の見出し行 (`def` や `end`) 込み | snacks scope |
| `ih`               | git hunk                                                  | gitsigns     |
| `i%` / `a%`        | `if` … `end` などのブロックの中 / 全体                    | vim-matchup  |
| `an` / `in`        | 構文ノードを 1 段外へ / 内へ (Visual で連打して広げる)    | Neovim 標準  |
| `i<Space>`         | `iW` (空白区切りの WORD)                                  | 自前         |
| `a"` `a'` `` a` `` | クォート込み。標準と違って後ろの空白は含めない            | 自前         |

## Leader キー

### 単独

| キー                      | 動作                                                                              |
| ------------------------- | --------------------------------------------------------------------------------- |
| `<leader><space>`         | ファイルを開く (バッファ・最近・全ファイルからよく使う順。hidden 込み)            |
| `<leader>,`               | バッファ一覧                                                                      |
| `<leader>/`               | grep (リテラル)                                                                   |
| `<leader>:`               | コマンド履歴                                                                      |
| `<leader>e`               | エクスプローラー                                                                  |
| `<leader>y`               | ヤンク履歴から選んで貼る                                                          |
| `<leader>z` / `<leader>Z` | Zen モード / 今のウィンドウを最大化                                               |
| `<leader>D`               | カーソルのあるスコープ以外を暗くする                                              |
| `<leader>+` / `<leader>-` | `<C-a>` / `<C-x>` と同じ                                                          |
| `<leader>n`               | snacks の通知履歴 (※ snacks の notifier を切っているので空。`<leader>snh` を使う) |
| `<leader>nh`              | 検索ハイライトを消す                                                              |
| `<leader>m`               | 開いている Markdown を Arto で開く (Markdown のときだけ)                          |

### `<leader>f` ファイル

| キー         | 動作                                                             |
| ------------ | ---------------------------------------------------------------- |
| `<leader>fa` | gitignore されたファイルも含めて探す (`node_modules` などは除外) |
| `<leader>fc` | nvim の設定ファイルを探す                                        |
| `<leader>fp` | プロジェクト一覧                                                 |
| `<leader>fm` | 整形 ([対応表](#整形-conform))                                   |

### `<leader>s` 検索

| キー                        | 動作                                     |
| --------------------------- | ---------------------------------------- |
| `<leader>sb`                | 今のバッファの行を絞り込む               |
| `<leader>sB`                | 開いているバッファ全部を grep            |
| `<leader>sg`                | grep (`<leader>/` と同じ)                |
| `<leader>sG`                | gitignore されたファイルも含めて grep    |
| `<leader>sw`                | カーソル下の単語 / 選択範囲で grep       |
| `<leader>sR`                | 前回の picker を開き直す                 |
| `<leader>ss` / `<leader>sS` | LSP シンボル (ファイル / ワークスペース) |
| `<leader>sd` / `<leader>sD` | 診断 (全体 / このバッファ)               |
| `<leader>sq` / `<leader>sl` | quickfix / location list                 |
| `<leader>sj` / `<leader>sm` | ジャンプ履歴 / マーク                    |
| `<leader>su`                | undo の履歴 (選ぶとその時点に戻る)       |
| `<leader>s"`                | レジスタ                                 |
| `<leader>s/`                | 検索履歴                                 |
| `<leader>sk`                | キーマップ                               |
| `<leader>sC`                | コマンド                                 |
| `<leader>sh` / `<leader>sM` | Neovim のヘルプ / man ページ             |
| `<leader>sH`                | ハイライトグループ                       |
| `<leader>si`                | アイコン                                 |
| `<leader>sa`                | autocmd                                  |
| `<leader>sp`                | プラグインの spec                        |

### `<leader>sn` メッセージ (noice)

| キー          | 動作                       |
| ------------- | -------------------------- |
| `<leader>snh` | メッセージ履歴             |
| `<leader>snl` | 最後のメッセージ           |
| `<leader>sna` | すべてのメッセージ         |
| `<leader>snd` | 表示中の通知をすべて閉じる |

### `<leader>g` Git (picker)

| キー         | 動作                                       |
| ------------ | ------------------------------------------ |
| `<leader>gs` | git status                                 |
| `<leader>gd` | 変更 (hunk) の一覧                         |
| `<leader>gl` | git log                                    |
| `<leader>gf` | このファイルの log                         |
| `<leader>gL` | この行の log                               |
| `<leader>gb` | ブランチ                                   |
| `<leader>gS` | stash                                      |
| `<leader>gB` | リモート (GitHub) のページをブラウザで開く |

### `<leader>gh` hunk (gitsigns)

| キー          | 動作                                                                |
| ------------- | ------------------------------------------------------------------- |
| `<leader>ghp` | hunk の差分をその場に表示                                           |
| `<leader>ghs` | hunk をステージ (Visual なら選択行だけ)                             |
| `<leader>ghr` | hunk を元に戻す (Visual なら選択行だけ)                             |
| `<leader>ghu` | 直前のステージを取り消す                                            |
| `<leader>ghS` | ファイル全体をステージ                                              |
| `<leader>ghR` | ファイル全体を元に戻す                                              |
| `<leader>ghb` | この行の blame (コミット全文)                                       |
| `<leader>ghB` | ファイル全体の blame                                                |
| `<leader>ghd` | index との diff を分割で開く                                        |
| `<leader>ghD` | `HEAD~` との diff を分割で開く (直前のコミットの変更も含めて見える) |

### `<leader>l` lazygit

| キー         | 動作                                 |
| ------------ | ------------------------------------ |
| `<leader>lg` | lazygit を開く                       |
| `<leader>lf` | このファイルの log を lazygit で開く |

### `<leader>a` Claude Code

herdr の隣のペインの Claude Code とつないでいるときに使う。つなぎ方は [README の Claude Code と並べて使う](README.md#claude-code-と並べて使う)。

| キー                        | 動作                                                          |
| --------------------------- | ------------------------------------------------------------- |
| `<leader>as` (Visual)       | 選択範囲を Claude の入力欄に入れる (`@ファイル#L10-20` の形)  |
| `<leader>as` (Explorer)     | カーソル下のファイルを Claude の入力欄に入れる                |
| `<leader>ab`                | 今のファイルを Claude の入力欄に入れる                        |
| `<leader>aa` / `<leader>ad` | Claude の変更提案 (diff) を採用 / 却下 (`:w` / `:q` でも同じ) |

### `<leader>c` コード / コピー

| キー         | 動作                                   |
| ------------ | -------------------------------------- |
| `<leader>ca` | コードアクション                       |
| `<leader>cR` | ファイル名を変える (LSP に通知する)    |
| `<leader>cv` | Python の仮想環境を選ぶ                |
| `<leader>cp` | 相対パスをコピー                       |
| `<leader>cP` | 絶対パスをコピー                       |
| `<leader>cn` | ファイル名をコピー (`foo.lua`)         |
| `<leader>cN` | 拡張子なしのファイル名をコピー (`foo`) |

### `<leader>x` 一覧 (Trouble)

| キー         | 動作                                           |
| ------------ | ---------------------------------------------- |
| `<leader>xw` | プロジェクトの診断                             |
| `<leader>xd` | このバッファの診断                             |
| `<leader>xq` | quickfix                                       |
| `<leader>xl` | location list                                  |
| `<leader>xt` | プロジェクトの `TODO:` `FIXME:` などのコメント |

### `<leader>p` のぞき見 (overlook)

| キー         | 動作                               |
| ------------ | ---------------------------------- |
| `<leader>pd` | 定義をポップアップでのぞく         |
| `<leader>pp` | カーソル位置をポップアップでのぞく |
| `<leader>pf` | ポップアップと元の画面を行き来     |
| `<leader>ps` | ポップアップを横分割で開く         |
| `<leader>pv` | ポップアップを縦分割で開く         |
| `<leader>pc` | ポップアップをすべて閉じる         |
| `<leader>pu` | 最後に閉じたポップアップを戻す     |

ポップアップの中では `<CR>` で元のウィンドウに開き、`<C-CR>` か `;` で縦分割に開く。

### `<leader>w` ウィンドウ / `<leader>t` タブ

| キー         | 動作                       |
| ------------ | -------------------------- |
| `<leader>wv` | 縦に分割                   |
| `<leader>wh` | 横に分割                   |
| `<leader>we` | サイズを均等に             |
| `<leader>wx` | 今のウィンドウを閉じる     |
| `<leader>to` | 新しいタブ                 |
| `<leader>tf` | 今のバッファを新しいタブで |
| `<leader>tn` | 次のタブ                   |
| `<leader>tp` | 前のタブ                   |
| `<leader>tx` | 今のタブを閉じる           |

### `<leader>u` 表示の切り替え

| キー         | 動作                                      |
| ------------ | ----------------------------------------- |
| `<leader>uh` | inlay hints                               |
| `<leader>ut` | 画面上端の関数名表示 (treesitter-context) |
| `<leader>uv` | CSV のテーブル表示                        |
| `<leader>uC` | カラースキームを選ぶ                      |

## ツールの中のキー

### Picker

`<leader><space>` や `<leader>/` などで開く snacks picker の中のキー。入力欄 (Insert) でもリスト (Normal) でも効く。

| キー                        | 動作                                                    |
| --------------------------- | ------------------------------------------------------- |
| `<C-j>` / `<C-k>`           | 候補を上下 (`<C-n>` / `<C-p>` も同じ)                   |
| `<CR>`                      | 開く                                                    |
| `<C-v>` / `<C-s>` / `<C-t>` | 縦分割 / 横分割 / タブで開く                            |
| `<S-CR>`                    | 開くウィンドウを選んで開く                              |
| `<Tab>` / `<S-Tab>`         | 選択して次 / 前へ (複数選択)                            |
| `<C-a>`                     | すべて選択                                              |
| `<C-q>`                     | quickfix に送る (選んでいればそれだけ、なければ全部)    |
| `<C-d>` / `<C-u>`           | リストをスクロール                                      |
| `<C-f>` / `<C-b>`           | プレビューをスクロール                                  |
| `<A-p>` / `<A-m>`           | プレビューの表示 / picker の最大化を切り替え            |
| `<A-h>` / `<A-i>`           | hidden / ignored ファイルの表示を切り替え               |
| `<A-r>`                     | 正規表現を切り替え (grep は既定でリテラル)              |
| `<C-g>`                     | grep で、ripgrep で探し直すか結果を絞り込むかを切り替え |
| `<C-r><C-w>`                | 元のバッファのカーソル下の単語を入力                    |
| `<C-Up>` / `<C-Down>`       | 入力履歴                                                |
| `?`                         | キー一覧 (Normal で)                                    |
| `<Esc>` / `q`               | 閉じる (入力欄では 1 回目の `<Esc>` で Normal に入る)   |

### Explorer

`<leader>e` で開くファイルツリーの中のキー。

| キー         | 動作                                     |
| ------------ | ---------------------------------------- |
| `l` / `<CR>` | 開く / ディレクトリを展開                |
| `h`          | ディレクトリを閉じる                     |
| `<BS>`       | 親ディレクトリへ                         |
| `.`          | このディレクトリをルートにする           |
| `a`          | 追加 (末尾に `/` を付けるとディレクトリ) |
| `r`          | リネーム                                 |
| `d`          | 削除                                     |
| `c` / `m`    | コピー / 移動                            |
| `y` / `p`    | パスをヤンク / ヤンクしたファイルを貼る  |
| `o`          | macOS のアプリで開く                     |
| `P`          | プレビューを切り替え                     |
| `H` / `I`    | hidden / ignored の表示を切り替え        |
| `Z`          | すべて閉じる                             |
| `]g` / `[g`  | 次 / 前の git の変更があるファイル       |
| `]d` / `[d`  | 次 / 前の診断があるファイル              |
| `<leader>/`  | このディレクトリで grep                  |
| `q`          | 閉じる                                   |

### Trouble

`<leader>xw` `<leader>xd` `<leader>xq` などで開く一覧の中のキー。開くとフォーカスが一覧に移る。

| キー               | 動作                                         |
| ------------------ | -------------------------------------------- |
| `<CR>`             | その場所へ飛ぶ (一覧は開いたまま)            |
| `o`                | その場所へ飛んで一覧を閉じる                 |
| `<C-v>` / `<C-s>`  | 縦分割 / 横分割で開く                        |
| `p` / `P`          | プレビュー / カーソル移動で自動プレビュー    |
| `]]` / `[[`        | 次 / 前の項目 (`}` / `{` も同じ)             |
| `dd`               | 項目を一覧から消す (Visual なら `d`)         |
| `za` / `zR` / `zM` | 折りたたみの切り替え / 全部開く / 全部閉じる |
| `gb`               | 今のバッファだけに絞る / 戻す                |
| `s`                | 診断の重要度で絞る                           |
| `r`                | 更新                                         |
| `?`                | キー一覧                                     |
| `q`                | 閉じる                                       |

### 補完 (blink.cmp)

| キー                | 動作                                      |
| ------------------- | ----------------------------------------- |
| `<C-j>` / `<C-k>`   | 候補を上下 (`<C-n>` / `<C-p>` も同じ)     |
| `<CR>`              | 確定                                      |
| `<C-y>`             | 選んで確定                                |
| `<C-e>`             | 閉じる                                    |
| `<C-Space>`         | 補完を出す / ドキュメントの表示を切り替え |
| `<C-f>` / `<C-b>`   | ドキュメントをスクロール                  |
| `<Tab>` / `<S-Tab>` | スニペットの次 / 前の入力欄へ             |

補完の元は LSP・パス・スニペット・バッファの単語 (Lua では lazydev も)。関数の引数を打つとシグネチャが自動で出る。

### 整形 (conform)

`<leader>fm` で実行する。対応するフォーマッターがなければ LSP で整形する。

| 言語                    | フォーマッター                                                                |
| ----------------------- | ----------------------------------------------------------------------------- |
| Python                  | ruff_format + ruff_fix                                                        |
| TypeScript / JavaScript | biome (`check --write --unsafe` なので unsafe な修正も入る)                   |
| JSON                    | biome                                                                         |
| YAML / Markdown         | prettier                                                                      |
| Nix                     | nixfmt                                                                        |
| Go                      | goimports + gofumpt                                                           |
| Rust                    | rustfmt                                                                       |
| Terraform               | terraform_fmt                                                                 |
| Shell / Bash            | shfmt                                                                         |
| Lua                     | stylua (`config/nvim/stylua.toml`。桁を揃えた表は `-- stylua: ignore` で守る) |

### CSV View

`.csv` / `.tsv` を開くと罫線付きのテーブル表示になる。`<leader>uv` で切り替え、`:CsvViewInfo` で区切り文字などを確認。
区切り文字を指定して開き直すなら `:CsvViewToggle delimiter=;` のように渡す。
表示中のバッファでだけ効くキー:

| キー                    | 動作                                                                         |
| ----------------------- | ---------------------------------------------------------------------------- |
| `if` / `af`             | フィールドの中 / 区切りを含むフィールド (関数のテキストオブジェクトより優先) |
| `<Tab>` / `<S-Tab>`     | 次 / 前のフィールドの末尾へ                                                  |
| `<Enter>` / `<S-Enter>` | 同じ列のまま次 / 前の行へ                                                    |

`#` と `//` で始まる行はコメントとして扱う。区切り文字は拡張子から決め、判定できなければ `,` `\t` `;` `|` `:` 空白 の順で推定する。

### Markdown

バッファでは生テキストのまま編集する (装飾表示はしない)。Markdown 内の画像も描かない (herdr 経由だと崩れるため)。
画像込みで、GitHub と同じ見た目でじっくり読むときは `<leader>m` (`:Arto`) で別窓のビューアに開く。

### lazygit

[docs/git/lazygit.md](../git/lazygit.md) を参照。lazygit の中で `e` を押すと、起動元の nvim でファイルが開く。

### ダッシュボード

引数なしで `nvim` を起動すると出る画面のキー。

| キー | 動作                     |
| ---- | ------------------------ |
| `f`  | ファイルを探す           |
| `r`  | 最近開いたファイル       |
| `g`  | grep                     |
| `n`  | エクスプローラー         |
| `e`  | 空のバッファで書き始める |
| `q`  | 終了                     |

### lazy.nvim (`:Lazy`)

プラグインの管理画面。キーマップは割り当てていないので `:Lazy` で開く。

| キー      | 動作                                    |
| --------- | --------------------------------------- |
| `U`       | 全プラグインを更新                      |
| `C`       | 更新があるか確認するだけ                |
| `S`       | 同期 (インストール + 削除 + 更新)       |
| `X`       | spec から消したプラグインを削除         |
| `R`       | `lazy-lock.json` のバージョンに戻す     |
| `L`       | 更新履歴 (コミットログ)                 |
| `P`       | 起動時間のプロファイル                  |
| `<CR>`    | カーソル下のプラグインの詳細            |
| `u` / `x` | カーソル下のプラグインだけを更新 / 削除 |
| `?`       | キー一覧                                |
| `q`       | 閉じる                                  |

更新すると `config/nvim/lazy-lock.json` (リポジトリ直リンク) が書き換わるので、動作を確かめてからコミットする。
更新後に壊れたら `R` でロックファイルの版に戻せる。

### Mason (`:Mason`)

LSP サーバーなどのツールの管理画面。キーマップは割り当てていないので `:Mason` で開く。

| キー    | 動作                                 |
| ------- | ------------------------------------ |
| `i`     | カーソル下のパッケージをインストール |
| `u`     | カーソル下のパッケージを更新         |
| `U`     | すべて更新                           |
| `C`     | 古いパッケージがあるか確認           |
| `X`     | アンインストール                     |
| `<CR>`  | 詳細を開く / 閉じる                  |
| `<C-f>` | 言語で絞り込む                       |
| `g?`    | キー一覧                             |

自動で入れるサーバーは `plugins/lsp/init.lua` の `ensure_installed` に書く。nixd だけは Mason ではなく Nix (`home/`) で入れている。

## 色の意味

| 何が                   | 色の意味                                                                                   |
| ---------------------- | ------------------------------------------------------------------------------------------ |
| 一瞬光る範囲           | undo は赤、redo は緑、貼り付けは青                                                         |
| カーソル行・行番号     | Insert は水色、Visual は紫、`y` の入力待ちは黄、`d` の入力待ちは赤                         |
| 右下のファイル名       | 赤はエラーあり、`●` は未保存                                                               |
| 右端のスクロールバー   | カーソル・検索の一致・診断・git の変更の位置                                               |
| 色コードの手前の `■`   | その色の見本 (`#416bb0` `rgb(...)`、CSS の色名など)                                        |
| `TODO:` などのコメント | `FIX:` `FIXME:` はエラー、`HACK:` `WARN:` は警告、`TODO:` は情報、`NOTE:` はヒントと同じ色 |
