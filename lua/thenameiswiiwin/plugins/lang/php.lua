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

  -- LSP configuration for PHP (intelephense and phpactor)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              stubs = {
                "apache",
                "bcmath",
                "bz2",
                "calendar",
                "com_dotnet",
                "Core",
                "ctype",
                "curl",
                "date",
                "dba",
                "dom",
                "enchant",
                "exif",
                "FFI",
                "fileinfo",
                "filter",
                "fpm",
                "ftp",
                "gd",
                "gettext",
                "gmp",
                "hash",
                "iconv",
                "imap",
                "intl",
                "json",
                "ldap",
                "libxml",
                "mbstring",
                "meta",
                "mysqli",
                "oci8",
                "odbc",
                "openssl",
                "pcntl",
                "pcre",
                "PDO",
                "pdo_ibm",
                "pdo_mysql",
                "pdo_pgsql",
                "pdo_sqlite",
                "pgsql",
                "Phar",
                "posix",
                "pspell",
                "readline",
                "Reflection",
                "session",
                "shmop",
                "SimpleXML",
                "snmp",
                "soap",
                "sockets",
                "sodium",
                "SPL",
                "sqlite3",
                "standard",
                "superglobals",
                "sysvmsg",
                "sysvsem",
                "sysvshm",
                "tidy",
                "tokenizer",
                "xml",
                "xmlreader",
                "xmlrpc",
                "xmlwriter",
                "xsl",
                "Zend OPcache",
                "zip",
                "zlib",
                "wordpress",
                "phpunit",
                "laravel",
              },
              files = {
                maxSize = 5000000,
              },
              environment = {
                includePaths = { "vendor" },
              },
              diagnostics = {
                enable = true,
              },
              completion = {
                maxItems = 100,
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
        },
        phpactor = {
          filetypes = { "php" },
          -- Only use certain features from phpactor since intelephense is more performant
          init_options = {
            index = {
              enabled = false,
            },
            completion = {
              enabled = false,
            },
            diagnostics = {
              enabled = false,
            },
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
        { "phpcs", "php-cs-fixer", "phpstan" }
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
