local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Import all plugins from modules
  spec = { { import = "thenameiswiiwin.plugins" } },

  -- Configuration
  defaults = {
    lazy = false,  -- Load plugins on startup by default
    version = false, -- Always use the latest version
  },

  -- Install options
  install = {
    -- Try to load colorscheme when installing
    colorscheme = { "catppuccin" },
  },

  -- Performance settings
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      -- Disable some built-in plugins we don't need
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- UI customization
  ui = {
    border = "rounded",
    icons = {
      cmd = "󰘳 ",
      config = " ",
      event = " ",
      ft = " ",
      init = " ",
      keys = " ",
      plugin = "󰏓 ",
      runtime = "󱑤 ",
      source = " ",
      start = "󰼛 ",
      task = " ",
      lazy = "󰂠 ",
    },
  },

  -- Change detection options
  change_detection = {
    notify = false,
  },
})
