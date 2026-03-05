# nvim-surround チートシート

## 基本操作

| 操作 | コマンド           | 説明                       |
| ---- | ------------------ | -------------------------- |
| 追加 | `ys{motion}{char}` | motion範囲を char で囲む   |
| 削除 | `ds{char}`         | char の囲みを削除          |
| 変更 | `cs{old}{new}`     | 囲みを old から new に変更 |

## 追加 (ys)

| コマンド        | 前            | 後                            |
| --------------- | ------------- | ----------------------------- |
| `ysiw"`         | `hello`       | `"hello"`                     |
| `ysiw'`         | `hello`       | `'hello'`                     |
| `ysiw)`         | `hello`       | `(hello)`                     |
| `ysiw(`         | `hello`       | `( hello )` (スペース付き)    |
| `ysiw]`         | `hello`       | `[hello]`                     |
| `ysiw[`         | `hello`       | `[ hello ]` (スペース付き)    |
| `ysiw}`         | `hello`       | `{hello}`                     |
| `ysiw{`         | `hello`       | `{ hello }` (スペース付き)    |
| `ysiw>`         | `hello`       | `<hello>`                     |
| `ysiw<div>`     | `hello`       | `<div>hello</div>`            |
| `ysiwt` + `div` | `hello`       | `<div>hello</div>` (タグ入力) |
| `ysiw`` `       | `hello`       | `` `hello` ``                 |
| `yss"`          | `hello world` | `"hello world"` (行全体)      |

## 削除 (ds)

| コマンド       | 前                 | 後                 |
| -------------- | ------------------ | ------------------ |
| `ds"`          | `"hello"`          | `hello`            |
| `ds'`          | `'hello'`          | `hello`            |
| `ds)` or `dsb` | `(hello)`          | `hello`            |
| `ds]` or `dsr` | `[hello]`          | `hello`            |
| `ds}` or `dsB` | `{hello}`          | `hello`            |
| `dst`          | `<div>hello</div>` | `hello` (タグ削除) |

## 変更 (cs)

| コマンド        | 前                 | 後                   |
| --------------- | ------------------ | -------------------- |
| `cs"'`          | `"hello"`          | `'hello'`            |
| `cs'"`          | `'hello'`          | `"hello"`            |
| `cs")`          | `"hello"`          | `(hello)`            |
| `cs"(`          | `"hello"`          | `( hello )`          |
| `cs)[`          | `(hello)`          | `[ hello ]`          |
| `cs)]`          | `(hello)`          | `[hello]`            |
| `cst"`          | `<div>hello</div>` | `"hello"`            |
| `cs"t` + `span` | `"hello"`          | `<span>hello</span>` |

## ビジュアルモード

| コマンド   | 説明                               |
| ---------- | ---------------------------------- |
| `S{char}`  | 選択範囲を char で囲む             |
| `gS{char}` | 選択範囲を char で囲む（改行付き） |

**例:**

```
1. viwS" → 単語を選択して " で囲む
2. V2jS{ → 3行選択して { } で囲む
```

## motion の例

| motion    | 対象                   |
| --------- | ---------------------- |
| `iw`      | 単語 (inner word)      |
| `aw`      | 単語+空白 (a word)     |
| `iW`      | WORD (空白区切り)      |
| `is`      | 文 (inner sentence)    |
| `ip`      | 段落 (inner paragraph) |
| `i"`      | " の中身               |
| `a"`      | " を含む               |
| `it`      | タグの中身             |
| `at`      | タグを含む             |
| `$`       | カーソルから行末       |
| `f{char}` | char まで              |

## エイリアス

| エイリアス | 対象                                 |
| ---------- | ------------------------------------ |
| `b`        | `()` 括弧                            |
| `B`        | `{}` 波括弧                          |
| `r`        | `[]` 角括弧                          |
| `q`        | 最も近いクォート (`"`, `'`, `` ` ``) |

## 実践例

```
"hello world" にカーソルがある状態で:

cs"'     → 'hello world'     ダブル→シングルクォート
ds'      → hello world       クォート削除
ysiw"    → hello "world"     worldを"で囲む
yssB     → {hello world}     行全体を{}で囲む
```

---

ポイント:

- `(`, `[`, `{` → スペース付き
- `)`, `]`, `}` → スペースなし
- `t` → HTMLタグ操作
