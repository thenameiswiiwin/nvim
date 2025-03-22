return {
	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 300,
			},
			preview_config = {
				border = "rounded",
				style = "minimal",
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, { desc = "Git stage hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "Git reset hunk" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git stage selected hunk" })
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git reset selected hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "Git stage buffer" })
				map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git undo stage hunk" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "Git reset buffer" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "Git preview hunk" })
				map("n", "<leader>gl", gs.blame_line, { desc = "Git blame line" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "Git blame line (full)" })
				map("n", "<leader>gd", gs.diffthis, { desc = "Git diff this" })
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, { desc = "Git diff this ~" })
				map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
			end,
		},
	},

	-- LazyGit integration
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	-- Fugitive (Git commands)
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
		keys = {
			{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
			{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
			{ "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
		},
	},
}
