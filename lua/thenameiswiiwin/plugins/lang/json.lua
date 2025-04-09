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
            -- Only load schemastore when needed
            local has_schemastore, schemastore = pcall(require, "schemastore")
            if has_schemastore then
              vim.list_extend(
                new_config.settings.json.schemas,
                schemastore.json.schemas()
              )
            else
              -- Fallback to basic schemas
              vim.list_extend(new_config.settings.json.schemas, {
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
              })
            end
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
              -- Performance optimizations
              maxItemsComputed = 2000, -- Limit computed items
              keepLines = {
                onFormatting = true, -- Keep lines on formatting
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

  -- Ensure Mason installs JSON tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "json-lsp" })
    end,
  },
}
