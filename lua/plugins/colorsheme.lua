return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "auto", -- auto, main, moon, or dawn
      dark_variant = "main", -- main, moon, or dawn
    },
  },
  { "folke/tokyonight.nvim", enabled = false },
  { "ellisonleao/gruvbox.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
