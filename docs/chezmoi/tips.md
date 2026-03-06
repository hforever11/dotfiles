# chezmoi Tips

## ファイル削除時の注意

chezmoiはソースからファイルを削除しても、実ファイル（`~/.config` 配下等）は自動で削除されない。

ソース側でファイルを消した場合は、実ファイルも手動で削除する必要がある:

```sh
# 実ファイルとchezmoiの管理情報を同時に削除
chezmoi destroy ~/.config/nvim/lua/config/plugins/lualine.lua
```

## chezmoi edit で自動apply

`chezmoi edit` でファイルを編集すると、保存時に自動で `chezmoi apply` が実行される（`[edit] apply = true` を設定済み）。

```sh
chezmoi edit ~/.config/nvim/lua/config/plugins/snacks.lua
```
