# chezmoi Tips

## よく使うコマンド

```sh
# 管理状態を確認
chezmoi status

# 適用前の差分を見る
chezmoi diff

# ソースの変更を実ファイルに反映
chezmoi apply

# リモート更新を取り込んで反映
chezmoi update

# 管理対象ファイルを編集（この repo では保存時に自動 apply）
chezmoi edit ~/.config/nvim/init.lua

# 実ファイル側の変更を source に取り込む
chezmoi add ~/.config/nvim/init.lua

# 管理対象一覧を見る
chezmoi managed

# source repo に移動して git 操作する
chezmoi cd
```

`chezmoi` を日常的に使うなら、まずは `status` / `diff` / `edit` / `apply` / `update` を覚えれば十分。

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

## 迷いやすい使い分け

```sh
# source 側を直接編集したい
chezmoi edit ~/.config/tmux/tmux.conf

# ~/.config 側を直接いじった変更を source に取り込みたい
chezmoi add ~/.config/tmux/tmux.conf

# とりあえず差分だけ確認したい
chezmoi diff
```
