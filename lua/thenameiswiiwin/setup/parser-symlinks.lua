local M = {}

M.setup = function()
	-- Only run this once
	if vim.g.parser_symlinks_created then
		return
	end

	-- Source and destination directories
	local src_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"
	local dest_dir = "/usr/local/Cellar/neovim/HEAD-b165ad0_1/lib/nvim/parser"

	-- Parsers to symlink
	local parsers = { "bash", "regex" }

	for _, parser in ipairs(parsers) do
		local src = src_dir .. "/" .. parser .. ".so"
		local dest = dest_dir .. "/" .. parser .. ".so"

		-- Check if source exists and destination doesn't
		if vim.fn.filereadable(src) == 1 and vim.fn.filereadable(dest) == 0 then
			vim.fn.system(string.format("ln -sf %s %s", src, dest))
			vim.notify(string.format("Created symlink for %s parser", parser))
		end
	end

	vim.g.parser_symlinks_created = true
end

return M
