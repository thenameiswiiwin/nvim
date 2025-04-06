return {
  -- Nvim-lspconfig: Core LSP client configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- LSP Management
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Additional lua configuration
      "folke/neodev.nvim",

      -- For schemas
      "b0o/SchemaStore.nvim",
    },
    config = function()
      -- Setup neovim lua configuration
      require("neodev").setup()

      -- Function to get capabilities with specified features
      local function make_capabilities(additional_capabilities)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport =
          true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        }
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        if additional_capabilities then
          capabilities =
            vim.tbl_deep_extend("force", capabilities, additional_capabilities)
        end
        return capabilities
      end

      -- Configure diagnostic display
      vim.diagnostic.config({
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
      })

      -- Define diagnostic signs
      for name, icon in pairs({
        Error = "✖ ",
        Warn = "⚠ ",
        Hint = "󰌶 ",
        Info = "ℹ ",
      }) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
      end

      -- Create a function for LSP on_attach
      local function on_attach(client, bufnr)
        -- Enable inlay hints if supported
        if client.supports_method("textDocument/inlayHint") then
          -- Using pcall to handle API differences across Neovim versions
          pcall(function()
            if vim.fn.has("nvim-0.10") == 1 then
              -- For Neovim 0.10+
              vim.lsp.inlay_hint.enable(true)
            else
              -- For older versions
              vim.lsp.inlay_hint.enable(bufnr, true)
            end
          end)
        end

        -- Enable document formatting if supported
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({ async = true })
          end, { desc = "Format using LSP" })
        end
      end

      -- LSP servers to configure
      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        },

        -- Web development
        vtsls = {
          settings = {
            complete_function_calls = true,
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
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
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
        volar = {
          init_options = {
            vue = { hybridMode = true },
          },
          filetypes = { "vue", "typescript", "javascript" },
        },
        eslint = {},

        -- Go
        gopls = {
          cmd = { "gopls" }, -- Explicitly set the command
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },

        -- PHP
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
              },
              files = {
                maxSize = 5000000,
              },
            },
          },
        },
        phpactor = {},

        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              procMacro = { enable = true },
              checkOnSave = true,
            },
          },
        },

        -- TailwindCSS
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

        -- Bash
        bashls = {},

        -- JSON with schema support
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- HTML
        html = {},

        -- CSS
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },
      }

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- Apply defaults
            server.capabilities = make_capabilities(server.capabilities)
            server.on_attach = on_attach
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -- LSP features keymaps
      vim.keymap.set("n", "<leader>th", function()
        -- Using pcall to handle API differences across Neovim versions
        pcall(function()
          if vim.fn.has("nvim-0.10") == 1 then
            -- For Neovim 0.10+
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          else
            -- For older versions
            vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
          end
        end)
      end, { desc = "Toggle inlay hints" })
    end,
  },

  -- Mason-lspconfig: Bridge mason.nvim with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      automatic_installation = true,
    },
  },
}
