return {
  -- Nvim-lint: Linting engine
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        vue = { "eslint_d" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        php = { "phpcs" },
        rust = { "clippy" },
      }

      -- Configure linter options for better performance
      lint.linters.eslint_d.args = {
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      -- Enable Rust clippy
      lint.linters.clippy = {
        cmd = "cargo",
        args = { "clippy", "--message-format=json" },
        stdin = false,
        append_fname = false,
        stream = "both",
      }

      -- Set up throttled autocommand for linting
      local lint_augroup =
        vim.api.nvim_create_augroup("nvim-lint", { clear = true })

      -- Throttled lint function
      local lint_timer = nil
      local function lint_throttled()
        if lint_timer then
          vim.loop.timer_stop(lint_timer)
        end

        lint_timer = vim.defer_fn(function()
          lint.try_lint()
          lint_timer = nil
        end, 300) -- 300ms throttle
      end

      vim.api.nvim_create_autocmd(
        { "BufWritePost", "BufReadPost", "InsertLeave" },
        {
          group = lint_augroup,
          callback = function()
            lint_throttled()
          end,
        }
      )

      -- Add keymap to manually trigger linting
      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}
