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

    require("nvim-ts-autotag").setup()
  end,
}
