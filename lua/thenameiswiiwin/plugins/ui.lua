return {
	-- Themes
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			term_colors = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				mason = true,
				telescope = true,
				which_key = true,
				mini = true,
				lsp_trouble = true,
				neotest = true,
			},
			custom_highlights = function(colors)
				return {
					LineNr = { fg = colors.overlay0 },
					CursorLineNr = { fg = colors.mauve, style = { "bold" } },
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "catppuccin",
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "lazy" } },
			},
			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "oil", "lazy", "trouble", "nvim-tree" },
		},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			indent = { char = "│", tab_char = "│" },
			scope = { enabled = true },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"oil",
				},
			},
		},
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		lazy = true,
		init = function()
			-- Modify the validate function before plugin loads
			if vim.validate ~= nil then
				local old_validate = vim.validate
				_G.notify_patched_validate = function(...)
					if select("#", ...) == 3 then
						-- Handle newer format
						return old_validate(...)
					end
					return old_validate(...)
				end
			end
		end,
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},

	-- Better UI for messages, cmdline, and popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = { enabled = true },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
	},

	-- Which key
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer" },
			{ "<leader>E", "<cmd>Oil --float<cr>", desc = "Open file explorer (float)" },
		},
		config = function()
			require("oil").setup({
				-- Set to false to prevent buffer hijacking during startup
				default_file_explorer = false,

				-- View options
				view_options = {
					show_hidden = true,
					natural_sort = true,
					sort = {
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},

				-- Columns displayed in the file explorer
				columns = {
					"icon",
					"size",
					"permissions",
					"mtime",
				},

				-- Buffer settings
				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},

				-- Window appearance
				win_options = {
					wrap = false,
					signcolumn = "no",
					cursorcolumn = false,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 3,
					concealcursor = "nvic",
				},

				-- Keymaps within oil buffers
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["g."] = "actions.toggle_hidden",
					["<C-h>"] = "actions.toggle_hidden",
					["<C-r>"] = "actions.refresh",
				},

				-- Float window settings
				float = {
					padding = 2,
					max_width = 90,
					max_height = 30,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
				},

				-- Preview window settings
				preview = {
					max_width = 0.9,
					min_width = { 40, 0.4 },
					width = nil,
					max_height = 0.9,
					min_height = { 5, 0.1 },
					height = nil,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
				},

				-- Progress display
				progress = {
					max_width = 0.9,
					min_width = { 40, 0.4 },
					width = nil,
					max_height = 0.9,
					min_height = { 5, 0.1 },
					height = nil,
					border = "rounded",
					minimized_border = "none",
					win_options = {
						winblend = 0,
					},
				},

				-- When opening a file, use this method
				default_file_open_command = "edit",

				-- Restore window options after closing
				restore_win_options = true,

				-- Skip the confirmation pop-up for simple operations
				skip_confirm_for_simple_edits = false,

				-- Configure trash behavior instead of using trash_command
				trash = {
					-- Use the built-in trash implementation
					cmd = "trash",
					-- Require confirmation before trashing files
					require_confirm = true,
				},

				-- Delete to trash setting
				delete_to_trash = true,

				-- File size formatting
				size_format = "bs",

				-- Use fd instead of find if available
				use_fd = true,
			})
		end,
	},

	-- Zen mode for focused editing
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
		opts = {
			window = {
				width = 90,
				options = {
					number = true,
					relativenumber = true,
				},
			},
		},
	},

	-- Diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle diagnostics" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
		},
		opts = {
			use_diagnostic_signs = true,
			action_keys = {
				close = "q",
				cancel = "<esc>",
				refresh = "r",
				jump = { "<cr>", "<tab>" },
				toggle_mode = "m",
				hover = "K",
			},
		},
	},
}
