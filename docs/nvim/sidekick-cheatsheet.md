# Sidekick.nvim Cheatsheet

## NES (Next Edit Suggestions)

| キー         | モード | 動作                                        |
| ------------ | ------ | ------------------------------------------- |
| `<Tab>`      | n      | NES にジャンプ/適用（なければ通常の Tab）    |
| `<leader>uN` | n      | NES の有効/無効をトグル                      |

## CLI (Claude Code / AI ターミナル)

### 基本操作

| キー         | モード     | 動作                    |
| ------------ | ---------- | ----------------------- |
| `<C-.>`      | n, t, i, x | CLI ターミナルをトグル  |
| `<leader>aa` | n          | CLI ターミナルをトグル  |
| `<leader>as` | n          | CLI ツールを選択        |
| `<leader>ad` | n          | CLI セッションを切断    |

### 送信・プロンプト

| キー         | モード | 動作                          |
| ------------ | ------ | ----------------------------- |
| `<leader>af` | n      | 現在のファイルを CLI に送信   |
| `<leader>av` | x      | 選択範囲を CLI に送信         |
| `<leader>ap` | n, x   | プロンプトを選択して送信      |

## セットアップ

初回起動時に Copilot の認証が必要:

```
:LspCopilotSignIn
```

ヘルスチェック:

```
:checkhealth sidekick
```
