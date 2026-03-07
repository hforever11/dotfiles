# Theme Notes

現在のテーマは `Catppuccin Frappe` ベース。

完全に 1 箇所で共通管理しているわけではなく、ツールごとに変更が必要。
ただし、どこを変えるべきかは以下の場所に整理されている。

## 変更ポイント

### Neovim

- 現在のテーマ定義: [`dot_config/nvim/lua/config/core/theme.lua`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/nvim/lua/config/core/theme.lua)
- colorscheme 適用: [`dot_config/nvim/lua/config/plugins/colorschema.lua`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/nvim/lua/config/plugins/colorschema.lua)

基本的には `theme.lua` の `name` / `variant` / `transparent_background` を変える。

注意:
`incline` / `modes` / `undo-glow` は `theme.lua` の `palette()` を通して色を参照している。
別テーマを使う場合、必要なら `palette()` の実装も追加する。

### Ghostty

- テーマ指定: [`dot_config/ghostty/config`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/ghostty/config)

```conf
theme = "Catppuccin Frappe"
```

Ghostty はここを書き換えるだけ。

### tmux

- テーマ色定義: [`dot_config/tmux/executable_style.tmux`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/tmux/executable_style.tmux)

`tmux` はテーマ名ではなく、色コードを直接持っている。
そのため、別テーマに切り替えるときはこのファイルの色変数を書き換える必要がある。

### git / delta

- delta の使用テーマ: [`dot_config/git/config.tmpl`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/git/config.tmpl)
- テーマ定義: [`dot_config/delta/themes/catppuccin.gitconfig`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/delta/themes/catppuccin.gitconfig)

現在は:

```gitconfig
[delta]
    features = catppuccin-frappe
```

`Catppuccin` 系の別 flavour に変えるだけなら `features` の切り替えでよい。
別テーマにするなら、delta 用テーマ定義も別途必要。

### bat

- テーマファイル: [`dot_config/bat/themes/Catppuccin Frappe.tmTheme`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/bat/themes/Catppuccin%20Frappe.tmTheme)

`delta` の `syntax-theme` は bat 側のテーマ名に依存している。
そのため、bat テーマを変える場合は delta 側も合わせて確認する。

## 現実的な運用

- 同じ `Catppuccin` 内で flavour だけ変えるなら、比較的変更は少ない
- `Everforest` のような別テーマへ移るなら、`Neovim` / `Ghostty` / `tmux` / `delta` を個別に調整する必要がある
- これはある程度仕方ない。無理に完全共通化するより、「変更箇所が分かる」状態を保つ方が実用的
