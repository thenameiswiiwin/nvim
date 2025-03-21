return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=40<cr>", desc = "Toggle vertical terminal" },
		},
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<C-\>]],
			shade_terminals = false,
			direction = "float",
			float_opts = {
				border = "curved",
				width = function()
					return math.floor(vim.o.columns * 0.8)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.8)
				end,
			},
		},
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({
				patterns = { ".git", "package.json", "composer.json", "Makefile", ".env" },
				detection_methods = { "pattern", "lsp" },
				silent_chdir = true,
			})
			require("telescope").load_extension("projects")
			vim.keymap.set("n", "<leader>pp", function()
				require("telescope").extensions.projects.projects({})
			end, { desc = "Projects" })
		end,
	},
}
