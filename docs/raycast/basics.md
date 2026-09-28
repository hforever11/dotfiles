# Raycast 基本ガイド

「アプリランチャー + よく使う操作の集約点」として使う。Spotlight の置き換え + α。
Notes の運用は [notes.md](./notes.md) 参照。

## セットアップ手順

GUI 操作のみ。nix 管理できるのは ⌘+Space の確保だけ
（Spotlight 側の無効化を `darwin/default.nix` の `postActivation` で行っている）。

### 1. 前提となる 2 つの設定

| 設定                                   | 場所                                              | 理由                                                 |
| -------------------------------------- | ------------------------------------------------- | ---------------------------------------------------- |
| アクセシビリティ権限を許可             | システム設定 → プライバシーとセキュリティ → アクセシビリティ | Window Management はこれが無いと動かない             |
| Hotkey Action を Toggle Visibility 以外に | Raycast Settings → Applications → Hotkey Action  | 既定だと最前面時に押すとアプリが隠れ、フォーカスがデスクトップに落ちる |

Hotkey Action は**全アプリ共通のグローバル設定**でアプリ個別には変えられない。
オフにするとターミナルの quake 風トグル（押して出す→押して隠す）もできなくなる。

### 2. ホットキー割り当て

アプリは検索 → `⌘+K` → Configure Application、コマンドは Settings → Extensions から。
詳細は [ホットキー構成](#ホットキー構成) 参照。

### 3. Snippets / Quicklinks

`;today` のテンプレは [notes.md](./notes.md#3-snippet-でテンプレ投入)、
デイリーノート生成などの Quicklink は [notes.md](./notes.md#効率化の仕掛け) 参照。

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

キーボード操作は Raycast に寄せる。`⌃+⌥` + 矢印は Rectangle / Spectacle 由来の
事実上の標準配列で、他環境でも手癖がそのまま通じる。

| ホットキー | コマンド    |
| ---------- | ----------- |
| `⌃+⌥+←`    | Left Half   |
| `⌃+⌥+→`    | Right Half  |
| `⌃+⌥+↑`    | Top Half    |
| `⌃+⌥+↓`    | Bottom Half |
| `⌃+⌥+↩`    | Maximize    |
| `⌃+⌥+C`    | Center      |

#### Cycling（同じキーの連打でサイズ巡回）

Left / Right / Top / Bottom Half は同じホットキーを連打すると ½ → ⅔ → ⅓ と
幅が切り替わる（v1.43 以降、**既定でオン**）。`⌃+⌥+←` を 2 回押せば左 2/3、
3 回で左 1/3 になるので、三分割系のコマンドにキーを振らなくても 2:1 分割が完結する。

設定は Settings → Extensions → **Window Management の親行**をクリック → 右ペインの
Preferences。コマンド個別の行（Type / Alias / Hotkey / Enabled の一覧）には出ない。
Half ごとに「サイズ巡回 / 隣のディスプレイへ移動 / 無効」を選べる。
Third / Quarter 系のコマンドには Cycling は無い。

三分割 / 四分割 / 六分割、Move to Next Display、Move to Next Space、Create Layout は
使用頻度が低いのでホットキーを振らず `⌘+Space` から名前で検索して呼ぶ
（レイアウトは 70 種類以上あり、全部にキーを振ると覚えられない。
三分割は上記 Cycling で代替できる）。

#### macOS 標準タイリングとの使い分け

キーが重複しないので併存できる。標準側は次の 2 つだけ使う。

| 操作                   | ショートカット      |
| ---------------------- | ------------------- |
| 2 窓を左右に同時配置   | `Fn+Control+Shift+←` |
| ドラッグで画面端に吸着 | （マウス操作）      |

Raycast にドラッグスナップは無く、標準側には 2 窓同時配置がある。逆に
**tao / Electron 系のアプリ（Arto など）は標準タイリングが効かない**。
NSWindow を自前生成していて macOS が標準ウィンドウとして扱わないため。
Raycast はアクセシビリティ API で位置とサイズを直接書き換えるので、
この種のアプリでも動く。キーボード操作を Raycast 主体にするのはこれが理由。

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

| ホットキー              | 機能                                    |
| ----------------------- | --------------------------------------- |
| `⇧+⌘+V`                 | Clipboard History                       |
| `⌃+⌥+←` `→` `↑` `↓` `↩` | Window 左 / 右 / 上 / 下半分 / 最大化   |
| `⌥+;`                   | Search Emoji & Symbols                  |

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
