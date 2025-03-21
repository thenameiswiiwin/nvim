local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Create main autocommand groups
local thenameiswiiwin_group = augroup("thenameiswiiwin", {})
local yank_group = augroup("HighlightYank", {})

-- Module reload function
function R(name)
	require("plenary.reload").reload_module(name)
end

-- Add filetype detection
vim.filetype.add({
	extension = {
		templ = "templ",
		vue = "vue",
		blade = "blade",
		php = "php",
	},
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

-- Highlight yanked text
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = thenameiswiiwin_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Theme per filetype
autocmd("BufEnter", {
	group = thenameiswiiwin_group,
	callback = function()
		if vim.bo.filetype == "zig" then
			vim.cmd.colorscheme("rose-pine-moon")
		else
			vim.cmd.colorscheme("catppuccin-mocha")
		end
	end,
})

-- Auto-format on save for specific filetypes
autocmd("BufWritePre", {
	group = thenameiswiiwin_group,
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.css", "*.scss", "*.php", "*.blade.php" },
	callback = function()
		require("conform").format()
	end,
})

-- LSP keybindings
autocmd("LspAttach", {
	group = thenameiswiiwin_group,
	callback = function(e)
		local opts = { buffer = e.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	end,
})

-- Optimize terminal behavior
autocmd("TermOpen", {
	group = thenameiswiiwin_group,
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
})
