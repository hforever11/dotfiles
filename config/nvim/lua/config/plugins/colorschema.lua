return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      local theme = require("config.core.theme")
      local palette = theme.palette()

      require("catppuccin").setup({
        flavour = theme.variant,
        transparent_background = theme.transparent_background,
        -- 背景はターミナル (Ghostty) と揃える。単一ソースは home/theme.nix
        -- green は herdr の accent と揃えた非公式値のため、ここで上書きしないと
        -- gitsigns add / diff / 文字列だけ公式 Latte の緑に取り残される
        color_overrides = {
          [theme.variant] = {
            base = palette.base,
            mantle = palette.mantle,
            green = palette.green,
          },
        },
        custom_highlights = function(colors)
          return {
            SnacksDashboardHeader = { fg = colors.green },
            SnacksDashboardIcon = { fg = colors.sky },
            SnacksDashboardKey = { fg = colors.sky },
            -- satellite.nvim
            SatelliteBar = { bg = colors.surface0 },
            SatelliteCursor = { fg = colors.text },
            SatelliteSearch = { fg = colors.yellow },
            SatelliteDiagnosticError = { fg = colors.red },
            SatelliteDiagnosticWarn = { fg = colors.yellow },
            SatelliteDiagnosticInfo = { fg = colors.sky },
            SatelliteDiagnosticHint = { fg = colors.green },
            SatelliteGitSignsAdd = { fg = colors.green },
            SatelliteGitSignsChange = { fg = colors.sky },
            SatelliteGitSignsDelete = { fg = colors.red },
            SatelliteMark = { fg = colors.overlay0 },
          }
        end,
      })
      vim.cmd.colorscheme(theme.name)
    end,
  },
}
