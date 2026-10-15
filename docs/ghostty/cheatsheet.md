# Ghostty Cheatsheet

## 基本情報

| 項目           | 値                                                  |
| -------------- | --------------------------------------------------- |
| テーマ         | Catppuccin Latte（マット版。色は `home/theme.nix`） |
| フォント       | Maple Mono NF（和文は HackGen Console NF）          |
| フォントサイズ | 14pt                                                |
| カーソル       | ブロック、点滅なし                                  |

## キーバインド

| キー     | 説明                                 |
| -------- | ------------------------------------ |
| `Ctrl+[` | Escape を送信                        |
| `⌘+h`    | 左ペイン移動（tmux / Neovim に連携） |
| `⌘+j`    | 下ペイン移動（tmux / Neovim に連携） |
| `⌘+k`    | 上ペイン移動（tmux / Neovim に連携） |
| `⌘+l`    | 右ペイン移動（tmux / Neovim に連携） |

### ⌘+hjkl の仕組み

Ghostty が Kitty keyboard protocol のエスケープシーケンスを送信し、tmux がそれを受け取って Neovim またはペインに転送する。

```
⌘+h → Ghostty → \x1b[104;9u → tmux → Neovim (C-w h) or tmux pane
```

これにより **Ghostty → tmux → Neovim** 間でシームレスにペイン移動できる。

## 表示設定

| 項目                 | 値                       |
| -------------------- | ------------------------ |
| 背景 / 前景          | `#f2ecbc` / `#545464`    |
| タイトルバー         | 非表示                   |
| ウィンドウ影         | なし                     |
| パディング           | 8px x, 10px y            |
| スクロールバー       | 非表示                   |
| 入力中マウスカーソル | 自動非表示               |
| リガチャ             | 無効（dlig, liga, calt） |
