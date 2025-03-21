vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
	local buffer = args.buf
	local wid = nil
	local win_ids = vim.api.nvim_list_wins()

	for _, win_id in ipairs(win_ids) do
		local win_bufnr = vim.api.nvim_win_get_buf(win_id)
		if win_bufnr == buffer then
			wid = win_id
		end
	end

	if wid == nil then
		return
	end

	vim.schedule(function()
		if vim.api.nvim_win_is_valid(wid) then
			vim.api.nvim_set_current_win(wid)
		end
	end)
end

local function create_nav_options(name)
	return {
		group = "DapGroup",
		pattern = string.format("*%s*", name),
		callback = navigate,
	}
end

return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{
				"<F8>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Conditional Breakpoint",
			},
		},
		config = function()
			local dap = require("dap")
			dap.set_log_level("INFO")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>dr",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("repl")
				end,
				desc = "Debug: toggle repl ui",
			},
			{
				"<leader>ds",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("stacks")
				end,
				desc = "Debug: toggle stacks ui",
			},
			{
				"<leader>dw",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("watches")
				end,
				desc = "Debug: toggle watches ui",
			},
			{
				"<leader>db",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("breakpoints")
				end,
				desc = "Debug: toggle breakpoints ui",
			},
			{
				"<leader>dS",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("scopes")
				end,
				desc = "Debug: toggle scopes ui",
			},
			{
				"<leader>dc",
				function()
					require("thenameiswiiwin.plugins.dap").toggle_debug_ui("console")
				end,
				desc = "Debug: toggle console ui",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Prepare layout configurations
			local function layout(name)
				return {
					elements = { { id = name } },
					enter = true,
					size = 40,
					position = "right",
				}
			end

			local name_to_layout = {
				repl = { layout = layout("repl"), index = 0 },
				stacks = { layout = layout("stacks"), index = 0 },
				scopes = { layout = layout("scopes"), index = 0 },
				console = { layout = layout("console"), index = 0 },
				watches = { layout = layout("watches"), index = 0 },
				breakpoints = { layout = layout("breakpoints"), index = 0 },
			}

			local layouts = {}
			for name, config in pairs(name_to_layout) do
				table.insert(layouts, config.layout)
				name_to_layout[name].index = #layouts
			end

			-- Function to toggle debug UI
			local function toggle_debug_ui(name)
				dapui.close()
				local layout_config = name_to_layout[name]

				if layout_config == nil then
					error(string.format("bad name: %s", name))
				end

				local uis = vim.api.nvim_list_uis()[1]
				if uis ~= nil then
					layout_config.size = uis.width
				end

				pcall(dapui.toggle, layout_config.index)
			end

			-- Export toggle_debug_ui function
			package.loaded["thenameiswiiwin.plugins.dap"] = { toggle_debug_ui = toggle_debug_ui }

			-- Setup autocommands for DAP UI
			vim.api.nvim_create_autocmd("BufEnter", {
				group = "DapGroup",
				pattern = "*dap-repl*",
				callback = function()
					vim.wo.wrap = true
				end,
			})

			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

			-- Setup DAP UI with layouts
			dapui.setup({ layouts = layouts, enter = true })

			-- Setup DAP listeners
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			dap.listeners.after.event_output.dapui_config = function(_, body)
				if body.category == "console" then
					dapui.eval(body.output) -- Sends stdout/stderr to Console
				end
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			ensure_installed = {
				"node2", -- JavaScript/TypeScript debug adapter
				"chrome", -- For frontend debugging
				"php", -- PHP debug adapter
			},
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		},
	},
}
