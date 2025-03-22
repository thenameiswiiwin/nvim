vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Initialize parser symlinks
local ok, parser_symlinks = pcall(require, "thenameiswiiwin.setup.parser-symlinks")
if ok then
	parser_symlinks.setup()
end

-- Apply plugin fixes and workarounds
require("thenameiswiiwin.core.plugin-fixes").setup()

-- Load core configurations
require("thenameiswiiwin.core")
