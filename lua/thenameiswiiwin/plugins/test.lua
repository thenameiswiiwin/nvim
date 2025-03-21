return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"haydenmeade/neotest-jest", -- For JS/TS testing
		"marilari88/neotest-vitest", -- For Vitest
		"thenbe/neotest-playwright", -- For e2e testing
		"olimorris/neotest-phpunit", -- For Laravel/PHP
	},
	keys = {
		{
			"<leader>tr",
			function()
				require("neotest").run.run({ suite = false })
			end,
			desc = "Run Nearest Test",
		},
		{
			"<leader>ts",
			function()
				require("neotest").run.run({ suite = true })
			end,
			desc = "Run Test Suite",
		},
		{
			"<leader>td",
			function()
				require("neotest").run.run({ suite = false, strategy = "dap" })
			end,
			desc = "Debug Nearest Test",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open()
			end,
			desc = "Open Test Output",
		},
		{
			"<leader>tm",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Test Summary",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop Test Run",
		},
		{
			"[n",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			desc = "Jump to previous failed test",
		},
		{
			"]n",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			desc = "Jump to next failed test",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.js",
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-vitest"),
				require("neotest-playwright").adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
				require("neotest-phpunit")({
					phpunit_cmd = function()
						if vim.fn.filereadable("./vendor/bin/phpunit") == 1 then
							return "./vendor/bin/phpunit"
						else
							return "phpunit"
						end
					end,
				}),
			},
			icons = {
				running = "🔄",
				passed = "✅",
				failed = "❌",
				skipped = "⏭️",
				unknown = "❓",
			},
			status = {
				virtual_text = true,
				signs = false,
			},
			output = {
				open_on_run = false,
			},
			summary = {
				animated = true,
				follow = true,
				expand_errors = true,
			},
		})
	end,
}
