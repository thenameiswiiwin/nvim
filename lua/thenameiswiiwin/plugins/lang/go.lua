return {
  -- Treesitter parsers for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(
          opts.ensure_installed,
          { "go", "gomod", "gowork", "gosum" }
        )
      end
    end,
  },

  -- Go specific debug adapter
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    ft = "go",
    config = function()
      require("dap-go").setup({
        -- Default configurations
        dap_configurations = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
          },
          {
            type = "go",
            name = "Debug Package",
            request = "launch",
            program = "${fileDirname}",
          },
          {
            type = "go",
            name = "Debug Test",
            request = "launch",
            mode = "test",
            program = "${file}",
          },
          {
            type = "go",
            name = "Debug Test Package",
            request = "launch",
            mode = "test",
            program = "${fileDirname}",
          },
        },
        -- Let delve infer the mode
        delve = {
          initialize_timeout_sec = 20,
          port = "${port}",
        },
      })

      -- Add keymaps for Go debugging
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          vim.keymap.set("n", "<leader>dt", function()
            require("dap-go").debug_test()
          end, { buffer = buffer, desc = "Debug Go Test" })
          vim.keymap.set("n", "<leader>dT", function()
            require("dap-go").debug_last_test()
          end, { buffer = buffer, desc = "Debug Last Go Test" })
        end,
      })
    end,
  },

  -- LSP configuration for Go
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
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
      },
    },
  },

  -- Ensure Mason installs Go tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(
        opts.ensure_installed,
        { "goimports", "gofumpt", "gomodifytags", "impl", "delve" }
      )
    end,
  },

  -- Testing support for Go
  {
    "fredrikaverpil/neotest-golang",
    event = { "BufRead *.go" },
    dependencies = { "nvim-neotest/neotest" },
  },
}
