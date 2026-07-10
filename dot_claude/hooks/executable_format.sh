#!/usr/bin/env bash
# PostToolUse (Edit|Write) hook: プロジェクトに設定がある formatter だけを編集ファイルへ適用する。
# 設定が見つからなければ何もしない（プロジェクトの流儀を勝手に上書きしない）。常に exit 0。
set -u

command -v jq >/dev/null 2>&1 || exit 0

file="$(jq -r '.tool_input.file_path // empty' 2>/dev/null)"
[ -n "$file" ] && [ -f "$file" ] || exit 0

# file の位置から git root まで遡って設定ファイルを探す
find_up() {
  local dir="$1"
  shift
  while :; do
    local name
    for name in "$@"; do
      [ -e "$dir/$name" ] && {
        printf '%s\n' "$dir/$name"
        return 0
      }
    done
    [ -e "$dir/.git" ] && return 1
    [ "$dir" = "/" ] && return 1
    dir="$(dirname "$dir")"
  done
}

run() { command -v "$1" >/dev/null 2>&1 && "$@" >/dev/null 2>&1; }

dir="$(cd "$(dirname "$file")" 2>/dev/null && pwd)" || exit 0
ext="${file##*.}"

case "$ext" in
lua)
  find_up "$dir" stylua.toml .stylua.toml >/dev/null && run stylua "$file"
  ;;
go)
  find_up "$dir" go.mod >/dev/null && run gofmt -w "$file"
  ;;
rs)
  find_up "$dir" rustfmt.toml .rustfmt.toml >/dev/null && run rustfmt "$file"
  ;;
py)
  if cfg="$(find_up "$dir" ruff.toml .ruff.toml)"; then
    run ruff format "$file"
  elif cfg="$(find_up "$dir" pyproject.toml)"; then
    if grep -q '\[tool\.ruff' "$cfg" 2>/dev/null; then
      run ruff format "$file"
    elif grep -q '\[tool\.black\]' "$cfg" 2>/dev/null; then
      run black -q "$file"
    fi
  fi
  ;;
sh | bash)
  # shfmt は .editorconfig をネイティブに読む → それを設定の存在条件とする
  find_up "$dir" .editorconfig >/dev/null && run shfmt -w "$file"
  ;;
js | jsx | ts | tsx | json | jsonc | css | scss | md | yaml | yml | html | vue | svelte)
  if cfg="$(find_up "$dir" biome.json biome.jsonc)"; then
    bin="$(dirname "$cfg")/node_modules/.bin/biome"
    { [ -x "$bin" ] && "$bin" format --write "$file" >/dev/null 2>&1; } || run biome format --write "$file"
  elif cfg="$(find_up "$dir" .prettierrc .prettierrc.json .prettierrc.yml .prettierrc.yaml .prettierrc.js .prettierrc.cjs .prettierrc.toml prettier.config.js prettier.config.cjs prettier.config.mjs)" ||
    { cfg="$(find_up "$dir" package.json)" && jq -e '.prettier' "$cfg" >/dev/null 2>&1; }; then
    bin="$(dirname "$cfg")/node_modules/.bin/prettier"
    { [ -x "$bin" ] && "$bin" --write --ignore-unknown "$file" >/dev/null 2>&1; } || run prettier --write --ignore-unknown "$file"
  fi
  ;;
esac

exit 0
