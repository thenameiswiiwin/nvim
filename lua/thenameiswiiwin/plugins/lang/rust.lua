return {
  -- Treesitter parsers for Rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust", "toml" })
      end
    end,
  },

  -- Crates.nvim for Cargo.toml management
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = false, -- Disable null-ls for better performance
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

            -- Reduce keymaps to essential ones for performance
            vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
            vim.keymap.set("n", "<leader>cr", crates.reload, opts)
            vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
            vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
            vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
            vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
            vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
          end,
        },
        -- Performance optimizations
        loading_indicator = true, -- Provide feedback during loading
        crates_cache = true, -- Enable crates cache
        crates_cache_path = vim.fn.stdpath('cache') .. '/crates-nvim', -- Cache path
        disable_invalid_feature_diagnostic = false, -- Disable some diags
        text_style = {
          version = { bold = false }, -- Disable bold
          feature = { bold = false }, -- Disable bold
        },
      })
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
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy", 
                extraArgs = { "--no-deps" }, -- Skip analyzing dependencies
              },
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
              -- Performance optimizations
              cachePriming = {
                numThreads = 4, -- Limit threads
                enable = true, 
              },
              diagnostics = {
                disabled = {"inactive-code"}, -- Disable some diagnostics
                experimental = {
                  enable = false, -- Disable experimental diagnostics
                },
              },
              lru = {
                capacity = 128, -- Reduce memory usage
              },
            },
          },
          -- Performance optimizations
          flags = {
            debounce_text_changes = 150, -- Reduce text change frequency
          },
        },
      },
    },
  },

  -- Ensure Mason installs Rust tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer" })
    end,
  },

  -- Neotest Rust
  {
    "rouge8/neotest-rust",
    event = { "BufRead *.rs" },
    dependencies = { "nvim-neotest/neotest" },
  },
}
