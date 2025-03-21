vim.g.mapleader = " "

-- File navigation
vim.keymap.set("n", "<leader>pf", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
vim.keymap.set("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end, { desc = "Find git files" })
vim.keymap.set("n", "<leader>ps", function()
	require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Search by grep" })
vim.keymap.set("n", "<leader>pws", function()
	local word = vim.fn.expand("<cword>")
	require("telescope.builtin").grep_string({ search = word })
end, { desc = "Search word under cursor" })

-- Web development specific
vim.keymap.set("n", "<leader>cc", function()
	vim.cmd("Telescope colorscheme")
end, { desc = "Change colorscheme" })
vim.keymap.set("n", "<leader>ct", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "TS go to source" })
vim.keymap.set("n", "<leader>co", "<cmd>TSToolsOrganizeImports<CR>", { desc = "TS organize imports" })
vim.keymap.set("n", "<leader>cs", "<cmd>TSToolsSortImports<CR>", { desc = "TS sort imports" })
vim.keymap.set("n", "<leader>cu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "TS remove unused" })
vim.keymap.set("n", "<leader>cf", "<cmd>TSToolsFixAll<CR>", { desc = "TS fix all" })
vim.keymap.set("n", "<leader>cA", "<cmd>TSToolsAddMissingImports<CR>", { desc = "TS add missing imports" })

-- Laravel specific
vim.keymap.set("n", "<leader>la", "<cmd>Laravel artisan<cr>", { desc = "Laravel Artisan" })
vim.keymap.set("n", "<leader>lr", "<cmd>Laravel routes<cr>", { desc = "Laravel Routes" })
vim.keymap.set("n", "<leader>lm", "<cmd>Laravel migrate<cr>", { desc = "Laravel Migrate" })
vim.keymap.set("n", "<leader>ls", "<cmd>Laravel sail<cr>", { desc = "Laravel Sail" })

-- Text manipulation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines keeping cursor position" })
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace word" }
)

-- Buffer management
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<CR>", { desc = "Delete all buffers but current" })

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

-- Clipboard operations
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

-- Git
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- Misc
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode with Ctrl+c" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end, { desc = "Source current file" })
