# Raycast Notes 運用ガイド

> Raycast 本体の起動キー ⌘+Space は、Spotlight 側のホットキーを nix-darwin（`darwin/default.nix` の `postActivation`）で無効化して確保している。



「今日やること」のスクラッチパッドとして割り切って使う。期日・通知が必要なタスクは扱わない（[割り切り](#割り切り) 参照）。

## キーバインド

| 操作                         | ショートカット            |
| ---------------------------- | ------------------------- |
| Notes ウィンドウ開閉         | `⌥+N`（自分で設定）        |
| タスクリスト化               | `⇧+⌘+9` または行頭で `[ ]`  |
| チェック切替                 | 行にカーソルを置いて `⌘+↩` |
| ピン留め                     | `⇧+⌘+P`                     |
| ピン留めノートへジャンプ     | `⌘+1`〜`⌘+9`                |
| ノート一覧 / 検索            | `⌘+P`                      |
| 前後のノートを行き来         | `⌘+[` / `⌘+]`               |
| 取り消し線（完了扱い）       | `⇧+⌘+S`                     |

## ノート構成

増やすと探すコストで破綻するので 3 枚に固定してピン留めする（無料プランのノート数上限にも収まる）。

| キー | ノート            | 用途                                 |
| ---- | ----------------- | ------------------------------------ |
| `⌘+1` | Today             | 今日やること + 雑なメモの受け皿      |
| `⌘+2` | Waiting / Someday | 他人待ち・いつかやる                 |
| `⌘+3` | Projects          | 案件ごとの見出し + サブタスク        |

### Today のテンプレ

完了タスクは `## Done` に落として達成感を可視化する。

```markdown
# Today {date}
[ ] 見積り修正を送る
[ ] 障害報告のレビュー依頼
## Waiting
[ ] Aさんの返信待ち
## Done
[x] 朝会
```

## 効率化の仕掛け

### 1. デイリーノートを Quicklink で自動生成

Quicklink に登録してホットキーを割り当てると、日付見出し付きの新規ノートが一発で作れる。

```
raycast://extensions/raycast/raycast-notes/create-note?fallbackText=# {date format="yyyy-MM-dd"} ({day})
```

### 2. 選択テキストを即ノート化

Slack やメールの文面を選択した状態で実行するとそのままノートになる。

```
raycast://extensions/raycast/raycast-notes/create-note?fallbackText={selection}
```

### 3. Snippet でテンプレ投入

`;today` などのキーワードで Today テンプレを展開する。Snippet 内では `{date}` `{day}` `{cursor}` が使え、展開後のカーソル位置も指定できる。

## 割り切り

Notes には期日・通知・繰り返しがない。ここを無理に埋めようとすると破綻するので線引きする。

- 今日〜数日で片付ける手元の作業 → Raycast Notes
- 日時が決まっている・忘れたら困る → Apple リマインダー（または Todoist / Things 拡張）

この線引きにより、Notes は「朝開いて夜閉じる作業盤」として軽快に回る。

## 参考

- [Notes | Raycast Manual](https://manual.raycast.com/notes)
- [Dynamic Placeholders | Raycast Manual](https://manual.raycast.com/dynamic-placeholders)
- [Quicklinks | Raycast Manual](https://manual.raycast.com/quicklinks)
- [Meet the new Raycast Notes - Raycast Blog](https://www.raycast.com/blog/raycast-notes)
