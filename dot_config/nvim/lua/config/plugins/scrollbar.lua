return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  config = function()
    require("scrollbar").setup({
      hide_if_all_visible = true,
      show_in_active_only = true,
      handle = {
        text = " ",
        color = "#626880",
      },
      marks = {
        Search = { color = "#8caaee" },
        Error = { color = "#e78284" },
        Warn = { color = "#e5c890" },
        Info = { color = "#8caaee" },
        Hint = { color = "#a6d189" },
        Misc = { color = "#c6d0f5" },
      },
    })

    local ok, gitsigns = pcall(require, "scrollbar.handlers.gitsigns")
    if ok then
      gitsigns.setup()
    end
  end,
}
