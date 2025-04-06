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
    "Saghen/blink.cmp", -- Corrected URL
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("blink.cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

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

      cmp.setup({
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
        mapping = cmp.mapping.preset.insert({
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- Super Tab functionality
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Scroll documentation
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),

          -- Toggle completion
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Abort completion
          ["<C-e>"] = cmp.mapping.abort(),

          -- Previous/next item
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
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
              vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = colors.text })
              vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = colors.iris })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindFunction",
                { fg = colors.iris }
              )
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindConstructor",
                { fg = colors.pine }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = colors.foam })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindVariable",
                { fg = colors.text }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = colors.gold })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindInterface",
                { fg = colors.gold }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = colors.gold })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindProperty",
                { fg = colors.foam }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = colors.gold })
              vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = colors.pine })
              vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = colors.gold })
              vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = colors.rose })
              vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = colors.iris })
              vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = colors.rose })
              vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = colors.text })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindReference",
                { fg = colors.text }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = colors.text })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindEnumMember",
                { fg = colors.pine }
              )
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindConstant",
                { fg = colors.pine }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = colors.gold })
              vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = colors.rose })
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindOperator",
                { fg = colors.rose }
              )
              vim.api.nvim_set_hl(
                0,
                "CmpItemKindTypeParameter",
                { fg = colors.foam }
              )
              vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = colors.gold })
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true, -- Enable ghost text
        },
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
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
