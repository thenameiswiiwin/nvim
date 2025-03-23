return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-vim-test",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"thenbe/neotest-playwright",
			"nvim-neotest/nvim-nio",
			"olimorris/neotest-phpunit",
		},
		config = function()
			local neotest = require("neotest")

			neotest.setup({
				discovery = {
					enabled = true,
				},
				diagnostic = {
					enabled = true,
					severity = vim.diagnostic.severity.ERROR,
				},
				quickfix = {
					enabled = true,
					open = function()
						vim.cmd("copen")
					end,
				},
				adapters = {
					-- JavaScript testing
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "jest.config.js",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),

					-- Vitest for Vue projects
					require("neotest-vitest"),

					-- Playwright for e2e testing
					require("neotest-playwright").adapter({
						options = {
							persist_project_selection = true,
							enable_dynamic_test_discovery = true,
						},
					}),

					-- Lua testing
					require("neotest-plenary"),

					-- PHP Testing
					require("neotest-phpunit")({
						phpunit_cmd = function()
							return "./vendor/bin/phpunit"
						end,
					}),
				},
				icons = {
					failed = "✖",
					passed = "✓",
					running = "🔄",
					skipped = "⏭️",
					unknown = "?",
				},
				floating = {
					border = "rounded",
					max_height = 0.6,
					max_width = 0.6,
				},
				summary = {
					enabled = true,
					follow = true,
					expand_errors = true,
				},
				output = {
					enabled = true,
					open_on_run = true,
				},
				status = {
					enabled = true,
					signs = true,
					virtual_text = false,
				},
				strategies = {
					integrated = {
						width = 120,
						height = 40,
					},
				},
			})

			-- Keymappings
			vim.keymap.set("n", "<leader>tt", function()
				neotest.run.run()
			end, { desc = "Run nearest test" })
			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Run current file" })
			vim.keymap.set("n", "<leader>ts", function()
				neotest.run.run({ suite = true })
			end, { desc = "Run test suite" })
			vim.keymap.set("n", "<leader>tl", function()
				neotest.run.run_last()
			end, { desc = "Run last test" })
			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug nearest test" })
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end, { desc = "Show test output" })
			vim.keymap.set("n", "<leader>tp", function()
				neotest.output_panel.toggle()
			end, { desc = "Toggle output panel" })
			vim.keymap.set("n", "<leader>tm", function()
				neotest.summary.toggle()
			end, { desc = "Toggle summary window" })
			vim.keymap.set("n", "[t", function()
				neotest.jump.prev({ status = "failed" })
			end, { desc = "Jump to previous failed test" })
			vim.keymap.set("n", "]t", function()
				neotest.jump.next({ status = "failed" })
			end, { desc = "Jump to next failed test" })
		end,
	},

	-- Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Set up DAP UI
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
			})

			-- Node.js / JavaScript / TypeScript adapter
			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
				},
			}

			-- Add Node.js configuration
			dap.configurations.javascript = {
				{
					name = "Launch",
					type = "node2",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
				{
					name = "Attach to node process",
					type = "node2",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}

			dap.configurations.typescript = dap.configurations.javascript

			-- Go debug adapter configuration
			require("dap-go").setup()

			-- Virtual text for variables
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				virt_text_pos = "eol",
				all_frames = false,
			})

			-- Open and close dapui automatically
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Keymaps for debugging
			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Debug: Continue" })
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dn", function()
				dap.step_over()
			end, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<leader>do", function()
				dap.step_out()
			end, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>dq", function()
				dap.close()
			end, { desc = "Debug: Close" })
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Debug: Open REPL" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Debug: Toggle UI" })
		end,
	},
}
