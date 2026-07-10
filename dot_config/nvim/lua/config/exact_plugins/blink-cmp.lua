return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  dependencies = {
    "saghen/blink.lib",
    "folke/lazydev.nvim",
  },
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = false },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    fuzzy = { implementation = "rust" },
  },
}
