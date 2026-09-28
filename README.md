# dotfiles

nix-darwin + home-manager で管理する macOS 環境。

Nix の役割は「パッケージの導入」「`config/` へのシンボリックリンク」「テーマ色から生成する少数の設定ファイル」の 3 つだけ。
各ツールの設定はネイティブ形式のまま `config/` に置いてあり、Nix を読まなくても理解できる。

## 構成

| パス | 役割 |
|---|---|
| `config/` | 各ツールの設定。`~/.config/*` へ直リンクされ、**編集は即反映** (rebuild 不要) |
| `bin/` | `~/.local/bin` へリンクされるスクリプト |
| `claude/` | Claude Code のグローバル設定。`~/.claude/` へリンク ([設定メモ](docs/claude/recommended-settings.md)) |
| `flake.nix` | エントリポイント。構成は `mac` の 1 つ (仕事用・個人用で共通) |
| `modules/identity.nix` | ユーザー名とリポジトリの場所 |
| `darwin/default.nix` | macOS 本体の設定 (キーリピート, Dock, Touch ID sudo など) |
| `darwin/homebrew.nix` | GUI アプリ (cask) と、nix で扱えない/扱いにくいものだけ |
| `home/packages.nix` | CLI パッケージ一覧 (nixpkgs) |
| `home/links.nix` | `config/` 等への直リンク一覧 |
| `home/theme.nix` | テーマ色の単一ソース。fzf / hunk / Neovim / statusline / Ghostty 背景色を生成 |
| `home/colima.nix` | colima (Docker ランタイム) のログイン時自動起動 |
| `home/mise.nix` | mise と、rebuild 時の `mise install` |

マシン固有の設定 (仕事用 git identity) だけはリポジトリ管理外で、`config/git/local.gitconfig` (gitignore) に置く。
詳細は [Git User Switching](docs/git/user-switching.md)。

## Usage

```sh
# 設定ファイルの編集 → 保存するだけ (直リンク)
nvim config/nvim/init.lua

# パッケージ追加・テーマ変更 → rebuild
rebuild   # = sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#mac

# nixpkgs を更新
nix flake update && rebuild

# 前世代に戻す
sudo darwin-rebuild --rollback
```

## Docs

- [Docs Index](docs/README.md)
- [Nix 運用メモ](docs/nix.md)
- [Neovim Docs](docs/nvim/README.md)
