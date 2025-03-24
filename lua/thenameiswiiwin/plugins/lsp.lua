return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP Management
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration
      "folke/neodev.nvim",

      -- For formatters and linters
      "stevearc/conform.nvim",
      "mfussenegger/nvim-lint",

      -- LSP Progress indicator
      "linrongbin16/lsp-progress.nvim",

      -- TypeScript tools for enhanced experience
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    config = function()
      -- Setup neovim lua configuration
      require("neodev").setup()

      -- Setup mason so it can manage external LSP, linters, and formatters
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Configure formatters and linters for Mason to manage
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatter
          "stylua", -- Lua
          "prettier", -- Web dev formatting
          "prettierd", -- Faster prettier daemon

          -- Linters
          "eslint_d", -- JavaScript linter
          "shellcheck", -- Shell linter
          "selene",  -- Lua linter
          "markdownlint", -- Markdown linter
        },
        auto_update = true,
        run_on_start = true,
      })

      -- Register linters using nvim-lint
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        vue = { "eslint_d" },
        lua = { "selene" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
      }

      -- Create autocommand to trigger linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      -- Setup formatter
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettierd", "prettier" },
          typescript = { "prettierd", "prettier" },
          javascriptreact = { "prettierd", "prettier" },
          typescriptreact = { "prettierd", "prettier" },
          css = { "prettierd", "prettier" },
          html = { "prettierd", "prettier" },
          json = { "prettierd", "prettier" },
          yaml = { "prettierd", "prettier" },
          markdown = { "prettierd", "prettier" },
          graphql = { "prettierd", "prettier" },
          vue = { "prettierd", "prettier" },
          svelte = { "prettierd", "prettier" },
          sh = { "shfmt" },
        },

        -- Format on save configuration
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return {
            timeout_ms = 500,
            lsp_fallback = true,
            stop_after_first = true,
          }
        end,
      })

      -- Format commands
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format document" })

      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          -- FormatToggle! will disable formatting just for this buffer
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify(
            string.format("Buffer autoformatting %s", vim.b.disable_autoformat and "disabled" or "enabled")
          )
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            string.format("Global autoformatting %s", vim.g.disable_autoformat and "disabled" or "enabled")
          )
        end
      end, { desc = "Toggle autoformatting", bang = true })

      -- Configure diagnostic display
      vim.diagnostic.config({
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
      })

      -- LSP servers to set up with default options
      local servers = {
        -- Web Development
        ts_ls = {},             -- TypeScript/JavaScript
        html = {},              -- HTML
        cssls = {},             -- CSS
        jsonls = {},            -- JSON
        tailwindcss = {},       -- TailwindCSS
        svelte = {},            -- Svelte
        eslint = {},            -- ESLint
        volar = {},             -- Vue
        emmet_language_server = {}, -- Emmet

        -- PHP
        intelephense = {}, -- PHP

        -- Other Languages
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
        gopls = {},     -- Go
        rust_analyzer = {}, -- Rust
        bashls = {},    -- Bash
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            -- Apply default configuration from the servers table
            require("lspconfig")[server_name].setup(
              vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server_name] or {})
            )
          end,
        },
      })

      -- Setup TypeScript tools for enhanced experience
      require("typescript-tools").setup({
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      })

      -- Setup LSP Progress
      require("lsp-progress").setup()

      -- Register autocmd for LSP attach to enable inlay hints
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(args.buf, true)
          end
        end,
      })

      -- Add keybinding to toggle inlay hints
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
      end, { desc = "Toggle inlay hints" })
    end,
  },
}
