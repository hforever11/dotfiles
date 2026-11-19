return {
  "lewis6991/satellite.nvim",
  event = "VeryLazy",
  opts = {
    current_only = false,
    winblend = 50,
    zindex = 40,
    width = 2,
    excluded_filetypes = { "lazy", "mason", "help", "snacks_dashboard" },
    handlers = {
      cursor = {
        enable = true,
        -- 既定の ⎺ ⎻ ⎼ ⎽ (U+23BA〜23BD) は Maple Mono NF にも HackGen にも無く、Ghostty が別のフォントで代用する。
        -- その代用で、ペインの境界に大きな √ のような字が出ることがあった。
        -- Ghostty が自前で描く記号 (フォントに依存しない) にする。上・中・下の 3 段階
        symbols = { "▔", "─", "▁" },
      },
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
        signs = { "-", "=", "≡" },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = {
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = false,
      },
    },
  },
}
