return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Additional text objects for treesitter
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- Enhanced code navigation and refactoring
      "nvim-treesitter/nvim-treesitter-refactor",
      -- Playground for debugging treesitter queries
      "nvim-treesitter/playground",
      -- Improved folding based on treesitter
      {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
      },
      -- Rainbow delimiters for better bracket matching
      "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
      -- Configure treesitter
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "c",
          "css",
          "dockerfile",
          "go",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "regex",
          "rust",
          "scss",
          "svelte",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing
        ignore_install = {},

        highlight = {
          -- Enable syntax highlighting
          enable = true,

          -- Disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },

        -- Incremental selection based on the named nodes from the grammar
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<nop>",
            node_decremental = "<bs>",
          },
        },

        -- Enable "textobjects" module
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["as"] = "@statement.outer",
              ["is"] = "@statement.inner",
              ["am"] = "@call.outer",
              ["im"] = "@call.inner",
              ["ad"] = "@comment.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]b"] = "@block.outer",
              ["]a"] = "@parameter.outer",
              ["]m"] = "@call.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]B"] = "@block.outer",
              ["]A"] = "@parameter.outer",
              ["]M"] = "@call.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[b"] = "@block.outer",
              ["[a"] = "@parameter.outer",
              ["[m"] = "@call.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[B"] = "@block.outer",
              ["[A"] = "@parameter.outer",
              ["[M"] = "@call.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>ws"] = "@parameter.inner",
              ["<leader>wf"] = "@function.outer",
              ["<leader>wm"] = "@call.outer",
            },
            swap_previous = {
              ["<leader>wS"] = "@parameter.inner",
              ["<leader>wF"] = "@function.outer",
              ["<leader>wM"] = "@call.outer",
            },
          },
        },

        -- Enhanced code navigation and refactoring
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
          },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "<leader>tr",
            },
          },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = "gnd",
              list_definitions = "gnD",
              list_definitions_toc = "gO",
              goto_next_usage = "<a-*>",
              goto_previous_usage = "<a-#>",
            },
          },
        },

        -- Playground for debugging treesitter queries
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })

      -- Set up treesitter for templ files
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      vim.treesitter.language.register("templ", "templ")

      -- Configure rainbow delimiters
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }

      -- Configure improved folding with UFO
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })

      -- Keybindings for folding
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)

      -- Keymap for Treesitter playground
      vim.keymap.set("n", "<leader>ts", "<cmd>TSPlaygroundToggle<CR>", { desc = "Toggle TS Playground" })
    end,
  },
}
