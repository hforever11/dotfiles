# Theme Notes

現在のテーマは `Catppuccin Latte` ベース（ライトテーマ）。

パレット（色コード）は `home/theme.nix` が単一ソースで、
home-manager が fzf / hunk / Neovim / Claude statusline / Ghostty の背景色・文字色向けの
設定ファイルを生成する（生成するのは色だけで、各ツールの色以外の設定は直リンク側に置く）。
テーマ名の指定と、herdr / delta / lazygit / bat の色は
直リンクされた設定ファイル側で個別に指定する。

## 変更ポイント

### パレット (Neovim + fzf + hunk + statusline + Ghostty 背景色・文字色 共通)

- 単一ソース兼生成ロジック: [`home/theme.nix`](../home/theme.nix)

パレットの色コードを書き換えて rebuild すれば、
`~/.config/fzf/config`, `~/.config/hunk/config.toml`,
`~/.config/theme/palette.lua`, `~/.config/theme/palette.sh`, `~/.config/theme/ghostty` に反映される。
パレットのキー名（`base` / `surface0` / `text` など）は Catppuccin のロール名を
そのまま使い、別テーマに移る場合は対応色をマッピングする。

公式 Latte から意図的に外している値:

| キー            | 値        | 理由                                             |
| --------------- | --------- | ------------------------------------------------ |
| `base` / `mantle` | 二段暗い | 眩しさ抑制。Ghostty `background` と揃える        |
| `text`          | `#44455d` | 公式 `#4c4f69` より少し濃い herdr 公式サイトの実測値。Ghostty `foreground` / herdr `text` と揃える |
| `green`         | `#2f9d44` | 公式 `#40a02b` は OKLCH 色相 140° でライト背景だとオリーブに濁る。herdr の `accent` に揃えた 146° |

Neovim は `colorschema.lua` がパレットを丸ごと `color_overrides` に渡すため、
ここで変えた値は Catppuccin 本体のハイライト（gitsigns / diff / 文字列など）にも反映される。

生成できない（別ファイルを読み込む仕組みがない）ため、次の 2 ファイルは手動で同じ値にする
（`home/theme.nix` の先頭コメントにも記載）:

| ファイル | 項目 | パレットのキー |
| --- | --- | --- |
| `config/herdr/config.toml` | `[theme.custom]` の `panel_bg` / `text` / `accent` | `mantle` / `text` / `green` |
| `config/delta/themes/catppuccin-latte.gitconfig` | `file-style` / `line-numbers-plus-style` と plus 系の混色 | `text` / `green` |

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
`background` / `foreground` は `home/theme.nix` の `base` / `text` から生成した `~/.config/theme/ghostty` を
`config-file` で読む（Neovim と同じ値になる）。`config-file` はこのファイルを読み終えた後に
読まれるため、`config/ghostty/config` に `background` / `foreground` を書いても上書きされる。
ANSI 16 色はテーマ (`Catppuccin Latte`) の公式値のまま。

### herdr

- テーマ指定: [`config/herdr/config.toml`](../config/herdr/config.toml)

```toml
[theme]
name = "catppuccin-latte"

[theme.custom]
panel_bg = "#d3d8e2"
text = "#44455d"
accent = "#2f9d44"
```

ビルトインテーマ名を指定するだけ。`[theme.custom]` はトークン上書き（省略可）。
herdr は別ファイルを読み込めないため、`panel_bg` / `text` / `accent` は `home/theme.nix` の
`mantle` / `text` / `green` と手動で同じ値にする。
`panel_bg` はペイン背景（`home/theme.nix` の `base`）より一段暗い `mantle` と同じ値にして
「グレーのチュロームが明るいペインを囲む」構成を作る。

ペイン枠線の色は 2 トークンに分かれる（枠線専用トークンは無い）。

| 対象               | トークン                | 現在値                       |
| ------------------ | ----------------------- | ---------------------------- |
| フォーカス中の枠線 | `accent`                | `#2f9d44`（Claude Code ライトテーマの `diffAddedWord` と同色） |
| 非フォーカスの枠線 | `overlay0`              | Latte 既定 `#9ca0b0` |

`[ui] accent` も同じ用途だが `[theme.custom] accent` が優先されるため使っていない。
`overlay0` は枠線専用ではなく **サイドバー見出し（`spaces` / `agents` など）と区切り記号**
にも使われるため、枠線のコントラストを稼ぐ目的で薄くしてはいけない。

緑を選ぶときの基準:

- WCAG コントラストより **OKLCH 色相**が効く。147° 前後の青緑寄りは澄んで見え、
  141° 以下の黄緑寄りはオリーブに濁る（Latte 公式 green `#40a02b` は 140°）
- Ghostty 側の `alpha-blending = linear` と `adjust-box-thickness = 115%` で
  罫線は指定値より暗く・太く描かれる。ライトテーマでは一段明るい値を選ぶ
- フォーカス/非フォーカスの判別性は輝度比ではなく OKLab ΔE で見る（現在 0.200）

設定リファレンスは
<https://herdr.dev/docs/configuration/> を参照。`catppuccin-latte` / `tokyo-night-day` /
`gruvbox-light` などのライト variant もある（候補は `herdr --default-config` のコメント参照）。

### git (delta)

- 機能定義: [`config/git/config`](../config/git/config) の `[delta] features` と `[include] path`
- テーマ本体: [`config/delta/themes/catppuccin-latte.gitconfig`](../config/delta/themes/catppuccin-latte.gitconfig)（[catppuccin/delta](https://github.com/catppuccin/delta) 公式がベース）

公式からの変更点:

- `syntax-theme` を bat テーマ非依存の `none` に変更
- `file-style` を `home/theme.nix` の `text` に、`line-numbers-plus-style` を `green` に変更
- `plus-emph-style` / `plus-style` の背景は `green` を upstream と同じ比率（35% / 20%）で
  公式 base `#eff1f5` と混ぜた値。`green` を変えたらコメントの比率で計算し直す

別テーマに切り替えるときは、新しい delta テーマファイルを `config/delta/themes/` に置き、`config/git/config` の参照を差し替える。

### Claude Code

- statusline: [`claude/statusline.sh`](../claude/statusline.sh)
  が生成済みの `~/.config/theme/palette.sh` を実行時に `source` する
- UI テーマ: [`claude/settings.json`](../claude/settings.json) の `"theme": "light"`

statusline の色は `home/theme.nix` から home-manager が注入するため、テーマ変更に自動追従する。
UI テーマはビルトインの明暗指定なので、ダークテーマに移るときは手動で変える。

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

## 明るさ・チュロームの調整手順

画面は「チュローム（herdr のサイドバー・タブバー）」が「ペイン（ターミナル領域）」を
囲む 2 レイヤー構成。チュロームは常にペインより一段（RGB で 8〜10 程度）暗く保つ。

| レイヤー | 設定箇所 | 現在値 |
| --- | --- | --- |
| ペイン背景 | `home/theme.nix` の `base`（Ghostty / Neovim / hunk はここから生成） | `#dce0e8` (Latte crust 相当) |
| チュローム | `home/theme.nix` の `mantle` と `config/herdr/config.toml` の `[theme.custom] panel_bg` | `#d3d8e2` |

Neovim の背景は `colorschema.lua` の `color_overrides` が `theme.palette()` を丸ごと
注入するため、`home/theme.nix` を変えれば追従する。
**herdr は生成できないため、`panel_bg` を `mantle` と手動で同じ値にする**
（`text` / `accent` も同様。`home/theme.nix` の先頭コメントにも記載）。

段階の目安（明 → 暗）。ペインを 1 段下げたらチュロームも 1 段下げる:

| 段階 | ペイン背景 | チュローム |
| --- | --- | --- |
| Latte 標準 | `#eff1f5` (base) | `#e6e9ef` (mantle) |
| 一段暗く | `#e6e9ef` (mantle) | `#dce0e8` (crust) |
| 現在 | `#dce0e8` (crust) | `#d3d8e2` |
| もう一段暗く | `#d3d8e2` | `#c9cfdb` |

手順:

1. `home/theme.nix` の色コードを書き換えて rebuild（fzf / hunk / Neovim / statusline / Ghostty 用に再生成される）
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

| 場所 | 内容 |
| --- | --- |
| `home/theme.nix` | `name` / `variant` とパレットの色コード一式 |
| `config/ghostty/config` | `theme` |
| `config/herdr/config.toml` | `[theme] name` と `[theme.custom]` |
| `config/delta/themes/` と `config/git/config` | テーマファイルの差し替えと `features` / `[include] path` |
| `config/lazygit/config.yml` | pager の `--light` / `--dark` |
| `claude/settings.json` | `"theme"` |
| `config/nvim/lua/config/plugins/colorschema.lua` | 別テーマへ移る場合のみ、プラグインの差し替え |
