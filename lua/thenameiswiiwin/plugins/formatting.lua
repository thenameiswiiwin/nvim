return {
  -- Conform.nvim: Formatting engine
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format document",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        -- Web development
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        svelte = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },

        -- Go
        go = { "gofumpt", "goimports" },

        -- Rust
        rust = { "rustfmt" },

        -- PHP
        php = { "php_cs_fixer" },

        -- Bash
        sh = { "shfmt" },
      },

      -- Format on save setup - controlled by autocmd in autocmds.lua
      format_on_save = false,

      -- Formatter options
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        prettier = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
              .. "/.prettierrc.json",
          },
        },
      },
    },
    init = function()
      -- Create format toggle command
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          -- FormatToggle! will disable formatting just for this buffer
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify(
            string.format(
              "Buffer autoformatting %s",
              vim.b.disable_autoformat and "disabled" or "enabled"
            )
          )
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            string.format(
              "Global autoformatting %s",
              vim.g.disable_autoformat and "disabled" or "enabled"
            )
          )
        end
      end, { desc = "Toggle autoformatting", bang = true })
    end,
  },

  -- Mason.nvim: Tool installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        -- Lua
        "stylua",

        -- Web development
        "prettierd",
        "prettier",
        "eslint_d",

        -- Go
        "gofumpt",
        "goimports",
        "delve",

        -- PHP
        "php-cs-fixer",
        "phpactor",
        "intelephense",

        -- Bash
        "shfmt",
        "shellcheck",
        "bash-language-server",

        -- Rust
        "rust-analyzer",
        "codelldb",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to load newly installed LSP servers
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      -- Install configured packages
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
