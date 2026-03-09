return {
  "y3owk1n/undo-glow.nvim",
  event = "BufReadPost",
  config = function()
    local undo_glow = require("undo-glow")
    local colors = require("config.core.theme").palette()

    undo_glow.setup({
      highlights = {
        undo = { hl_color = { bg = colors.red } },
        redo = { hl_color = { bg = colors.green } },
        yank = { hl_color = { bg = colors.yellow } },
        paste = { hl_color = { bg = colors.blue } },
        search = { hl_color = { bg = colors.mauve } },
      },
    })

    vim.keymap.set("n", "u", undo_glow.undo, { desc = "Undo with highlight" })
    vim.keymap.set("n", "U", undo_glow.redo, { desc = "Redo with highlight" })

    vim.keymap.set("n", "p", function()
      undo_glow.paste_below()
      vim.cmd.normal({ args = { "`]" }, bang = true })
    end, { desc = "Paste below with highlight" })
    vim.keymap.set("n", "P", function()
      undo_glow.paste_above()
      vim.cmd.normal({ args = { "`]" }, bang = true })
    end, { desc = "Paste above with highlight" })
  end,
}
