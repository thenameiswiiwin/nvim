return {
  -- Mini.pairs: Auto-pairs for brackets, quotes, etc.
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup({
        -- Disable for specific filetypes
        mappings = {
          ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
          ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
          ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
          [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
          ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
          ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
          ['"'] = {
            action = "closeopen",
            pair = '""',
            neigh_pattern = "[^\\].",
            register = { cr = false },
          },
          ["'"] = {
            action = "closeopen",
            pair = "''",
            neigh_pattern = "[^%a\\].",
            register = { cr = false },
          },
          ["`"] = {
            action = "closeopen",
            pair = "``",
            neigh_pattern = "[^\\].",
            register = { cr = false },
          },
        },
      })
    end,
  },

  -- Comment.nvim: Smart commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        -- Add support for JSX/TSX comments
        pre_hook = function(ctx)
          local U = require("Comment.utils")

          local location = nil
          if ctx.ctype == U.ctype.block then
            location =
              require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location =
              require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
          })
        end,
      })
    end,
  },

  -- JoosepAlviste/nvim-ts-context-commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- Mini.ai: Enhanced text objects
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

  -- Lazydev: Enhanced Lua development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- For plugins you're actively developing
        vim.fn.stdpath("data") .. "/lazy",
      },
    },
  },

  -- Mini.surround: Operations on surroundings
  {
    "echasnovski/mini.surround",
    keys = {
      { "sa", desc = "Add surrounding" },
      { "sd", desc = "Delete surrounding" },
      { "sf", desc = "Find surrounding" },
      { "sr", desc = "Replace surrounding" },
      { "sF", desc = "Find surrounding to the left" },
    },
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa", -- Add surrounding
          delete = "sd", -- Delete surrounding
          find = "sf", -- Find surrounding (to the right)
          find_left = "sF", -- Find surrounding (to the left)
          highlight = "sh", -- Highlight surrounding
          replace = "sr", -- Replace surrounding
          update_n_lines = "sn", -- Update `n_lines`
        },
      })
    end,
  },

  -- Blink.cmp: Completion engine
  {
    "Saghen/blink.cmp",
    version = "1.*", -- Use a release tag to download pre-built binaries
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local blink_cmp = require("blink.cmp")

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Helper function for super tab
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end

      blink_cmp.setup({
        keymap = {
          preset = "default",
        },

        sources = {
          default = { "lsp", "copilot", "snippets", "path", "buffer" },
        },

        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
          },
        },

        appearance = {
          nerd_font_variant = "mono",
        },

        fuzzy = {
          implementation = "lua", -- Use Lua implementation as fallback
        },

        snippets = {
          preset = "luasnip",
        },
      })

      -- Set up filetype-specific snippets
      luasnip.filetype_extend("typescript", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "javascript", "react" })
      luasnip.filetype_extend("javascriptreact", { "javascript", "react" })
      luasnip.filetype_extend("vue", { "javascript", "html", "css" })

      -- Enable luasnip for blink.cmp
      require("blink.compat").setup()

      -- Configure cmdline manually inside a protected call
      pcall(function()
        vim.api.nvim_create_autocmd("CmdlineEnter", {
          group = vim.api.nvim_create_augroup(
            "blink_cmp_cmdline",
            { clear = true }
          ),
          callback = function()
            -- Setup command line completions manually when needed
            local cmdtype = vim.fn.getcmdtype()
            if cmdtype == "/" or cmdtype == "?" then
              -- Search completions
              blink_cmp.start(function()
                return { providers = { "buffer" } }
              end)
            elseif cmdtype == ":" then
              -- Command completions
              blink_cmp.start(function()
                return { providers = { "cmdline", "path" } }
              end)
            end
          end,
        })
      end)
    end,
  },

  -- Friendly snippets
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
}
