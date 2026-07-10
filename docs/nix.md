# Nix 運用メモ

2026-07 に chezmoi から nix-darwin + home-manager へ移行した。

## 日常操作

| やりたいこと | 操作 |
|---|---|
| nvim / zsh / ghostty 等の設定変更 | `config/` のファイルを直接編集。保存で即反映 (直リンク) |
| CLI パッケージ追加 | `home/default.nix` に追記 → rebuild |
| GUI アプリ / nixpkgs に無いツール | `darwin/homebrew.nix` に追記 → rebuild |
| テーマ変更 | `home/theme.nix` を編集 → rebuild |
| git identity / ホスト固有値 | `hosts/*.nix` を編集 → rebuild |
| nixpkgs 更新 | `nix flake update` → rebuild |
| 前世代に戻す | `sudo darwin-rebuild --rollback` |
| 古い世代の掃除 | `nix-collect-garbage --delete-older-than 14d` |

rebuild = `sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#work`

## 設計メモ

- **直リンク方式**: `config/` は `mkOutOfStoreSymlink` でリポジトリの絶対パスへリンクする。
  リポジトリを移動する場合は `modules/identity.nix` の `dotfilesDir` を変更する
- **テーマ生成**: `home/theme.nix` → `home/generated.nix` が
  `~/.config/fzf/config`, `~/.config/hunk/config.toml`, `~/.config/theme/palette.{lua,sh}` を生成。
  nvim は `config/nvim/lua/config/core/theme.lua` が palette.lua を dofile、
  statusline は palette.sh を source する
- **herdr**: `~/.config/herdr` に session.json / ソケットを書くため config.toml のみファイル単位リンク
- **tmux**: herdr 移行済みの fallback。appearance.tmux はテーマ焼き込みの静的ファイル
- **vault**: unfree のため nix バイナリキャッシュ対象外 (毎回ソースビルドになる)。brew 管理
- **lazy-lock.json / mise.lock**: 直リンクにより リポジトリ内で自動追跡される
- **tenv**: terraform / tofu / atmos のシムを `/etc/profiles/per-user/*/bin` に同梱する

## brew に残っている手動インストール分 (棚卸し待ち)

Brewfile 管理外で手動インストールされていたもの。`onActivation.cleanup = "none"` で温存中。
不要と判断したら `brew uninstall` で消し、必要なら nix / homebrew.nix へ宣言を移すこと。
全て整理できたら cleanup を `"zap"` にして宣言駆動へ移行する。

- コンテナ系: docker, docker-compose, docker-credential-helper, podman, lazydocker
- 言語系: rustup (mise の rust と重複?), luarocks, lua-language-server, stylua, ruff, dprint
- CLI: ast-grep, chafa, coreutils, wget, sevenzip, sl, imagemagick, ghostscript, tectonic
- インフラ: hashicorp/tap/terraform (tenv と重複), terraform-ls
- ライブラリ: libpq (zshrc が PATH 参照), zlib, pkgconf
- zsh: zsh-autosuggestions, zsh-completions (sheldon 管理と重複、未使用のはず)

※ delta, direnv, ast-grep, lua-language-server, stylua, ruff, luarocks は nix 宣言済み。
brew 側の同名 formula は削除してよい。
