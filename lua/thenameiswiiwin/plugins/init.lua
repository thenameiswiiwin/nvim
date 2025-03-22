return {
	-- Core plugins
	{ "nvim-lua/plenary.nvim", lazy = false },

	-- Development
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "numToStr/Comment.nvim", opts = {}, event = "VeryLazy" },

	-- Navigation
	{ "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't save current session",
			},
		},
	},

	-- Useful utilities
	{ "echasnovski/mini.pairs", event = "VeryLazy", opts = {} },
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update n lines for surrounding

				-- Make these more specific to avoid overlap warnings
				suffix_last = "l", -- Suffix for 'last' finder
				suffix_next = "n", -- Suffix for 'next' finder
			},
			search_method = "cover_or_next",
		},
	},
	{ "famiu/bufdelete.nvim", event = "VeryLazy" },
}
