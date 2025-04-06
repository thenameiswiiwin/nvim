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
