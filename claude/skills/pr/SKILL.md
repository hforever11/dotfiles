---
name: pr
description: 現在のブランチから Pull Request を作成する。「PR 作って」「プルリク」「PR 出して」「pull request」の依頼時、/pr 実行時、実装完了後にレビューへ回したい場面で使用。
---

# pr

現在の作業内容から PR を作成し、URL を返す。

## 手順

1. デフォルトブランチを確認する: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`（以下 `<base>`。`/pr base <branch>` の指定があればそちらを優先）
2. 並列で現状を把握する:
   - `git status` — 未コミットの変更の有無
   - `git branch --show-current` と `git log <base>..HEAD --oneline` — ブランチと積まれたコミットの確認
   - `git diff <base>...HEAD` — PR に含まれる全差分（最新コミットだけでなく全体）
3. 前処理:
   - 未コミットの変更があれば、commit skill の規約に沿ってコミットする
   - `<base>` 上にいる場合は、変更内容を要約したブランチ名（例: `feat/nvim-lsp-fix`）で新しいブランチを切ってから進める
4. `git push -u origin <branch>` で push する
5. `gh pr create` で PR を作成し、URL を報告する

## PR の書き方

- タイトル: コミット規約と同じ `<type>: <日本語の要約>`。コミットが 1 つならそのメッセージを流用する
- body の構成:

```markdown
## 概要
（何を・なぜ変えたかを 1-3 行）

## 変更内容
- （主要な変更の箇条書き）

## 動作確認
- （実施した確認。未実施なら「未確認」と正直に書く）

## レビューしてほしい点
- （設計判断に迷った箇所、影響範囲が広い箇所など。無ければセクションごと省略）
```

- 「🤖 Generated with」などの attribution は付けない
- 差分に含まれない予定・展望は書かない

## 注意

- `$ARGUMENTS` はヒントとして使う（例: `/pr draft` → `--draft` を付ける、`/pr base develop` → base ブランチ指定）
- push 済みブランチに既存 PR があれば（`gh pr view`）、新規作成せずその URL を報告する
- force push が必要な状況では実行せず、状況を報告して指示を仰ぐ
