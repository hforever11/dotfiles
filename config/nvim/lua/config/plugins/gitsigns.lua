-- 差分の基準を「既定ブランチとの分岐点」に切り替える / 戻す。
-- 切り替えている間は、コミット済みの変更も行頭の印と ]h の対象になる (Claude がブランチで変えた箇所を追う用)
local branch_base = false
local function toggle_branch_base()
  local gs = require("gitsigns")
  if branch_base then
    gs.reset_base(true)
    branch_base = false
    vim.notify("差分の基準: 未コミットの変更だけ (既定)")
    return
  end
  local base, branch, at_head = require("config.core.git").branch_point()
  if not base then
    vim.notify("既定ブランチとの分岐点が見つかりません", vim.log.levels.WARN)
    return
  end
  -- 分岐点が今のコミットと同じなら、切り替えても印は変わらない。効いていないように見えるので知らせて止める
  if at_head then
    vim.notify(("%s から先のコミットがありません。印は未コミットの変更だけのままです"):format(branch))
    return
  end
  gs.change_base(base, true)
  branch_base = true
  vim.notify(("差分の基準: %s との分岐点 (%s)"):format(branch, base:sub(1, 7)))
end

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- lazygit の stage/commit で .git が書き換わると全 nvim インスタンスの
    -- ウォッチャーが一斉に発火する。既定 100ms では束ねきれないため延ばす
    update_debounce = 500,
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      -- ; と , で繰り返せるよう treesitter-textobjects の仕組みに載せる
      local nav_hunk = require("nvim-treesitter-textobjects.repeatable_move").make_repeatable_move(function(opts)
        if vim.wo.diff then
          vim.cmd.normal({ opts.forward and "]c" or "[c", bang = true })
        else
          gs.nav_hunk(opts.forward and "next" or "prev")
        end
      end)

      -- stylua: ignore start
      map("n", "]h", function() nav_hunk({ forward = true }) end, "Next Hunk")
      map("n", "[h", function() nav_hunk({ forward = false }) end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map("n", "<leader>ghm", toggle_branch_base, "Toggle base: branch point")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
}
