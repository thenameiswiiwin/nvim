return {
  -- Persistence: Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
      pre_save = function()
        -- Close certain types of windows before saving the session
        local tabpages = vim.api.nvim_list_tabpages()
        for _, tabpage in ipairs(tabpages) do
          local wins = vim.api.nvim_tabpage_list_wins(tabpage)
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            local bufname = vim.api.nvim_buf_get_name(buf)

            -- Skip special buffers
            if
              vim.tbl_contains({ "gitcommit", "help", "qf" }, filetype)
              or vim.tbl_contains({ "prompt", "nofile", "terminal" }, buftype)
              or vim.fn.isdirectory(bufname) == 1
            then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        end
      end,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- Plenary: Utility functions
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}
