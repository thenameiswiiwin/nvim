return {
  -- Nvim-lint: Linting engine
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

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
      }

      -- Configure linter options
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

      -- Add rust linting
      lint.linters_by_ft.rust = { "clippy" }

      -- Set up autocommand for linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      -- Add keymap to manually trigger linting
      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}
