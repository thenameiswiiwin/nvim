return {
	-- File explorer
	{
		"stevearc/oil.nvim",
		lazy = true,
		event = "VimEnter", -- Load after Vim has fully started
		cmd = "Oil",
		keys = {
			{ "<leader>pv", "<CMD>Oil<CR>", desc = "Open parent directory" },
			{ "<space>pp", ":lua require('oil').toggle_float()<CR>", desc = "Toggle floating file explorer" },
		},
		config = function()
			vim.schedule(function()
				require("oil").setup({
					view_options = { show_hidden = true },
					float = {
						padding = 2,
						max_width = 80,
						max_height = 30,
						border = "rounded",
					},
				})
			end)
		end,
	},

	-- Harpoon for quick navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>A",
				function()
					require("harpoon"):list():prepend()
				end,
				desc = "Harpoon prepend file",
			},
			{
				"<leader>a",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon add file",
			},
			{
				"<C-e>",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon quick menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon file 4",
			},
		},
		config = function()
			require("harpoon"):setup()
		end,
	},

	-- Undotree for undo history visualization
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
		},
	},

	-- Mini.nvim for small but useful plugins
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.comment").setup()
			require("mini.pairs").setup()
		end,
	},

	-- Editorconfig support
	{ "editorconfig/editorconfig-vim", event = "BufReadPre" },

	-- Neogen for documentation generation
	{
		"danymat/neogen",
		cmd = "Neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
	},

	-- LuaSnip for snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("javascript", { "jsdoc" })
			ls.filetype_extend("typescript", { "jsdoc", "tsdoc" })
			ls.filetype_extend("vue", { "html", "javascript", "typescript" })
			ls.filetype_extend("php", { "php", "html" })
			ls.filetype_extend("blade", { "html", "php" })

			require("luasnip.loaders.from_vscode").lazy_load()

			vim.keymap.set({ "i" }, "<C-s>e", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>;", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>,", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { buffer = bufnr, expr = true, desc = "Next hunk" })

				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { buffer = bufnr, expr = true, desc = "Previous hunk" })
			end,
		},
	},
}
