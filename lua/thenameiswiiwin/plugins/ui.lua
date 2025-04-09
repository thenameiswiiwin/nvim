return {
  -- Lualine: Status line (minimal configuration)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local colors = require("rose-pine.palette")

      local mode_color = {
        n = colors.pine,
        i = colors.foam,
        v = colors.iris,
        V = colors.iris,
        ["\22"] = colors.iris,
        c = colors.gold,
        s = colors.rose,
        S = colors.rose,
        ["\19"] = colors.rose,
        R = colors.rose,
        r = colors.rose,
        ["!"] = colors.love,
        t = colors.love,
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      local config = {
        options = {
          -- Disable sections and component separators
          component_separators = "",
          section_separators = "",
          theme = {
            -- We are going to use a custom theme
            normal = { c = { fg = colors.text, bg = colors.base } },
            inactive = { c = { fg = colors.muted, bg = colors.base } },
          },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter", "oil" },
            winbar = { "dashboard", "alpha", "starter", "oil" },
          },
          global_status = true,
          refresh = {
            statusline = 1000, -- Update less frequently for performance
          },
        },
        sections = {
          -- These are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- These are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left({
        function()
          return "▊"
        end,
        color = function()
          -- auto change color according to neovims mode
          return { fg = mode_color[vim.fn.mode()], bg = colors.base }
        end,
        padding = { right = 1 },
      })

      ins_left({
        -- mode component
        function()
          return ""
        end,
        color = function()
          -- auto change color according to neovims mode
          return { fg = mode_color[vim.fn.mode()], bg = colors.base }
        end,
        padding = { right = 1 },
      })

      ins_left({
        "filename",
        color = { fg = colors.foam, gui = "bold" },
      })

      ins_left({ "location", color = { fg = colors.rose } })

      ins_left({
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          color_error = { fg = colors.love },
          color_warn = { fg = colors.gold },
          color_info = { fg = colors.foam },
        },
        update_in_insert = false, -- Update diagnostics less frequently for performance
      })

      -- Add simplified component for Copilot status
      ins_left({
        function()
          return vim.g.copilot_active == 1 and "" or ""
        end,
        cond = function()
          return vim.g.copilot_active ~= nil
        end,
        color = { fg = colors.gold },
      })

      -- Add simplified component for LSP status
      ins_right({
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return ""
          end
          return "LSP"
        end,
        color = { fg = colors.foam, gui = "bold" },
      })

      ins_right({
        "branch",
        icon = "",
        color = { fg = colors.pine, gui = "bold" },
      })

      ins_right({
        "diff",
        symbols = { added = "+ ", modified = "~ ", removed = "- " },
        diff_color = {
          added = { fg = colors.foam },
          modified = { fg = colors.rose },
          removed = { fg = colors.love },
        },
        cond = conditions.hide_in_width,
      })

      ins_right({
        function()
          return "▊"
        end,
        color = function()
          -- auto change color according to neovims mode
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { left = 1 },
      })

      return config
    end,
    config = function(_, opts)
      require("lualine").setup(opts)

      -- Set up copilot status tracking
      vim.g.copilot_active = 0

      -- Add autocommands to update Copilot status
      local group =
        vim.api.nvim_create_augroup("CopilotStatus", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "CopilotActive",
        group = group,
        callback = function()
          vim.g.copilot_active = 1
          require("lualine").refresh()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "CopilotInactive",
        group = group,
        callback = function()
          vim.g.copilot_active = 0
          require("lualine").refresh()
        end,
      })
    end,
  },

  -- Mini.icons: Icons for various UI elements
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup({
        file = {
          -- Git files
          [".gitignore"] = { glyph = "", hl = "MiniIconsRed" },
          [".gitattributes"] = { glyph = "", hl = "MiniIconsRed" },

          -- Config files
          [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
          [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
          [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
          ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
          ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
          ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
          ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
          [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
          ["Cargo.toml"] = { glyph = "", hl = "MiniIconsRed" },
          ["Cargo.lock"] = { glyph = "", hl = "MiniIconsRed" },
        },
        filetype = {
          -- Languages
          ["javascript"] = { glyph = "", hl = "MiniIconsYellow" },
          ["typescript"] = { glyph = "", hl = "MiniIconsBlue" },
          ["typescriptreact"] = { glyph = "", hl = "MiniIconsBlue" },
          ["javascriptreact"] = { glyph = "", hl = "MiniIconsYellow" },
          ["go"] = { glyph = "", hl = "MiniIconsBlue" },
          ["rust"] = { glyph = "", hl = "MiniIconsRed" },
          ["php"] = { glyph = "", hl = "MiniIconsPurple" },
          ["gotmpl"] = { glyph = "󰟓", hl = "MiniIconsGrey" },
          ["vue"] = { glyph = "󰡄", hl = "MiniIconsGreen" },
          ["svelte"] = { glyph = "", hl = "MiniIconsRed" },
        },
      })
    end,
  },
}
