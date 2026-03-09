return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format",
    },
  },
  opts = function()
    local util = require("conform.util")
    return {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix" },
        typescript = { "biome_check" },
        typescriptreact = { "biome_check" },
        javascript = { "biome_check" },
        javascriptreact = { "biome_check" },
        json = { "biome" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        terraform = { "terraform_fmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
      },
      formatters = {
        biome_check = {
          command = util.from_node_modules("biome"),
          args = { "check", "--write", "--unsafe", "$FILENAME" },
          stdin = false,
          cwd = util.root_file({ "biome.json", "biome.jsonc" }),
          exit_codes = { 0, 1 },
        },
      },
    }
  end,
}
