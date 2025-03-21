return {
	-- TypeScript utilities
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
		opts = {
			settings = {
				tsserver_file_preferences = {
					importModuleSpecifierPreference = "relative",
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},

	-- Vue tools
	{
		"yaegassy/coc-volar-tools",
		event = "BufReadPre *.vue",
		dependencies = { "neovim/nvim-lspconfig" },
	},

	-- Tailwind CSS autocomplete
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		ft = { "html", "css", "scss", "javascript", "typescript", "vue", "php", "blade.php" },
	},

	-- Color highlighter
	{
		"NvChad/nvim-colorizer.lua",
		ft = { "html", "css", "scss", "javascript", "typescript", "vue", "php", "blade.php" },
		opts = {
			user_default_options = {
				tailwind = true,
				css = true,
				css_variables = true,
				mode = "background",
			},
		},
	},
}
