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

  -- nvim-cmp: Completion engine
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
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
        performance = {
          debounce = 60, -- Debounce completions for better performance
          throttle = 30, -- Throttle completion menu rendering
          fetching_timeout = 200, -- Timeout for completion fetching
          async_budget = 1, -- Budget for async operations
          max_view_entries = 100, -- Limit number of entries for performance
          filtering_context_budget = 20, -- Control filtering context budget
          confirm_resolve_timeout = 100, -- Timeout for confirming resolve
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
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
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 1, priority = 100 },
          { name = "nvim_lsp", group_index = 1, priority = 90 },
          { name = "luasnip", group_index = 1, priority = 80 },
          { name = "path", group_index = 2, priority = 50 },
          {
            name = "buffer",
            group_index = 2,
            priority = 40,
            max_item_count = 5,
          },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Copilot = "" },
            before = function(entry, vim_item)
              -- Limit completion width
              local label = vim_item.abbr
              local truncated_label = vim.fn.strcharpart(label, 0, 50)
              if truncated_label ~= label then
                vim_item.abbr = truncated_label .. "..."
              end
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = false, -- Disable ghost text for better performance
        },
      })

      -- Set up filetype-specific snippets
      luasnip.filetype_extend("typescript", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "javascript", "react" })
      luasnip.filetype_extend("javascriptreact", { "javascript", "react" })
      luasnip.filetype_extend("vue", { "javascript", "html", "css" })

      -- Set up cmdline completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- cmp-nvim-lsp
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },

  -- cmp-buffer
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },

  -- cmp-path
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },

  -- cmp-cmdline
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },

  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip").setup({
        history = true,
        delete_check_events = "TextChanged",
        region_check_events = "CursorMoved",
      })
    end,
  },

  -- cmp-luasnip
  {
    "saadparwaiz1/cmp_luasnip",
    lazy = true,
  },

  -- Friendly snippets
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
}
