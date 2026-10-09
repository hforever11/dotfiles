# mise Notes

この環境では、ランタイムを `mise` でまとめて管理する。
グローバルで使う `node/npm`, `python`, `go`, `rust`, `deno`, `uv` は、`mise` 経由で呼び出す前提にしている。

## 方針

- ランタイム本体は `mise` で入れる
- `mise` 自体は nix (`home/mise.nix`) で入れる。ランタイム本体を nix / Homebrew と二重管理しない
- `npm` は `node` に同梱されるものを使う
- 特定プロジェクトだけ別 version が必要なら、その repo に `.mise.toml` を置く
- Rust は `mise` で管理し、内部で使う `rustup` は `mise` の backend に任せる
- Neovim 専用の LSP サーバーは Homebrew ではなく Mason 管理を優先する

## グローバル設定

[`config/mise/config.toml`](../config/mise/config.toml) では次を管理する。

- `node = "lts"`: npm を含む Node.js は LTS を使う
- `python = "3.14"`: Python は minor を固定し、patch の更新には追従する
- `go = "1.25"`: Go は minor を固定する
- `deno = "2"` / `uv = "0"`: major だけ固定して更新に追従する
- `opentofu = "latest"`: `tofu` はここで管理する (nix 側に tenv は置かない)
- `rust = { version = "stable", profile = "default", components = "rust-src" }`: stable toolchain と主要 component を揃える

## 初期化フロー

- [`config/zsh/.zshenv`](../config/zsh/.zshenv) で Homebrew の PATH を読み込んだあとに、`mise` の shim を PATH の先頭に置く
- [`config/zsh/.zshrc`](../config/zsh/.zshrc) は `mise activate` を使わず、shims 方式にしている。`mise env` の結果 (PATH 以外) だけをキャッシュして読む
- shims 方式なので、interactive shell だけでなく Neovim / LSP / non-interactive shell でも、`mise` で管理しているランタイムを優先して使える

## Bootstrap

`home/mise.nix` の `home.activation.miseInstall` が、switch のたびに `mise install -y` を実行する。
そのため、rebuild 後に `config/mise/config.toml` の内容がまとめて反映される。

Homebrew 側は、`darwin-rebuild switch` のときに `darwin/homebrew.nix` の宣言に合わせて同期される。

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

プロジェクトのルートで次を実行する。

```sh
mise use node@22
```

これで `.mise.toml` が作られ、その repo だけ Node version を固定できる。

Python や Rust も同じ方法で固定できる。

```sh
mise use python@3.13
mise use rust@beta
```

## Neovim / LSP との関係

`yaml-language-server`, `tailwindcss-language-server` などは `node` に依存している。
そのため、`node` が PATH から見つからないと `exit code 127` で落ちる。

この dotfiles では、`pyright`, `vtsls`, `yamlls` などエディタ専用の LSP サーバーは Mason で管理する前提にしている。そのため、Homebrew で同じサーバーを入れる必要はない。

Rust 系の開発では、toolchain 側の `cargo`, `rustfmt`, `clippy`, `rust-src` が揃っている必要がある。
`rust-analyzer` の LSP サーバー自体は、Neovim 側の Mason で管理している。

## Claude Code の LSP サーバー

Neovim の LSP サーバーは Mason で管理している。
一方で、Claude Code の LSP プラグイン (`typescript-lsp` / `pyright-lsp` など `@claude-plugins-official`) はラッパーにすぎず、言語サーバーの本体はグローバルな PATH 上にあるものを使う。
Mason で入れたサーバーは Neovim の中でしか PATH が通らないので、Claude Code 用は Mason とは別に管理する。

本体が無いと、`/doctor` で `Executable not found in $PATH` が出る。
`node` は `mise` で管理しているので、npm でグローバルにインストールしたあとに `mise reshim` で shim を作る必要がある。

```sh
npm install -g typescript-language-server typescript pyright
mise reshim
```

確認には次のコマンドを使う。

```sh
which typescript-language-server pyright-langserver pyright
# すべて ~/.local/share/mise/shims/ 配下を指せば OK
```

反映後は Claude Code を再起動してから、`/doctor` でエラーが消えたことを確認する。

### 注意点

- `node` を `mise` でバージョンアップすると、グローバルの npm パッケージは引き継がれない。もう一度 `npm install -g ...` を実行してから `mise reshim` する必要がある。
- Python プロジェクトごとに pyright のバージョンを固定したいなら、その repo で `uv add --dev pyright` を使う方法もある。グローバルに入れたものと共存できる。

## Rust について

`mise` の Rust backend は内部で `rustup` を使う。
そのため、`command -v rustc` や `command -v cargo` が `~/.cargo/bin/...` を指していても、`mise current rust` と version が揃っていれば問題ない。

Neovim 側では `rust-analyzer` を使い、保存時チェックは `clippy`、整形は `rustfmt` に分けている。

## Homebrew から移すとき

すでに Homebrew で `node`, `uv`, `python@3.x` などを入れている場合は、dotfiles 側の定義を `mise` に移したあとで、Homebrew で入れたものを手動で削除する。

```sh
brew uninstall node uv python@3.14
brew uninstall pyright typescript-language-server typescript
hash -r
mise current
```

削除する前に、`command -v node`, `command -v npm`, `command -v python3`, `command -v uv` が `mise` 側を指していることを確認すると安全。

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

`command -v node` / `npm` / `python3` / `uv` が Homebrew や `/usr/bin` を指しているなら、シェルの初期化か、Homebrew 側の削除漏れを疑う。

## 管理境界

- **Mason**: Neovim 専用の LSP サーバー
- **mise**: ランタイム本体 + Claude Code 用 LSP サーバー(グローバル npm + `mise reshim`)
- **Homebrew**: ネイティブ配布のユーティリティや GUI アプリ
