return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/nvim-nio",
			-- Test adapters
			"haydenmeade/neotest-jest", -- For JavaScript/TypeScript testing
			"marilari88/neotest-vitest", -- For Vitest (Vue)
			"rouge8/neotest-rust",
			"olimorris/neotest-phpunit", -- For PHP/Laravel
		},
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run current file",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle test summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Show test output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output.open({ enter = true, short = true })
				end,
				desc = "Show test output (short)",
			},
			{
				"<leader>tp",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop test",
			},
			{
				"<leader>tc",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug nearest test",
			},
			{
				"[t",
				function()
					require("neotest").jump.prev({ status = "failed" })
				end,
				desc = "Jump to previous failed test",
			},
			{
				"]t",
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
					failed = "✖",
					passed = "✓",
					running = "⟳",
					skipped = "ⓢ",
					unknown = "?",
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
	},
}
