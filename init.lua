-- Entry point for Neovim configuration
-- Path: init.lua

-- Set leader key first for proper mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load thenameiswiiwin.core modules
require("thenameiswiiwin.core.options") -- Neovim options
require("thenameiswiiwin.core.keymaps") -- Key mappings
require("thenameiswiiwin.core.lazy_init") -- Initialize plugin manager
require("thenameiswiiwin.core.autocmds") -- Autocommands
