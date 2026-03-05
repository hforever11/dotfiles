# Git ユーザー切り替え

仕事用と個人用の Git ユーザーを、リポジトリのディレクトリに応じて自動で切り替える仕組み。

仕事用の具体的な情報（名前・メールアドレス・組織ディレクトリ）はリポジトリには含まれず、`chezmoi init` 時にローカルにのみ保存される。

## 仕組み

```
~/.config/git/config
├── [user]  ← デフォルト（個人用）
├── [includeIf "gitdir:~/ghq/github.com/your-org/"]  ← 仕事用ディレクトリのみ
│   └── path = ~/.config/git/users/work.gitconfig
└── ...

~/.config/git/users/work.gitconfig  ← 仕事用の name/email を上書き
```

Git の `includeIf` により、指定ディレクトリ配下のリポジトリでは仕事用の設定が自動適用される。

## セットアップ

### 初回セットアップ

```sh
chezmoi init --apply hforever11/dotfiles
```

対話プロンプトで以下を聞かれる：

| プロンプト | 説明 |
|---|---|
| Git user name | デフォルト（個人用）の名前 |
| Git email address | デフォルト（個人用）のメールアドレス |
| Machine type | `personal` または `work` を選択 |

`work` を選んだ場合、追加で以下を聞かれる：

| プロンプト | 説明 | 例 |
|---|---|---|
| Work Git user name | 仕事用の名前 | `taro-company` |
| Work Git email address | 仕事用のメールアドレス | `taro@company.com` |
| Work Git directory | 仕事用リポジトリの親ディレクトリ | `~/ghq/github.com/your-org/` |

### 設定の変更

保存済みの値を変更したい場合：

```sh
# chezmoi の設定ファイルを直接編集
chezmoi edit-config
```

`~/.config/chezmoi/chezmoi.toml` の `[data]` セクションを編集する：

```toml
[data]
    name = "your-name"
    email = "your-email@example.com"
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
cd ~/ghq/github.com/your-personal-repo
git config user.email  # → 個人用メールアドレス

# 仕事リポジトリで確認
cd ~/ghq/github.com/your-org/some-repo
git config user.email  # → 仕事用メールアドレス
```
