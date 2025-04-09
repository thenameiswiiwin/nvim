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
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
        vue = { "prettierd" },

        -- Go
        go = { "gofumpt" },

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
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
              .. "/.prettierrc.json",
          },
          timeout_ms = 1000, -- Increase timeout for better reliability
        },
        stylua = {
          prepend_args = { "--indent-width", "2", "--indent-type", "Spaces" },
        },
      },

      -- Performance optimization settings
      format_after_save = false,
      notify_on_error = false, -- Disable notifications for better performance
      log_level = vim.log.levels.ERROR,
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
        keymaps = {
          -- Keymap for toggling package expand
          toggle_package_expand = "<CR>",
          -- Keymap for installing the package under the cursor
          install_package = "i",
          -- Keymap for updating the package under the cursor
          update_package = "u",
          -- Keymap for checking for new version of the package under the cursor
          check_package_version = "c",
          -- Keymap for checking outdated packages
          check_outdated_packages = "C",
          -- Keymap for uninstalling the package under the cursor
          uninstall_package = "X",
          -- Keymap for cancelling a package installation
          cancel_installation = "<C-c>",
          -- Keymap for applying language filter
          apply_language_filter = "<C-f>",
        },
      },
      ensure_installed = {
        -- Lua
        "stylua",

        -- Web development
        "prettierd",
        "eslint_d",

        -- Go
        "gofumpt",
        "delve",

        -- PHP
        "php-cs-fixer",
        "intelephense",

        -- Bash
        "shfmt",
        "shellcheck",
        "bash-language-server",

        -- Rust
        "rust-analyzer",
        "codelldb",
      },
      max_concurrent_installers = 10, -- Speed up installation
      -- Performance optimizations
      install = {
        -- Timeout in milliseconds for package installation
        timeout_ms = 300000, -- 5 minutes
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        -- Use defer_fn to slightly delay the reload
        vim.defer_fn(function()
          -- Trigger FileType event to load newly installed LSP servers
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 200)
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

      -- Defer the registry refresh and installation
      vim.defer_fn(function()
        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end, 100)
    end,
  },
}
