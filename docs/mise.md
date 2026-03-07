# mise Notes

この環境では、ランタイム管理は `mise` に寄せる。
少なくとも `node` は `mise` で管理するのが前提。

## 方針

- グローバルの `node` は `mise` で入れる
- `Neovim` の LSP が使う `node` もこれに乗る
- 特定プロジェクトだけ別 version が必要なら、その repo に `.mise.toml` を置く
- `brew install node` と `mise` の二重管理は避ける

## 推奨コマンド

```sh
# LTS をグローバルに使う
mise use -g node@lts

# 現在の有効 version を確認
mise current

# 実際に解決される node を確認
mise which node

# 利用可能な Node version を探す
mise ls-remote node
```

## プロジェクトごとに固定したい場合

プロジェクトのルートで実行する:

```sh
mise use node@22
```

これで `.mise.toml` が作られ、その repo だけ Node version を固定できる。

## Neovim / LSP との関係

`yaml-language-server`, `tailwindcss-language-server`, `copilot-language-server` などは `node` 依存。
そのため、`node` が PATH に見えていないと `exit code 127` で落ちる。

今回の dotfiles では [`dot_config/zsh/dot_zshrc`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/zsh/dot_zshrc) で `mise activate zsh` を読み込むようにしている。

## トラブル時の確認

```sh
command -v node
node -v
mise current
mise which node
```

`command -v node` が空なら、シェル初期化か `mise` の導入状態を疑う。
