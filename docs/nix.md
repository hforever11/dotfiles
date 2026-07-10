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
(zsh alias `rebuild` として `config/zsh/.zshrc` に登録済み)

## 設計メモ

- **直リンク方式**: `config/` は `mkOutOfStoreSymlink` でリポジトリの絶対パスへリンクする。
  リポジトリを移動する場合は `modules/identity.nix` の `dotfilesDir` を変更する
- **テーマ生成**: `home/theme.nix` → `home/generated.nix` が
  `~/.config/fzf/config`, `~/.config/hunk/config.toml`, `~/.config/theme/palette.{lua,sh}` を生成。
  nvim は `config/nvim/lua/config/core/theme.lua` が palette.lua を dofile、
  statusline は palette.sh を source する
- **herdr**: `~/.config/herdr` に session.json / ソケットを書くため config.toml のみファイル単位リンク
- **追加の git identity**: Nix の pure-eval は非 store 絶対パスを読めないため管理できない。新しいマシンでは
  `hosts/work-local.gitconfig`(includeIf)と `hosts/work-identity.local.gitconfig`(user)を手動作成する(共に gitignore 対象、`home/git.nix` が参照)
- **vault**: unfree のため nix バイナリキャッシュ対象外 (毎回ソースビルドになる)。brew 管理
- **lazy-lock.json / mise.lock**: 直リンクにより リポジトリ内で自動追跡される
- **tenv**: terraform / tofu / atmos のシムを `/etc/profiles/per-user/*/bin` に同梱する
- **コンテナランタイム**: Rancher Desktop から colima (nix 宣言, `home/default.nix`) へ移行済み (2026-07-10)。
  `colima start` で Docker ランタイムのみ起動 (Kubernetes は使わない方針)。kubectl / helm も nix 宣言に移した。
  brew の `docker` / `docker-compose` / `docker-credential-helper` / `podman` / `lazydocker` は
  CLI / TUI として引き続き利用するため維持

## brew 棚卸し完了 (2026-07-10)

手動インストール分の整理が完了し、`darwin/homebrew.nix` の `brews` / `casks` が
実際にインストール済みの formula/cask 全量と一致した状態にした。
`onActivation.cleanup` は `"zap"` に変更済み — 以後 `homebrew.nix` に無い
formula/cask を brew で入れても、次の rebuild で自動的に削除される。

- コンテナ系 (docker, docker-compose, docker-credential-helper, podman, lazydocker):
  colima 移行後も CLI / TUI として `brews` に宣言して維持
- libpq: zshrc が PATH 参照 (psql/pg_config) のため `brews` に宣言して維持。
  icu4c@78 / krb5 / openssl@3 / ca-certificates はその依存として自動的に残る
- ripgrep: nix 宣言と重複するが cask `codex` の brew 版依存のため `brews` に宣言して維持
- cask (arto, copilot-cli, font-hackgen, font-udev-gothic-nf, raycast,
  session-manager-plugin, visual-studio-code): 手動インストールのままだったものを `casks` へ宣言化
- font-hackgen-nerd / font-maple-mono-nf (cask): `darwin/default.nix` の
  `fonts.packages` と重複していたため削除 (nix 側のみで管理)

※ delta, direnv, ast-grep, lua-language-server, stylua, ruff, luarocks, rustup, zlib, pkgconf,
dprint, chafa, coreutils, wget, sevenzip, sl, imagemagick, ghostscript, tectonic,
terraform, terraform-ls, zsh-autosuggestions, zsh-completions, tree-sitter, colima(空 Cellar の残骸),
argocd, bat, cloudflared, cosign, eza, fd, flux, fzf, gh, ghq, grpcurl, herdr, jq, kind,
kustomize, mise, mkcert, neovim, nixfmt, protobuf, sheldon, starship, tenv, tmux, tree,
tree-sitter-cli, yq, zoxide, k9s, talosctl, zsh-abbr
は nix 宣言済み/未使用/重複と確認し、brew 側を削除済み (2026-07-10)。
zsh-abbr は sheldon プラグイン (`config/sheldon/plugins.toml`) 管理と重複しており、
untrusted tap でロードエラーになっていたため削除。
