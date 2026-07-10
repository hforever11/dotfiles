# Claude Code ベストプラクティス ギャップ分析

現行の Claude Code 設定・運用を 2026-07 時点の公式ベストプラクティスと突き合わせ、**「文書化・理解済みだが有効化していない」ギャップ**を優先度順に整理したもの。`dev-style.md`（開発スタイル）と `recommended-settings.md`（推奨設定）の補完。

- **出典**: 公式 [Best practices](https://code.claude.com/docs/en/best-practices) / [Memory](https://code.claude.com/docs/en/memory) / [Hooks](https://code.claude.com/docs/en/hooks) / [Sub-agents](https://code.claude.com/docs/en/sub-agents) / [Skills](https://code.claude.com/docs/en/skills)（2026-07 検証）
- **注記**: 組織ポリシー（managed settings / remote-settings）の具体値は機密のため本書には含めない。

---

## 再検証（2026-07-06 / CLI v2.1.200）

- `.claude/agents/` / `.claude/skills/` / hooks / `.claude/rules/` は検証時点で**依然すべてゼロ**だった → **同日、汎用グローバル構成として実装済み**（適用状況は下記「推奨アクション順」）。配置は chezmoi 管理の `dot_claude/` → `~/.claude/`。
- **新規ギャップ**: `.claude/settings.local.json` に承認プロンプト由来の allow が約 90 行蓄積し、グローバル方針と矛盾（`Bash(gh api:*)` / `Bash(git rm *)` / `Read(//Users/sfukunaga/**)` 等）。詳細と棚卸し手順は [recommended-settings.md](./recommended-settings.md) の 2026-07-06 節 → 推奨アクションの先頭に追加（同日実施済み）。
- fast mode の再評価（下記「更新を検討する点」）は**決着**: v2.1.154 で値下げされたが Opus 4.8/4.7 限定で、現在は Fable 5 運用のため対象外。
- モデル情勢: **Sonnet 5 が Claude Code のデフォルトに**（v2.1.197 / ネイティブ 1M / 2026-08-31 までプロモ価格）。Fable 5（Mythos クラス）は settings で明示指定中。

---

## エグゼクティブサマリ

設定の成熟度は高い（allowlist/denylist、lean な CLAUDE.md、context% 表示の statusline、LSP プラグイン、`docs/claude/` の整備）。**最大の問題は「知識と設定の乖離」**: `dev-style.md` に Plan Mode・subagent・TDD 3 エージェント・hooks・dynamic workflows まで文書化済みなのに、`.claude/agents/` `.claude/skills/` `hooks` はいずれも**ファイルが 1 つも存在しない**。読んで理解したが、有効化していない。**（2026-07-06 追記: この 3 点は汎用グローバル構成として実装済み → 「推奨アクション順」参照）**

最優先で埋めるべき 3 つ（すべてゼロ、かつ低コスト・高レバレッジ）:

1. **Hooks** — 決定論的な強制力。CLAUDE.md は「お願い」だが hooks は「必ず実行」。
2. **Skills** — `skill-creator` を導入済みなのに自作スキルがゼロ。繰り返す手順の置き場所。
3. **Subagents** — CLAUDE.md のレビュー基準をそのまま `code-reviewer` エージェントに落とせる。

---

## すでにできていること（強み・維持）

| 項目 | 状態 | 備考 |
|---|---|---|
| lean な CLAUDE.md | ✅ | ~50 行。200 行ガイドラインに対し高信号。TDD/設計/コメント/レビュー基準が明確 |
| 権限 allowlist + denylist | ✅ | 読み取り専用 git/gh/探索を allow、破壊的操作を deny。ワイルドカード濫用なし |
| context% 付き statusline | ✅ | 公式推奨の「context を常時トラッキング」を実践。chezmoi で再現可能 |
| コード知能プラグイン | ✅ | pyright/lua/ts/rust-analyzer LSP = 公式推奨の「typed 言語には code intelligence plugin」を実践済み |
| context7 プラグイン | ✅ | ライブラリドキュメント取得 |
| env チューニング | ✅ | `BASH_DEFAULT_TIMEOUT_MS` / `BASH_MAX_OUTPUT_LENGTH` |
| effortLevel: high | ✅ | Fable 5 で明示設定（既定 effort は公式未記載のため意味を持つ） |
| プロジェクト settings.local.json | ⚠️ | ドメイン allowlist + chezmoi 操作。ただし方針矛盾の allow が蓄積（再検証 2026-07-06 参照） |

公式が「多くの開発者が未導入」と名指しする項目のうち、**permission allowlist・statusline・code intelligence plugin は既に達成**している。ここは触らなくてよい。

---

## ギャップ（優先度順）

### Tier 1 — 設定で今すぐ効く（低コスト・高レバレッジ）

#### 1. Hooks（現在ゼロ）★最重要

CLAUDE.md は助言的（守られない場合がある）。hooks はライフサイクルの決まった時点で**必ず**シェルを実行する。公式は「例外なく毎回起きるべきことは CLAUDE.md ではなく hook に書け」と明言。

dotfiles リポジトリで特に効くもの:

- **PostToolUse（Edit/Write 後）にフォーマッタ**: `stylua`（nvim lua）、`shfmt`/`shellcheck`（`*.sh.tmpl`）を自動実行。手で「フォーマットして」と言わずに済む。
- **PreToolUse で「デプロイ先の直接編集」をブロック**: chezmoi 管理なので `~/.config/nvim/**` を直接編集するのはアンチパターン。ソース（`dot_config/...`）を編集すべき。この guard は chezmoi ユーザー特有の高価値パターン。
- **Stop フックで検証ゲート**: dotfiles には test スイートがない代わりに「設定が壊れず読めるか」を検証（Tier 2-5 参照）。

> **導入のコツ**: 公式は「hook は Claude に書かせろ」と推奨。例:「`*.lua` を Edit したら stylua をかける PostToolUse hook を settings に書いて」「`~/.config/` 配下への Write をブロックし、chezmoi ソースを編集するよう促す PreToolUse hook を書いて」。

代表的な形（`~/.claude/settings.json` か `.claude/settings.json`）:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/format.sh" }
        ]
      }
    ]
  }
}
```

`format.sh` は stdin で `tool_input`（編集ファイルパス）を受け取り、拡張子ごとに stylua/shfmt を呼ぶ。ブロックしたい場合は exit code 2 + stderr でメッセージ（Claude に伝わる）。

#### 2. Skills（現在ゼロ、`skill-creator` 導入済みなのに）

繰り返す手順・ドメイン知識の置き場所。CLAUDE.md と違い**呼ばれた時だけ読み込まれる**ためコンテキストを汚さない。`disable-model-invocation: true` で副作用のある手順を手動起動に限定できる。

`dev-style.md` の TDD 手順は、そのままスキルにできる:

```markdown
<!-- .claude/skills/tdd/SKILL.md -->
---
name: tdd
description: 探索→Red→Green→Refactoring で 1 機能を実装する
---
$ARGUMENTS を TDD で実装する。

1. 探索: 関連ファイルと既存パターンを読む（まだ実装しない）
2. Red: 対象+条件+期待結果を名前に含む失敗テストを 1 つ書き、実行して赤を確認
3. Green: テストを通す最小実装。mock で誤魔化さない
4. Refactoring: 重複除去・命名見直し。テストは緑のまま
5. 証拠を提示: 実行したコマンドとテスト出力を示す
```

dotfiles 向けなら `/chezmoi-verify`（apply → execute-template で検証 → nvim/tmux が壊れず読めるか）も有用。

#### 3. Subagents（現在ゼロ、3 エージェントパターンを文書化済みなのに）

別コンテキストで動くため、(a) 大量ファイル探索で本体を汚さない、(b) 実装バイアスのない「新鮮な目」でレビューできる。あなたの CLAUDE.md のレビュー基準をそのまま `code-reviewer` に落とすのが最短:

```markdown
<!-- .claude/agents/code-reviewer.md -->
---
name: code-reviewer
description: 差分を独立コンテキストでレビューし、重要度分類で報告する
tools: Read, Grep, Glob, Bash
model: opus
---
あなたはシニアエンジニア。現在の差分を以下でレビューする:

TDD 観点:
- 1 テスト 1 振る舞い（AAA）か
- テスト名が「対象+条件+期待結果」を語るか
- 仕様を駆動しているか（過剰 mock の写経でないか）
- 境界値・異常系・空ケースを網羅するか

報告様式:
- 重要度で分類（修正必須 / 推奨 / 提案）
- 必ず file:line と具体的リファクタ案を添える
- 「良い点」も短く記載する
```

呼び出し:「code-reviewer サブエージェントでこの差分をレビューして」。または公式バンドルの **`/code-review` スキル**（新鮮な subagent でバグ検出、後述）。

---

### Tier 2 — ワークフロー習慣（設定不要、やり方の問題）

#### 4. Plan Mode を「複数ファイル変更の既定」にする

`dev-style.md` に書いてあるが習慣化が課題。公式の 4 フェーズ: **Explore（plan mode で読むだけ）→ Plan（`Ctrl+G` でプランをエディタ編集）→ Implement → Commit**。
「1 文で diff を説明できる小変更」ならスキップしてよい、と公式も明記。判断基準を CLAUDE.md か rules に 1 行足すと定着する。

#### 5. 検証ループを渡す（公式が「最重要原則」とする項目）

Claude は「done に見えた」時点で止まる。**pass/fail を返すチェックを与えると自律的に反復**する。段階:

- **プロンプト内**: 「実装後にテストを実行して失敗を直せ」
- **セッション横断**: `/goal "all tests pass"` — 毎ターン評価器が再チェックし満たすまで続行
- **決定論ゲート**: Stop hook（8 連続ブロックで解除）
- **第三者**: `/code-review` スキル or レビュー subagent（実装したモデルとは別のモデルが反証を試みる）

> **dotfiles での「検証」= テストではなく「壊れず読めるか」**:
> - `chezmoi execute-template <src>` がエラーなくレンダーされるか
> - `nvim --headless "+checkhealth" +qa` / `+qa` が設定エラーを出さないか
> - `stylua --check` / `shellcheck` / `zsh -n`（構文チェック）
> - `tmux -f <conf> new-session -d \; kill-server` が通るか
>
> これらを「実装後に実行して直せ」と渡すのが、このリポジトリでの検証ループ。

#### 6. Claude にインタビューさせて SPEC.md → 新セッションで実装

大きめ機能では、最小プロンプト +「`AskUserQuestion` ツールで詳細にインタビューして SPEC.md を書いて」。考慮漏れ（エッジケース・トレードオフ）を先に潰し、**クリーンなコンテキストの新セッションで実装**する。

#### 7. コンテキスト衛生

- `/clear` を無関係タスク間で頻繁に（「kitchen sink セッション」回避）
- 2 回訂正しても直らないなら `/clear` + より具体的な初期プロンプトで再スタート（長い訂正履歴より速い）
- `/compact <指示>` で要約を制御（例: `/compact API 変更に集中`）
- `/btw` — 履歴に残さない小質問
- 探索は subagent に投げて本体を汚さない
- `/rewind`（`Esc Esc`）— チェックポイント復元。`/clear` より前にも戻れる。git の代替ではない

---

### Tier 3 — 応用・状況依存

#### 8. 並列セッション + git worktree（Writer/Reviewer）
別 worktree で「実装役」と「新鮮コンテキストのレビュー役」を分ける。実装したコードにバイアスのないレビューが得られる。個人利用でも有効。

#### 9. Path-scoped rules（`.claude/rules/`）
dotfiles はマルチドメイン（nvim=Lua / tmux / zsh / git / ghostty）。ドメイン別ルールを**該当ファイルを触る時だけ**読み込ませてコンテキストを節約:

```markdown
<!-- .claude/rules/lua.md -->
---
paths:
  - "dot_config/nvim/**/*.lua"
---
# Neovim Lua 規約
- lazy.nvim のプラグイン spec 形式に従う
- keymap は既存の `config/exact_core/keymaps.lua` のパターンを踏襲
```

`paths` なしのルールは常時ロード（`.claude/CLAUDE.md` と同格）。今の 1 枚 CLAUDE.md が肥大化したらここへ分割。

#### 10. Headless mode（`claude -p`）+ fan-out
`claude -p "..." --output-format json` で CI・スクリプト・pre-commit に組み込み。大量ファイル移行は `for f in ...; do claude -p "..." --allowedTools "Edit,Bash(...)"; done` で並列化。

#### 11. Auto-memory の活用
**実は稼働中**: `~/.claude/projects/<repo>/memory/MEMORY.md` に Claude が自動で学習を蓄積する（v2.1.59+ 既定 ON、リポジトリごと）。`/memory` で中身を閲覧・編集でき、「これ覚えて」で追記される。CLAUDE.md（あなたが書く規約）と auto-memory（Claude が学ぶ発見）は補完関係。時々 `/memory` で棚卸しを。

#### 12. MCP（組織許可済みサーバの活用）
組織ポリシーで外部 MCP が制限されている場合でも、許可済みサーバ（GitHub 等）は利用可能。GitHub MCP を繋げば issue/PR をチャットにコピペせず直接扱える。dotfiles では優先度低め。CLI（`gh`）で足りるものは CLI が context 効率的、というのが公式の指針。

---

## 2026 年の新機能で見落としがちなもの

`recommended-settings.md` は 2026-06 更新基準。それ以降/前後の追加で押さえておくとよいもの:

- **`/code-review` スキル**（バンドル）— 新鮮な subagent で差分のバグ検出。※`code-review` **プラグイン**を blocklist に入れていても、バンドル版スキルの `/code-review` は別物で利用可能。テスト用エントリなら掃除推奨。
- **Checkpointing / `/rewind`** — 全プロンプトが自動チェックポイント。「リスキーな案を試させて、ダメなら rewind」が可能。セッション跨ぎで残る。
- **`/goal`** — 継続検証条件（Tier 2-5）。
- **Auto mode**（`--permission-mode auto`）— 分類器が危険な操作だけブロックし、それ以外は承認プロンプトなしで進む。無人実行向け。組織の deny ルールは引き続き有効。
- **Dynamic workflows / Agent teams** — 数十〜数百の subagent をバックグラウンド編成（`dev-style.md` で言及済み）。大規模監査・移行向け。
- **`/cd`** — prompt cache を壊さずに作業ディレクトリ変更。
- **権限のパラメータマッチング** — `Tool(param:value)` 形式（例 `Bash(run_in_background:true)`）。
- **`AGENTS.md` 連携** — 他ツール用の AGENTS.md があれば `CLAUDE.md` から `@AGENTS.md` で取り込み一元化。
- **`claudeMdExcludes`** — monorepo で無関係な親 CLAUDE.md を除外。
- **CLAUDE.md 内の HTML コメント** `<!-- ... -->` は context に注入されず除去される（保守メモをトークン消費なしで残せる）。

### 2026-07-06 再検証で追加確認したもの

- **ultraplan / ultrareview**（research preview, v2.1.91+）— `/ultraplan <依頼>` でプラン作成を Claude Code on the web に委譲。ブラウザでセクション単位にコメント → 修正 → 「web で実装」か「ターミナルへテレポート」を選択。コードレビュー版の ultrareview もある。
- **`/agents` ウィザード削除**（v2.1.198）— subagent 作成は「Claude に頼む」か `.claude/agents/` 直接編集が正規手段（本書 Tier 1-3 のファイルベース構成がそのまま公式経路）。
- **subagent の強化** — 5 段までのネスト（v2.1.172）、frontmatter `memory: persistent` で永続メモリ。
- **skill frontmatter の拡充** — `paths`（glob でパス連動の自動有効化）/ `context: fork`（fork した subagent で実行）/ `hooks` / `shell`（v2.1.196+）。Tier 3-9 の path-scoped rules と同様のことが skill 単位でも可能に。
- **hooks の拡充** — イベント約 30 種（`Setup` / `PostToolBatch` / `ConfigChange` / `FileChanged` / `WorktreeCreate` 等）+ matcher **`if` フィールド**（permission ルール構文で絞り込み）。
- **workflow のトリガーキーワードは `ultracode`** — `workflow` という単語では発火しなくなった（v2.1.154 でリネーム。/config で発火自体の無効化も可）。
- **Claude in Chrome GA**（v2.1.198）。

---

## 既存ドキュメントで更新を検討する点

- ~~fast mode の評価~~ → **決着（2026-07-06）**: v2.1.154 の値下げ（標準 2 倍レートで 2.5 倍速）を確認。ただし Opus 4.8/4.7 限定で Fable 5 は対象外のため、現運用では採否の判断自体が不要。
- **blocklist の掃除**: テスト痕跡のエントリが残っていれば削除。

---

## 推奨アクション順

方針: **プロジェクト固有でなく汎用**の設定として実装する（2026-07-06 決定）。配置は chezmoi 管理の `dot_claude/` → `~/.claude/` で全マシン再現可能。

1. ✅ `.claude/settings.local.json` を棚卸し — 2026-07-06 実施。方針矛盾の 9 エントリ（`gh api:*` / `git rm *` / `claude *` / `Read(//Users/sfukunaga/**)` / `/tmp` 系 / 他プロジェクト参照）を削除、88 → 79 行。`defaults write` は dotfiles 用途として意図的に残置
2. ✅ `code-reviewer` subagent — 2026-07-06 実施。グローバル `~/.claude/agents/code-reviewer.md`（CLAUDE.md の設計 + TDD レビュー基準を移植）
3. ✅ PostToolUse フォーマット hook — 2026-07-06 実施。**汎用版**: プロジェクトに formatter 設定がある時だけ適用（stylua / gofmt / rustfmt / ruff / black / prettier / biome / shfmt）。設定が無ければ no-op
4. ⏭️ PreToolUse「デプロイ先直接編集」ブロック hook — dotfiles 固有のため見送り（汎用方針）。誤編集が実際に起きたらこのリポジトリの `.claude/` に追加
5. ✅ `/tdd` スキル — 2026-07-06 実施。tdd-test-writer / tdd-implementer / tdd-refactorer の 3 subagent + フェーズゲート skill をグローバルに（`dev-style.md` §B の構成）
6. ⏭️ dotfiles 用「検証コマンド」明記 — プロジェクト固有のため見送り
7. ✅ Plan Mode 既定の 1 行ルール — 2026-07-06 実施。グローバル CLAUDE.md「開発スタイル」に追記

---

## 関連ドキュメント

- [`dev-style.md`](./dev-style.md) — 上級エンジニアの Claude Code 開発スタイル
- [`recommended-settings.md`](./recommended-settings.md) — グローバル設定推奨事項
