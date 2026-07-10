return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = function()
    local palette = require("config.core.theme").palette()
    local sidebar_filetypes = {
      snacks_picker_input = true,
      snacks_picker_list = true,
    }

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
        sidebar_focus = function(_, current)
          local filetype = current and current.buf_opts and current.buf_opts.filetype
          return filetype ~= nil and sidebar_filetypes[filetype] or false
        end,
      },
      enablefocusfading = false,
      usecursorhold = false,
      nohlcheck = true,
    }
  end,
}
