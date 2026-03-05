# dotfiles を chezmoi に移行する手順書

## 前提条件

- macOS (Apple Silicon)
- Homebrew インストール済み
- 移行元: `~/.config` を git で直接管理
- 移行先: `hforever11/dotfiles.git`（chezmoi 形式）

---

## Step 1: バックアップ

```bash
# .config 全体をバックアップ
cp -r ~/.config ~/.config.bak

# ホームディレクトリ直下のファイルもバックアップ
[ -f ~/.zprofile ] && cp ~/.zprofile ~/.zprofile.bak
[ -f ~/.zshenv ] && cp ~/.zshenv ~/.zshenv.bak
```

## Step 2: chezmoi インストール

```bash
brew install chezmoi
```

## Step 3: chezmoi 設定ファイルの作成

`chezmoi init` 時にテンプレートで対話入力が求められるため、先に設定ファイルを作成しておく。

```bash
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
    name = "your-git-username"
    email = "your-email@example.com"
EOF
```

> `name` と `email` は `git/config` テンプレートで使われる値。自分の情報に書き換えること。

## Step 4: chezmoi 初期化

```bash
chezmoi init https://github.com/hforever11/dotfiles.git
```

- `~/.local/share/chezmoi` にリポジトリがクローンされる
- Step 3 で設定済みのため、対話入力はスキップされる

## Step 5: 差分確認（適用前）

```bash
# 全体の差分を確認
chezmoi diff

# 変更されるファイル一覧だけ見たい場合
chezmoi diff | grep "^diff --git"
```

### 確認ポイント

- `git/config` — ユーザー名・メールが正しいか
- `nvim/` — プラグイン設定の変更
- `tmux/tmux.conf` — ローカルで変更中の内容が上書きされないか
- `zsh/.zshrc` — シェル設定の違い
- `.zshenv` — ZDOTDIR と Homebrew の設定

## Step 6: 適用

```bash
chezmoi apply -v
```

- `-v` で変更内容を表示しながら適用
- 初回は `run_once_install-packages.sh` が実行され、Brewfile のパッケージインストールが走る
- temurin 等の cask は sudo が必要なため、手動で別途インストールが必要な場合がある

## Step 7: dotfiles に無いファイルの対応

chezmoi 管理に追加したいファイルがあれば：

```bash
# 例: lazygit の設定を追加
chezmoi add ~/.config/lazygit/config.yml
```

管理しないファイル（認証情報など）はそのまま放置で OK。

## Step 8: 旧 git 管理の無効化

```bash
rm -rf ~/.config/.git ~/.config/.gitignore
```

> chezmoi が `~/.local/share/chezmoi` でバージョン管理するため不要。

## Step 9: 動作確認

```bash
# chezmoi の状態確認（空なら全て同期済み）
chezmoi status

# 全ファイルが同期しているか検証
chezmoi verify && echo "OK" || echo "NG"

# 管理ファイル一覧
chezmoi managed
```

ターミナルを再起動して、以下を確認：
- starship プロンプトが表示されるか
- nvim が正常に起動するか
- tmux の設定が反映されているか
- fzf のキーバインドが効いているか

---

## 日常の使い方

### 設定を変更したとき

```bash
# ~/.config 側を直接編集した場合 → ソースに反映
chezmoi add ~/.config/nvim/init.lua

# ソース側で編集したい場合（エディタが開く）
chezmoi edit ~/.config/nvim/init.lua

# ソースの変更を ~/.config に適用
chezmoi apply
```

### リポジトリに push

```bash
chezmoi cd
git add -A
git commit -m "update config"
git push
```

### 別マシンでセットアップ

```bash
# 1コマンドで init + apply
chezmoi init --apply https://github.com/hforever11/dotfiles.git
```

### リモートの変更を取り込む

```bash
chezmoi update
```

---

## ディレクトリ構成

```
~/.local/share/chezmoi/     ← ソース（git リポジトリ）
├── .chezmoi.toml.tmpl      ← テンプレート設定（name, email を聞く）
├── .chezmoiignore          ← chezmoi が無視するファイル
├── .chezmoiscripts/        ← 初回実行スクリプト
├── Brewfile                ← Homebrew パッケージ一覧
├── dot_config/             ← ~/.config/ に展開される
│   ├── bat/
│   ├── delta/
│   ├── fzf/
│   ├── ghostty/
│   ├── git/
│   ├── lazygit/
│   ├── mise/
│   ├── nvim/
│   ├── sheldon/
│   ├── starship/
│   ├── tmux/
│   ├── zsh/
│   └── zsh-abbr/
├── dot_zprofile            ← ~/.zprofile に展開
└── dot_zshenv              ← ~/.zshenv に展開

~/.config/chezmoi/
└── chezmoi.toml            ← ローカル設定（テンプレート変数の値）

~/.config/                  ← ターゲット（chezmoi が生成・管理）
```

---

## ロールバック手順

問題が起きた場合：

```bash
# バックアップから復元
rm -rf ~/.config
cp -r ~/.config.bak ~/.config

# .zshenv, .zprofile も復元
[ -f ~/.zprofile.bak ] && cp ~/.zprofile.bak ~/.zprofile
[ -f ~/.zshenv.bak ] && cp ~/.zshenv.bak ~/.zshenv

# chezmoi を削除（必要なら）
rm -rf ~/.local/share/chezmoi
rm -rf ~/.config/chezmoi
brew uninstall chezmoi
```
