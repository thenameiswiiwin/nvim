return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true,
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
      })

      -- Set key mapping for opening Oil
      vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
    end,
  },
}
