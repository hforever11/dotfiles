# dotfiles

nix-darwin + home-manager で管理する macOS 環境。

## Setup (新マシン)

```sh
# 1. Determinate Nix をインストール
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm

# 2. リポジトリを取得
git clone https://github.com/hforever11/dotfiles.git ~/ghq/github.com/hforever11/dotfiles

# 3. 適用 (ホストは work / personal)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/ghq/github.com/hforever11/dotfiles#work
```

2 回目以降は `darwin-rebuild` が PATH に入る:

```sh
sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#work
```

## 構成

| パス | 役割 |
|---|---|
| `config/` | 各ツールの設定。`~/.config/*` へ直リンクされ、**編集は即反映** (rebuild 不要) |
| `home/theme.nix` | テーマの単一ソース。fzf / nvim / hunk / statusline に生成展開 |
| `home/default.nix` | CLI パッケージ一覧 (nixpkgs) |
| `hosts/{work,personal}.nix` | ホスト固有値 (git identity など) |
| `darwin/homebrew.nix` | nixpkgs に無いものだけ brew 宣言 (hunk, vault, cask) |
| `bin/` | `~/.local/bin` へリンクされるスクリプト |
| `claude/` | `~/.claude/{agents,hooks,skills}` へリンク |

## Usage

```sh
# 設定ファイルの編集 → 保存するだけ (直リンク)
nvim config/nvim/init.lua

# パッケージ追加・テーマ変更・ホスト設定の変更 → rebuild
sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#work

# nixpkgs を更新
nix flake update && sudo darwin-rebuild switch --flake .#work

# 前世代に戻す
sudo darwin-rebuild --rollback
```

## Docs

- [Docs Index](docs/README.md)
- [Nix 運用メモ](docs/nix.md)
- [Neovim Docs](docs/nvim/README.md)
