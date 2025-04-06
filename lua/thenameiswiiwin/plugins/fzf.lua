return {
  -- FZF-Lua: Fast fuzzy finder
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    cmd = "FzfLua",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          border = "rounded",
          preview = {
            border = "border",
            wrap = "nowrap",
            hidden = "nohidden",
            vertical = "down:45%",
            horizontal = "right:50%",
            layout = "flex",
            flip_columns = 120,
            title = true,
            delay = 100,
          },
        },
        keymap = {
          builtin = {
            ["<C-/>"] = "toggle-help",
            ["<C-q>"] = "toggle-fullscreen",
            ["<C-r>"] = "toggle-preview-wrap",
            ["<C-p>"] = "toggle-preview",
            ["<C-y>"] = "preview-page-up",
            ["<C-e>"] = "preview-page-down",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            ["ctrl-]"] = "toggle-preview",
          },
        },
        fzf_opts = {
          -- options are sent as `k=v` pairs to fzf
          ["--layout"] = "reverse",
          ["--info"] = "inline-right",
        },
        previewers = {
          cat = {
            cmd = "cat",
            args = "--number",
          },
          bat = {
            cmd = "bat",
            args = "--style=numbers,changes --color always",
            theme = "tokyonight_night",
          },
        },
        files = {
          prompt = "Files❯ ",
          cmd = "fd --type f --hidden --follow --exclude .git --exclude node_modules",
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
        grep = {
          prompt = "Rg❯ ",
          input_prompt = "Grep For❯ ",
          cmd = "rg --color=always --line-number --no-heading --smart-case --hidden --glob='!.git' --glob='!node_modules'",
          -- Performance optimizations
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
          no_header = false, -- hide grep|cwd header?
          no_header_i = false, -- hide interactive header?
          multiprocess = true, -- use multiprocess when grep
        },

        -- Performance optimization settings
        performance = {
          async_job_timeout = 1000, -- timeout jobs after 1000ms
          history = {
            path = vim.fn.stdpath("data") .. "/fzf-lua-history",
            limit = 1000,
          },
        },
      })

      -- Set up LSP integration for code navigation
      local lsp_fzf = function(method, opts)
        return function()
          opts = opts or {}
          require("fzf-lua").lsp_document_symbols({
            symbol_names = {
              File = "File",
              Module = "Module",
              Namespace = "Namespace",
              Package = "Package",
              Class = "Class",
              Method = "Method",
              Property = "Property",
              Field = "Field",
              Constructor = "Constructor",
              Enum = "Enum",
              Interface = "Interface",
              Function = "Function",
              Variable = "Variable",
              Constant = "Constant",
              String = "String",
              Number = "Number",
              Boolean = "Boolean",
              Array = "Array",
              Object = "Object",
              Key = "Key",
              Null = "Null",
              EnumMember = "EnumMember",
              Struct = "Struct",
              Event = "Event",
              Operator = "Operator",
              TypeParameter = "TypeParameter",
            },
          })
        end
      end

      -- Replace common Telescope mappings with FZF-lua
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
      vim.keymap.set(
        "n",
        "<leader>gc",
        fzf.git_commits,
        { desc = "Git commits" }
      )
      vim.keymap.set(
        "n",
        "<leader>gb",
        fzf.git_branches,
        { desc = "Git branches" }
      )
    end,
  },
}
