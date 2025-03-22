local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })
keymap("i", "jk", "<Esc>", opts)
keymap("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", { desc = "Source init.lua" })

-- Harpoon
keymap("n", "<leader>ha", function()
	require("harpoon"):list():append()
end, { desc = "Harpoon add file" })
keymap("n", "<leader>hm", function()
	require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon quick menu" })
keymap("n", "<leader>h1", function()
	require("harpoon"):list():select(1)
end, { desc = "Harpoon file 1" })
keymap("n", "<leader>h2", function()
	require("harpoon"):list():select(2)
end, { desc = "Harpoon file 2" })
keymap("n", "<leader>h3", function()
	require("harpoon"):list():select(3)
end, { desc = "Harpoon file 3" })
keymap("n", "<leader>h4", function()
	require("harpoon"):list():select(4)
end, { desc = "Harpoon file 4" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
keymap("n", "<S-h>", "<cmd>bprevious<cr>", opts)
keymap("n", "<leader>c", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Text manipulation
keymap("v", "<", "<gv", opts) -- Stay in indent mode when indenting
keymap("v", ">", ">gv", opts)
keymap("v", "J", ":m '>+1<cr>gv=gv", opts) -- Move text up and down
keymap("v", "K", ":m '<-2<cr>gv=gv", opts)
keymap("n", "J", "mzJ`z", opts) -- Join lines while keeping cursor position
keymap("n", "<leader>p", '"_dP', opts) -- Paste without yanking

-- Improved movement
keymap("n", "n", "nzzzv", opts) -- Center cursor when navigating search results
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<C-d>", "<C-d>zz", opts) -- Center when navigating up/down
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "{", "{zz", opts)
keymap("n", "}", "}zz", opts)

-- Terminal - make these consistent
keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" }) -- Changed from <C-\>
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical size=40<cr>", { desc = "Vertical terminal" })
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })

-- LSP (to be expanded in lsp.lua)
keymap("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- File explorer
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Search
keymap("n", "<leader>sf", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
keymap("n", "<leader>sg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
keymap("n", "<leader>ss", function()
	require("telescope.builtin").grep_string()
end, { desc = "Grep string" })
keymap("n", "<leader>sb", function()
	require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

-- Git
keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
keymap("n", "<leader>gj", function()
	require("gitsigns").next_hunk()
end, { desc = "Next hunk" })
keymap("n", "<leader>gk", function()
	require("gitsigns").prev_hunk()
end, { desc = "Previous hunk" })
keymap("n", "<leader>gl", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
keymap("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
keymap("n", "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
keymap("n", "<leader>gs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
keymap("n", "<leader>gu", function()
	require("gitsigns").undo_stage_hunk()
end, { desc = "Undo stage hunk" })

-- Testing - move to separate group
keymap("n", "<leader>tr", function()
	require("neotest").run.run()
end, { desc = "Run nearest test" })
keymap("n", "<leader>tR", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
keymap("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
keymap("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, { desc = "Show test output" })
keymap("n", "<leader>tO", function()
	require("neotest").output.open({ enter = true, short = true })
end, { desc = "Show test output (short)" })
keymap("n", "<leader>tp", function()
	require("neotest").run.stop()
end, { desc = "Stop test" })
keymap("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

-- Web Development
keymap("n", "<leader>lt", "<cmd>TypescriptFixAll<cr>", { desc = "Fix TypeScript" })
keymap("n", "<leader>lo", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize imports" })

-- PHP/Laravel
keymap("n", "<leader>la", "<cmd>Laravel artisan<cr>", { desc = "Laravel Artisan" })
keymap("n", "<leader>lr", "<cmd>Laravel routes<cr>", { desc = "Laravel Routes" })
