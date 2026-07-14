---
name: commit
description: 現在の変更からコミットメッセージを生成してコミットする。「コミットして」「コミットメッセージを考えて」「commit」の依頼時、/commit 実行時、機能実装や fix が一段落して変更を記録したい場面で使用。
---

# commit

現在の変更を分析し、リポジトリの規約に沿ったコミットメッセージでコミットする。

## 手順

1. 並列で現状を把握する:
   - `git status` — staged / unstaged / untracked の確認
   - `git diff HEAD` — 変更内容の把握（staged があるなら `git diff --cached` を優先）
   - `git log --oneline -10` — このリポジトリのメッセージ規約の確認
2. staged の変更があればそれだけをコミット対象にする。staged が無ければ関連する変更をまとめて `git add` する（無関係な変更や秘密情報らしきファイルは混ぜず、その旨を報告する）。
3. メッセージを生成してコミットする。

## メッセージ規約

- 形式: `<type>: <日本語の要約>`（type: feat / fix / refactor / docs / chore / test / perf）
- リポジトリの `git log` に既存の規約があればそちらを優先する
- 要約は「何をしたか」ではなく「何がどう変わるか」を 1 行で
- 変更が大きい場合のみ body に箇条書きで補足する
- Co-Authored-By などの attribution は付けない

## 注意

- `$ARGUMENTS` が渡されたらメッセージの方向性のヒントとして使う（例: `/commit fix系で短めに`）
- 論理的に独立した変更が混在している場合は、分割コミットを提案してから進める
- pre-commit hook が失敗したら、修正してリトライする（`--no-verify` は使わない）
