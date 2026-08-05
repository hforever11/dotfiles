# Raycast 基本ガイド

「アプリランチャー + よく使う操作の集約点」として使う。Spotlight の置き換え + α。
Notes の運用は [notes.md](./notes.md) 参照。

## 基本操作

| 操作                     | キー                     |
| ------------------------ | ------------------------ |
| Raycast を開く           | `⌘+Space`                 |
| 選択中の項目のアクション一覧 | `⌘+K`                 |
| 第 2 アクション実行      | `⌘+↩`                     |
| 設定を開く               | `⌘+,`                     |
| お気に入りに追加         | `⇧+⌘+F`（ルート検索で上位固定） |

**`⌘+K` が最重要**。どのコマンド・検索結果にも追加アクションが隠れている（ファイルならパスコピー、アプリなら隠す/終了など）。迷ったらまず `⌘+K`。

コマンドには **alias**（短い呼び名）と **hotkey** を付けられる。ルート検索でコマンドを選んで `⌘+K` → Configure Command から設定。

## まず使うべき内蔵機能

### 1. Clipboard History（クリップボード履歴）

過去にコピーしたテキスト・画像・ファイルを検索して貼り直せる。**最初にホットキーを割り当てる価値が一番高い**（`⇧+⌘+V` 推奨）。ピン留め・機密アプリの除外も設定可能。

### 2. Snippets（スニペット）

キーワード入力で定型文を全アプリ展開。`;today`（Notes のデイリーテンプレ）、メールアドレス、よく書く挨拶文など。`{date}` `{cursor}` `{clipboard}` などのプレースホルダが使える。

### 3. Window Management（ウィンドウ整列）

「Left Half」「Right Half」「Maximize」などでウィンドウを配置。ホットキー例:

| 配置       | ホットキー例 |
| ---------- | ------------ |
| 左半分     | `⌃+⌥+←`        |
| 右半分     | `⌃+⌥+→`        |
| 最大化     | `⌃+⌥+↩`        |

### 4. 電卓・単位変換（設定不要）

ルート検索にそのまま式を打つだけ。`⌘+C` で結果をコピー。

- 計算: `128*1.1`、`2^16`
- 単位・通貨: `100 usd to jpy`、`5km to mile`
- 日時: `3pm PST in JST`、`45 days from now`

### 5. Quicklinks

URL テンプレートに引数を渡して即検索。`{argument}` がクエリになる。

- Google 検索: `https://www.google.com/search?q={argument}`
- DeepL 翻訳: `https://www.deepl.com/translator#en/ja/{argument}`
- GitHub リポジトリ検索: `https://github.com/search?q={argument}`

### 6. その他の便利コマンド

| コマンド              | 用途                                             |
| --------------------- | ------------------------------------------------ |
| Search Files          | ファイル検索（Spotlight 相当）                   |
| Search Emoji & Symbols | 絵文字・記号入力                                |
| Search Menu Items     | 最前面アプリのメニュー項目を検索して実行         |
| Quit All Applications | 全アプリ終了                                     |
| System 系             | Lock Screen / Sleep / Empty Trash / Toggle Dark Mode |
| Define Word           | 辞書引き                                         |
| My Schedule           | 今日の予定表示・会議 URL にワンキー参加（カレンダー連携） |

## ホットキー構成

「⌥ + 頭文字」をアプリ切替レイヤーとして使う。アプリのホットキーはトグル動作
（最前面でもう一度押すと隠れる）なので、ターミナルの出し入れにも使える。
設定はアプリ名を検索 → `⌘+K` → Configure Application → Hotkey。

| ホットキー | 割り当て          | 覚え方       |
| ---------- | ----------------- | ------------ |
| `⌥+T`      | Ghostty           | **T**erminal |
| `⌥+B`      | ブラウザ          | **B**rowser  |
| `⌥+M`      | Arto              | **M**arkdown |
| `⌥+E`      | VS Code           | **E**ditor   |
| `⌥+N`      | Raycast Notes     | **N**otes    |

機能系はこの 3 つだけ。それ以外は `⌘+Space` 検索か alias で呼ぶ
（ホットキーは増やすほど覚えられなくなる。アプリ 5 + 機能 3 程度で止める）。

| ホットキー          | 機能                              |
| ------------------- | --------------------------------- |
| `⇧+⌘+V`             | Clipboard History                 |
| `⌃+⌥+←` / `→` / `↩` | Window 左半分 / 右半分 / 最大化   |
| `⌥+;`               | Search Emoji & Symbols            |

Caps Lock の Hyper キー化機能は、hidutil の caps_lock → right_control 割り当て
（nix-darwin 管理）と競合するため使わない。

## おすすめ拡張（Store から）

ルート検索で「Store」→ 拡張名で検索してインストール。

| 拡張               | 用途                                       |
| ------------------ | ------------------------------------------ |
| GitHub             | PR・Issue・通知の検索、自分の PR 一覧      |
| Brew               | Homebrew パッケージの検索・情報表示        |
| Visual Studio Code | 最近開いたプロジェクトを検索して開く       |
| Kill Process       | 重いプロセスを検索して kill               |

## 最初の 1 週間の習慣づけ

1. アプリ切替を Dock/⌘+Tab でなく **⌘+Space + 数文字** でやる
2. 貼り付けを `⌘+V` でなく **`⇧+⌘+V`（Clipboard History）** 経由にする
3. 何かを選んだら **`⌘+K`** を押してアクションを眺める癖をつける
4. 計算・単位変換で電卓アプリを開かない

この 4 つが手に馴染めば、あとは困りごとが出るたびに Store で拡張を探す運用で回る。
