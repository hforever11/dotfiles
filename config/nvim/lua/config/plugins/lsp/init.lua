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
      -- Mason に入っているだけで自動 enable させない。有効化は下の vim.lsp.enable() の明示リストのみで行う
      -- (basedpyright 導入後も pyright が残っていて二重アタッチしていた事故の再発防止)
      automatic_enable = false,
      ensure_installed = {
        "lua_ls",
        "basedpyright",
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
        -- nixd は mason-lspconfig のレジストリに存在しないため対象外 (home/default.nix で nix 管理)
      },
    },
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
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
          local opts = { buf = args.buf, silent = true }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
          -- Inlay Hints トグル
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
            end, { buf = args.buf, desc = "Toggle Inlay Hints" })
          end
        end,
      })
      -- 共通設定
      vim.lsp.config("*", { capabilities = capabilities })
      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = { checkThirdParty = false },
            hint = { enable = true },
          },
        },
      })
      -- Python
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
                functionReturnTypes = true,
                genericTypes = false,
              },
            },
          },
        },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })
      -- TypeScript / JavaScript
      local ts_inlay_hints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
      vim.lsp.config("vtsls", {
        settings = {
          typescript = { inlayHints = ts_inlay_hints },
          javascript = { inlayHints = ts_inlay_hints },
        },
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
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
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
            cargo = {
              features = "all",
              buildScripts = {
                enable = true,
              },
            },
            check = {
              command = "clippy",
              allTargets = true,
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
        "basedpyright",
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
        "nixd",
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
}
