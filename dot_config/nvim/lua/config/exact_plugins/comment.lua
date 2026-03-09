return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = { enable_autocmd = false },
    },
  },
  opts = {
    pre_hook = function(ctx)
      return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
    end,
  },
}
