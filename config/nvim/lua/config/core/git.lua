-- ブランチ全体の変更を見るための git の問い合わせ (gitsigns.lua と snacks.lua が使う)
local M = {}

local function git(dir, ...)
  local out = vim.system({ "git", "-C", dir, ... }, { text = true }):wait()
  if out.code == 0 then
    return vim.trim(out.stdout)
  end
end

local function repo_dir()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

-- リモートの既定ブランチ (origin/main など)。見つからなければ nil
function M.default_branch()
  local dir = repo_dir()
  local head = git(dir, "symbolic-ref", "--short", "refs/remotes/origin/HEAD")
  if head then
    return head
  end
  -- clone でなく init + remote add したリポジトリには origin/HEAD が無い
  for _, name in ipairs({ "origin/main", "origin/master", "main", "master" }) do
    if git(dir, "rev-parse", "--verify", "--quiet", name) then
      return name
    end
  end
end

-- 今のブランチが既定ブランチから分かれた地点のコミット。既定ブランチの名前と、
-- 分岐点が今のコミット (HEAD) と同じか (= コミット済みの差分が無いか) も返す
function M.branch_point()
  local branch = M.default_branch()
  if not branch then
    return nil
  end
  local dir = repo_dir()
  local base = git(dir, "merge-base", "HEAD", branch)
  return base, branch, base ~= nil and base == git(dir, "rev-parse", "HEAD")
end

return M
