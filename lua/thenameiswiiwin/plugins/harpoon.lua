return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			-- Initialize harpoon
			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key = function()
						-- Get a stable identifier for the file
						-- Use full path for projects with duplicate filenames
						return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
					end,
				},
			})

			-- Setup Telescope integration if available
			local telescope_config = require("telescope.config")
			local telescope_actions = require("telescope.actions")

			local function toggle_telescope(harpoon_files)
				local telescope_opts = {
					initial_mode = "normal",
					borderchars = telescope_config.values.borderchars,
					layout_config = {
						width = 0.8,
						height = 0.5,
					},
					attach_mappings = function(_, map)
						map("n", "dd", function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
							-- Close telescope and delete selection
							telescope_actions.close(prompt_bufnr)
							harpoon:list():remove(selection.index)
						end)
						return true
					end,
				}
				require("telescope.builtin").find_files(telescope_opts)
			end

			-- Keybindings for harpoon
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():append()
			end, { desc = "Harpoon: Add file" })
			vim.keymap.set("n", "<leader>hm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon: Menu" })

			-- Quick jumps to harpoon files (1-5)
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon: Jump to file 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon: Jump to file 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon: Jump to file 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon: Jump to file 4" })
			vim.keymap.set("n", "<leader>5", function()
				harpoon:list():select(5)
			end, { desc = "Harpoon: Jump to file 5" })

			-- Navigate between harpoon marks
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():next()
			end, { desc = "Harpoon: Next file" })
			vim.keymap.set("n", "<C-p>", function()
				harpoon:list():prev()
			end, { desc = "Harpoon: Previous file" })

			-- Telescope integration
			vim.keymap.set("n", "<leader>ht", function()
				harpoon.ui:toggle_telescope(toggle_telescope)
			end, { desc = "Harpoon: Telescope menu" })
		end,
	},
}
