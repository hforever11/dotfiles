# Theme Notes

現在のテーマは `Catppuccin Latte` をマット（くすみ）にしたライトテーマ。

パレット（色コード）は `home/theme.nix` が単一ソースで、
home-manager が fzf / hunk / Neovim / Claude Code（statusline とカスタムテーマ）/
Ghostty の背景色・文字色・ANSI 16 色向けの設定ファイルを生成する
（生成するのは色だけで、各ツールの色以外の設定は直リンク側に置く）。
テーマ名の指定と、herdr / delta / lazygit / bat の色は
直リンクされた設定ファイル側で個別に指定する。

## 変更ポイント

### パレット (Neovim + fzf + hunk + Claude Code + Ghostty 共通)

- 単一ソース兼生成ロジック: [`home/theme.nix`](../home/theme.nix)

パレットの色コードを書き換えて rebuild すれば、
`~/.config/fzf/config`, `~/.config/hunk/config.toml`,
`~/.config/theme/palette.lua`, `~/.config/theme/palette.sh`, `~/.config/theme/ghostty`,
`~/.claude/themes/dotfiles.json` に反映される。
パレットのキー名（`base` / `surface0` / `text` など）は Catppuccin のロール名を
そのまま使い、別テーマに移る場合は対応色をマッピングする。

公式 Latte から意図的に外している値:

| キー              | 値        | 理由                                                                                               |
| ----------------- | --------- | -------------------------------------------------------------------------------------------------- |
| `base` / `mantle` | 二段暗い  | 眩しさ抑制。Ghostty `background` と揃える                                                          |
| `text`            | `#44455d` | 公式 `#4c4f69` より少し濃い herdr 公式サイトの実測値。Ghostty `foreground` / herdr `text` と揃える |
| アクセント 14 色  | マット版  | 下記                                                                                               |

アクセント（`rosewater`〜`lavender`）は公式の色相を保ったまま（ずれ 5° 以内。`yellow` だけは
暗くすると茶色に濁るため黄色寄りへ +6°）、OKLCH の彩度を 0.075〜0.13 に揃えて鮮やかさを抑えている。
公式の値は白に近い背景 `#eff1f5` 向けの明るさなので、二段暗くした背景の上では
明るく鮮やかな色（peach / yellow / sky / pink など）ほど浮いて光って見えるため。
彩度を落とすと近づく組（`mauve` と `blue`、`peach` と `yellow` など）は明度の差で見分けられるようにした。
`green` の色相は Claude Code の差分の数字（`#2f9d44`）と同じ 146°（公式 `#40a02b` の 140° はライト背景だとオリーブに濁る）。

Neovim は `colorschema.lua` がパレットを丸ごと `color_overrides` に渡すため、
ここで変えた値は Catppuccin 本体のハイライト（gitsigns / diff / 文字列など）にも反映される。

生成できない（別ファイルを読み込む仕組みがない）ため、次の 2 ファイルは手動で同じ値にする
（`home/theme.nix` の先頭コメントにも記載）:

| ファイル                                         | 項目                                                                                                            | パレットのキー                                           |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `config/herdr/config.toml`                       | `[theme.custom]` の `panel_bg` / `text` / `accent` / `mauve` `green` `yellow` `red` `blue` `teal` `peach`       | `mantle` / `text` / `blue` / 同名の色                    |
| `config/delta/themes/catppuccin-latte.gitconfig` | `file-style` / `line-numbers-minus-style` / `line-numbers-plus-style` と minus 系・plus 系・`map-styles` の混色 | `text` / `red` / `green` / `mauve` `blue` `sky` `yellow` |

### Neovim

- テーマ本体: [`config/nvim/lua/config/core/theme.lua`](../config/nvim/lua/config/core/theme.lua)
  が生成済みの `~/.config/theme/palette.lua` を `dofile` で読む
- colorscheme 適用: [`config/nvim/lua/config/plugins/colorschema.lua`](../config/nvim/lua/config/plugins/colorschema.lua)

`theme.lua` は `palette.lua` を読むだけで、`name` / `variant` / `transparent_background` /
パレット本体はすべて `home/theme.nix` が生成する。

注意:
`incline` / `modes` / `undo-glow` / `scrollbar` / `vimade` / `noice` は `theme.lua` の `palette()` を通して色を参照している。
別テーマのプラグイン（例: `folke/tokyonight.nvim`）に移る場合は `colorschema.lua` の差し替えが必要。

### Ghostty

- テーマ指定: [`config/ghostty/config`](../config/ghostty/config)

```conf
theme = Catppuccin Latte
config-file = ?~/.config/theme/ghostty
```

テーマ名はここを書き換えるだけ（候補は `ghostty +list-themes`）。
`background` / `foreground` と ANSI 16 色（`palette`）は `home/theme.nix` から生成した
`~/.config/theme/ghostty` を `config-file` で読む（Neovim と同じ値になる）。`config-file` はこのファイルを
読み終えた後に読まれるため、`config/ghostty/config` に同じ項目を書いても上書きされる。
ANSI の割り当ては Ghostty 同梱の `Catppuccin Latte` と同じで（1 red / 2 green / 3 yellow / 4 blue /
5 pink / 6 teal）、bright（9〜14）は通常色と同じ値にしている。
テーマ名の指定が効いているのは選択範囲の色などの残りの項目だけ。

### herdr

- テーマ指定: [`config/herdr/config.toml`](../config/herdr/config.toml)

```toml
[theme]
name = "catppuccin-latte"

[theme.custom]
panel_bg = "#d3d8e2"
text = "#44455d"
accent = "#416bb0"
mauve = "#69499c"
green = "#47894f"
# yellow / red / blue / teal / peach も同様
```

ビルトインテーマ名を指定するだけ。`[theme.custom]` はトークン上書き（省略可）。
herdr は別ファイルを読み込めないため、`panel_bg` / `text` / `accent` と色名のトークン
（`mauve` / `green` / `yellow` / `red` / `blue` / `teal` / `peach`。エージェントの状態表示などに使われる）は
`home/theme.nix` の `mantle` / `text` / `blue` / 同名の色と手動で同じ値にする。
`panel_bg` はペイン背景（`home/theme.nix` の `base`）より一段暗い `mantle` と同じ値にして
「グレーのチュロームが明るいペインを囲む」構成を作る。

ペイン枠線の色は 2 トークンに分かれる（枠線専用トークンは無い）。

| 対象               | トークン   | 現在値                         |
| ------------------ | ---------- | ------------------------------ |
| フォーカス中の枠線 | `accent`   | `#416bb0`（パレットの `blue`） |
| 非フォーカスの枠線 | `overlay0` | Latte 既定 `#9ca0b0`           |

`accent` は枠線のほか、選択中のタブの背景や navigate モード・メニューの強調にも使われる。
パレットの `blue` にしている理由:

- herdr はエージェントの状態を `green`（idle の ✓）/ `teal`（done）/ `yellow`（working）/ `red`（blocked）で、
  ブランチ名を `mauve` で表示する。`accent` が緑系だとフォーカス枠が idle の色に見えるため、
  これらと被らない `blue` にする（`blue` トークンは in-app トーストにしか使われず、
  `[ui.toast] delivery = "terminal"` では表示されない）
- Neovim の浮動ウィンドウの枠（`FloatBorder`）と Claude Code の確認ダイアログの枠
  （カスタムテーマの `permission`）も `blue` なので、アクティブな枠の色が揃う
- herdr のビルトイン `catppuccin-latte` の `accent` も公式の blue `#1e66f5`。それをマット版にした値になる

`[ui] accent` も同じ用途だが `[theme.custom] accent` が優先されるため使っていない。
`overlay0` は枠線専用ではなく **サイドバー見出し（`spaces` / `agents` など）と区切り記号**
にも使われるため、枠線のコントラストを稼ぐ目的で薄くしてはいけない。

`accent` を選ぶときの基準:

- エージェントの状態色（`green` / `teal` / `yellow` / `red`）や `mauve` に近い色は避ける
- フォーカス/非フォーカスの判別性は輝度比ではなく OKLab ΔE で見る（`blue` は 0.201）。
  Catppuccin のスタイルガイドはアクティブな枠を `lavender` としているが、
  このパレットの `lavender` `#7684c6` は `overlay0` と色相が近く ΔE 0.110 しかない
- 選択中のタブやメニュー項目では `accent` が背景、`panel_bg` が文字色になる。
  `panel_bg` との輝度比が低い色は文字が読みにくい（`blue` は 3.7:1）
- Ghostty 側の `alpha-blending = linear` と `adjust-box-thickness = 115%` で
  罫線は指定値より暗く・太く描かれる。暗く沈んで見える場合は一段明るい値を検討する

設定リファレンスは
<https://herdr.dev/docs/configuration/> を参照。`catppuccin-latte` / `tokyo-night-day` /
`gruvbox-light` などのライト variant もある（候補は `herdr --default-config` のコメント参照）。

### git (delta)

- 機能定義: [`config/git/config`](../config/git/config) の `[delta] features` と `[include] path`
- テーマ本体: [`config/delta/themes/catppuccin-latte.gitconfig`](../config/delta/themes/catppuccin-latte.gitconfig)（[catppuccin/delta](https://github.com/catppuccin/delta) 公式がベース）

公式からの変更点:

- `syntax-theme` を bat テーマ非依存の `none` に変更
- `file-style` を `home/theme.nix` の `text` に、`line-numbers-minus-style` / `line-numbers-plus-style` を
  `red` / `green` に変更
- minus 系 / plus 系（`*-emph-style` と `*-style`）の背景は `red` / `green` を、`map-styles` は
  `mauve` / `blue` / `sky` / `yellow` を、upstream と同じ比率（35% / 20%）で公式 base `#eff1f5` と混ぜた値。
  元の色を変えたらコメントの比率で計算し直す

別テーマに切り替えるときは、新しい delta テーマファイルを `config/delta/themes/` に置き、`config/git/config` の参照を差し替える。

### Claude Code

- statusline: [`claude/statusline.sh`](../claude/statusline.sh)
  が生成済みの `~/.config/theme/palette.sh` を実行時に `source` する
- UI テーマ: `home/theme.nix` が生成するカスタムテーマ `~/.claude/themes/dotfiles.json` を
  [`claude/settings.json`](../claude/settings.json) の `"theme": "custom:dotfiles"` で選ぶ

statusline の色とカスタムテーマはどちらも `home/theme.nix` から生成するため、パレットの変更に自動追従する。
カスタムテーマは Claude Code の機能で、ビルトインテーマ（`base`）を土台に色キーを上書きする
（`/theme` の一覧に「Catppuccin Latte (dotfiles)」として出る。ファイルの変更は監視されて即反映）。
土台は `light` で、鮮やかな色（OKLCH の彩度 0.14 超。権限確認の青、auto-accept の紫、bash モードのピンクなど）
を同じ役割のパレットの色に置き換えている。サブエージェントの 8 色と ultrathink の虹色 7 色は組で揃うよう全部置き換える。
ダークテーマに移るときは `base` を `dark` にする。

差分の色（`diffAdded` / `diffRemoved` / `*Dimmed` / `diffAddedWord` / `diffRemovedWord`）は上書きしない。
上書きしなければ差分は Claude Code 内蔵の配色（GitHub 風の明るい背景）で描かれる。
上書きすると次の問題が出る:

- `diffAddedWord` は「`+12 -3` の数字の色」と「差分の単語ハイライトの背景」を兼ねている
- 数字が読める濃さ（マットの `green` など）にすると、単語ハイライトの上に載るシンタックス色
  （関数名の紫や組み込み値の青）がほぼ読めなくなる。逆に明るくすると数字が背景に溶ける
- 単語ハイライトだけ内蔵色のまま行の背景だけマットにすると、明るい単語ハイライトが浮いて見える

そのため数字は light の `#2f9d44` のままにしている（パレットの `green` はこの色と色相を揃えている）。

### lazygit

差分表示は delta に委譲しており、[`config/lazygit/config.yml`](../config/lazygit/config.yml) の
pager 引数 `--light` / `--dark` をテーマの明暗と手動で合わせる必要がある（lazygit 独自の
`{{filename}}` テンプレート構文と home-manager の Nix 文字列展開が衝突するため、直リンクのまま手動管理している）。

### fzf

- 色: `home/theme.nix` が生成する `~/.config/fzf/config`（`FZF_DEFAULT_OPTS_FILE`）
- 色以外（高さ・レイアウト・枠線）: [`config/zsh/.zshenv`](../config/zsh/.zshenv) の `FZF_DEFAULT_OPTS`

fzf はファイルと環境変数の両方を読む。fzf-tab は既定で `FZF_DEFAULT_OPTS` を空にして fzf を呼ぶため、
[`config/zsh/.zshrc`](../config/zsh/.zshrc) の `zstyle ':fzf-tab:*' use-fzf-default-opts yes` で読ませている
（`--height` / `--layout` は fzf-tab が自前で上書きするので、実際に効くのは `--border` だけ）。

### eza / bat / zsh syntax highlighting

Ghostty のターミナル ANSI カラーに委ねている。bat のみデフォルトがダーク用の
Monokai Extended のため、[`config/bat/config`](../config/bat/config) で `--theme=ansi` を明示している。

### hunk

- 色: `home/theme.nix` が生成する `~/.config/hunk/config.toml`

背景系（`background` / `panel` / `panelAlt`）と `text` だけをパレットで上書きしていて、
コードの色と差分の色はビルトイン `catppuccin-latte` の公式値（マット化していない鮮やかな色）のまま。
hunk の色は土台テーマから計算した値で、上書きしたキー以外は計算し直されない。
コードの色を変えるには `[custom_theme.syntax]` を使うが、これを指定すると土台テーマのハイライトの代わりに
hunk 独自の配色になり、決まった色だけが置き換わる。そのため括弧やカンマはほぼ黒（`#0a0a0a`）、
コメントはグレー（`#737373`）に固定され、Neovim と見た目が揃わない（hunk 0.17.3 で確認）。

## 明るさ・チュロームの調整手順

画面は「チュローム（herdr のサイドバー・タブバー）」が「ペイン（ターミナル領域）」を
囲む 2 レイヤー構成。チュロームは常にペインより一段（RGB で 8〜10 程度）暗く保つ。

| レイヤー   | 設定箇所                                                                                | 現在値                       |
| ---------- | --------------------------------------------------------------------------------------- | ---------------------------- |
| ペイン背景 | `home/theme.nix` の `base`（Ghostty / Neovim / hunk はここから生成）                    | `#dce0e8` (Latte crust 相当) |
| チュローム | `home/theme.nix` の `mantle` と `config/herdr/config.toml` の `[theme.custom] panel_bg` | `#d3d8e2`                    |

Neovim の背景は `colorschema.lua` の `color_overrides` が `theme.palette()` を丸ごと
注入するため、`home/theme.nix` を変えれば追従する。
**herdr は生成できないため、`panel_bg` を `mantle` と手動で同じ値にする**
（`text` と色名のトークンも同様。`home/theme.nix` の先頭コメントにも記載）。

段階の目安（明 → 暗）。ペインを 1 段下げたらチュロームも 1 段下げる:

| 段階         | ペイン背景         | チュローム         |
| ------------ | ------------------ | ------------------ |
| Latte 標準   | `#eff1f5` (base)   | `#e6e9ef` (mantle) |
| 一段暗く     | `#e6e9ef` (mantle) | `#dce0e8` (crust)  |
| 現在         | `#dce0e8` (crust)  | `#d3d8e2`          |
| もう一段暗く | `#d3d8e2`          | `#c9cfdb`          |

手順:

1. `home/theme.nix` の色コードを書き換えて rebuild（fzf / hunk / Neovim / Claude Code / Ghostty 用に再生成される）
2. `config/herdr/config.toml` の `panel_bg` を合わせる（直リンクなので保存で即反映）
3. herdr: `herdr server reload-config`（起動中のまま即反映）
4. Ghostty: `Cmd + Shift + ,` で設定リロード
5. 起動中の Neovim は再起動

文字が細く見える場合はフォント側で調整する（ライト背景はダーク背景と違い
グロー効果がないため構造的に細く見える）:

- `font-thicken = true`（macOS。ステムを太らせる。強さは `font-thicken-strength` 0-255）
- それでも細ければ `font-style = "Medium"`（Maple Mono は Medium あり。
  ただし HackGen Console NF に Medium はないため和文は Regular のままになる）

## 現実的な運用

- 色の微調整は `home/theme.nix` を変えて rebuild し、手動で揃える 2 ファイル（herdr / delta）を合わせる
- variant（例: Latte → Mocha）やテーマを変える場合に書き換える場所:

| 場所                                             | 内容                                                                     |
| ------------------------------------------------ | ------------------------------------------------------------------------ |
| `home/theme.nix`                                 | `name` / `variant` とパレットの色コード一式、Claude Code テーマの `base` |
| `config/ghostty/config`                          | `theme`                                                                  |
| `config/herdr/config.toml`                       | `[theme] name` と `[theme.custom]`                                       |
| `config/delta/themes/` と `config/git/config`    | テーマファイルの差し替えと `features` / `[include] path`                 |
| `config/lazygit/config.yml`                      | pager の `--light` / `--dark`                                            |
| `config/nvim/lua/config/plugins/colorschema.lua` | 別テーマへ移る場合のみ、プラグインの差し替え                             |
