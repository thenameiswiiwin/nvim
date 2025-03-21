-- Performance settings
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- UI Options
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.maxmempattern = 5000

-- Display
vim.opt.wrap = false
vim.opt.isfname:append("@-@")

-- Status line
vim.opt.laststatus = 3

-- Highlights
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fe8019", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#7F849C" })
