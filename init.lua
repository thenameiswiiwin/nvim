vim.loader.enable()
--[[
  Performance optimization: Set global variables at the very start
  to reduce startup time before loading any plugins
--]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_gzip = 0
vim.g.loaded_zip = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_tar = 0
vim.g.loaded_tarPlugin = 0

-- Disable providers we don't need (improves startup time)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Set leader key first for proper mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Performance optimization: Setup UI options early to prevent flicker
vim.opt.termguicolors = true
vim.opt.guicursor = ""
vim.opt.laststatus = 3

-- Load core modules
require("thenameiswiiwin.core.options") -- Neovim options
require("thenameiswiiwin.core.keymaps") -- Key mappings
require("thenameiswiiwin.core.lazy_init") -- Initialize plugin manager
require("thenameiswiiwin.core.autocmds") -- Autocommands
require("thenameiswiiwin.core.utils") -- Utility functions
