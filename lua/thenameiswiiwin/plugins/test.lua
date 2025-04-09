return {
  -- Neotest: Test runner framework
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/nvim-nio",
      -- Lazy load test adapters based on filetype
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

      -- Load adapters only when needed based on filetype
      local adapters = {}

      -- Only load JavaScript adapters when needed
      if vim.fn.glob("**/package.json") ~= "" then
        if vim.fn.glob("**/vitest.config.*") ~= "" then
          table.insert(adapters, require("neotest-vitest"))
        end

        if vim.fn.glob("**/jest.config.*") ~= "" then
          table.insert(
            adapters,
            require("neotest-jest")({
              jestCommand = "npm test --",
              env = { CI = true },
              cwd = function()
                return vim.fn.getcwd()
              end,
            })
          )
        end
      end

      -- Only load Go adapter when needed
      if vim.fn.executable("go") == 1 then
        table.insert(
          adapters,
          require("neotest-golang")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
          })
        )
      end

      -- Only load Rust adapter when needed
      if vim.fn.glob("**/Cargo.toml") ~= "" then
        table.insert(
          adapters,
          require("neotest-rust")({
            args = { "--no-capture" },
            dap_adapter = "lldb",
          })
        )
      end

      -- Only load PHP adapter when needed
      if
        vim.fn.glob("**/phpunit.xml") ~= ""
        or vim.fn.glob("**/composer.json") ~= ""
      then
        table.insert(
          adapters,
          require("neotest-phpunit")({
            phpunit_cmd = function()
              return "./vendor/bin/phpunit"
            end,
          })
        )
      end

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
        adapters = adapters,
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
          open_on_run = false, -- Don't auto-open output window
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
        -- Performance optimizations
        running = {
          concurrent = true, -- Enable concurrent test runs
        },
        consumers = {},
      })
    end,
  },
}
