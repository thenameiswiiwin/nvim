return {
  -- Nvim-treesitter: Tree-sitter integration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      -- Additional text objects for treesitter
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- Auto closing of HTML/JSX tags
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- Configure treesitter
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          -- Web development
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "scss",
          "json",
          "json5",
          "jsonc",
          "vue",
          "svelte",

          -- Languages
          "lua",
          "go",
          "gomod",
          "gowork",
          "gosum",
          "php",
          "python",
          "rust",
          "bash",

          -- Markup and config
          "markdown",
          "markdown_inline",
          "yaml",
          "toml",

          -- Git related
          "git_config",
          "gitcommit",
          "git_rebase",
          "gitignore",
          "gitattributes",

          -- Other utilities
          "regex",
          "vim",
          "vimdoc",
          "query",
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
              ["<leader>cs"] = "@parameter.inner",
              ["<leader>cf"] = "@function.outer",
              ["<leader>cm"] = "@call.outer",
            },
            swap_previous = {
              ["<leader>cS"] = "@parameter.inner",
              ["<leader>cF"] = "@function.outer",
              ["<leader>cM"] = "@call.outer",
            },
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

      -- Setup auto-tag for JSX/HTML
      require("nvim-ts-autotag").setup({
        enable = true,
        filetypes = {
          "html",
          "xml",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "tsx",
          "jsx",
          "vue",
          "svelte",
          "php",
        },
      })
    end,
  },
}
