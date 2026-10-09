return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  },
  config = function()
    require("nvim-treesitter").install({
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "python",
      "go",
      "rust",
      "toml",
      "nix",
    })

    -- Highlight and indent are now Neovim builtins
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Textobjects: select
    local ts_select = function(query)
      return function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
      end
    end
    vim.keymap.set({ "x", "o" }, "af", ts_select("@function.outer"), { desc = "Select around function" })
    vim.keymap.set({ "x", "o" }, "if", ts_select("@function.inner"), { desc = "Select inside function" })
    vim.keymap.set({ "x", "o" }, "ac", ts_select("@class.outer"), { desc = "Select around class" })
    vim.keymap.set({ "x", "o" }, "ic", ts_select("@class.inner"), { desc = "Select inside class" })
    vim.keymap.set({ "x", "o" }, "aa", ts_select("@parameter.outer"), { desc = "Select around argument" })
    vim.keymap.set({ "x", "o" }, "ia", ts_select("@parameter.inner"), { desc = "Select inside argument" })

    -- Textobjects: move
    local ts_move = function(fn, query)
      return function()
        require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
      end
    end
    vim.keymap.set({ "n", "x", "o" }, "]f", ts_move("goto_next_start", "@function.outer"), { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]c", ts_move("goto_next_start", "@class.outer"), { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]a", ts_move("goto_next_start", "@parameter.inner"), { desc = "Next argument" })
    vim.keymap.set({ "n", "x", "o" }, "]F", ts_move("goto_next_end", "@function.outer"), { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "]C", ts_move("goto_next_end", "@class.outer"), { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "[f", ts_move("goto_previous_start", "@function.outer"), { desc = "Previous function start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", ts_move("goto_previous_start", "@class.outer"), { desc = "Previous class start" })
    vim.keymap.set({ "n", "x", "o" }, "[a", ts_move("goto_previous_start", "@parameter.inner"), { desc = "Previous argument" })
    vim.keymap.set({ "n", "x", "o" }, "[F", ts_move("goto_previous_end", "@function.outer"), { desc = "Previous function end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", ts_move("goto_previous_end", "@class.outer"), { desc = "Previous class end" })

    -- Textobjects: repeat
    -- ]f や ]h などの移動も ; と , で繰り返す。向きは Vim 標準と同じで、; は直前の移動と同じ向き。
    -- f/F/t/T も ; , を共有するため、ここで記録させる
    local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move, { desc = "Repeat last move" })
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_opposite, { desc = "Repeat last move (opposite)" })
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })

    require("nvim-ts-autotag").setup()
  end,
}
