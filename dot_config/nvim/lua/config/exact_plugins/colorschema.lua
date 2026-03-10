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
        custom_highlights = function()
          return {
            SnacksDashboardHeader = { fg = "#a6d189" },
            SnacksDashboardIcon = { fg = "#81c8be" },
            SnacksDashboardKey = { fg = "#81c8be" },
          }
        end,
      })
      vim.cmd.colorscheme(theme.name)
    end,
  },
}
