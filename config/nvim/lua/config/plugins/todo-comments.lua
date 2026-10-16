-- TODO / FIXME / HACK / NOTE などのコメントに色を付け、]t / [t で前後へ移動する。
-- <leader>xt (trouble.lua) の一覧もこの setup が前提 (setup 前に開くとエラーになる)

-- ]h などと同じく ; と , で繰り返せるよう treesitter-textobjects の仕組みに載せる
local function jump(forward)
  local move = require("nvim-treesitter-textobjects.repeatable_move").make_repeatable_move(function(opts)
    if opts.forward then
      require("todo-comments").jump_next()
    else
      require("todo-comments").jump_prev()
    end
  end)
  move({ forward = forward })
end

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
  keys = {
    -- Neovim 標準の ]t / [t (:tnext / :tprevious) は上書きする
    { "]t", function() jump(true) end,  desc = "Next TODO comment" },
    { "[t", function() jump(false) end, desc = "Previous TODO comment" },
  },
}
