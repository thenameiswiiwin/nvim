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
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal",
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal",
          },
        },
        mapping = {
          -- Accept currently selected item
          ["<C-y>"] = function()
            require("blink.cmp").confirm({ select = true })
          end,

          -- Super Tab functionality
          ["<Tab>"] = function(fallback)
            if blink_cmp.visible() then
              blink_cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              blink_cmp.complete()
            else
              fallback()
            end
          end,

          ["<S-Tab>"] = function(fallback)
            if blink_cmp.visible() then
              blink_cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,

          -- Scroll documentation
          ["<C-d>"] = blink_cmp.scroll_docs(4),
          ["<C-u>"] = blink_cmp.scroll_docs(-4),

          -- Toggle completion
          ["<C-Space>"] = blink_cmp.complete(),

          -- Abort completion
          ["<C-e>"] = blink_cmp.close(),

          -- Previous/next item
          ["<C-p>"] = blink_cmp.select_prev_item(),
          ["<C-n>"] = blink_cmp.select_next_item(),
        },
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
            symbol_map = {
              Copilot = "",
            },
            -- Use rose-pine colors for completion menu
            before = function(entry, vim_item)
              local colors = require("rose-pine.palette")
              vim_item.menu = vim_item.kind
              vim_item.kind_hl_group = "CmpItemKind" .. vim_item.kind

              -- Set up highlighting for completion items
              local hl_groups = {
                Text = colors.text,
                Method = colors.iris,
                Function = colors.iris,
                Constructor = colors.pine,
                Field = colors.foam,
                Variable = colors.text,
                Class = colors.gold,
                Interface = colors.gold,
                Module = colors.gold,
                Property = colors.foam,
                Unit = colors.gold,
                Value = colors.pine,
                Enum = colors.gold,
                Keyword = colors.rose,
                Snippet = colors.iris,
                Color = colors.rose,
                File = colors.text,
                Reference = colors.text,
                Folder = colors.text,
                EnumMember = colors.pine,
                Constant = colors.pine,
                Struct = colors.gold,
                Event = colors.rose,
                Operator = colors.rose,
                TypeParameter = colors.foam,
                Copilot = colors.gold,
              }

              for kind, color in pairs(hl_groups) do
                vim.api.nvim_set_hl(0, "CmpItemKind" .. kind, { fg = color })
              end

              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true, -- Enable ghost text
        },
      })

      -- Set up cmdline completion for / and ?
      blink_cmp.setup_cmdline({ "/", "?" }, {
        sources = {
          { name = "buffer" },
        },
      })

      -- Set up cmdline completion for :
      blink_cmp.setup_cmdline(":", {
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })

      -- Set up filetype-specific snippets
      luasnip.filetype_extend("typescript", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "javascript", "react" })
      luasnip.filetype_extend("javascriptreact", { "javascript", "react" })
      luasnip.filetype_extend("vue", { "javascript", "html", "css" })

      -- Enable luasnip for blink.cmp
      require("blink.compat").setup()
    end,
  },

  -- Friendly snippets
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
}
