return {
  "max397574/better-escape.nvim",
  event = "VeryLazy",
  config = function()
    require("better_escape").setup({
      timeout = 200,
      mappings = {
        i = { j = { k = "<Esc>" } },
        c = { j = { k = "<Esc>" } },
        x = { j = { k = "<Esc>" } },
        s = { j = { k = "<Esc>" } },
        o = { j = { k = "<Esc>" } },
        t = {
          j = {
            k = function()
              local bufname = vim.api.nvim_buf_get_name(0)
              if bufname:match("lazygit") then
                vim.api.nvim_feedkeys("k", "n", false)
                return
              end
              vim.api.nvim_input("<C-\\><C-n>")
            end,
          },
        },
      },
    })
  end,
}
