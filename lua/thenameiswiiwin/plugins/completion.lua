return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua", -- For Neovim Lua API
      "hrsh7th/cmp-calc",  -- For calculations
      "hrsh7th/cmp-emoji", -- For emoji support

      -- Snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",

      -- Icons
      "onsails/lspkind.nvim",

      -- Copilot
      "zbirenbaum/copilot.lua",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Configure Copilot
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = false,
          hide_during_completion = false,
          debounce = 150,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = "<C-CR>",
            next = false,
            prev = false,
            dismiss = false,
          },
        },
        panel = {
          enabled = false,
        },
      })

      -- Configure Copilot CMP integration
      require("copilot_cmp").setup()

      -- Helper function for super tab functionality
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- Define the snippet expand function
      local function expand_snippet(fallback)
        if luasnip.expandable() then
          luasnip.expand()
        else
          fallback()
        end
      end

      -- Define the snippet jump functions
      local function jump_next(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local function jump_prev(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      -- Set up nvim-cmp
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
            else
              jump_next(fallback)
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              jump_prev(fallback)
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
          { name = "copilot",  group_index = 2 }, -- Copilot suggestions
          { name = "nvim_lsp", group_index = 2 }, -- LSP suggestions
          { name = "luasnip",  group_index = 2 }, -- Snippets
          { name = "path",     group_index = 3 }, -- File paths
          { name = "nvim_lua", group_index = 3 }, -- Neovim Lua API
          { name = "calc",     group_index = 3 }, -- Calculations
          { name = "emoji",    group_index = 3 }, -- Emoji
        }, {
          { name = "buffer" },               -- Buffer text
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
          }),
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            -- Put copilot at the beginning
            require("copilot_cmp.comparators").prioritize,

            -- Default comparators
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
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
    end,
  },
}
