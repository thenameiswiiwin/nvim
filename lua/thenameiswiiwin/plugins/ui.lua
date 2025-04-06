return {
  -- Lualine: Status line
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
            statusline = { "dashboard", "alpha", "starter" },
            winbar = { "dashboard", "alpha", "starter" },
          },
          global_status = true,
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
        -- filesize component
        "filesize",
        cond = conditions.buffer_not_empty,
      })

      ins_left({
        "filename",
        color = { fg = colors.foam, gui = "bold" },
      })

      ins_left({ "location", color = { fg = colors.rose } })

      ins_left({ "progress" })

      ins_left({
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          color_error = { fg = colors.love },
          color_warn = { fg = colors.gold },
          color_info = { fg = colors.foam },
        },
      })

      -- Insert mid section - for Copilot status
      ins_left({
        function()
          local status = vim.api.nvim_get_var("copilot_active") == 1 and ""
            or ""
          return status
        end,
        cond = function()
          return vim.g.copilot_active ~= nil
        end,
        color = { fg = colors.gold },
      })

      -- Add component for LSP status
      -- Update this function in the lualine opts (around line 156)
      ins_right({
        function()
          local msg = "No LSP"
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_clients() -- Changed from get_active_clients
          if next(clients) == nil then
            return msg
          end
          -- Only show client name for the filetype
          msg = ""
          local client_names = {}
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              client_names[client.name] = true
            end
          end
          for name, _ in pairs(client_names) do
            if msg == "" then
              msg = name
            else
              msg = msg .. ", " .. name
            end
          end
          return msg
        end,
        color = { fg = colors.foam, gui = "bold" },
      })

      ins_right({
        "o:encoding", -- option component same as &encoding in viml
        fmt = string.upper,
        cond = conditions.hide_in_width,
        color = { fg = colors.iris },
      })

      ins_right({
        "fileformat",
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.iris },
      })

      ins_right({
        "branch",
        icon = "",
        color = { fg = colors.pine, gui = "bold" },
      })

      ins_right({
        "diff",
        -- Is it me or the symbol for modified is really weird
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

  -- Nui.nvim: UI component library
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- Noice.nvim: Better UI for messages, cmdline, popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline",
        format = {
          cmdline = { icon = ">" },
          search_down = { icon = "🔍⌄" },
          search_up = { icon = "🔍⌃" },
          filter = { icon = "$" },
          lua = { icon = "☾" },
          help = { icon = "?" },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil,
          opts = {},
        },
        message = {
          enabled = true,
          view = "notify",
          opts = {},
        },
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      smart_move = {
        enabled = true,
        excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
  },

  -- Snacks.nvim: Collection of mini utilities
  {
    "folke/snacks.nvim",
    lazy = false, -- Ensure it's not lazy loaded
    priority = 1000, -- Give it high priority
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Initialize the Snacks global
      _G.Snacks = require("snacks")

      -- Helper function for terminal navigation
      local function term_nav(direction)
        return function()
          if vim.fn.winnr("$") > 1 then
            return string.format("<cmd>wincmd %s<cr>", direction)
          else
            return ""
          end
        end
      end

      -- Setup snacks with all the requested features
      Snacks.setup({
        -- Enable indent guides (replace indent-blankline)
        indent = { enabled = true },

        -- Input dialogs (replace dressing.nvim)
        input = { enabled = true },

        -- Enable notification system
        notifier = { enabled = true },

        -- Current scope visualization
        scope = { enabled = true },

        -- Smooth scrolling
        scroll = { enabled = true },

        -- Configurable toggle options
        toggle = {
          map = function(mode, lhs, rhs, opts)
            opts = opts or {}
            vim.keymap.set(mode, lhs, rhs, opts)
          end,
        },

        -- Word highlighting
        words = { enabled = true },

        -- Large file handling
        bigfile = { enabled = true },

        -- Quick file access
        quickfile = { enabled = true },

        -- Terminal improvements
        terminal = {
          win = {
            keys = {
              nav_h = {
                "<C-h>",
                term_nav("h"),
                desc = "Go to Left Window",
                expr = true,
                mode = "t",
              },
              nav_j = {
                "<C-j>",
                term_nav("j"),
                desc = "Go to Lower Window",
                expr = true,
                mode = "t",
              },
              nav_k = {
                "<C-k>",
                term_nav("k"),
                desc = "Go to Upper Window",
                expr = true,
                mode = "t",
              },
              nav_l = {
                "<C-l>",
                term_nav("l"),
                desc = "Go to Right Window",
                expr = true,
                mode = "t",
              },
            },
          },
        },
      })

      -- Set up keymaps for snacks features
      vim.keymap.set("n", "<leader>.", function()
        Snacks.scratch()
      end, { desc = "Toggle Scratch Buffer" })
      vim.keymap.set("n", "<leader>S", function()
        Snacks.scratch.select()
      end, { desc = "Select Scratch Buffer" })
      vim.keymap.set("n", "<leader>dps", function()
        Snacks.profiler.scratch()
      end, { desc = "Profiler Scratch Buffer" })
      vim.keymap.set("n", "<leader>n", function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end, { desc = "Notification History" })
      vim.keymap.set("n", "<leader>un", function()
        Snacks.notifier.hide()
      end, { desc = "Dismiss All Notifications" })
    end,
  },
}
