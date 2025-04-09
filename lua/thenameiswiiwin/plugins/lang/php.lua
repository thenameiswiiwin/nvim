return {
  -- Treesitter parsers for PHP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php" })
      end
    end,
  },

  -- LSP configuration for PHP (intelephense)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              -- Limit stubs to essentials for better performance
              stubs = {
                "apache",
                "bcmath",
                "Core",
                "curl",
                "date",
                "dom",
                "filter",
                "ftp",
                "hash",
                "iconv",
                "json",
                "libxml",
                "mbstring",
                "mysqli",
                "openssl",
                "pcre",
                "PDO",
                "pdo_mysql",
                "pdo_sqlite",
                "Phar",
                "reflection",
                "session",
                "SimpleXML",
                "SPL",
                "standard",
                "superglobals",
                "tokenizer",
                "xml",
                "xmlreader",
                "xmlwriter",
                "zip",
                "zlib",
                "wordpress",
                "phpunit",
                "laravel",
              },
              files = {
                maxSize = 1000000, -- Limit max file size to 1MB for better performance
              },
              environment = {
                includePaths = { "vendor" },
              },
              diagnostics = {
                enable = true,
                run = "onSave", -- Only run on save for better performance
              },
              completion = {
                maxItems = 50, -- Limit completion items for better performance
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints = true,
              },
              phpdoc = {
                useFullyQualifiedNames = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
          -- Performance optimizations
          filetypes = { "php" }, -- Only activate for PHP files
          flags = {
            debounce_text_changes = 150, -- Reduce text change frequency
          },
        },
      },
    },
  },

  -- Ensure Mason installs PHP tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(
        opts.ensure_installed,
        { "phpcs", "php-cs-fixer", "intelephense" }
      )
    end,
  },

  -- PHP Testing support
  {
    "olimorris/neotest-phpunit",
    event = { "BufRead *.php" },
    dependencies = { "nvim-neotest/neotest" },
  },
}
