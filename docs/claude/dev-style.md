# 上級エンジニアの Claude Code 開発スタイル

2026 年前半時点で、上級エンジニア / Anthropic チームが共通して実践している Claude Code の使い方まとめ。
出典は末尾の参照リンク。

> **2026-07-06 再検証**（CLI v2.1.200 / changelog 突合済み）: 本文の手法は現行仕様と整合。修正・追記した差分は次の通り。
> ① workflow のトリガーキーワードは `ultracode` にリネーム済み — "workflow" と書いても発火しない（§6 反映）
> ② plan mode の切替は `Shift+Tab`。`Ctrl+G` は「プランをエディタで開く」（§A 反映）
> ③ `/agents` ウィザードは廃止（v2.1.198）→ `.claude/agents/` のファイル直接編集が正規手段に。§B の YAML 構成がそのまま公式経路
> ④ subagent は 5 段までネスト可能に（v2.1.172）。frontmatter `memory: persistent` で永続メモリも持てる
> ⑤ skill frontmatter に `paths`（glob でパス連動の自動有効化）と `context: fork` が追加（§B 補足参照）
> ⑥ クラウドプランニング **ultraplan** 登場（§A 参照）
> モデル情勢（Sonnet 5 デフォルト化・Fable 5）は [recommended-settings.md](./recommended-settings.md) を参照。

## 1. いきなり実装させない（Plan Mode 起点）

最も繰り返し語られる原則。最大のミスは「プラン無しでコードに飛びつかせる」こと。

- **Plan Mode で開始** → 探索・問題理解・実装方針・変更ファイルの洗い出し・フロー設計まで、変更を加えずに行う
- 1 つの Claude にプランを書かせ、**別の Claude に「スタッフエンジニア」としてレビュー**させてから実装へ
- 曖昧な判断をレビュー済み spec に落とし込み、各判断の確度を上げてから着手する
- 「高出力のエンジニアとそれ以外の差は、実行前に Claude の周りに組む“構造”」

## 2. CLAUDE.md は生きた文書

- 黄金律: **「Claude が間違ったら、その場で CLAUDE.md に追記して二度と繰り返させない」**
- git に commit し、週に何度も更新する運用
- プロジェクト規約・ツール選好・ワークフローパターンを集約
- 公式目安は 200 行以下。短く・ノイズ無しを保つ

## 3. Context 管理がすべての土台

- 前提: **context window はすぐ埋まり、埋まるほど性能が落ちる**
- 高密度な context を保つことが長尺タスク成功の条件
- subagent / workflow で探索を別 context に隔離し、メイン session には**圧縮済みサマリだけ**戻す

## 4. 並列セッション × git worktree

- チームの「#1 生産性 Tip」: **10〜15 セッション同時起動**、各セッションに専用 git worktree を割り当て変更衝突を防ぐ
- 1 人が複数の独立タスクを並走させる
- Claude Code 側: worktree 機能 / Agent の `isolation: worktree`

## 5. Subagent でコンテキスト汚染を断つ（特に TDD）

- 1 context で全部やると汚染: テスト作成者の分析が実装者に漏れ、実装者の探索が refactor 評価を汚す → TDD が壊れる
- **テスト作成 subagent は実装プランを見られない**ようにする → テストが「予想した実装構造」でなく「実際の要求」を反映
- feature ごとに新鮮な subagent を割り当て、**2 段階レビュー**を挟み、Red-Green-Refactor を回す

## 6. Dynamic Workflows / ultracode（2026 の新潮流）

- **dynamic workflow**: やりたいことを書くと Claude が JS のオーケストレーションスクリプトを生成し、subagent を並列ファンアウト（数十〜数百）、結果を検証してから統合。`/workflows` で進捗閲覧
- **トリガーは `ultracode` キーワード**（v2.1.154 で `workflow` からリネーム）。プロンプトに含めて単発発火、または `/effort ultracode` でセッション常時 ON（xhigh reasoning + タスクごとに自動 workflow 化）
- 用途: 大規模 migration・全コードベース監査・網羅的レビューなど「1 context に収まらない規模」
- 保存済み workflow は `.claude/workflows/`（プロジェクト）/ `~/.claude/workflows/`（グローバル）に置ける

## 7. Skills / Hooks / カスタムコマンドで定型を固める

- 静的に検査可能なルールはプロンプトでなく **hooks / lint / ast-grep** に寄せる
- 繰り返す手順は skill / カスタムスラッシュコマンド化（`/code-review`, `/verify` 等）

---

## 自分用の次の一手

土台（TDD・CLAUDE.md・厳格 permissions）は既に上級者寄り。差分として効くもの:

1. **Plan Mode を習慣化** — 着手前に spec 化 → 別 Claude でレビュー
2. **CLAUDE.md の“その場追記”運用** — ミスを見たら即追記
3. **worktree 並列** — 独立タスクを別 worktree で並走
4. **TDD を subagent 分離で** — テスト作成と実装を別 context に

---

# 深掘り

## A. Plan Mode ワークフロー（探索 → spec → レビュー → 実装）

### 基本: 4 フェーズ

研究・計画と実装を分離し、「間違った問題を解く」のを防ぐ。**`Shift+Tab`** で plan mode に切替（起動時なら `claude --permission-mode plan`）。

1. **Explore（plan mode）** — 変更せずに読む・理解する
   ```
   read /src/auth and understand how we handle sessions and login.
   also look at how we manage environment variables for secrets.
   ```
2. **Plan（plan mode）** — 詳細な実装プランを作らせる。`Ctrl+G` でプランをエディタで直接編集できる
   ```
   I want to add Google OAuth. What files need to change?
   What's the session flow? Create a plan.
   ```
3. **Implement（default mode）** — plan mode を抜けてコード化、プランと照合させる
   ```
   implement the OAuth flow from your plan. write tests for the
   callback handler, run the test suite and fix any failures.
   ```
4. **Commit** — 説明的メッセージで commit + PR

> **plan mode を飛ばすべき時**: 1 文で diff を説明できる小さな変更（typo 修正・ログ追加・リネーム）。
> plan が効くのは「方針が不確実」「複数ファイルに跨る」「不慣れなコード」のとき。

### クラウドでプランを練る: ultraplan（research preview / v2.1.91+）

`/ultraplan <依頼>`（または prompt に `ultraplan` を含める）で、プラン作成を **Claude Code on the web** に委譲できる。ドラフト中もローカルターミナルは空くので他作業を継続可能。

- ブラウザの専用レビュー画面で**セクション単位のインラインコメント** → Claude が改訂 → 納得するまで反復
- 実行先を選べる: **web でそのまま実装して PR** or **「Approve plan and teleport back to terminal」でローカルへ戻す**（今の会話に注入 / 新 session で開始 / ファイル保存のみ、の 3 択）
- ローカルの plan 承認ダイアログから「No, refine with Ultraplan」で途中送りも可
- 要件: Claude Code on the web アカウント + GitHub リポジトリ（Bedrock/Vertex/Foundry では不可）
- コードレビュー版の **ultrareview** もある（merge 前のバグ検出）

### より強い spec 化: Claude にインタビューさせる

大きめの機能は、最小プロンプトで **`AskUserQuestion` を使ったインタビュー**を回させ、SPEC.md に落とす。

```
I want to build [brief description]. Interview me in detail using the
AskUserQuestion tool. Ask about technical implementation, UI/UX, edge cases,
concerns, and tradeoffs. Don't ask obvious questions, dig into the hard parts
I might not have considered. Keep interviewing until we've covered everything,
then write a complete spec to SPEC.md.
```

- 良い spec の条件: **関与するファイル・インターフェースを名指し / スコープ外を明記 / 末尾に end-to-end の検証手順**
- spec ができたら **新しい session で実行**（クリーンな context で実装に集中）

### 「2 人の Claude」: Writer / Reviewer

別 session（=fresh context）でレビューさせると、自分が書いたコードへのバイアスが無く質が上がる。

| Session A（Writer） | Session B（Reviewer） |
| --- | --- |
| `Implement a rate limiter for our API endpoints` | |
| | `Review @src/middleware/rateLimiter.ts. Look for edge cases, race conditions, consistency with existing middleware.` |
| `Here's the review feedback: [B output]. Address these issues.` | |

### Adversarial review（完了前の独立チェック）

「完了」と数える前に、**fresh subagent に diff だけ**を見せて plan との突合をさせる。

```
Use a subagent to review the rate limiter diff against PLAN.md. Check that
every requirement is implemented, the listed edge cases have tests, and
nothing outside the task's scope changed. Report gaps, not style preferences.
```

- バンドル済み **`/code-review`** スキルでも可（fresh subagent でバグを見て findings を返す）
- ⚠️ 落とし穴: gap を探せと言われた reviewer は健全でも何か挙げる → **過剰エンジニアリング**に注意。「correctness / 要求に効く gap のみ」と縛る

---

## B. TDD × subagent 分離（Red-Green-Refactor を壊さない）

あなたの CLAUDE.md の「探索 → Red → Green → Refactoring」を、context 汚染なしで強制する構成。

### なぜ subagent 分離か

1 つの context で全部やると、テスト作成の分析が実装に漏れ、実装の探索が refactor 評価を汚す。
→ **各フェーズを独立 context の subagent に分け**、テスト作成者は実装を一切見られないようにする。

### 3 つの subagent（`.claude/agents/`）

**1. test-writer（RED）** — 要求だけを受け取り、失敗するテストを書く
```yaml
name: tdd-test-writer
description: Write failing tests for TDD RED phase
tools: Read, Glob, Grep, Write, Edit, Bash
```
- テストを書く → 実行して**失敗を確認** → テストパス + 失敗出力を返す
- 実装の詳細は決して見ない

**2. implementer（GREEN）** — 「失敗テストのパス + 要求」だけを受け取る
```yaml
name: tdd-implementer
description: Implement minimal code to pass failing tests (GREEN)
tools: Read, Glob, Grep, Write, Edit, Bash
```
- テストを通す**最小限のコードだけ**書く（"No extras"）→ 実行してパス確認

**3. refactorer（REFACTOR）** — テスト + 実装を受け取る
```yaml
name: tdd-refactorer
description: Evaluate and refactor after GREEN, keep tests green
tools: Read, Glob, Grep, Write, Edit, Bash
```
- 重複・命名・抽出をチェックリスト評価 → テストを緑のまま改善、または「不要」を理由付きで返す

### オーケストレーション skill（フェーズゲート）

`.claude/skills/tdd/skill.md` で順序とゲートを強制:

```markdown
## Phase 1: RED  → tdd-test-writer を呼ぶ
**失敗が確認できるまで Green に進まない**
## Phase 2: GREEN → tdd-implementer を呼ぶ
**テストが通るまで Refactor に進まない**
## Phase 3: REFACTOR → tdd-refactorer を呼ぶ
```

各フェーズの "Do NOT proceed until…" が、確認なしの進行をブロックする。

### skill を確実に発火させる hook

skill は自然発火率が低い（~20%）ため、`UserPromptSubmit` hook で毎回評価を注入すると ~84% に上がる。

```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "matcher": "", "hooks": [
        { "type": "command",
          "command": "npx tsx \"$CLAUDE_PROJECT_DIR/.claude/hooks/skill-eval.ts\"",
          "timeout": 5 } ] }
    ]
  }
}
```
hook は「各 skill を YES/NO で評価 → YES なら `Skill()` を呼んでから実装」を指示する短いテキストを stdout に出すだけ。

> **補足（2026-07）**: skill frontmatter の **`paths`**（glob）で「特定パスを触る時だけ自動有効化」が公式サポートされた。パス連動で足りるケースはまず `paths` を使い、上記 hook は「毎プロンプトで発火判定させたい」時の手段として使い分ける。`context: fork` を付ければ skill 自体を fork した subagent で実行でき、本体 context を汚さない。

### テストヘルパーで agent 間の API を固定

各 agent が毎回 setup を書かないよう、`createTestApp()` 的なヘルパーを 1 つ用意して共通化する。
→ agent は要求に集中でき、テストの一貫性も保てる。

> このパターンはプロジェクト単位（`.claude/`）に置くのが定石。グローバル CLAUDE.md には「TDD で開発する」方針だけ残し、具体構成はプロジェクトへ。

---

# 実際の開発フロー例（A + B を 1 本に繋ぐ）

A（Plan Mode）と B（TDD subagent）の役割分担:

- **A = 自分が対話でコントロールする“枠”** — plan mode トグル / プロンプト / 別 session / `/clear`
- **B = その枠の「実装」フェーズで半自動に回る“エンジン”** — `.claude/` に仕込んだ skill / hook が subagent を順に駆動

## 前提セットアップ

- プロジェクトの `.claude/` に B 一式（`tdd-test-writer` / `tdd-implementer` / `tdd-refactorer` agents + `tdd` skill + `UserPromptSubmit` hook）
- グローバル CLAUDE.md に「複数ファイル/不確実な変更は実装前にプラン提示」の 1 行

以下は「パスワードリセット機能の追加」を例にした流れ。

## フェーズ 1: 探索 + spec 化（A — plan mode を駆動）

```
👤 [Ctrl+G で plan mode]
   read src/auth/ を読んで、今のログイン/セッション管理とメール送信の
   仕組みを理解して。パスワードリセットを追加したい。
   関連ファイルとフローを洗い出してプランを作って。

🤖 [plan mode: 変更せず探索]
   現状フロー / 必要な変更①②③ / 変更ファイル / スコープ外 を提示
```

- `Ctrl+G` でプランをエディタで直接編集。対話で詰める（例: トークン有効期限15分・使い捨て）
- 大きい機能は `AskUserQuestion でインタビューして SPEC.md に書いて` を回す

## フェーズ 2: レビュー（A — 「2 人目の Claude」）

```
👤 [別 session]
   このプラン（貼付）をセキュリティ担当スタッフエンジニアとしてレビュー。
   トークン漏洩・タイミング攻撃・レート制限の観点で穴を指摘して。

🤖 トークンはハッシュ保存に。enumeration 防止で存在しないメールでも
   同じレスポンスを返すべき。...
```

→ 指摘を元 session に戻してプラン修正。**ここまでコードは書かない**。

## フェーズ 3: 実装 = TDD ループ（B — skill/hook が半自動発火）

plan mode を抜けて依頼するだけ:

```
👤 プランに沿ってリセットトークン発行のエンドポイントを実装して

🤖 🔴 RED: tdd-test-writer → 失敗テスト作成（実装は知らない）→ 失敗確認 ✅
   🟢 GREEN: tdd-implementer → 最小コードのみ → パス ✅
   🔵 REFACTOR: tdd-refactorer → 抽出/整理 → テスト緑のまま ✅
```

- 各 subagent は別 context → テスト作成者は実装を覗けない（テストが写経にならない）
- 自分の制御は**フェーズへの介入**（例: `RED に期限切れトークンの異常系を足して`）
- 機能が複数なら「依頼 → 3 フェーズ」を機能単位で繰り返す

## フェーズ 4: 完了前チェック（A — adversarial review）

```
👤 subagent で今回の diff を SPEC.md と突合。要求の実装漏れ・異常系テストの
   有無・スコープ外変更を確認。correctness に効く gap のみ報告して。

🤖 [fresh subagent が diff だけ見て] レート制限がプランにあるが未実装です。
```

→ 潰して再チェック。`/code-review` でも代替可。

## フェーズ 5: コミット

```
👤 説明的なメッセージで commit して PR を開いて
```

## 対話で握るレバー

| レバー | いつ | 操作 |
| --- | --- | --- |
| `Shift+Tab` plan mode | 探索/計画と実装を分ける | 切替（`Ctrl+G` でプランをエディタ編集） |
| プロンプトの具体度 | 全工程 | ファイル名・異常系・スコープを明示 |
| 別 session | プラン/コードレビュー | fresh context で批評 |
| フェーズ介入 | TDD ループ中 | 「RED にケース追加」等 |
| `/clear` | タスク切替時 | context リセット |
| `Esc` / `/rewind` | 脱線時 | 巻き戻し |

---

## 参照

- [Best practices for Claude Code（公式）](https://code.claude.com/docs/en/best-practices)
- [Orchestrate subagents at scale with dynamic workflows（公式）](https://code.claude.com/docs/en/workflows)
- [Introducing dynamic workflows in Claude Code（Anthropic blog）](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code)
- [9 Claude Code Tricks for Senior Engineers（Medium, 2026-06）](https://medium.com/@joe.njenga/9-claude-code-tricks-for-senior-engineers-who-love-speed-926ed04a7257)
- [Claude Code Maximum Performance Configuration 2026](https://pooya.blog/blog/maximize-claude-code-senior-engineer-guide-2026/)
- [A Claude Code TDD Skill: Forcing Red-Green-Refactor Discipline](https://alexop.dev/posts/custom-tdd-workflow-claude-code-vue/)
- [Claude Code: Workflows and Best Practices 2026](https://smart-webtech.com/blog/claude-code-workflows-and-best-practices/)
- [Plan in the cloud with ultraplan（公式）](https://code.claude.com/docs/en/ultraplan)

## 関連ドキュメント

- [`recommended-settings.md`](./recommended-settings.md) — グローバル設定推奨事項（モデル情勢・permissions・statusline）
- [`gap-analysis.md`](./gap-analysis.md) — 現運用とのギャップ分析・推奨アクション
