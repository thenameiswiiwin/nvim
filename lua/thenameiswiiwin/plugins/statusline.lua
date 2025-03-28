return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      local lualine = require("lualine")
      local progress = require("lsp-progress").progress

      -- Only show filename in statusline mode, with git info and diagnostics
      local minimal_sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            icon = "",
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            diff_color = {
              added = { fg = "#a6e3a1" }, -- Green
              modified = { fg = "#f9e2af" }, -- Yellow
              removed = { fg = "#f38ba8" }, -- Red
            },
          },
        },
        lualine_c = {
          "%=", -- forces everything after this to center
          {
            "filename",
            path = 1, -- Relative path
            symbols = {
              modified = "●",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
            "%=",  -- forces everything after this to center
          },
          { progress }, -- Add LSP progress
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      }

      -- Simplify inactive sections even more
      local inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      }

      -- Configure Lualine with Catppuccin
      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "NvimTree", "neo-tree", "dashboard", "Outline", "oil" },
            winbar = { "oil" },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = minimal_sections,
        inactive_sections = inactive_sections,
        tabline = {},
        winbar = {},
        extensions = { "oil", "fugitive", "lazy", "mason", "quickfix" },
      })

      -- Refresh lualine when LSP progress updates
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end,
  },
}
