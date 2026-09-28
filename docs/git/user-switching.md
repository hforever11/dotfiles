# Git ユーザーの自動切り替え

仕事用と個人用の Git ユーザー（name / email）を、リポジトリのディレクトリに応じて
Git の `includeIf` で自動的に切り替える。Nix は関与せず、`config/git/` の静的なファイルだけで完結する。

## 仕組み

`config/git/` はディレクトリごと `~/.config/git` に直リンクされている。
include の相対パスは `~/.config/git/` 基準で解決される。

```
config/git/
├── config                   … includeIf の入口 (下記)
├── personal.gitconfig       … 個人用 [user]。~/ghq/github.com/hforever11/ 配下で有効
├── dotfiles-repo.gitconfig  … このリポジトリだけ core.hooksPath = .githooks (pre-commit で nixfmt)
├── local.gitconfig          … マシン固有 (gitignore)。仕事用 identity の includeIf を書く
└── work.local.gitconfig     … 仕事用 [user] (gitignore)。local.gitconfig から include される
```

`config/git/config` の先頭:

```gitconfig
[includeIf "gitdir:~/ghq/github.com/hforever11/"]
	path = personal.gitconfig
[includeIf "gitdir:~/ghq/github.com/hforever11/dotfiles/"]
	path = dotfiles-repo.gitconfig
[include]
	path = local.gitconfig
```

`local.gitconfig` が無いマシンでは Git が黙って無視するので、個人用マシンでは作らなくてよい。

**SSH 鍵の切り替えはこの仕組みの対象外**。SSH 鍵は `~/.ssh/config` の
ホストエイリアス（`github.com` / `github.com-ktd` など、`IdentitiesOnly yes` +
`IdentityFile` で個別指定）で、リモート URL 側 (`git@github.com-ktd:org/repo.git`) を
使い分けて選択する。この `~/.ssh/config` はこのリポジトリの管理外（マシンごとに手動管理）。

## セットアップ

### 新しい仕事用マシンで仕事用 identity を追加する

`config/git/local.gitconfig`:

```gitconfig
[includeIf "gitdir:~/ghq/github.com/<work-org>/"]
  path = work.local.gitconfig
```

`config/git/work.local.gitconfig`:

```gitconfig
[user]
  name = <仕事用の名前>
  email = <仕事用のメールアドレス>
```

どちらも gitignore 対象で、直リンクなので rebuild は不要（保存した時点で有効）。

## 動作確認

```sh
# 個人リポジトリで確認
cd ~/ghq/github.com/hforever11/dotfiles
git config user.email   # → 個人用メールアドレス

# 仕事リポジトリで確認 (local.gitconfig を置いたマシンのみ)
cd ~/ghq/github.com/<work-org>/some-repo
git config user.email   # → 仕事用メールアドレス

# どのファイルから値が来ているか
git config --show-origin --get-regexp '^user\.'
```
