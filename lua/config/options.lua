local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Use block cursor
opt.guicursor = ""

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.cursorline = true

-- Tab settings
opt.tabstop = 2 -- Default to 2 spaces for tabs
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true -- Use spaces instead of tabs opt.smartindent = true

-- No line wrapping
opt.wrap = false

-- Backup and undo
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
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

-- Set leader key (must happen early)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Hide command line when not in use (Neovim v0.8+)
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
