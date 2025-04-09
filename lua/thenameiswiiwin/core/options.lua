local opt = vim.opt
local g = vim.g

g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_python_provider = 0

-- Disable shada file for faster startup
opt.shadafile = "NONE"

-- Use block cursor
opt.guicursor = ""

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.cursorline = true

-- Tab settings
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- No line wrapping
opt.wrap = false

-- Backup and undo
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true

-- Search settings
opt.hlsearch = false -- Don't highlight all search matches
opt.incsearch = true -- Show search matches as you type

-- Colors
opt.termguicolors = true

-- UI improvements
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
opt.signcolumn = "yes" -- Always show sign column
opt.isfname:append("@-@")

-- Faster update time for better UX
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 300

-- Line length indicator
opt.colorcolumn = "80"

-- Completion settings
opt.completeopt = "menu,menuone,noselect"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Grep using ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Hide command line when not in use
opt.cmdheight = 1

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Add a small icon to diagnostics
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Statuscolumn setup (minimal)
opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"

-- Fold settings for better performance
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- Global status line for a cleaner look
opt.laststatus = 3

-- Better performance settings
opt.hidden = true -- Hide buffers when abandoned
opt.history = 100 -- Remember only last 100 commands
opt.synmaxcol = 240 -- Only highlight first 240 columns
opt.ttyfast = true -- Faster terminal rendering
opt.redrawtime = 1500 -- Time in milliseconds for abandoning redraw
opt.ttimeoutlen = 10 -- Short key code timeout

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Don't redraw during macros for better performance
opt.lazyredraw = true
