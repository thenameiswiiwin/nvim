return {
  -- Treesitter parsers for Rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "ron", "toml" })
      end
    end,
  },

  -- LSP configuration for Rust
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = true,
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".github",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
              },
            },
          },
        },
      },
    },
  },

  -- Crates.nvim for Cargo.toml management
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
          autofocus = true,
        },
        lsp = {
          enabled = true,
          on_attach = function(_, bufnr)
            local crates = require("crates")
            local opts = { silent = true, buffer = bufnr }

            -- Set keymaps for Cargo.toml files
            vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
            vim.keymap.set("n", "<leader>cr", crates.reload, opts)
            vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
            vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
            vim.keymap.set(
              "n",
              "<leader>cd",
              crates.show_dependencies_popup,
              opts
            )
            vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
            vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
            vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
            vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
            vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
            vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)
          end,
        },
      })
    end,
  },

  -- Ensure Mason installs Rust tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer" })
    end,
  },
}
