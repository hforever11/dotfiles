# Claude Code 設定メモ

グローバル設定 (`~/.claude/`) の現状と、その設計意図。

## どこに何があるか

すべて `claude/` に置き、`~/.claude/` の同名パスへ直リンクしている (`home/links.nix`)。

| ファイル | 内容 |
|---|---|
| `settings.json` | モデル / 権限 / hook / statusline / プラグインなど (下記) |
| `CLAUDE.md` | 全プロジェクト共通の指示 (「日本語で話して下さい。」のみ) |
| `keybindings.json` | `shift+enter` で改行、`ctrl+j` 無効 |
| `statusline.sh` | statusline 本体 (下記) |
| `hooks/format.sh` | Edit/Write 後の formatter (下記) |
| `skills/commit/` | `/commit` スキル |

`~/.claude` はセッション履歴などのランタイム状態を含むため、ディレクトリごとはリンクしない。
`settings.json` は Claude Code 自身も書き換える (権限の許可, `/effort` の既定値, プラグインの有効化など)。
リンクは保たれたままリンク先 (リポジトリのファイル) が更新されるので、変更は git の差分として現れる
(2 段のシンボリックリンク越しでも保たれることを v2.1.283 で確認)。
Claude Code が同期する組織スキルは `claude/skills/synced/` に書かれるので gitignore している。

## `settings.json` の中身

- `modelSettings`: Opus 5.5 は `effortLevel: xhigh`。全体の既定は `effortLevel: high`
- `enabledPlugins`: pyright / lua / typescript / rust-analyzer の LSP, context7, skill-creator
- `extraKnownMarketplaces`: karpathy-skills
- `env`: `BASH_DEFAULT_TIMEOUT_MS=180000` (3 分), `BASH_MAX_OUTPUT_LENGTH=30000` (context 消費抑制)
- `attribution`: commit / PR とも空 (Co-Authored-By を付けない)
- `hooks.PostToolUse`: Edit/Write 後に `~/.claude/hooks/format.sh` (下記)
- `statusLine`: `~/.claude/statusline.sh` (下記)
- `theme: light` / `tui: fullscreen` / `skipWorkflowUsageWarning: true`

## `permissions` の方針

- `defaultMode` は未設定。allow に無い Bash は承認を通る
- `allow` は **読み取り専用のサブコマンドだけ** (git status/diff/log…, gh の view/list, ls, rg, brew list, mise ls,
  nix search/eval/flake show/path-info, `nix build --dry-run`, `nixfmt --check` など)。
  `Bash(git:*)` のような広いワイルドカードや、実行系オプションを持つ `find` / `fd` / `gh api` は入れない
- `deny` は **誤操作ガード**: `git push --force` 系, `git reset --hard`, `git branch -D/-d`, `git clean -fd`,
  `rm -r` 系, `sudo rm`, `dd`, `mkfs`, `chmod -R 777`, `brew uninstall` など

deny は前方一致なので事故防止にはなるが、セキュリティ境界ではない:

- `&&` / `;` / `|` などの複合コマンドはサブコマンドごとに判定されるので、連結では回避できない
- フラグなしの単発 `rm file` は deny に当たらない (承認は必ず通る)
- 変数やコマンド置換で危険語を隠すと前方一致をすり抜ける。確実に止めたいなら PreToolUse hook か sandboxing を使う

## hook: `format.sh`

Edit/Write したファイルに、**プロジェクトに設定がある formatter だけ**を適用する (設定が無ければ何もしない。常に exit 0)。

| 拡張子 | 条件 | formatter |
|---|---|---|
| lua | `stylua.toml` / `.stylua.toml` | stylua |
| go | `go.mod` | gofmt |
| rs | `rustfmt.toml` / `.rustfmt.toml` | rustfmt |
| py | `ruff.toml` / pyproject の `[tool.ruff]` (`[tool.black]` なら black) | ruff format |
| nix | `flake.nix` に `formatter` がある | `nix fmt` (1 回 1〜2 秒) |
| js / ts / json / md / yaml など | `biome.json` / prettier の設定 | biome / prettier (node_modules 優先) |

設定ファイルは編集したファイルの位置から git root まで遡って探す。

## statusLine

```
Opus 5.5 │ ◐ 89% │ dotfiles │ ⎇ main *↑2 │ +120 -15
```

- モデル名 (`(1M context)` などの suffix は剥がす) / context 使用率 (`<50%` 緑・`<80%` 黄・それ以上赤) /
  プロジェクト名 / git branch (dirty `*`, ahead/behind `↑↓`, detached 時は SHA) / セッション中の追加・削除行数 /
  output style (default 以外のとき)
- 配色は `home/theme.nix` から生成される `~/.config/theme/palette.sh` を source する
- jq と git はそれぞれ 1 回だけ呼ぶ (TSV にまとめて read、`git status --porcelain=v2` 1 回)
- `context_window.used_percentage` は session 初期や `/compact` 直後に null になるので、その間は表示を省く

## 避けること

- グローバルで `permissions.defaultMode: "acceptEdits"` / `"bypassPermissions"`
- `permissions.allow` に広すぎるパターン (`Bash(git:*)` / `Bash(gh api:*)` / `Bash(find:*)`)
- グローバル `CLAUDE.md` にプロジェクト固有の規約を書く (全プロジェクトで context を消費する)
- 使わない LSP プラグインを有効にしておく (起動が遅くなる)

## 参考リンク

- [Settings](https://code.claude.com/docs/en/settings) / [Permissions](https://code.claude.com/docs/en/permissions) /
  [Hooks](https://code.claude.com/docs/en/hooks) / [Status Line](https://code.claude.com/docs/en/statusline) /
  [Memory & CLAUDE.md](https://code.claude.com/docs/en/memory)
- [開発スタイル](dev-style.md)
