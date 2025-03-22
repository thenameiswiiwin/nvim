local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight yanked text
autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Check if file changed when gaining focus
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = general,
	command = "checktime",
})

-- Resize windows on resizing vim
autocmd("VimResized", {
	group = general,
	command = "tabdo wincmd =",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
	group = general,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- File type specific settings
local filetype_settings = augroup("FiletypeSettings", { clear = true })

-- Set indentation for specific file types
autocmd("FileType", {
	group = filetype_settings,
	pattern = { "lua" },
	command = "setlocal shiftwidth=2 tabstop=2",
})

autocmd("FileType", {
	group = filetype_settings,
	pattern = { "php", "blade" },
	command = "setlocal shiftwidth=4 tabstop=4",
})

-- Close specific buffers with q
autocmd("FileType", {
	group = filetype_settings,
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"startuptime",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- LSP settings
local lsp_augroup = augroup("LSP", { clear = true })

-- Format on save for specific file types
autocmd("BufWritePre", {
	group = lsp_augroup,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue", "*.css", "*.scss", "*.php", "*.blade.php" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Auto setup LSP keymaps when LSP attaches
autocmd("LspAttach", {
	group = lsp_augroup,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		local opts = { buffer = bufnr, noremap = true, silent = true }

		-- LSP keybindings
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)

		-- Set up formatting
		if client and client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<leader>lf", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
		end
	end,
})
