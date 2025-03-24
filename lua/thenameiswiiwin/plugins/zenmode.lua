return {
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.95,
          width = 90,
          height = 1,
          options = {
            signcolumn = "no",
            number = true,
            relativenumber = true,
            cursorline = true,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
          },
        },
        plugins = {
          -- Disable tmux status when in zen mode
          tmux = { enabled = true },

          -- Dim inactive windows
          twilight = { enabled = false },

          -- Keep gitsigns active
          gitsigns = { enabled = true },

          -- Keep diagnostics active
          diagnostics = {
            enabled = true,
            underline = true,
            virtual_text = false,
          },
        },
        on_open = function()
          -- Disable diagnostics virtual text
          vim.diagnostic.config({
            virtual_text = false,
          })
        end,
        on_close = function()
          -- Restore diagnostics virtual text
          vim.diagnostic.config({
            virtual_text = {
              prefix = "●",
            },
          })
        end,
      })

      -- Standard zen mode (minimal distractions, still showing line numbers)
      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").toggle({
          window = {
            width = 90,
            options = {
              number = true,
              relativenumber = true,
            },
          },
        })
      end, { desc = "Zen Mode (with line numbers)" })

      -- Full zen mode (no line numbers or other UI elements)
      vim.keymap.set("n", "<leader>zZ", function()
        require("zen-mode").toggle({
          window = {
            width = 80,
            options = {
              number = false,
              relativenumber = false,
              signcolumn = "no",
              cursorline = false,
            },
          },
        })
      end, { desc = "Zen Mode (full focus)" })
    end,
  },
}
