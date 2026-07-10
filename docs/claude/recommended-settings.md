# Claude Code グローバル設定 推奨事項

`~/.claude/` のグローバル設定について、現状・推奨改善ポイント・適用済み内容をまとめたメモ。

## 再検証（2026-07-06 / CLI v2.1.200 / Fable 5）

changelog（v2.1.154〜2.1.200）と公式ドキュメントを突き合わせて再確認。**本メモの「Opus 4.8 前提」は過去のものになった**（現行設定は Fable 5）。

### モデル情勢の更新

- **Claude Sonnet 5**（v2.1.197 / 2026-06-30）が **Claude Code のデフォルトモデル**に。ネイティブ 1M context、プロモ価格 $2/$10 per Mtok（2026-08-31 まで）
- **Claude Fable 5**（v2.1.170 / 2026-06-09）: Mythos クラス。一般提供モデルとして過去最高能力
- 現行設定は `model: "claude-fable-5[1m]"` だが、**Fable 5 は 1M context が標準のため `[1m]` suffix は自動除去される**（v2.1.173）→ `"claude-fable-5"` へ簡素化してよい（挙動は同一）
- `effortLevel: "high"` の位置づけが変化: 旧「Opus 4.8 の既定値なので冗長」だったが、**Fable 5 の既定 effort は公式未記載** → 明示設定として意味を持つ
- **fast mode の再評価は決着**: v2.1.154 で値下げ（標準の 2 倍レートで 2.5 倍速）。ただし対象は Opus 4.8/4.7 で **Fable 5 は対象外** → 現運用では採否の判断自体が不要。Opus に戻す場合のみ再検討

### 実設定とメモの差分（メモ側を更新済み）

- `theme`: `dark-daltonized` → `dark` に変更済み
- `tui: "fullscreen"` を追加済み
- `extraKnownMarketplaces`: `karpathy-skills`（github: forrestchang/andrej-karpathy-skills）を追加済み
- statusline の表示例: model display name をそのまま出すため `Fable 5 │ …` になる（スクリプト変更不要）

### ⚠️ 発見: プロジェクト settings.local.json の方針乖離

dotfiles リポジトリの `.claude/settings.local.json` に、承認プロンプトの「常に許可」で蓄積した allow が約 90 行あり、本メモのセキュリティ方針と矛盾するものが混ざっている:

| エントリ | 矛盾点 |
| --- | --- |
| `Bash(gh api:*)` | 本メモで「実行系オプション（`-X DELETE` 等）を含むため allow から除外」と明記した対象 |
| `Bash(git rm *)` | 破壊系。「read-only のみ allow」方針と逆行 |
| `Bash(claude *)` | 任意の claude CLI 実行（再帰起動・設定変更を含む） |
| `Read(//Users/sfukunaga/**)` | ホーム全域の読み取り。個別パス許可を無意味化 |
| `Bash(defaults write:*)` | macOS 設定の書き換え（dotfiles 用途なら意図的の可能性 → 残すなら方針として明記） |

**推奨**: 定期的（四半期目安）に settings.local.json を棚卸しし、(1) グローバル方針に反する write 系・広域パターンを削除、(2) 一時作業の許可は「常に許可」でなく「今回のみ」を選ぶ。read-only 頻出コマンドの追加は `/fewer-permission-prompts` スキルで提案ベースに整理できる。

**2026-07-06 棚卸し実施**: 上記のうち `Bash(gh api:*)` / `Bash(git rm *)` / `Bash(claude *)` / `Read(//Users/sfukunaga/**)`、加えて `/tmp` 系の一時許可と他プロジェクト参照の計 9 エントリを削除（88 → 79 行）。`Bash(defaults write:*)` は dotfiles 用途（macOS 設定の適用）として意図的に残置。

### 適用（2026-07-06）— 汎用グローバル構成を導入

[gap-analysis.md](./gap-analysis.md) の推奨アクションのうち**汎用部分**を実装した。chezmoi 管理（ソース `dot_claude/` → ターゲット `~/.claude/`）で全マシンに再現可能。

| 追加物 | 配置 | 内容 |
| --- | --- | --- |
| `code-reviewer` subagent | `~/.claude/agents/` | CLAUDE.md のレビュー基準（設計 + TDD + 重要度分類）を独立コンテキストで実行 |
| TDD 3 subagents | `~/.claude/agents/` | tdd-test-writer（実装を見ずにテスト作成）/ tdd-implementer（最小実装のみ）/ tdd-refactorer（緑を維持して改善） |
| `/tdd` skill | `~/.claude/skills/tdd/` | 上記 3 subagent をフェーズゲート付きで駆動（失敗確認前に GREEN へ進まない等） |
| PostToolUse format hook | `~/.claude/hooks/format.sh` + settings.json | Edit/Write 後、**プロジェクトに設定がある formatter のみ**適用（stylua / gofmt / rustfmt / ruff / black / prettier / biome / shfmt）。設定が無ければ no-op |
| Plan Mode ルール | `~/.claude/CLAUDE.md` | 「複数ファイル・方針不確実な変更は実装前にプラン提示」の 1 行 |

- settings.json: `model` を `claude-fable-5` に簡素化（`[1m]` は自動除去のため）+ `hooks.PostToolUse` を登録
- hook 設定は新しい session から有効（起動中の session は開始時の snapshot を使う）

### settings.json の新キー（v2.1.181〜2.1.200）

| キー | v | 用途 |
| --- | --- | --- |
| `askUserQuestionTimeout` | 2.1.200 | AskUserQuestion 無応答時の自動継続タイムアウト |
| `enableArtifact` | 2.1.196 | Artifact ツールの有効/無効 |
| `disableSideloadFlags` | 2.1.193 | プラグイン/エージェントのサイドロード CLI フラグ拒否 |
| `autoMode.classifyAllShell` | 2.1.193 | auto mode で全シェルコマンドを分類器に通す |
| `disableClaudeAiConnectors` | 2.1.182 | claude.ai MCP コネクタ無効化 |
| `axScreenReader` | 2.1.181 | スクリーンリーダー対応出力 |

> 本メモの方針（最小構成）ではいずれも不要。auto mode を使い始めたら `autoMode.classifyAllShell` のみ検討。

### hooks の拡充

- イベントが約 30 種に拡充: `Setup` / `PostToolUseFailure` / `PostToolBatch` / `ConfigChange` / `FileChanged` / `WorktreeCreate`/`WorktreeRemove` / `InstructionsLoaded` / `PreCompact`/`PostCompact` / `SubagentStart` / `SessionEnd` など
- matcher に **`if` フィールド**（v2.1.85+）: permission ルール構文で絞り込み（例 `"if": "Bash(git *)"`）。対象イベントは PreToolUse / PostToolUse / PostToolUseFailure / PermissionRequest / PermissionDenied
- `Stop` の matcher 非対応は変わらず

参照: <https://code.claude.com/docs/en/hooks-guide>

### その他

- `/agents` ウィザードは削除（v2.1.198）。subagent 作成は「Claude に頼む」か `.claude/agents/` の直接編集が正規手段
- Claude in Chrome が GA（v2.1.198）
- クラウドプランニング **ultraplan** / レビュー版 **ultrareview**（research preview）→ 詳細は [dev-style.md](./dev-style.md)

## 再検証（2026-06-10 / CLI v2.1.170 / Opus 4.8）

公式ドキュメント（code.claude.com/docs/en と settings の JSON スキーマ）と本メモを突き合わせて再確認。大半は正確で、以下のみ修正した。

- **statusLine をネイティブ field 化**: `context_window.used_percentage` / `remaining_percentage` / `context_window_size` が stdin JSON で**事前計算済み**提供される（v2.1.132+）。transcript 末尾の tail+`jq` 集計と `[1m]`/1M 上限判定が不要になり、スクリプトを単一 `jq` 呼び出しへ簡素化した（公式 `used_percentage` は `input + cache_creation + cache_read` 算出で旧自前式と一致 → 出力は不変）。
- **permissions の表現を是正**: 公式は「Bash 引数マッチは fragile（security boundary ではない）」と明記。`deny` は**事故防止ガード**であって敵対的回避（変数間接化等）まで防ぐ保証ではない。一方 `&&` `;` `|` 等の複合コマンドは各サブコマンド独立判定なので連結回避は不可（堅牢）。確実な強制には PreToolUse hook / sandboxing を併用。
- **Stop hook**: `Stop` は `matcher` 非対応（付けても無視）。例から `matcher` を削除し `timeout` を追記。`{ "hooks": [ ... ] }` のネスト構造は維持が正。
- **effortLevel の既定はモデル別**: 4.8=`high` / 4.7=`xhigh`。enum は `low/medium/high/xhigh/max`、`max` は session 限定。「明示設定は冗長」は 4.8 にいる間のみ成立。
- 新モデル **Fable 5**（`claude-fable-5`）も登場済み。本メモは Opus 4.8 前提。

陳腐化なしを再確認: permissions 構文（`:*` 前方一致）・優先順位 deny→ask→allow・Fast mode 課金・CLAUDE.md 200 行目安・MCP `--scope`（local/project/user）・statusLine 設定形・env var・`theme` キー（schema 未収載だが公式 settings 例に存在し有効）。

## 再レビュー（2026-06-09 / CLI v2.1.169 / Opus 4.8）

前回 2026-05-19 から約 3 週間後の見直し。陳腐化と新設定を反映。

### 陳腐化していた点

- statusLine の表示例が `Opus 4.7` → 現行最新は **Opus 4.8**（model ID `claude-opus-4-8`、1M 版 `claude-opus-4-8[1m]`）。
- `effortLevel: "high"` は **Opus 4.8 の既定値**（enum は `low/medium/high/xhigh/max`、`max` は session 限定）。明示設定のままで害は無いが「最適化」の意味は薄い。**既定はモデル別**で、Opus 4.7 は `xhigh` が既定 → 「冗長」は 4.8 にいる間だけ成立する。
- セキュリティ方針・permissions・CLAUDE.md の評価は**現行でも有効**。陳腐化なし。

### 新設定（公式 settings ページで実在確認済み・2026-06-09 時点）

| キー | 型 | 既定 | メモ |
| --- | --- | --- | --- |
| `model` | string | （未設定=デフォルト追従） | 固定するなら `"opus"` / `"opus[1m]"`。こだわりが無ければ未設定が正解 |
| `alwaysThinkingEnabled` | bool | — | 拡張思考を常時 ON |
| `showThinkingSummaries` | bool | `false` | 思考サマリ表示（インタラクティブ向け） |
| `spinnerTipsEnabled` | bool | `true` | スピナーの Tips。不要なら `false` |
| `cleanupPeriodDays` | number | `30` | セッション / orphaned subagent worktrees / tasks / shell snapshots / backups の保持日数 |
| `respectGitignore` | bool | `true` | `@` ファイルピッカーが `.gitignore` を尊重 |

> このメモの方針（最小構成・セキュリティ重視）に照らすと、上記は**好みの範囲**で必須ではない。
> 入れるなら `spinnerTipsEnabled: false`（ノイズ削減）程度が無難。`model` は固定したい明確な理由がある時だけ。

### 採用見送り

- `defaultMode: "acceptEdits"`: 本メモの**アンチパターン方針と矛盾するため不採用**。
- Fast mode（`/fast` / `fastMode`）: Opus 4.8 で使える高速モードだが、**Max プランでも usage credits から別途従量課金**（プラン枠に含まれず最初のトークンから fast mode レート）。コスト見合わず**採用しない**。

## 適用状況（2026-05-19）

| 項目 | 状態 |
| --- | --- |
| `permissions.allow` / `deny`（セキュリティ強化版） | ✅ 適用済 |
| `env.BASH_DEFAULT_TIMEOUT_MS=180000` | ✅ 適用済 |
| `env.BASH_MAX_OUTPUT_LENGTH=30000` | ✅ 適用済 |
| Stop hook（macOS 通知） | ❌ 適用見送り |
| `statusLine`（配色は `.chezmoidata/theme.toml` から注入） | ✅ 適用済 |
| CLAUDE.md から `z-ai/` ルールを memory へ移動 | ❌ 不要（CLAUDE.md に残すのが正解） |

## 現状の設定（適用後）

- `~/.claude/settings.json`
  - `model`: `claude-fable-5`（1M context 標準）
  - `enabledPlugins`: pyright / lua / typescript / rust-analyzer LSP, context7, skill-creator
  - `extraKnownMarketplaces`: karpathy-skills
  - `effortLevel`: `high`（Fable 5 の既定 effort は公式未記載 → 明示設定として有効）
  - `theme`: `dark` / `tui`: `fullscreen`
  - `skipWorkflowUsageWarning`: `true`
  - `env`: `BASH_DEFAULT_TIMEOUT_MS=180000`, `BASH_MAX_OUTPUT_LENGTH=30000`
  - `permissions.allow` / `permissions.deny`: 下記参照
  - `hooks.PostToolUse`: Edit/Write 後の設定連動フォーマッタ（`~/.claude/hooks/format.sh`）
- `~/.claude/agents/` / `~/.claude/skills/`: code-reviewer + TDD 3 subagents + `/tdd` skill（chezmoi ソースは `dot_claude/`）
- `~/.claude/keybindings.json`
  - `shift+enter` → 改行、`ctrl+j` 無効化
- `~/.claude/CLAUDE.md`
  - 約 50 行（TDD、関心の分離、コードレビュー、`z-ai/` ディレクトリの扱い）

---

## 適用済 `permissions` の設計意図

### セキュリティ方針

- `defaultMode` は未設定（= デフォルトの `default` モード）。allow に無い Bash は必ず承認プロンプトを通る。
- `allow` は **read-only サブコマンドだけ** に限定。広いワイルドカード（`Bash(git:*)` 等）は採用しない。
- `deny` は **誤操作ガード**（事故防止）。`rm -rf` / `git reset --hard` / `git push --force` / `git branch -D` 等を弾く。ただし公式は **Bash 引数マッチは fragile（security boundary ではない）** と明記 → 敵対的回避まで防ぐ保証ではない（下記「`rm` 系の保証範囲」参照）。
- `find` / `fd` / `gh api` は実行系オプション（`-exec`, `-x`, `-X DELETE` 等）を含むため allow から除外。

### `allow` 一覧

```jsonc
{
  "permissions": {
    "allow": [
      // git (read-only サブコマンドのみ)
      "Bash(git status)",
      "Bash(git status:*)",
      "Bash(git diff)",
      "Bash(git diff:*)",
      "Bash(git log)",
      "Bash(git log:*)",
      "Bash(git show)",
      "Bash(git show:*)",
      "Bash(git blame:*)",
      "Bash(git branch)",
      "Bash(git branch --show-current)",
      "Bash(git branch -l)",
      "Bash(git branch -l:*)",
      "Bash(git branch --list:*)",
      "Bash(git branch -vv)",
      "Bash(git remote)",
      "Bash(git remote -v)",
      "Bash(git stash list)",
      "Bash(git stash show:*)",
      "Bash(git config --get:*)",
      "Bash(git config --list:*)",
      "Bash(git rev-parse:*)",
      "Bash(git ls-files:*)",
      "Bash(git ls-tree:*)",

      // gh (read-only サブコマンドのみ、gh api は除外)
      "Bash(gh pr view:*)",
      "Bash(gh pr list:*)",
      "Bash(gh pr diff:*)",
      "Bash(gh pr status)",
      "Bash(gh pr checks:*)",
      "Bash(gh issue view:*)",
      "Bash(gh issue list:*)",
      "Bash(gh run view:*)",
      "Bash(gh run list:*)",
      "Bash(gh repo view:*)",
      "Bash(gh auth status)",

      // 探索
      "Bash(ls)",
      "Bash(ls:*)",
      "Bash(pwd)",
      "Bash(tree)",
      "Bash(tree:*)",
      "Bash(rg:*)",
      "Bash(wc:*)",

      // dotfiles 周辺 (read-only のみ)
      "Bash(chezmoi diff)",
      "Bash(chezmoi diff:*)",
      "Bash(chezmoi status)",
      "Bash(chezmoi data)",
      "Bash(chezmoi managed:*)",
      "Bash(brew list)",
      "Bash(brew list:*)",
      "Bash(brew info:*)",
      "Bash(mise current)",
      "Bash(mise ls)",
      "Bash(mise ls:*)",
      "Bash(mise env)"
    ]
  }
}
```

### `deny` 一覧（ブロック対象）

```jsonc
{
  "permissions": {
    "deny": [
      // git の破壊的操作
      "Bash(git push --force:*)",
      "Bash(git push -f:*)",
      "Bash(git push --force-with-lease:*)",
      "Bash(git reset --hard:*)",
      "Bash(git branch -D:*)",
      "Bash(git branch -d:*)",
      "Bash(git clean -fd:*)",
      "Bash(git clean -fdx:*)",

      // 再帰削除（rm -rf / rm -r 系を広く弾く）
      "Bash(rm -rf:*)",
      "Bash(rm -fr:*)",
      "Bash(rm -r:*)",
      "Bash(rm -R:*)",
      "Bash(sudo rm:*)",

      // ディスク破壊系
      "Bash(dd if=:*)",
      "Bash(mkfs:*)",

      // 強制 chmod
      "Bash(chmod -R 777:*)",

      // パッケージ系の破壊操作
      "Bash(brew uninstall:*)",
      "Bash(brew cleanup --prune:*)"
    ]
  }
}
```

### `rm` 系の保証範囲

- ✅ `rm` 系は allow に無いため、**プロンプト無しでは実行されない**（デフォルトモードでは必ず承認画面を通る）
- ✅ `rm -rf` / `rm -r` / `rm -R` / `rm -fr` / `sudo rm` は **deny でブロック**
- ✅ 複合コマンドは堅牢: `&&` `||` `;` `|` `|&` `&` 改行は解釈され**各サブコマンドが独立判定**される → `safe && rm -rf x` のような連結で deny を回避することはできない
- ⚠️ フラグなし単発 `rm file.txt` は deny を貫通する（承認プロンプトには必ず出る）。Claude に rm を一切使わせたくない場合は deny に `Bash(rm:*)` を追加
- ⚠️ **変数間接化は貫通する**: `C="rm -rf"; $C /tmp` のように危険語自体を変数へ逃がすと前方一致に当たらない（コマンド置換・リダイレクトも同様）。deny は事故防止であり敵対的回避の防御ではない。確実な強制が要るなら **PreToolUse hook**（実行前検証）か **sandboxing**（OS レベル）を併用する
- ⚠️ ユーザー自身が `--dangerously-skip-permissions` で起動した場合や `defaultMode: "bypassPermissions"` を設定した場合は保証外（deny は依然有効。`rm -rf /` 等は circuit breaker でなお prompt）
- ⚠️ allow したコマンドが内部スクリプトで rm を呼ぶケース（例: `npm install` の lifecycle script）は別問題。現提案では npm/pip/make 等は allow に含めていない

---

## 適用済 `env`

```jsonc
{
  "env": {
    "BASH_DEFAULT_TIMEOUT_MS": "180000",   // Bash デフォルトタイムアウト 2 分 → 3 分
    "BASH_MAX_OUTPUT_LENGTH": "30000"      // Bash 出力上限を 30k 文字に制限（context 消費抑制）
  }
}
```

---

## 適用見送り: Stop hook

長時間タスクで macOS 通知を出す案。今回は適用しない。
あとから入れる場合は以下（`Stop` は `matcher` 非対応なので付けない。`timeout` は秒・任意で既定 600s）:

```jsonc
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude done\" with title \"Claude Code\" sound name \"Submarine\"'",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

参照: <https://code.claude.com/docs/en/hooks>

---

## 適用済 `statusLine`

### 表示内容

```
Fable 5 │ ◐ 89% │ dotfiles │ ⎇ main *↑2 │ +120 -15
```

| 項目 | 説明 |
| --- | --- |
| モデル表示名 | `(1M context)` 等の suffix は冗長なので剥がす |
| コンテキスト使用率 % | stdin の `context_window.used_percentage`。`<50%` 緑 / `<80%` 黄 / `≥80%` 赤 |
| プロジェクト basename | cwd の末尾セグメント |
| git branch | detached 時は `@<short SHA>` を表示 |
| dirty `*` | working tree に未コミット変更があれば付与（branch 全体を黄色化） |
| ahead/behind `↑N↓N` | upstream に対する先行 / 遅れコミット数 |
| 追加 / 削除行数 | セッション中の累計（あれば） |
| output style | `default` 以外のとき表示 |

配色は `.chezmoidata/theme.toml` から chezmoi が注入（mauve / blue / green / yellow / red / overlay0）。テーマを変えると自動追従する。

### 設計上の工夫

- **jq は 1 回だけ**: 入力 JSON のフィールドは TSV にまとめて `IFS=$'\t' read` で分配。7 回 → 1 回で ~70ms/render（旧版から約 3x 改善）
- **git は porcelain=v2 を 1 回**: branch / dirty / ahead-behind / detached SHA を全て同じ出力から抽出
- **context % はネイティブ提供を利用**: stdin JSON の `context_window.used_percentage`（公式が `input + cache_creation + cache_read` で事前計算）をそのまま使う。v2.1.132+ で追加され、**transcript の tail+集計も `[1m]`/1M 上限判定も不要**になった
- **堅牢性**: `used_percentage` は session 初期 / `/compact` 直後に `null`。`// -1 | floor` で正規化し `^[0-9]+$` で数値判定 → データ無しは表示を省略するだけで壊れない

### 構成

- スクリプト本体: [`dot_config/claude/executable_statusline.sh`](/Users/sfukunaga/ghq/github.com/hforever11/dotfiles/dot_config/claude/executable_statusline.sh)
  - chezmoi 経由で `~/.config/claude/statusline.sh` に展開（実行ビット付き）
- 依存: `jq` / `git`（ともに既にインストール済み）
- `~/.claude/settings.json`:
  ```jsonc
  {
    "statusLine": {
      "type": "command",
      "command": "~/.config/claude/statusline.sh",
      "padding": 0
    }
  }
  ```

### カスタマイズ余地

- context window 使用率は `context_window.used_percentage` をそのまま使用（残量を出すなら `remaining_percentage`、上限トークン数は `context_window_size`）。コスト / 経過時間は `cost.total_cost_usd` / `cost.total_duration_ms`、変更行数は `cost.total_lines_added` / `cost.total_lines_removed` が stdin に来る
- 表示要素を減らす / 増やすときは `out+=...` の行を編集

参照: <https://code.claude.com/docs/en/statusline>

---

## CLAUDE.md の評価

- **現状で健全**。50 行は公式目安（200 行以下）より十分短い。TDD / 関心の分離 / レビュー観点は汎用性が高くノイズなし。
- `z-ai/` ルールは **CLAUDE.md に残すのが正解**:
  - memory（特に reference 型）は「会話間で思い出す」もので、毎回確実に適用してほしい不変ルールには向かない
  - CLAUDE.md は standing operating procedure（恒久的な運用規約）の場所であり、z-ai/ ルールはまさにそれ
  - 切り出すべきは「人物プロフィール」「進行中案件の状態」「外部システムへのポインタ」「学習したフィードバック」など、状況依存の情報

参照: <https://code.claude.com/docs/en/memory>

---

## MCP / プラグイン

現状の `context7` + 各 LSP は鉄板構成。グローバル追加の決定打は無く、必要に応じてプロジェクト単位で `claude mcp add` するのが定石。

- `github` MCP: `gh` CLI で代替可能 → 任意
- `filesystem` MCP: Read/Write/Bash で代替可能 → メリット小
- `playwright` MCP: フロントエンドの UI 確認をする場合のみ、プロジェクト個別で導入

---

## 回避すべきアンチパターン

- ❌ グローバルで `permissions.defaultMode: "acceptEdits"` / `"bypassPermissions"`
- ❌ `permissions.allow` に広すぎるパターン（例: `Bash(git:*)` / `Bash(gh api:*)` / `Bash(find:*)`）
- ❌ グローバル `CLAUDE.md` にプロジェクト固有の規約を詰め込む（全プロジェクトで context を浪費）
- ❌ 不要な LSP プラグインを enable にしておく（起動が遅くなる）

---

## 参考リンク

- [Settings](https://code.claude.com/docs/en/settings)
- [Permissions](https://code.claude.com/docs/en/permissions)
- [Sandboxing](https://code.claude.com/docs/en/sandboxing)
- [Hooks](https://code.claude.com/docs/en/hooks)
- [Memory & CLAUDE.md](https://code.claude.com/docs/en/memory)
- [Status Line](https://code.claude.com/docs/en/statusline)
- [MCP](https://code.claude.com/docs/en/mcp)
- [Changelog](https://code.claude.com/docs/en/changelog)

## 関連ドキュメント

- [`dev-style.md`](./dev-style.md) — 開発スタイル（Plan Mode / TDD subagent / workflows）
- [`gap-analysis.md`](./gap-analysis.md) — 現運用とのギャップ分析・推奨アクション
