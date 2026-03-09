return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
      },
    },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,         -- 検索を下部に表示
      command_palette = true,       -- コマンドラインをポップアップに
      long_message_to_split = true, -- 長いメッセージをsplitに
      lsp_doc_border = true,        -- LSPドキュメントに枠線
    },
  },
  keys = {
    { "<leader>sn",  "",                                             desc = "+noice" },
    { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "History" },
    { "<leader>sna", function() require("noice").cmd("all") end,     desc = "All Messages" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
  },
}
