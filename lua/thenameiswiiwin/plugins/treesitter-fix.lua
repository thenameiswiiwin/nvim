return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		init = function()
			-- Set parser install path
			local parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"

			-- Add the parser installation directory to runtimepath
			vim.opt.runtimepath:append(parser_install_dir)

			-- Make parsers visible to Neovim and Noice
			local parsers = require("nvim-treesitter.parsers")
			if parsers.get_parser_configs then
				local configs = parsers.get_parser_configs()
				for _, parser in ipairs({ "bash", "regex" }) do
					if configs[parser] then
						if not configs[parser].install_info then
							configs[parser].install_info = {}
						end
						configs[parser].install_info.path = parser_install_dir
					end
				end
			end
		end,
		-- Keep your existing config function
	},
}
