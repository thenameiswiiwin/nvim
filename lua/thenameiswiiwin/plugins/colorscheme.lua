local function ColorMyPencils()
  vim.cmd.colorscheme("catppuccin-mocha")

  -- Optional: Make background transparent
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  -- Catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- mocha, macchiato, frappe, latte
        transparent_background = false,
        term_colors = true,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          functions = { "bold" },
          keywords = { "bold" },
          strings = {},
          variables = {},
          numbers = { "bold" },
          types = { "italic" },
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = {
            enabled = true,
            style = "nvchad",
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          dap = {
            enabled = true,
            enable_ui = true,
          },
          mason = true,
          neotest = true,
        },
        highlight_overrides = {
          mocha = function(mocha)
            return {
              -- Enhanced editor UI highlights
              CursorLineNr = { fg = mocha.peach, bold = true },
              LineNr = { fg = mocha.overlay2 },
              CursorLine = { bg = mocha.surface0 },

              -- Telescope customization
              TelescopeBorder = { fg = mocha.blue },
              TelescopeSelectionCaret = { fg = mocha.peach },
              TelescopeMatching = { fg = mocha.peach },

              -- Indent-blankline
              IndentBlanklineChar = { fg = mocha.surface0 },
              IndentBlanklineContextChar = { fg = mocha.overlay0 },
            }
          end,
        },
      })

      -- Apply the colorscheme
      ColorMyPencils()
    end,
  },
}
