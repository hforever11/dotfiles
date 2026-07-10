# Theme Notes

現在のテーマは `Catppuccin Latte` ベース（ライトテーマ）。

パレット（色コード）は `home/theme.nix` が単一ソースで、
home-manager (`home/generated.nix`) が fzf / hunk / Neovim / Claude statusline 向けの
設定ファイルを生成する。Ghostty / herdr / delta / lazygit / bat は直リンクされた
設定ファイル側で個別にテーマ名・色を指定する。

## 変更ポイント

### パレット (Neovim + fzf + hunk + statusline 共通)

- 単一ソース: [`home/theme.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/home/theme.nix)
- 生成ロジック: [`home/generated.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/home/generated.nix)

`palette` の色コードを書き換えて rebuild すれば、
`~/.config/fzf/config`, `~/.config/hunk/config.toml`,
`~/.config/theme/palette.lua`, `~/.config/theme/palette.sh` に反映される。
パレットのキー名（`base` / `surface0` / `text` など）は Catppuccin のロール名を
そのまま使い、別テーマに移る場合は対応色をマッピングする。

### Neovim

- テーマ本体: [`config/nvim/lua/config/core/theme.lua`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/nvim/lua/config/core/theme.lua)
  が生成済みの `~/.config/theme/palette.lua` を `dofile` で読む
- colorscheme 適用: [`config/nvim/lua/config/plugins/colorschema.lua`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/nvim/lua/config/plugins/colorschema.lua)

`name` / `variant` / パレット本体は `palette.lua` から注入され、`transparent_background` のみ `theme.lua` 側で持つ。

注意:
`incline` / `modes` / `undo-glow` / `scrollbar` / `vimade` / `noice` は `theme.lua` の `palette()` を通して色を参照している。
別テーマのプラグイン（例: `folke/tokyonight.nvim`）に移る場合は `colorschema.lua` の差し替えが必要。

### Ghostty

- テーマ指定: [`config/ghostty/config`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/ghostty/config)

```conf
theme = Catppuccin Latte
background = #e6e9ef
foreground = #44455d
```

Ghostty はここを書き換えるだけ（候補は `ghostty +list-themes`）。
`background` は眩しさを抑えるため Latte mantle 相当に一段落としたオーバーライド。
`foreground` は herdr 公式サイトのライトテーマ実測値。

### herdr

- テーマ指定: [`config/herdr/config.toml`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/herdr/config.toml)

```toml
[theme]
name = "catppuccin-latte"

[theme.custom]
panel_bg = "#dce0e8"
text = "#44455d"
accent = "#3357ed"
```

ビルトインテーマ名を指定するだけ。`[theme.custom]` はトークン上書き（省略可）。
`panel_bg` はペイン背景（Ghostty の `#e6e9ef`）より一段暗い Latte crust 相当にして
「グレーのチュロームが明るいペインを囲む」構成を作る。設定リファレンスは
<https://herdr.dev/docs/configuration/> を参照。`catppuccin-latte` / `tokyo-night-day` /
`gruvbox-light` などのライト variant もある（候補は `herdr --default-config` のコメント参照）。

### git (delta)

- 機能定義: [`config/git/config`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/git/config) の `[delta] features` と `[include] path`
- テーマ本体: [`config/delta/themes/catppuccin-latte.gitconfig`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/delta/themes/catppuccin-latte.gitconfig)（[catppuccin/delta](https://github.com/catppuccin/delta) 公式。`syntax-theme` のみ bat テーマ非依存の `none` に変更）

別テーマに切り替えるときは、新しい delta テーマファイルを `config/delta/themes/` に置き、`config/git/config` の参照を差し替える。

### Claude Code (statusline)

- 本体: [`config/claude/statusline.sh`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/claude/statusline.sh)
  が生成済みの `~/.config/theme/palette.sh` を実行時に `source` する

色は `home/theme.nix` から home-manager が注入するため、テーマ変更に自動追従する。

### lazygit

差分表示は delta に委譲しており、[`config/lazygit/config.yml`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/lazygit/config.yml) の
pager 引数 `--light` / `--dark` をテーマの明暗と手動で合わせる必要がある（lazygit 独自の
`{{filename}}` テンプレート構文と home-manager の Nix 文字列展開が衝突するため、直リンクのまま手動管理している）。

### fzf / eza / bat / zsh syntax highlighting

Ghostty のターミナル ANSI カラーに委ねている。bat のみデフォルトがダーク用の
Monokai Extended のため、[`config/bat/config`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/config/bat/config) で `--theme=ansi` を明示している。

## 明るさ・チュロームの調整手順

画面は「チュローム（herdr のサイドバー・タブバー）」が「ペイン（ターミナル領域）」を
囲む 2 レイヤー構成。チュロームは常にペインより一段（RGB で 8〜10 程度）暗く保つ。

| レイヤー | 設定箇所 | 現在値 |
| --- | --- | --- |
| ペイン背景 | `config/ghostty/config` の `background` と `home/theme.nix` の `base`（Neovim はここから参照） | `#dce0e8` (Latte crust 相当) |
| チュローム | `config/herdr/config.toml` の `[theme.custom] panel_bg` と `home/theme.nix` の `mantle` | `#d3d8e2` |

Neovim の背景は `colorschema.lua` の `color_overrides` が `theme.palette()` の
`base` / `mantle` を注入するため、`home/theme.nix` を変えれば追従する。
**Ghostty の `background` と `home/theme.nix` の `base` は必ず同じ値にする**
（ズレると Neovim だけ明るさが変わる）。

段階の目安（明 → 暗）。ペインを 1 段下げたらチュロームも 1 段下げる:

| 段階 | ペイン背景 | チュローム |
| --- | --- | --- |
| Latte 標準 | `#eff1f5` (base) | `#e6e9ef` (mantle) |
| 一段暗く | `#e6e9ef` (mantle) | `#dce0e8` (crust) |
| 現在 | `#dce0e8` (crust) | `#d3d8e2` |
| もう一段暗く | `#d3d8e2` | `#c9cfdb` |

手順:

1. `config/ghostty/config` / `config/herdr/config.toml` の色コードを書き換える（直リンクなので保存で即反映）
2. `home/theme.nix` の色コードを書き換えて rebuild（fzf / hunk / Neovim / statusline 用に再生成される）
3. herdr: `herdr server reload-config`（起動中のまま即反映）
4. Ghostty: `Cmd + Shift + ,` で設定リロード
5. 起動中の Neovim は再起動

文字が細く見える場合はフォント側で調整する（ライト背景はダーク背景と違い
グロー効果がないため構造的に細く見える）:

- `font-thicken = true`（macOS。ステムを太らせる。強さは `font-thicken-strength` 0-255）
- それでも細ければ `font-style = "Medium"`（Maple Mono は Medium あり。
  ただし HackGen Console NF に Medium はないため和文は Regular のままになる）

## 現実的な運用

- 同じテーマ内で variant だけ変えるなら、`home/theme.nix` のパレットと Ghostty / herdr の `theme` を変えれば大半が揃う
- 別テーマへ移る場合は、上記に加えて git(delta) のテーマファイル差し替えと `colorschema.lua` のプラグイン差し替えが必要
