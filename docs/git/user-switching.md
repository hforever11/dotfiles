# Git ユーザーの自動切り替え

仕事用と個人用の Git ユーザー（name / email）を、リポジトリのディレクトリに応じて
nix-darwin + home-manager が自動で切り替える仕組み。

仕事用の具体的な情報（名前・メールアドレス・組織ディレクトリ）はリポジトリに直接書く
（`hosts/work.nix` はこのリポジトリ専用の設定であり、汎用テンプレートではないため）。

## 仕組み

- オプション定義: [`modules/identity.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/modules/identity.nix)
  が `my.git.personal` / `my.git.work` (name/email/dir) を宣言する
- ホスト別の値: [`hosts/work.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/hosts/work.nix) /
  [`hosts/personal.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/hosts/personal.nix) が実際の name/email/dir を持つ
  (`work.nix` は personal + work の両方、`personal.nix` は personal のみ)
- 生成: [`home/git.nix`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/home/git.nix) が
  `~/.config/git/identity.gitconfig` に `includeIf` ブロックを書き出す

```
~/.config/git/identity.gitconfig
├── [includeIf "gitdir:<personal.dir>"]
│   └── path = ~/.config/git/users/personal.gitconfig  ([user] name, email)
└── [includeIf "gitdir:<work.dir>"]      ← work.nix で git.work を設定した場合のみ
    └── path = ~/.config/git/users/work.gitconfig       ([user] name, email)
```

Git の `includeIf` により、ディレクトリに応じて **ユーザー名・メールアドレスが自動で切り替わる**。

**SSH 鍵の切り替えはこの仕組みの対象外**（旧 chezmoi 版にあった `core.sshCommand` の
ディレクトリ連動は現行の nix 構成には引き継いでいない）。SSH 鍵は `~/.ssh/config` の
ホストエイリアス（`github.com` / `github.com-ktd` など、`IdentitiesOnly yes` +
`IdentityFile` で個別指定）で、リモート URL 側 (`git@github.com-ktd:org/repo.git`) を
使い分けて選択する。この `~/.ssh/config` はこのリポジトリの管理外（マシンごとに手動管理）。

## セットアップ

### 新しいマシンで identity を設定する

1. `modules/identity.nix` の `username` / `dotfilesDir` がそのマシンと一致するか確認する
   （違う場合は `hosts/*.nix` で `my.username` / `my.dotfilesDir` を上書き）
2. `hosts/work.nix` または `hosts/personal.nix` に `my.git.personal` / `my.git.work` の
   name/email/dir を書く
3. `flake.nix` の `darwinConfigurations.<name>` がどの `hosts/*.nix` を import するか確認する
   (現状 `work` → `hosts/work.nix`, `personal` → `hosts/personal.nix`)
4. rebuild (`sudo darwin-rebuild switch --flake ~/ghq/github.com/hforever11/dotfiles#work` など)

### personal だけの構成から work を追加する

`hosts/personal.nix` の `my.git.work` に name/email/dir を追記して rebuild すれば、
`~/.config/git/users/work.gitconfig` と `includeIf` が追加生成される
（`home/git.nix` は `git.work != null` の場合のみ work 用ブロックを生成する）。

## 動作確認

```sh
# 個人リポジトリで確認
cd ~/ghq/github.com/hforever11/some-repo
git config user.email   # → 個人用メールアドレス

# 仕事リポジトリで確認 (my.git.work を設定したホストのみ)
cd ~/ghq/github.com/<work-org>/some-repo
git config user.email   # → 仕事用メールアドレス
```
