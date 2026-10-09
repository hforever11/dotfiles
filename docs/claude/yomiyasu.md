# yomiyasu (日本語の推敲スキル)

AI が書いた日本語のうち、不自然な比喩、主語と述語の関係が曖昧な文、過剰な太字や箇条書きを直すスキル。
[nanaism/yomiyasu](https://github.com/nanaism/yomiyasu) (MIT) を Claude Code のプラグインとして入れている。

自動では動かない。直したい文章があるときに呼ぶ。

## 使い方

確実に使うには `/yomiyasu` を付けて頼む。

```text
/yomiyasu この文章を読みやすくして
（ここに文章を貼る）

/yomiyasu docs/claude/dev-style.md を読みやすくして
/yomiyasu さっき書いた PR 説明文を読みやすくして
/yomiyasu のルールに沿って、この変更の PR 説明文を書いて
```

「読みやすくして」「自然な日本語にして」「AIっぽさをなくして」と頼むだけでも呼ばれることがあるが、毎回ではない。

### 用途の指定

省略すると文章の内容から判断される。決めたいときは依頼文に添える。

| 指定                                    | 向いている文章                  | 主な調整                                     |
| --------------------------------------- | ------------------------------- | -------------------------------------------- |
| 「技術記事向けに」/ `ドメイン tech`     | 技術ブログ、設計書              | 手順や仕組みを文で説明し、箇条書きを減らす   |
| 「業務仕様向けに」/ `ドメイン business` | PR 説明文、仕様書、社内レポート | 比喩を客観的な表現にし、条件や担当を明記する |
| 「エッセイ向けに」/ `ドメイン essay`    | 個人ブログ、note                | 大げさな教訓を避け、体験や感想を残す         |

### 返ってくる内容

1. 書き直した本文
2. 変えたところ (最大 5 点。理由つき)
3. 残した AI っぽいところ (意味があって残した箇所がある場合だけ)
4. 書き手に確かめたい点 (意味が読み取れない箇所がある場合だけ。最大 2 点)

本文だけ欲しいときは「本文だけ返して」と書く。

## 付属スクリプト

Claude はスキルの手順の中でこのスクリプトを実行する。手元で文章を検査するときにも使える。
Python の標準ライブラリだけで動く。

置き場所はプラグインのキャッシュで、パスにバージョン番号が入る (更新すると変わる)。

```sh
ls ~/.claude/plugins/cache/yomiyasu/yomiyasu/
# → 1.1.0 など。以下の <version> をこれに置き換える
S=~/.claude/plugins/cache/yomiyasu/yomiyasu/<version>/skills/yomiyasu/scripts
```

### `yomiyasu_lint.py`: AI っぽさの検査

比喩動詞、絵文字、文末のコロン、太字や箇条書きの多さ、同じ文末の連続などを 100 点からの減点で採点する。

```sh
python3 $S/yomiyasu_lint.py docs/foo.md            # レポートを表示
python3 $S/yomiyasu_lint.py docs/foo.md --strict   # 指摘があれば exit 1
python3 $S/yomiyasu_lint.py docs/foo.md --json     # JSON で出力
```

指摘は見直す候補で、0 件になるまで直す必要はない。文脈に合っている表現はそのまま残す。

### `yomiyasu_diff.py`: 書き直し前後の比較

書き直しで情報が増えたり減ったりしていないか、文末の調子が変わっていないかを確かめる。

```sh
python3 $S/yomiyasu_diff.py 元の文.md 書き直した文.md --stance=説明   # 勧め / 決まり / 説明
python3 $S/yomiyasu_diff.py --endings 対象.md                        # 文末の種類の内訳だけ
```

## 導入と更新

`claude/settings.json` に次の 2 つを登録している。

- `extraKnownMarketplaces.yomiyasu`: GitHub の `nanaism/yomiyasu`
- `enabledPlugins`: `"yomiyasu@yomiyasu": true`

本体の取得は次のコマンドで行った。新しいマシンで `/yomiyasu` が使えないときも同じコマンドを実行する
(settings.json の登録だけで自動で取得されるかは確認していない)。

```sh
claude plugin marketplace add nanaism/yomiyasu
claude plugin install yomiyasu@yomiyasu
```

更新は次のとおり。終わったら Claude Code を再起動する。

```sh
claude plugin marketplace update yomiyasu
claude plugin update yomiyasu@yomiyasu
```

公式 README にある `npx skills add` は使わない。`~/.claude/skills` に書き込むが、このリポジトリではそこを home-manager がリンクで管理しているため。

## 注意点

- SKILL.md が約 2 万 3 千字あり、呼ぶたびにその分のコンテキストを使う
- 書き直すのは会話中と同じモデルなので、自分の文章の癖を見逃すことがある。付属の lint はこれを補うためのもの
- 英単語や数字の前後の空白は、削除も追加もしない (このリポジトリの書き方のままになる)
- 他の日本語校正スキルと同時に使うと指示が食い違うことがある
- 書いた日本語を自動で検査したくなったら、hooks で別モデルに判定させる方式がある
  ([Claude Codeに「理解しやすい日本語」を書かせるためにやっていること](https://zenn.dev/ncdc/articles/6ea029ba5ecf65))

## 参考リンク

- [nanaism/yomiyasu](https://github.com/nanaism/yomiyasu) / [リリース](https://github.com/nanaism/yomiyasu/releases)
- [紹介記事 (Zenn)](https://zenn.dev/algoartis/articles/0b1c731881b25c)
- [Claude Code 設定メモ](recommended-settings.md)
