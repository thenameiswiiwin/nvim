local opt = vim.opt

-- Performance
opt.lazyredraw = false
opt.shell = "/bin/zsh"
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.showmode = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cmdheight = 1
opt.completeopt = "menuone,noselect"
opt.pumheight = 10
opt.updatetime = 100
opt.timeoutlen = 300
opt.conceallevel = 0
opt.showmatch = true
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"

-- Tabs & Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true
opt.wrap = false

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Files
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.fileencoding = "utf-8"
opt.hidden = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- System
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.mousemoveevent = true

-- Appearance
opt.list = true
opt.listchars = "tab:» ,trail:·,nbsp:␣,extends:›,precedes:‹"
opt.shortmess:append("c")
opt.fillchars = "eob: "
opt.colorcolumn = "80"
