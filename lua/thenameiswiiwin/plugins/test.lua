return {
  -- Neotest: Test runner framework
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      -- Test adapters
      "fredrikaverpil/neotest-golang",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
      "rouge8/neotest-rust",
      "olimorris/neotest-phpunit",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "Run test suite",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show test output",
      },
      {
        "<leader>tp",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        "<leader>tm",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle summary window",
      },
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Jump to previous failed test",
      },
      {
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Jump to next failed test",
      },
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        discovery = {
          enabled = true,
        },
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },
        quickfix = {
          enabled = true,
          open = function()
            vim.cmd("copen")
          end,
        },
        adapters = {
          -- JavaScript testing
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),

          -- Vitest for Vue projects
          require("neotest-vitest"),

          -- Playwright for e2e testing
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),

          -- Go testing
          require("neotest-golang")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
          }),

          -- Rust testing
          require("neotest-rust")({
            args = { "--no-capture" },
            dap_adapter = "lldb",
          }),

          -- PHP Testing
          require("neotest-phpunit")({
            phpunit_cmd = function()
              return "./vendor/bin/phpunit"
            end,
          }),
        },
        icons = {
          failed = "✖",
          passed = "✓",
          running = "🔄",
          skipped = "⏭️",
          unknown = "?",
        },
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
        },
        summary = {
          enabled = true,
          follow = true,
          expand_errors = true,
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        strategies = {
          integrated = {
            width = 120,
            height = 40,
          },
        },
      })
    end,
  },
}
