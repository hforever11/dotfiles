# ghq コマンドリファレンス

## 基本情報

- **バージョン**: 1.9.4
- **リポジトリルート**: `~/ghq`
- **ディレクトリ構造**: `~/ghq/<ホスト>/<ユーザー>/<リポジトリ>`
- **設定ファイル**: `.gitconfig` の `[ghq]` セクション

---

## リポジトリの取得 (`ghq get`)

### target の指定方法

`https://` は省略可能。ホストが `github.com` の場合はそれも省略可能。

```bash
ghq get https://github.com/x-motemen/ghq   # フルURL
ghq get github.com/x-motemen/ghq            # https:// 省略
ghq get x-motemen/ghq                       # github.com も省略
ghq get git@github.com:x-motemen/ghq.git    # SSH URL
ghq get ../projB                            # 相対パス (同一org内の別リポジトリ)
```

`ghq.user` が設定されている場合、`ghq get <project>` でオーナーを省略できる。

### オプション

| オプション | 説明 |
| --- | --- |
| `--update, -u` | 取得済みリポジトリを最新に更新 |
| `-p` | SSH 経由でクローン |
| `--shallow` | シャロークローン (最新の履歴のみ) |
| `--branch, -b <branch>` | ブランチ指定 (Git では `--single-branch` で高速取得) |
| `--look, -l` | 取得後にそのディレクトリへ移動 (一時的な確認用) |
| `--parallel, -P` | 複数 target を並列取得 |
| `--no-recursive` | Git submodule の再帰取得を抑制 |
| `--bare` | ベアリポジトリとしてクローン |
| `--partial blobless\|treeless` | パーシャルクローン |
| `--vcs <vcs>` | VCS を明示指定 (git, hg, svn, git-svn, bzr, fossil, darcs) |
| `--silent, -s` | 出力を抑制 (`--parallel` 時は自動で有効) |

### SSH でクローンしたい場合

`-p` オプションより、Git 側の設定で統一するのが推奨：

```gitconfig
# pushのみSSHにする例
[url "git@github.com:"]
    pushInsteadOf = https://github.com/
```

---

## リポジトリの一覧 (`ghq list`)

### 基本

```bash
ghq list                    # 相対パスで一覧
ghq list --full-path        # フルパスで一覧
ghq list <query>            # 部分一致で絞り込み
ghq list github.com/        # ホスト配下のみ一覧
```

### オプション

| オプション | 説明 |
| --- | --- |
| `--full-path, -p` | フルパスで表示 |
| `--exact, -e` | クエリに後方一致 + サブパス完全一致で絞り込み |
| `--unique` | ユニークな最短サブパスで表示 |
| `--vcs <vcs>` | VCS で絞り込み |

### `--exact` の使い分け

```bash
ghq list go              # "go" を含むリポジトリすべて
ghq list --exact go      # プロジェクト名が "go" に完全一致
ghq list --exact golang/go  # owner/project で絞り込み
```

フルパスを一意に取得 (スクリプト連携向き)：

```bash
ghq list --full-path --exact github.com/x-motemen/ghq
```

---

## リポジトリの作成 (`ghq create`)

```bash
ghq create <project>                # ghq ルート配下に作成
ghq create <user>/<project>         # ユーザー指定で作成
ghq create --vcs hg <target>        # VCS を明示指定
```

ディレクトリ作成とリポジトリ初期化を同時に行う。

---

## リポジトリの削除 (`ghq rm`)

```bash
ghq rm <repo>               # ローカルリポジトリを削除
ghq rm --dry-run <repo>     # 削除の確認 (実際には削除しない)
```

---

## リポジトリの移行 (`ghq migrate`)

既存リポジトリを ghq 管理下に移行する。

```bash
ghq migrate <dir>            # 対話的に移行
ghq migrate -y <dir>         # 確認をスキップ
ghq migrate --dry-run <dir>  # 移行先の確認のみ
```

---

## ルートの確認 (`ghq root`)

```bash
ghq root           # プライマリルートを表示
ghq root --all     # 全ルートを表示 (複数設定時)
```

---

## 一括操作レシピ

### 全リポジトリを一括更新

```bash
ghq list | ghq get --update --parallel
```

### 別マシンへのリポジトリ移行

```bash
# 移行元
ghq list > repolist.txt

# 移行先
cat repolist.txt | ghq get --parallel
```

### submodule を個別に一括取得

```bash
cat .gitmodules | grep '\turl = ' | cut -d' ' -f 3 | ghq get --parallel
```

---

## 高度な設定

### プロジェクトごとに取得先を切り替え (`ghq.<base>.root`)

```gitconfig
[ghq]
    root = ~/ghq

[ghq "https://github.com/mycompany"]
    root = ~/work

[ghq "https://myvcs.example.com"]
    root = ~/work
```

`includeIf` と併用すると、ディレクトリ別に git 設定を切り分けられる：

```gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/work/.gitconfig
```

### 特定ホストの VCS を固定

```gitconfig
[ghq "https://svn.example.com"]
    vcs = svn
```

### オーナー補完の設定

```bash
# ghq get <project> で自分のリポジトリとして補完
git config --global ghq.user your-username

# owner名の代わりにプロジェクト名を使う (ruby → github.com/ruby/ruby)
git config --global ghq.completeUser false
```

### 動的なルート切り替え

`$GHQ_ROOT` 環境変数が設定されていると、他の設定に関わらずそのディレクトリに取得される。

---

## zsh 連携 (カスタム設定)

| キー | 説明 |
| --- | --- |
| `Ctrl + g` | ghq + fzf でリポジトリを選択して cd |

fzf のプレビューには eza のツリー表示 (2階層) が表示される。
