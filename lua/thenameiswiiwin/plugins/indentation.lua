return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      -- Single subtle highlight
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#45475A" }) -- Subtle grey from catppuccin palette
      end)

      local ibl = require("ibl")

      ibl.setup({
        indent = {
          char = "▏", -- Thinner indentation character
          highlight = { "IblIndent" },
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          highlight = { "IblIndent" },
        },
        exclude = {
          filetypes = {
            "help",
            "dashboard",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "oil",
          },
          buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
          },
        },
      })
    end,
  },

  -- Add mini.indentscope for a more visual indication of the current scope
  {
    "echasnovski/mini.indentscope",
    version = false,
    config = function()
      require("mini.indentscope").setup({
        symbol = "▏", -- Use the same symbol as indent-blankline
        options = {
          try_as_border = true,
          border = "both",
          indent_at_cursor = true,
        },
        draw = {
          animation = function(_, _, _)
            return 0
          end, -- Disable animation for performance
        },
      })

      -- Don't enable in certain file types
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "dashboard",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "oil",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
