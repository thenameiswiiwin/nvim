vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Apply plugin fixes and workarounds
require("thenameiswiiwin.core.plugin-fixes").setup()

-- Load core configurations
require("thenameiswiiwin.core")
