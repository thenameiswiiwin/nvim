return {
  -- Copilot: AI-powered code completion
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-y>",
            accept_word = "<M-k>",
            accept_line = "<M-l>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-e>",
          },
        },
        filetypes = {
          -- Default filetypes
          ["*"] = true,
          -- Disabled filetypes
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          TelescopePrompt = false,
          ["dap-repl"] = false,
        },
        copilot_node_command = "node", -- Node.js version to use
        server_opts_overrides = {},

        -- Broadcast events for integration with other plugins like lualine
        on_status_update = function(status)
          -- Send Copilot status to other plugins through User events
          if status == "Normal" or status == "InProgress" then
            vim.api.nvim_exec_autocmds("User", { pattern = "CopilotActive" })
          else
            vim.api.nvim_exec_autocmds("User", { pattern = "CopilotInactive" })
          end
        end,
      })
    end,
  },

  -- Copilot-cmp integration
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    config = function()
      require("copilot_cmp").setup({
        formatters = {
          label = require("copilot_cmp.format").format_label_text,
          insert_text = require("copilot_cmp.format").format_insert_text,
          preview = require("copilot_cmp.format").deindent,
        },
        event = { "InsertEnter", "LspAttach" },
        fix_pairs = true,
      })
    end,
  },
}
