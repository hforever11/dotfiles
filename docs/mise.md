# mise Notes

この環境では、ランタイム管理を `mise` に寄せる。
グローバルで使う `node/npm`, `python`, `go`, `rust`, `deno`, `uv` は `mise` を入口にする前提。

## 方針

- ランタイム本体は `mise` で入れる
- Homebrew は `mise` 自体とユーティリティ配布に寄せ、ランタイム本体の二重管理は避ける
- `npm` は `node` に同梱されるものを使う
- 特定プロジェクトだけ別 version が必要なら、その repo に `.mise.toml` を置く
- Rust は `mise` 経由で管理し、内部的な `rustup` は `mise` backend に任せる
- Neovim 専用の LSP サーバーは Homebrew ではなく Mason 管理を優先する

## グローバル設定

[`dot_config/mise/config.toml`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/mise/config.toml) では次を管理する。

- `node = "lts"`: npm を含む Node.js は LTS を使う
- `python = "3.14"`: Python は minor を固定しつつ patch を追従する
- `go = "1.25"`: Go は minor を固定する
- `deno = "latest"` / `uv = "latest"`: 更新追従を優先する
- `rust = { version = "stable", profile = "default", components = "rust-src" }`: stable toolchain と主要 component を揃える

## 初期化フロー

- [`dot_config/zsh/dot_zshenv`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/zsh/dot_zshenv) で Homebrew の PATH を読み込んだあとに `mise` shim を先頭に置く
- [`dot_config/zsh/dot_zshrc`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/zsh/dot_zshrc) で `mise activate zsh` を読み込む
- この順番で、interactive shell だけでなく Neovim / LSP / non-interactive shell でも `mise` 管理ランタイムを優先できる

## Bootstrap

[`run_onchange_01_install-packages.sh.tmpl`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/.chezmoiscripts/run_onchange_01_install-packages.sh.tmpl) では:

1. Homebrew を導入する
2. `brew bundle` で Brewfile のツールを入れる
3. `mise install -y` で `config.toml` のランタイムを入れる

そのため、`chezmoi apply` 後に `dot_config/mise/config.toml` の内容がまとめて反映される。

## 推奨コマンド

```sh
# config.toml に書かれたランタイムを入れる
mise install

# 管理中ランタイムの version を確認
mise current

# 実際に解決されるバイナリを確認
mise which node
mise which npm
mise which python3
mise which uv
mise which rustc

# 利用可能な version を探す
mise ls-remote node
mise ls-remote python
mise ls-remote rust

# 既存インストールを更新
mise upgrade
```

## プロジェクトごとに固定したい場合

プロジェクトのルートで実行する:

```sh
mise use node@22
```

これで `.mise.toml` が作られ、その repo だけ Node version を固定できる。

Python や Rust も同様:

```sh
mise use python@3.13
mise use rust@beta
```

## Neovim / LSP との関係

`yaml-language-server`, `tailwindcss-language-server`, `copilot-language-server` などは `node` 依存。
そのため、`node` が PATH に見えていないと `exit code 127` で落ちる。

この dotfiles では `pyright`, `vtsls`, `yamlls` などの editor-only LSP は Mason 管理を前提にしているので、Homebrew で同じサーバーを持つ必要はない。

Rust 系の開発では toolchain 側の `cargo`, `rustfmt`, `clippy`, `rust-src` が揃っている必要がある。
`rust-analyzer` の LSP サーバー自体は Neovim 側で `mason` 管理にしている。

## Claude Code の LSP サーバー

Neovim の LSP は Mason 管理だが、Claude Code の LSP プラグイン
(`typescript-lsp` / `pyright-lsp` など `@claude-plugins-official`)はラッパーにすぎず、
言語サーバー本体を**グローバル PATH 上**に要求する。Mason は Neovim 専用 PATH なので別管理になる。

本体が無いと `/doctor` で `Executable not found in $PATH` が出る。
`node` は `mise` 管理なので、グローバル install 後に `mise reshim` で shim を作る必要がある。

```sh
npm install -g typescript-language-server typescript pyright
mise reshim
```

確認:

```sh
which typescript-language-server pyright-langserver pyright
# すべて ~/.local/share/mise/shims/ 配下を指せば OK
```

反映後は Claude Code を再起動してから `/doctor` でエラーが消えたことを確認する。

注意点:

- `node` を `mise` でバージョンアップするとグローバル npm パッケージは引き継がれないので、
  再度 `npm install -g ...` → `mise reshim` が必要。
- Python プロジェクト個別で pyright を固定したいなら、その repo で `uv add --dev pyright` に寄せる手もある(グローバル分と共存可)。

## Rust について

`mise` の Rust backend は内部的に `rustup` を使う。
そのため `command -v rustc` や `command -v cargo` が `~/.cargo/bin/...` を指していても、`mise current rust` と version が揃っていれば問題ない。

Neovim 側では `rust-analyzer` を使い、保存時チェックは `clippy`、整形は `rustfmt` に分けている。

## Homebrew から寄せるとき

すでに Homebrew で `node`, `uv`, `python@3.x` などを入れている場合、dotfiles 側の定義を `mise` に寄せたあとで手動 cleanup する。

```sh
brew uninstall node uv python@3.14
brew uninstall pyright typescript-language-server typescript
hash -r
mise current
```

削除前に `command -v node`, `command -v npm`, `command -v python3`, `command -v uv` が `mise` 側を向くことを確認すると安全。

## トラブル時の確認

```sh
command -v node
node -v
command -v npm
npm -v
command -v python3
python3 --version
command -v uv
uv --version
command -v rustc
rustc --version
cargo --version
mise current
mise which node
mise which rustc
```

`command -v node` / `npm` / `python3` / `uv` が Homebrew や `/usr/bin` を向くなら、シェル初期化か未 cleanup を疑う。

## 管理境界

- **Mason**: Neovim 専用の LSP サーバー
- **mise**: ランタイム本体 + Claude Code 用 LSP サーバー(グローバル npm + `mise reshim`)
- **Homebrew**: ネイティブ配布のユーティリティや GUI アプリ
