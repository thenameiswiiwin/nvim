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
        html = {},

        -- CSS language server
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
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
            "svelte",
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                  { 'className="([^"]*)"', '"([^"]*)"' },
                  { 'class="([^"]*)"', '"([^"]*)"' },
                  { 'className={"([^"}]*)"}', '"([^"]*)"' },
                  { "className={`([^`]*)`}", "`([^`]*)`" },
                },
              },
            },
          },
        },
      },
    },
  },

  -- TailwindCSS colorizer integration
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
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
