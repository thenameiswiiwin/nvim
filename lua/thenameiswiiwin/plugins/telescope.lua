return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{
			"<leader>vh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Search help tags",
		},
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					"dist",
					".git",
					"vendor",
				},
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})
	end,
}
