return {
  "y3owk1n/undo-glow.nvim",
  event = "BufReadPost",
  dependencies = { "gbprod/yanky.nvim" },
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

    -- 貼り付け後にカーソルを動かすと yanky のリング切替 (<C-p>/<C-n>) が
    -- 解除されるため、旧 `] ジャンプは付けない
    local function yanky_put(action)
      return function()
        return undo_glow.yanky_put(action)
      end
    end

    local function put(mode, lhs, action, desc)
      vim.keymap.set(mode, lhs, yanky_put(action),
        { expr = true, remap = true, desc = desc })
    end

    put("n", "p", "YankyPutAfter", "Put after with highlight")
    put("n", "P", "YankyPutBefore", "Put before with highlight")
    put("x", "p", "YankyPutBefore", "Paste without overwriting register")
    put("x", "P", "YankyPutBefore", "Paste without overwriting register")

    -- カーソルを貼り付けたテキストの末尾に残す(連続ペースト向き)
    put("n", "gp", "YankyGPutAfter", "Put after, cursor after text")
    put("n", "gP", "YankyGPutBefore", "Put before, cursor after text")

    -- 現在行のインデントに揃えて行単位ペースト(コードブロック向き)
    put("n", "]p", "YankyPutIndentAfterLinewise", "Put indented after (linewise)")
    put("n", "[p", "YankyPutIndentBeforeLinewise", "Put indented before (linewise)")
  end,
}
