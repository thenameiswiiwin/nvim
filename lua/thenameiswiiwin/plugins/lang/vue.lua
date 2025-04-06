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
              hybridMode = true,
            },
          },
          filetypes = { "vue", "typescript", "javascript" },
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
