return {
  -- Treesitter parsers for TypeScript
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },

  -- LSP configuration for TypeScript
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Using vtsls instead of tsserver for better performance and features
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        -- Disable the old tsserver
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
      },
    },
  },

  -- Ensure Mason installs TypeScript tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(
        opts.ensure_installed,
        { "js-debug-adapter", "typescript-language-server", "eslint-lsp" }
      )
    end,
  },

  -- Testing support for TypeScript/JavaScript
  {
    "nvim-neotest/neotest-jest",
    event = { "BufRead *.{ts,tsx,js,jsx}" },
    dependencies = { "nvim-neotest/neotest" },
  },
}
