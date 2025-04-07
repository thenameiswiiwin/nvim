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

  -- Blink.cmp: Completion engine
  {
    "Saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "giuxtaposition/blink-cmp-copilot",
      -- Add blink.compat for nvim-cmp source compatibility
      {
        "Saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
      },
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
          providers = {
            copilot = {
              name = "Copilot",
              module = "blink-cmp-copilot",
              score_offset = 100, -- Give Copilot suggestions high priority
              async = true,
            },
          },
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

      -- Configure cmdline manually inside a protected call
      pcall(function()
        vim.api.nvim_create_autocmd("CmdlineEnter", {
          group = vim.api.nvim_create_augroup(
            "blink_cmp_cmdline",
            { clear = true }
          ),
          callback = function()
            local cmdtype = vim.fn.getcmdtype()
            if cmdtype == "/" or cmdtype == "?" then
              blink_cmp.setup({
                sources = function()
                  return { "buffer" }
                end,
              })
            elseif cmdtype == ":" then
              blink_cmp.setup({
                sources = function()
                  return { "cmdline", "path" }
                end,
              })
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
