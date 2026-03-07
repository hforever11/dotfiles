# Git ユーザー・SSH 鍵の自動切り替え

仕事用と個人用の Git ユーザー・SSH 鍵を、リポジトリのディレクトリに応じて自動で切り替える仕組み。

仕事用の具体的な情報（名前・メールアドレス・組織ディレクトリ）はリポジトリには含まれず、`chezmoi init` 時にローカルにのみ保存される。

## 仕組み

```
~/.config/git/config
├── [includeIf "gitdir:~/ghq/github.com/<personal>/"]
│   └── path = ~/.config/git/users/personal.gitconfig
├── [includeIf "gitdir:~/ghq/github.com/<work-org>/"]  ← work マシンのみ
│   └── path = ~/.config/git/users/work.gitconfig
└── ...

~/.config/git/users/personal.gitconfig
├── [user]   name, email
└── [core]   sshCommand = ssh -i ~/.ssh/id_rsa

~/.config/git/users/work.gitconfig  ← work マシンのみ生成
├── [user]   name, email
└── [core]   sshCommand = ssh -i ~/.ssh/id_ed25519_work
```

Git の `includeIf` により、ディレクトリに応じて **ユーザー情報と SSH 鍵が同時に切り替わる**。
`core.sshCommand` で鍵を直接指定するため、SSH config に偽ホスト名や `insteadOf` は不要。

## セットアップ

### 初回セットアップ

```sh
chezmoi init --apply hforever11/dotfiles
```

`git config --global` に `user.name` / `user.email` が設定済みなら自動でデフォルト値が入る。
ほとんどの場合 Enter 連打で OK。

| プロンプト | 説明 | デフォルト値 |
|---|---|---|
| Git user name | 個人用の名前 | `git config --global user.name` |
| Git email address | 個人用のメールアドレス | `git config --global user.email` |
| Personal Git directory | 個人リポジトリの親ディレクトリ | `~/ghq/github.com/<name>/` |
| Machine type | `personal` または `work` を選択 | — |

`work` を選んだ場合、追加で以下を聞かれる：

| プロンプト | 説明 | 例 |
|---|---|---|
| Work Git user name | 仕事用の名前 | `taro-company` |
| Work Git email address | 仕事用のメールアドレス | `taro@company.com` |
| Work Git directory | 仕事用リポジトリの親ディレクトリ | `~/ghq/github.com/your-org/` |

### 完全に非対話で init する場合

```sh
chezmoi init --apply \
  --promptString name=myname \
  --promptString email=me@example.com \
  --promptString gitdir="~/ghq/github.com/myname/" \
  --promptChoice machine_type=personal \
  hforever11/dotfiles
```

### SSH 鍵の準備

chezmoi は SSH 鍵自体は管理しない。各マシンで鍵を用意すること。

| 用途 | 鍵ファイル |
|---|---|
| 個人用 GitHub | `~/.ssh/id_rsa` |
| 仕事用 GitHub | `~/.ssh/id_ed25519_work` |

### 設定の変更

```sh
# chezmoi の設定ファイルを直接編集
chezmoi edit-config
```

`~/.config/chezmoi/chezmoi.toml` の `[data]` セクションを編集する：

```toml
[data]
    name = "your-name"
    email = "your-email@example.com"
    gitdir = "~/ghq/github.com/your-name/"
    machine_type = "work"
    work_name = "your-work-name"
    work_email = "your-work-email@company.com"
    work_gitdir = "~/ghq/github.com/your-org/"
```

編集後に適用：

```sh
chezmoi apply
```

### personal から work への切り替え

`chezmoi edit-config` で `machine_type` を `"work"` に変更し、`work_name`・`work_email`・`work_gitdir` を追加してから `chezmoi apply` を実行する。

## 動作確認

```sh
# 個人リポジトリで確認
cd ~/ghq/github.com/your-name/some-repo
git config user.email   # → 個人用メールアドレス
git config core.sshCommand  # → ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes

# 仕事リポジトリで確認（work マシンのみ）
cd ~/ghq/github.com/your-org/some-repo
git config user.email   # → 仕事用メールアドレス
git config core.sshCommand  # → ssh -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes
```
