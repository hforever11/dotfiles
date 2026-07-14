-- toggle で非表示にしても lazygit は常駐し auto-refresh (git status) が index.lock を
-- 取り続けるため、任意ロックを無効化して他の git 操作との衝突を防ぐ(必須ロックは影響なし)
local lazygit_env = { GIT_OPTIONAL_LOCKS = "0" }

-- gitignore 込み検索(<leader>fa / <leader>sG)で中身を見る価値の無いノイズを除外
local search_exclude = {
  -- 依存・成果物
  ".git",
  "node_modules",
  "vendor",
  "dist",
  "build",
  "target",
  ".next",
  ".venv",
  "venv",
  "__pycache__",
  -- キャッシュ
  ".cache",
  ".mypy_cache",
  ".pytest_cache",
  ".ruff_cache",
  ".turbo",
  -- ロックファイル(1行が長く grep が詰まる)
  "*.lock",
  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "bun.lockb",
  -- OS
  ".DS_Store",
}

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  -- stylua: ignore
  keys = {
    -- Lazygit
    { "<leader>lg", function()
        -- lazygit 起動前に stale index.lock を自己修復する（保持中の lock は git-unlock 側が温存）
        local dir = vim.fn.expand("%:p:h")
        if dir == "" then dir = vim.fn.getcwd() end
        vim.fn.system({ vim.fn.expand("~/.local/bin/git-unlock"), "-f", dir })
        Snacks.lazygit({ env = lazygit_env })
      end, desc = "Lazygit" },
    { "<leader>lf", function() Snacks.lazygit.log_file({ env = lazygit_env }) end, desc = "Lazygit file log" },
    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        local picker = require("snacks").picker
        local sources = require("snacks.picker.config.sources")
        local files = vim.tbl_deep_extend("force", sources.files, {
          cwd = vim.uv.cwd(),
          hidden = true,
        })
        picker({
          multi = { "buffers", "recent", files },
          format = "file",
          matcher = { frecency = true, sort_empty = true },
          filter = { cwd = true },
          transform = "unique_file",
        })
      end,
      desc = "Smart Find Files (frecency)"
    },
    { "<leader>,",  function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>:",  function() Snacks.picker.command_history() end,                         desc = "Command History" },
    { "<leader>n",  function() Snacks.picker.notifications() end,                           desc = "Notification History" },
    { "<leader>e",  function() Snacks.explorer() end,                                       desc = "File Explorer" },
    -- find
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
    {
      "<leader>fa",
      function()
        Snacks.picker.files({
          hidden = true,
          ignored = true,
          exclude = search_exclude,
        })
      end,
      desc = "Find Files (incl. gitignored)",
    },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
    {
      "<leader>sG",
      function()
        Snacks.picker.grep({
          hidden = true,
          ignored = true,
          exclude = search_exclude,
        })
      end,
      desc = "Grep (incl. gitignored)",
    },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end,                               desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end,                          desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
    { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end,                                    desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end,                                   desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end,                                 desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end,                                   desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end,                                     desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end,                                    desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
    -- LSP
    { "gd",         function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
    -- Zen Mode
    { "<leader>z",  function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
    -- Git Browse
    { "<leader>gB", function() Snacks.gitbrowse() end,                                      desc = "Git Browse" },
    -- Rename
    { "<leader>cR", function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
    -- Dim
    { "<leader>D",  function() if Snacks.dim.enabled then Snacks.dim.disable() else Snacks.dim.enable() end end, desc = "Toggle Dim" },
  },
  opts = {
    lazygit = {
      configure = true,
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
        grep = {
          regex = false,
          toggles = {
            regex = { icon = "R", value = false },
          },
        },
      },
    },
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
      enabled = false,
    },
    words = {
      enabled = true,
    },
    notifier = {
      enabled = false,
    },
    statuscolumn = {
      enabled = true,
    },
    dim = {
      enabled = true,
    },
    image = {
      enabled = true,
    },
    gitbrowse = {
      enabled = true,
    },
    rename = {
      enabled = true,
    },
    quickfile = {
      enabled = true,
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
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 1 },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        {
          pane = 2,
          section = "terminal",
          cmd = "pokemon-colorscripts --name venusaur --no-title; cat",
          random = 10,
          indent = 4,
          height = 30,
          ttl = 5 * 60,
          enabled = vim.o.columns > 100,
        },
      },
    },
  },
}
