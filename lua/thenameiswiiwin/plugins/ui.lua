function ColorMyPencils(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					telescope = { enabled = true },
					indent_blankline = { enabled = true },
					which_key = true,
					notify = true,
					mini = true,
					dap = { enabled = true, enable_ui = true },
				},
			})
			ColorMyPencils()
		end,
	},

	-- Status line that's fast and minimal
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "catppuccin",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			indent = { char = "│" },
		},
	},

	-- Zen mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{
				"<leader>zz",
				function()
					require("zen-mode").setup({ window = { width = 90 } })
					require("zen-mode").toggle()
					vim.wo.wrap = false
					vim.wo.number = true
					vim.wo.rnu = true
					ColorMyPencils()
				end,
				desc = "Zen Mode (with line numbers)",
			},
			{
				"<leader>zZ",
				function()
					require("zen-mode").setup({ window = { width = 80 } })
					require("zen-mode").toggle()
					vim.wo.wrap = false
					vim.wo.number = false
					vim.wo.rnu = false
					vim.opt.colorcolumn = "0"
					ColorMyPencils()
				end,
				desc = "Zen Mode (no line numbers)",
			},
		},
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		lazy = true,
		opts = {
			timeout = 3000,
			render = "compact",
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
	},

	-- Trouble for diagnostics display
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		keys = {
			{
				"<leader>tt",
				function()
					require("trouble").toggle()
				end,
				desc = "Toggle Trouble",
			},
			{
				"[t",
				function()
					require("trouble").next({ skip_groups = true, jump = true })
				end,
				desc = "Next Trouble item",
			},
			{
				"]t",
				function()
					require("trouble").previous({ skip_groups = true, jump = true })
				end,
				desc = "Previous Trouble item",
			},
		},
		opts = {
			icons = false,
			padding = false,
			fold_open = "v",
			fold_closed = ">",
			use_diagnostic_signs = true,
		},
	},

	-- Which-key for better keymap discoverability
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			win = { border = "rounded", padding = { 1, 2, 1, 2 } },
			disable = { filetypes = { "TelescopePrompt" } },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			wk.add({
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Format/Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>p", group = "Project/Files" },
				{ "<leader>t", group = "Test/Toggle" },
				{ "<leader>v", group = "LSP" },
				{ "<leader>z", group = "Zen" },
			})
		end,
	},
}
