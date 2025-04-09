return {
  -- Nvim-lspconfig: Core LSP client configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- LSP Management
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- For schemas
      "b0o/SchemaStore.nvim",
    },
    config = function()
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

        -- Add capabilities from nvim-cmp
        local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = vim.tbl_deep_extend(
            "force",
            capabilities,
            cmp_lsp.default_capabilities()
          )
        end

        return capabilities
      end

      -- Configure diagnostic display using vim.diagnostic.config()
      vim.diagnostic.config({
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = "●",
          severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
        },
        update_in_insert = false, -- Don't update diagnostics in insert mode
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✖ ",
            [vim.diagnostic.severity.WARN] = "⚠ ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = "ℹ ",
          },
        },
      })

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

        -- Disable formatting for certain LSP servers
        if client.name == "tsserver" or client.name == "vtsls" then
          client.server_capabilities.documentFormattingProvider = false
        end

        -- Add keymap to toggle inlay hints
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
        end, { buffer = bufnr, desc = "Toggle inlay hints" })
        -- Limit workspace size for large projects
        if client.name == "gopls" or client.name == "vtsls" then
          client.config.settings = client.config.settings or {}
          client.config.settings.workspace = client.config.settings.workspace
            or {}
          client.config.settings.workspace.maxFileSize = 1024 * 1024 -- 1MB
          client.config.settings.workspace.maxFiles = 5000 -- Max 5000 files
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
              -- Performance optimizations
              performance = {
                enable = true,
                maxPreload = 1000,
                preloadFileSize = 1000,
              },
              hint = {
                enable = true,
                setType = true,
                paramType = true,
              },
            },
          },
        },

        -- Web development
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                -- Limit inlay hints for better performance
                enumMemberValues = { enabled = false },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
          },
          -- Performance optimizations
          flags = {
            debounce_text_changes = 150,
          },
        },
        volar = {
          init_options = {
            vue = { hybridMode = true },
          },
          filetypes = { "vue" },
        },
        eslint = {
          settings = {
            -- Run on save instead of change
            run = "onSave",
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              -- Disable unused codelenses for better performance
              codelenses = {
                gc_details = false,
                test = true,
                tidy = false,
                upgrade_dependency = false,
                vendor = false,
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
              staticcheck = true,
            },
          },
          -- Performance optimizations
          flags = {
            debounce_text_changes = 150,
          },
        },

        -- PHP
        intelephense = {
          settings = {
            intelephense = {
              -- Limit stubs to essentials for better performance
              stubs = {
                "Core",
                "date",
                "pcre",
                "standard",
                "superglobals",
                "SPL",
                "mysqli",
                "pdo",
                "pdo_mysql",
              },
              files = {
                maxSize = 1000000, -- Limit max file size
              },
              environment = {
                includePaths = { "vendor" },
              },
              -- Performance optimizations
              diagnostics = {
                run = "onSave", -- Only run on save
              },
            },
          },
        },

        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" }, -- Skip analyzing dependencies
              },
              procMacro = { enable = true },
            },
          },
        },

        -- Tailwind CSS
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
    end,
  },

  -- Mason-lspconfig: Bridge mason.nvim with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },

  -- Enhanced Lua development support
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load plugins you're actively developing
        vim.fn.stdpath("data") .. "/lazy",
      },
      -- Integrations
      integrations = {
        lspconfig = true,
        cmp = true,
      },
    },
  },
}
