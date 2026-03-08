return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
  -- Mason (LSPサーバー自動管理)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "vtsls",
        "tailwindcss",
        "jsonls",
        "yamlls",
        "terraformls",
        "bashls",
        "html",
        "cssls",
        "gopls",
        "rust_analyzer",
        "copilot",
      },
    },
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Diagnostic設定
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        severity_sort = true,
        float = { border = "rounded" },
      })
      -- キーマップ (LspAttach時)
      -- gd, gD, gr, gI は Snacks picker で定義済み
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        end,
      })
      -- 共通設定
      vim.lsp.config("*", { capabilities = capabilities })
      -- Mason 等で入っていても、Lua 整形は stylua LSP を使わない
      vim.lsp.enable("stylua", false)
      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = { checkThirdParty = false },
          },
        },
      })
      -- Python
      vim.lsp.config("pyright", {
        settings = {
          pyright = { disableOrganizeImports = true },
        },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })
      -- Go
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      -- Terraform
      vim.lsp.config("terraformls", {
        filetypes = { "tf", "terraform", "terraform-vars" },
      })
      -- Rust
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              allFeatures = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })
      -- Copilot LSP (sidekick.nvim NES 用)
      vim.lsp.config("copilot", {
        cmd = { "copilot-language-server", "--stdio" },
        root_markers = { ".git" },
      })
      -- LSP有効化
      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "ruff",
        "vtsls",
        "tailwindcss",
        "jsonls",
        "yamlls",
        "terraformls",
        "bashls",
        "html",
        "cssls",
        "gopls",
        "rust_analyzer",
        "copilot",
      })
    end,
  },
  -- LSP進捗表示
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  -- Python venv選択
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Venv" },
    },
    opts = {},
  },
  -- 補完
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
