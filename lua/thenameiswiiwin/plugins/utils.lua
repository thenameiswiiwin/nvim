return {
  -- Essential Lua functions
  { "nvim-lua/plenary.nvim" },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Better coding experience
  {
    "numToStr/Comment.nvim",
    opts = {
      -- Add support for JSX/TSX comments
      pre_hook = function(ctx)
        local U = require("Comment.utils")

        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
          location = location,
        })
      end,
    },
  },

  -- Better text objects and surround operations
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          -- Add text objects for function calls
          o = require("mini.ai").gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = require("mini.ai").gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }),
          c = require("mini.ai").gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }),
        },
      })
    end,
  },

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa",       -- Add surrounding
          delete = "sd",    -- Delete surrounding
          find = "sf",      -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr",   -- Replace surrounding
          update_n_lines = "sn", -- Update `n_lines`
        },
      })
    end,
  },

  -- Enhanced % matching
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- Auto pairs for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- Make it work with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      if cmp.event then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Context aware commenting for TSX/JSX
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- Highlight current context with treesitter
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        min_window_height = 15,
        line_numbers = true,
        multiline_threshold = 5,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
      })
    end,
  },

  -- Show hex colors and color names
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {},
  },

  -- Better quick-fix list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      position = "bottom",         -- position of the list can be: bottom, top, left, right
      icons = true,                -- use devicons for filenames
      mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      severity = nil,              -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
      fold_open = "",              -- icon used for open folds
      fold_closed = "",            -- icon used for closed folds
      group = true,                -- group results by file
      padding = true,              -- add an extra new line on top of the list
      cycle_results = true,        -- cycle item list when reaching beginning or end of list
      action_keys = {              -- key mappings for actions in the trouble list
        close = "q",               -- close the list
        cancel = "<esc>",          -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",             -- manually refresh
        jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" },  -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" },    -- open buffer in new tab
        jump_close = { "o" },      -- jump to the diagnostic and close the list
        toggle_mode = "m",         -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P",      -- toggle auto_preview
        hover = "K",               -- opens a small poup with the full multiline message
        preview = "p",             -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k",            -- previous item
        next = "j",                -- next item
        help = "?",                -- help menu
      },
      multiline = true,            -- render multi-line messages
      auto_open = false,           -- automatically open the list when you have diagnostics
      auto_close = false,          -- automatically close the list when you have no diagnostics
      auto_preview = true,         -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false,           -- automatically fold a file trouble list at creation
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
      },
      win_config = { border = "rounded" },
    },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
    },
  },

  -- Better undos
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
  },
}
