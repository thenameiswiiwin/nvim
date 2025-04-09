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

-- Performance optimization: Set this before loading plugins
vim.g.loaded_gzip = 0
vim.g.loaded_matchit = 0
vim.g.loaded_netrwPlugin = 0
vim.g.loaded_tarPlugin = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_man = 0
vim.g.loaded_2html_plugin = 0
vim.g.loaded_remote_plugins = 0

require("lazy").setup({
  -- Import all plugins from modules
  spec = { { import = "thenameiswiiwin.plugins" } },

  -- Configuration
  defaults = {
    lazy = true, -- Lazy load plugins by default
    version = false, -- Always use the latest version
  },

  -- Install options
  install = {
    -- Try to load colorscheme when installing
    colorscheme = { "rose-pine" },
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
        "spellfile",
        "editorconfig",
      },
    },
  },

  -- UI customization
  ui = {
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
  },

  -- Change detection options
  change_detection = {
    notify = false, -- Disable notifications on config changes
  },

  -- Profile plugin loading (disabled for better performance)
  profiling = {
    enabled = false,
  },
})
