return {
  -- Grug-far: Find and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "Far", "Farf", "Fardo", "Farundo" },
    config = function()
      require("grug-far").setup({
        preview_window_height = 12,
        preview_window_width = 0.8,
        default_opt = {
          max_count = 2000,
          ignore_case = false,
          regex = false,
          replace_all = false,
        },
      })
    end,
  },

  -- Flash.nvim: Enhanced navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
      jump = {
        autojump = true,
      },
      label = {
        rainbow = {
          enabled = true,
        },
      },
      -- Performance optimizations
      highlight = {
        backdrop = false,
      },
    },
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
        mode = "o",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
        mode = { "o", "x" },
      },
    },
  },

  -- Gitsigns: Git integration in signcolumn
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      -- Performance optimizations
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = false,
      current_line_blame = false,
      sign_priority = 6,
      update_debounce = 200,
      max_file_length = 40000, -- Disable if file is longer than this
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between hunks
        map("n", "]g", function()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git hunk" })

        map("n", "[g", function()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous Git hunk" })

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage selected hunk" })
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset selected hunk" })
        map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
        map(
          "n",
          "<leader>ghu",
          gs.undo_stage_hunk,
          { desc = "Undo stage hunk" }
        )
        map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame line" })
        map(
          "n",
          "<leader>gtb",
          gs.toggle_current_line_blame,
          { desc = "Toggle line blame" }
        )
        map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, { desc = "Diff this ~" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })
      end,
    },
  },

  -- Trouble: Better diagnostics display
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      position = "bottom",
      icons = true,
      mode = "workspace_diagnostics",
      auto_preview = false,
      use_diagnostic_signs = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>" },
        toggle_mode = "m",
        toggle_preview = "P",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Todo-comments: Highlight and search TODOs
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = true,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = {
          icon = "⏲ ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
      },
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    },
    keys = {
      { "<leader>ft", ":TodoFzfLua<cr>", desc = "Find TODOs" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
    },
  },

  -- Which-key: Display keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          {
            "<leader>u",
            group = "ui",
            icon = { icon = "󰙵 ", color = "cyan" },
          },
          {
            "<leader>x",
            group = "diagnostics/quickfix",
            icon = { icon = "󱖫 ", color = "green" },
          },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
  },

  -- Harpoon2: Quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")

      -- Initialize harpoon with proper setup
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          -- Use the standard key function from documentation
          key = function()
            return vim.loop.cwd()
          end,
        },
      })

      -- Keybindings for harpoon
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon: Add file" })

      vim.keymap.set("n", "<leader>hm", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon: Menu" })

      -- Quick jumps to harpoon files (1-5)
      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon: Jump to file 1" })
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon: Jump to file 2" })
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon: Jump to file 3" })
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon: Jump to file 4" })
      vim.keymap.set("n", "<leader>5", function()
        harpoon:list():select(5)
      end, { desc = "Harpoon: Jump to file 5" })

      -- Navigate between harpoon marks
      vim.keymap.set("n", "<leader>hn", function()
        harpoon:list():next()
      end, { desc = "Harpoon: Next file" })

      vim.keymap.set("n", "<leader>hp", function()
        harpoon:list():prev()
      end, { desc = "Harpoon: Previous file" })
    end,
  },

  -- Oil.nvim: File explorer
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Oil File Explorer" },
    },
    opts = {
      columns = {
        "icon",
        -- Don't include size/mtime for faster directory loading
      },
      view_options = {
        show_hidden = true,
        natural_order = true,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["g."] = "actions.toggle_hidden",
      },
      use_default_keymaps = false,
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = 0, -- Immediate cleanup for better performance
      delete_to_trash = false, -- Faster than moving to trash
      prompt_save_on_select_new_entry = true,
      buffers = {
        show_hidden_files = true,
        file_explorer = true,
        only_show_dirs = false,
      },
      -- Performance optimizations
      preview = {
        -- Disable preview for faster navigation
        max_width = 0,
        min_width = 0,
        delay_ms = 0,
      },
      -- Faster directory loading
      progress = {
        enable = false, -- Disable progress bar for better performance
      },
      win_options = {
        wrap = false, -- Don't wrap filenames
        signcolumn = "no", -- Disable sign column for cleaner view
      },
    },
  },

  -- Zen-mode for focused editing
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 90,
        height = 1,
        options = {
          signcolumn = "no",
          number = true,
          relativenumber = true,
          cursorline = true,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        -- Disable tmux status when in zen mode
        tmux = { enabled = true },
        -- Keep gitsigns active
        gitsigns = { enabled = true },
        -- Keep diagnostics active
        diagnostics = {
          enabled = true,
          underline = true,
          virtual_text = false,
        },
      },
      on_open = function()
        -- Disable diagnostics virtual text
        vim.diagnostic.config({
          virtual_text = false,
        })
      end,
      on_close = function()
        -- Restore diagnostics virtual text
        vim.diagnostic.config({
          virtual_text = {
            prefix = "●",
          },
        })
      end,
    },
  },

  -- FZF-Lua: Fast fuzzy finder
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    cmd = "FzfLua",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        -- Use the 'silent=true' flag to hide deprecation messages
        silent = true,

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
          hls = {
            border = "Comment",
            scrollbar = "PmenuSbar",
          },
        },

        keymap = {
          -- Neovim terminal mappings for the fzf window
          builtin = {
            ["<M-Esc>"] = "hide",
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<S-Left>"] = "preview-reset",
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"] = "preview-page-up",
            ["<M-S-down>"] = "preview-down",
            ["<M-S-up>"] = "preview-up",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
          },
        },

        fzf_opts = {
          ["--ansi"] = true,
          ["--info"] = "inline-right",
          ["--height"] = "100%",
          ["--layout"] = "reverse",
          ["--border"] = "none",
        },

        files = {
          prompt = "Files❯ ",
          multiprocess = true,
          git_icons = false,
          file_icons = true,
          color_icons = true,
          fd_opts = "--type f --color=never --hidden --follow --exclude .git --exclude node_modules --exclude '*.so' --exclude '*.o' --exclude '*.obj' --exclude '*.bin' --exclude '*.dll'",
          rg_opts = "--files --hidden --follow -g '!.git' -g '!node_modules' -g '!*.{so,o,obj,bin,dll}'",
          hidden = true,
          -- Use a faster way of filtering files
          find_opts = "-type f -not -path '*/\\.*' -not -path '*/node_modules/*' -not -path '*/build/*' -not -path '*/dist/*' -not -path '*/target/*'",
        },

        grep = {
          prompt = "Rg❯ ",
          multiprocess = true,
          git_icons = false,
          file_icons = true,
          color_icons = true,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        },
      })

      -- FZF-lua mappings
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
