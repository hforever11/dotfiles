return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = function()
    local palette = require("config.core.theme").palette()

    return {
      recipe = { "default", { animate = false } },
      ncmode = "windows",
      fadelevel = 0.6,
      basebg = palette.base,
      blocklist = {
        default = {
          buf_opts = {
            buftype = { "prompt", "popup" },
            filetype = {
              "lazy",
              "mason",
              "neo-tree",
              "snacks_dashboard",
              "snacks_picker_input",
              "snacks_picker_list",
            },
          },
          win_config = {
            relative = true,
          },
        },
      },
      enablefocusfading = false,
      usecursorhold = false,
      nohlcheck = true,
    }
  end,
}
