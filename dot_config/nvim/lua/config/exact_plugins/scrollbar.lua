return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  config = function()
    local p = require("config.core.theme").palette()

    require("scrollbar").setup({
      hide_if_all_visible = true,
      show_in_active_only = true,
      handle = {
        text = " ",
        color = p.surface1,
      },
      marks = {
        Search = { color = p.blue },
        Error = { color = p.red },
        Warn = { color = p.yellow },
        Info = { color = p.blue },
        Hint = { color = p.green },
        Misc = { color = p.text },
      },
    })

    local ok, gitsigns = pcall(require, "scrollbar.handlers.gitsigns")
    if ok then
      gitsigns.setup()
    end
  end,
}
