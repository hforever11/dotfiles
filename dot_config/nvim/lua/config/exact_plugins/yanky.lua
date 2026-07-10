return {
  "gbprod/yanky.nvim",
  -- yanky の履歴は vim.ui.select 経由で出す(snacks picker が ui.select を乗っ取るので snacks UI で表示される)
  dependencies = { "folke/snacks.nvim" },
  opts = {},
  -- p/P・インデント揃え・gp/gP は undo-glow 側で yanky_put 統合として定義している
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank (record to yank ring)" },
    { "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank ring entry" },
    { "<C-n>", "<Plug>(YankyNextEntry)", desc = "Next yank ring entry" },
    -- <leader>p は overlook.nvim が prefix 占有(pc/pd/...)しているので衝突回避で <leader>y に置く
    { "<leader>y", function() require("yanky.picker").select_in_history() end, mode = { "n", "x" }, desc = "Yank history picker" },
  },
}
