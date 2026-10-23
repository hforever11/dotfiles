return {
  {
    "arto-app/arto.vim",
    cmd = { "Arto", "ArtoVersion" },
    ft = { "markdown" },
    keys = {
      { "<leader>m", "<cmd>Arto<cr>", ft = "markdown", desc = "Open in Arto" },
    },
  },
}
