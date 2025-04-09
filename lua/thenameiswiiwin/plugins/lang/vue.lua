return {
  -- Treesitter parsers for Vue
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "css" })
      end
    end,
  },

  -- LSP configuration for Vue
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Volar for Vue 3
        volar = {
          init_options = {
            vue = {
              hybridMode = true, -- Enable hybrid mode for better performance
            },
          },
          filetypes = { "vue" }, -- Only apply to .vue files for better performance
          -- Performance optimizations
          settings = {
            volar = {
              completion = {
                autoImport = true,
                useScaffoldSnippets = true,
              },
              diagnostics = {
                delay = 200, -- Delay diagnostics for better performance
              },
              codeLens = {
                references = false, -- Disable code lens for better performance
                pugTools = false,
              },
              takeOverMode = {
                enabled = true, -- Use takeover mode for better performance
              },
            },
          },
        },
      },
    },
  },

  -- Ensure Mason installs Vue tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue-language-server" })
    end,
  },

  -- Testing support for Vue
  {
    "marilari88/neotest-vitest",
    event = { "BufRead *.vue" },
    dependencies = { "nvim-neotest/neotest" },
  },
}
