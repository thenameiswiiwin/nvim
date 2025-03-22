return {
	-- Telescope (Fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "truncate" },
				file_ignore_patterns = {
					"node_modules",
					"vendor",
					".git",
					"dist",
					"build",
				},
				layout_config = {
					horizontal = {
						preview_width = 0.55,
						results_width = 0.8,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
		end,
	},

	-- Native fzf for telescope performance
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- File explorer
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
}
