return {
  -- Treesitter parsers for web languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html", "css", "scss" })
      end
    end,
  },

  -- LSP configuration for web languages
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML language server
        html = {
          -- Performance optimization
          filetypes = { "html" },
          init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true,
            },
            provideFormatter = false, -- Use conform.nvim instead
          },
        },

        -- CSS language server
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
          -- Performance optimizations
          filetypes = { "css", "scss", "less" },
        },

        -- TailwindCSS language server
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { 'className="([^"]*)"', '"([^"]*)"' },
                  { 'class="([^"]*)"', '"([^"]*)"' },
                },
              },
              -- Performance optimizations
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
            },
          },
        },
      },
    },
  },

  -- Ensure Mason installs web tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "css-lsp",
        "html-lsp",
        "tailwindcss-language-server",
      })
    end,
  },
}
