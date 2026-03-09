return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  -- stylua: ignore
  keys = {
    -- Lazygit
    { "<leader>lg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
    { "<leader>lf",      function() Snacks.lazygit.log_file() end,                               desc = "Lazygit file log" },
    -- Top Pickers & Explorer
    { "<leader><space>", function()
        local picker = require("snacks").picker
        local root = require("snacks.git").get_root()
        local sources = require("snacks.picker.config.sources")
        local files = root == nil and sources.files
          or vim.tbl_deep_extend("force", sources.git_files, {
            untracked = true,
            cwd = vim.uv.cwd(),
          })
        picker({
          multi = { "buffers", "recent", files },
          format = "file",
          matcher = { frecency = true, sort_empty = true },
          filter = { cwd = true },
          transform = "unique_file",
        })
      end,                                                                                       desc = "Smart Find Files (frecency)" },
    { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
    { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
    { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
    -- find
    { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
    -- git
    { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
    { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
    { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
    { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
    { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
    { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
    { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
    -- Grep
    { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
    { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
    { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
    { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
    { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
    { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
    { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
    { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
    { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
    { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
    { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
    { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
    { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
    { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
    { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
    { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
    { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
    { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
    { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
    { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
    { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
    -- LSP
    { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
    { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
    { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
    { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
    -- Zen Mode
    { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
    { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
  },
  opts = {
    lazygit = {
      configure = true,
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {},
    indent = {
      enabled = true,
      char = "│",
    },
    chunk = {
      enabled = true,
      char = {
        corner_top = "┌",
        corner_bottom = "└",
        horizontal = "─",
        vertical = "│",
        arrow = ">",
      },
    },
    scope = {
      enabled = true,
    },
    input = {},
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
    },
    zoom = {
      enabled = true,
    },
    scroll = {
      enabled = true,
    },
    words = {
      enabled = true,
    },
    notifier = {
      enabled = false,
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "n", desc = "File Explorer", action = ":lua Snacks.explorer()" },
          { icon = "󰁯 ", key = "s", desc = "Restore Session", action = ":SessionRestore" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        {
          section = "terminal",
          cmd =
          "/opt/homebrew/bin/chafa ~/.config/wall.png --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
          height = 17,
          padding = 1,
        },
        {
          pane = 2,
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
