return {
  "WilliamHsieh/overlook.nvim",
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("overlook_enter_mapping", { clear = true }),
      pattern = "*",
      callback = function()
        vim.schedule(function()
          if vim.w.is_overlook_popup then
            vim.keymap.set("n", "<CR>", function()
              require("overlook.api").open_in_original_window()
            end, { buffer = true, desc = "Overlook: Open in original window" })

            for _, lhs in ipairs({ "<C-CR>", ";" }) do
              vim.keymap.set("n", lhs, function()
                require("overlook.api").open_in_vsplit()
              end, { buffer = true, desc = "Overlook: Open in vertical split" })
            end
          end
        end)
      end,
    })
  end,
  keys = {
    { "<leader>pd", function() require("overlook.api").peek_definition() end, desc = "Peek definition" },
    { "<leader>pp", function() require("overlook.api").peek_cursor() end,     desc = "Peek cursor" },
    { "<leader>pc", function() require("overlook.api").close_all() end,       desc = "Close all popups" },
    { "<leader>pu", function() require("overlook.api").restore_popup() end,   desc = "Restore last popup" },
    { "<leader>pf", function() require("overlook.api").switch_focus() end,    desc = "Switch focus" },
    { "<leader>ps", function() require("overlook.api").open_in_split() end,   desc = "Open popup in split" },
    { "<leader>pv", function() require("overlook.api").open_in_vsplit() end,  desc = "Open popup in vsplit" },
  },
}
