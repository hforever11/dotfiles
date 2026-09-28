# Nix 運用メモ

## 日常操作

| やりたいこと | 操作 |
|---|---|
| nvim / zsh / ghostty / git 等の設定変更 | `config/` のファイルを直接編集。保存で即反映 (直リンク) |
| CLI パッケージ追加 | `home/packages.nix` に追記 → rebuild |
| GUI アプリ / nixpkgs に無いツール | `darwin/homebrew.nix` に追記 → rebuild |
| ランタイム (node, python, go, tofu …) | `config/mise/config.toml` に追記 → `mise install` ([mise](mise.md)) |
| テーマ変更 | `home/theme.nix` を編集 → rebuild ([Theme Notes](theme.md)) |
| マシン固有の git identity | `config/git/local.gitconfig` (gitignore) を編集 ([Git User Switching](git/user-switching.md)) |
| nixpkgs 更新 | `nix flake update` → rebuild |
| 前世代に戻す | `sudo darwin-rebuild --rollback` |
| 古い世代の掃除 | `nix-collect-garbage --delete-older-than 14d` |

rebuild = `sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#mac`
(zsh 関数 `rebuild` として `config/zsh/.zshrc` に登録済み。補完キャッシュの作り直しも行う)

## ツール導入・削除の判断フロー

### 導入する時

1. `nix search nixpkgs <name>` で収録有無を確認
2. 収録されている場合 → 原則 `home/packages.nix` の `home.packages` に追記
   - ただし unfree でバイナリキャッシュ対象外 (毎回ソースビルドになる) など nix 側が実用的でない事情があれば brew を検討 (例: vault)
3. 収録されていない場合、または GUI アプリ/cask でしか提供されない場合 → `darwin/homebrew.nix` の `brews`/`casks` に追記
4. いずれも追記後は rebuild して反映

### 削除する時

| 追加先 | 削除方法 | 備考 |
|---|---|---|
| `home/packages.nix` (nix) | 該当行を削除して rebuild | 実体は nix store に残り続ける。ディスクを解放したい場合は別途 `nix-collect-garbage --delete-older-than 14d` |
| `darwin/homebrew.nix` (brew) | 該当行を削除して rebuild | `cleanup = "zap"` のため、宣言外の formula/cask は rebuild 時に自動アンインストールされる (手動 `brew uninstall` 不要。逆に brew で手動インストールしたものも消える) |

brew に残している個別の理由 (vault, libpq, ripgrep) は `darwin/homebrew.nix` のコメントを参照。

## 設計メモ

- **ホストは 1 つ**: 仕事用・個人用の Mac で同じ `darwinConfigurations.mac` を使う。
  マシンごとの差分は仕事用 git identity だけで、それは Nix の外 (`config/git/local.gitconfig`) に置いている。
  Nix の pure-eval は非 store の絶対パスを読めないため、gitignore したファイルの値を Nix で扱うことはできない
- **直リンク方式**: `config/` は `mkOutOfStoreSymlink` でリポジトリの絶対パスへリンクする。
  リポジトリを移動する場合は `modules/identity.nix` の `dotfilesDir` を変更する
- **テーマ生成**: `home/theme.nix` が `~/.config/fzf/config`, `~/.config/hunk/config.toml`,
  `~/.config/theme/{palette.lua,palette.sh,ghostty}` を生成する。
  nvim は `config/nvim/lua/config/core/theme.lua` が palette.lua を dofile、
  statusline は palette.sh を source、Ghostty は `config-file` で ghostty を読む
- **herdr**: `~/.config/herdr` に session.json / ソケットを書くため config.toml のみファイル単位リンク
- **~/.claude**: ランタイム状態を含むため `agents` / `hooks` / `skills` だけリンクする。
  Claude Code が同期する組織スキルは `claude/skills/synced/` に書かれるので gitignore している
- **lazy-lock.json**: 直リンクのため、Neovim が書き戻した内容がそのままリポジトリで追跡される
- **コンテナ**: ランタイムは colima (`home/colima.nix`)。launchd agent がログイン時に
  `colima start --cpu 4 --memory 8` で起動する (Kubernetes は使わない)。
  docker CLI / lazydocker は nix。nixpkgs の docker は buildx / compose プラグインと zsh 補完を同梱している
- **vault**: unfree のため nix バイナリキャッシュ対象外 (毎回ソースビルドになる)。brew 管理
