return {
	-- Laravel tools
	{
		"adalessa/laravel.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-dotenv",
			"MunifTanjim/nui.nvim",
		},
		cmd = { "Artisan", "Laravel", "Composer" },
		ft = { "php", "blade" },
		init = function()
			-- Ensure file types are recognized
			vim.filetype.add({
				pattern = {
					[".*%.blade%.php"] = "blade",
				},
			})
		end,
		config = function()
			require("laravel").setup({
				lsp_server = "intelephense",
				features = {
					route = {
						enabled = true,
						cache = true,
					},
					completion = {
						enabled = true,
					},
				},
			})
		end,
	},

	-- Better Blade support
	{
		"jwalton512/vim-blade",
		ft = { "blade", "php" },
		config = function()
			vim.g.blade_custom_directives = {
				"component",
				"error",
				"permission",
				"role",
				"script",
				"style",
			}
			vim.g.blade_custom_directives_pairs = {
				component = "endcomponent",
				permission = "endpermission",
				role = "endrole",
				script = "endscript",
				style = "endstyle",
			}
		end,
	},

	-- PHP Refactoring tools
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
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "php",
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>pi",
						"<cmd>PhpactorImportClass<cr>",
						{ desc = "Import class", buffer = true }
					)
					vim.keymap.set(
						"n",
						"<leader>pe",
						"<cmd>PhpactorClassExpand<cr>",
						{ desc = "Expand class", buffer = true }
					)
					vim.keymap.set(
						"n",
						"<leader>pu",
						"<cmd>PhpactorImportMissingClasses<cr>",
						{ desc = "Import missing classes", buffer = true }
					)
					vim.keymap.set(
						"n",
						"<leader>pcm",
						"<cmd>PhpactorContextMenu<cr>",
						{ desc = "Context menu", buffer = true }
					)
					vim.keymap.set(
						"n",
						"<leader>pcc",
						"<cmd>PhpactorCopyClassName<cr>",
						{ desc = "Copy class name", buffer = true }
					)
				end,
			})
		end,
	},
}
