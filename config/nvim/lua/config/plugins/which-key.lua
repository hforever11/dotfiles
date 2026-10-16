return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- <leader> のグループ名。docs/nvim/keymaps.md の見出しと揃える
    -- (名前がないと "+30 keymaps" のように件数しか出ない)
    spec = {
      {
        mode = { "n", "x" },
        { "<leader>a", group = "Claude Code" },
        { "<leader>c", group = "コード / コピー" },
        { "<leader>f", group = "ファイル" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "hunk" },
        { "<leader>l", group = "lazygit / LSP" },
        { "<leader>p", group = "のぞき見" },
        { "<leader>r", group = "リネーム" },
        { "<leader>s", group = "検索" },
        { "<leader>sn", group = "メッセージ" },
        { "<leader>t", group = "タブ" },
        { "<leader>u", group = "表示の切り替え" },
        { "<leader>w", group = "ウィンドウ" },
        { "<leader>x", group = "一覧 (Trouble)" },
      },
    },
  },
}
