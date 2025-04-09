return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false, -- Load during startup
    priority = 1000, -- Load before other plugins
    config = function()
      require("rose-pine").setup({
        variant = "main", -- Default is dark mode
        dark_variant = "main",
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,

        -- Improve performance by limiting highlight groups
        highlight_groups = {
          -- Enhance current line number
          CursorLineNr = { fg = "gold" },
          -- Subtle sign column
          SignColumn = { bg = "none" },
          -- Optimize inactive windows
          ColorColumn = { bg = "surface" },
          -- Optimize Git signs for better performance
          GitSignsAdd = { fg = "foam" },
          GitSignsChange = { fg = "rose" },
          GitSignsDelete = { fg = "love" },
          -- Optimize LSP UI
          DiagnosticError = { fg = "love" },
          DiagnosticWarn = { fg = "gold" },
          DiagnosticInfo = { fg = "foam" },
          DiagnosticHint = { fg = "iris" },
        },
      })

      -- Set colorscheme
      vim.cmd.colorscheme("rose-pine")

      -- Add command to toggle between dark and light modes
      vim.api.nvim_create_user_command("ToggleTheme", function()
        local current_bg = vim.o.background
        if current_bg == "dark" then
          vim.o.background = "light"
          vim.cmd("colorscheme rose-pine-dawn")
        else
          vim.o.background = "dark"
          vim.cmd("colorscheme rose-pine")
        end
      end, {})

      -- Create keymap for toggling themes
      vim.keymap.set(
        "n",
        "<leader>ut",
        "<cmd>ToggleTheme<CR>",
        { desc = "Toggle dark/light theme" }
      )
    end,
  },
}
