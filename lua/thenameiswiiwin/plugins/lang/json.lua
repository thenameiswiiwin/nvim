return {
  -- Treesitter parsers for JSON
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  -- SchemaStore for JSON schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- LSP configuration for JSON
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- Lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas
              or {}
            vim.list_extend(
              new_config.settings.json.schemas,
              require("schemastore").json.schemas()
            )
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                  fileMatch = { ".prettierrc", ".prettierrc.json" },
                  url = "https://json.schemastore.org/prettierrc.json",
                },
                {
                  fileMatch = { ".eslintrc", ".eslintrc.json" },
                  url = "https://json.schemastore.org/eslintrc.json",
                },
              },
            },
          },
        },
      },
    },
  },

  -- Ensure Mason installs JSON tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "json-lsp" })
    end,
  },
}
