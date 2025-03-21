return {
	-- Core dependencies
	{ "nvim-lua/plenary.nvim", name = "plenary", lazy = false },

	-- Fun
	{ "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },

	-- Performance metrics
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
