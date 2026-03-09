return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      local theme = require("config.core.theme")

      require("catppuccin").setup({
        flavour = theme.variant,
        transparent_background = theme.transparent_background,
      })
      vim.cmd.colorscheme(theme.name)
    end,
  },
}
