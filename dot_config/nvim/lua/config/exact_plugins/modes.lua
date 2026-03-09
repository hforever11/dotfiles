return {
  "mvllow/modes.nvim",
  event = "BufReadPost",
  opts = function()
    local colors = require("config.core.theme").palette()
    return {
      colors = {
        copy = colors.yellow,
        delete = colors.red,
        insert = colors.sky,
        visual = colors.mauve,
      },
      line_opacity = {
        copy = 0.4,
        delete = 0.4,
        insert = 0.4,
        visual = 0.4,
      },
      set_cursor = true,
      set_cursorline = true,
      set_number = true,
    }
  end,
}
