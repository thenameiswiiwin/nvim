return {
	-- Laravel support
	{
		"adalessa/laravel.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-dotenv",
			"MunifTanjim/nui.nvim",
		},
		ft = { "php", "blade" },
		cmd = { "Sail", "Artisan", "Composer" },
		keys = {
			{ "<leader>la", "<cmd>Laravel artisan<cr>", desc = "Laravel Artisan" },
			{ "<leader>lr", "<cmd>Laravel routes<cr>", desc = "Laravel Routes" },
			{ "<leader>lm", "<cmd>Laravel migrate<cr>", desc = "Laravel Migrate" },
		},
		opts = {
			features = {
				null_ls = {
					register = false,
				},
			},
		},
	},

	-- Better blade support
	{
		"jwalton512/vim-blade",
		ft = { "blade", "php" },
	},

	-- PHP refactoring tools
	{
		"phpactor/phpactor",
		ft = { "php" },
		build = "composer install --no-dev --optimize-autoloader",
		cmd = { "PhpactorContextMenu", "PhpactorFindReferences" },
		keys = {
			{ "<leader>pm", "<cmd>PhpactorContextMenu<cr>", desc = "Phpactor Context Menu" },
			{ "<leader>pn", "<cmd>PhpactorNavigate<cr>", desc = "Phpactor Navigate" },
			{ "<leader>pt", "<cmd>PhpactorTransform<cr>", desc = "Phpactor Transform" },
		},
	},
}
