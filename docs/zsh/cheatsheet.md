# Zsh Cheatsheet

シェルのエイリアス・スニペット・キーバインドのまとめ。

## キーバインド

| キー     | 説明                                         |
| -------- | -------------------------------------------- |
| `Ctrl+g` | ghq + fzf でリポジトリを選択して cd          |
| `Ctrl+t` | ghq + fzf でリポジトリの herdr workspace を作成/フォーカス |
| `Ctrl+r` | fzf: コマンド履歴を fuzzy 検索               |
| `Ctrl+o` | fzf でファイルを選んでコマンドラインに挿入（`fzf-file-widget`） |

`Ctrl+t` は既存 workspace があれば focus、無ければ作成する。詳細は [herdr Commands](../herdr/COMMANDS.md) 参照。

`Ctrl+o` は fzf 標準のファイル挿入ウィジェット。`Ctrl+t` を ghq に割り当てているため
`Ctrl+o` へ退避している。プレビューは bat（ディレクトリは eza ツリー）。

## fzf コマンド

入力して実行する fzf ベースの関数。

| コマンド          | 説明                                                     |
| ----------------- | -------------------------------------------------------- |
| `rg-fzf [query]`  | ripgrep の live grep（入力ごとに再検索）→ 選択行を nvim で開く |
| `gco-fzf`         | ブランチを選んで `git switch`（単発の切替は lazygit より速い） |
| `fkill`           | プロセスを選んで kill（`Tab` で複数選択、SIGTERM）        |
| `pr-fzf`          | `gh pr list` から選んで `gh pr checkout`                 |

`rg-fzf` のプレビューは該当行をハイライト表示。`gco-fzf` はリモート名
（`remotes/origin/…`）を自動で短縮するため、選ぶだけで追跡ブランチを作成できる。

## エイリアス

| エイリアス | 展開先                                      |
| ---------- | ------------------------------------------- |
| `vim`      | `nvim`                                      |
| `c`        | `clear`                                     |
| `cat`      | `bat`（シンタックスハイライト付き）          |
| `diff`     | `delta`（Git スタイルの diff）               |
| `gds`      | `git diff --delta-features="+side-by-side"` |

## 略語展開（zsh-abbr）

**Space / Enter で略語をフルコマンドに自動展開**する（fish の abbr 相当）。
例: `gs` + Space → `git status` に展開される。alias と違い実行前に展開されるので、
履歴にはフルコマンドが残り、展開後に編集もできる。

- 定義ファイル: `~/.config/zsh-abbr/user-abbreviations`（chezmoi 管理）
- その場で追加: `abbr add xxx="..."`（定義ファイルに追記される）
- 展開させたくないとき: `Ctrl+v` を挟んで Space（quoted-insert）

※ zeno.zsh から移行（2026-07）。Deno 依存と独自実装を排して定番ツールに寄せた。

### Git

| キー   | 展開先                        |
| ------ | ----------------------------- |
| `g`    | `git`                         |
| `ga`   | `git add`                     |
| `gc`   | `git commit`                  |
| `gco`  | `git checkout`                |
| `gd`   | `git diff`                    |
| `gp`   | `git push`                    |
| `gl`   | `git pull`                    |
| `gs`   | `git status`                  |
| `glog` | `git log --oneline --graph`   |

### Docker

| キー  | 展開先                 |
| ----- | ---------------------- |
| `d`   | `docker`               |
| `dc`  | `docker compose`       |
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down`  |
| `dps` | `docker ps`            |

### Kubernetes

| キー  | 展開先              |
| ----- | ------------------- |
| `k`   | `kubectl`           |
| `kgp` | `kubectl get pods`  |
| `kgs` | `kubectl get svc`   |
| `kgd` | `kubectl get deploy` |
| `kd`  | `kubectl describe`  |
| `kl`  | `kubectl logs`      |
| `kex` | `kubectl exec -it`  |

### ナビゲーション / 一般

| キー | 展開先                   |
| ---- | ------------------------ |
| `cd` | `z`（zoxide ジャンプ）   |
| `ls` | `eza --icons --git`      |
| `ll` | `eza -l --icons --git`   |

## Tab 補完（fzf-tab）

Tab を押すと zsh 標準の補完候補が **fzf で絞り込める**。zeno の独自パターン定義と違い、
zsh の補完関数が文脈を理解するので `git switch <Tab>` のブランチ一覧、
`docker stop <Tab>` のコンテナ一覧、`kubectl logs <Tab>` の Pod 一覧などが定義なしで出る。

- kubectl の補完は nix パッケージに site-functions が同梱されないため、
  zshrc が `kubectl completion zsh` を `~/.cache/zsh/completions/_kubectl` に生成してキャッシュする
- 補完が古い/おかしいときは `rm ~/.cache/zsh/zcompdump*` して開き直す

## ツール連携

| ツール    | 役割                                 |
| --------- | ------------------------------------ |
| `sheldon` | Zsh プラグインマネージャ             |
| `zsh-abbr`| 略語展開（Space/Enter）              |
| `fzf-tab` | Tab 補完の fzf UI 化                 |
| `mise`    | ランタイム管理（node/npm, python, go, rust, deno, uv） |
| `fzf`     | fuzzy finder（`Ctrl+r` 履歴 / `Ctrl+o` ファイル挿入） |
| `starship`| プロンプト                           |
| `zoxide`  | スマート cd（`z` コマンド）          |
