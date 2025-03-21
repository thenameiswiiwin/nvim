function ColorMyPencils(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		opts = {},
		config = function()
			ColorMyPencils()
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					italic = false,
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				term_colors = true,
				dim_inactive = { enabled = true, shade = "dark", percentage = 0.15 }, -- subtle dimming
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					functions = { "bold" },
					keywords = { "bold" },
					strings = {},
					variables = {},
					numbers = { "bold" },
					types = { "italic" },
					operators = {},
				},
				color_overrides = {
					mocha = {
						base = "#1E1E2E",
						mantle = "#181825",
						crust = "#11111B",
						text = "#CDD6F4",
						overlay1 = "#7F849C",
						surface1 = "#45475A",
						surface0 = "#313244",
						blue = "#89B4FA",
						green = "#A6E3A1",
						yellow = "#F9E2AF",
						red = "#F38BA8",
						mauve = "#CBA6F7",
						teal = "#94E2D5",
						sky = "#89DCEB",
						peach = "#FAB387",
					},
				},
				custom_highlights = function(colors)
					return {
						-- Editor UI
						Normal = { fg = colors.text, bg = colors.base },
						NormalFloat = { bg = colors.mantle },
						LineNr = { fg = colors.surface1 },
						CursorLineNr = { fg = colors.peach, bold = true },
						CursorLine = { bg = colors.surface0 },
						Visual = { bg = colors.surface1 },
						Search = { bg = colors.peach, fg = colors.base, bold = true },

						-- Popup menu (completion)
						Pmenu = { bg = colors.mantle, fg = colors.overlay1 },
						PmenuSel = { bg = colors.surface0, fg = colors.text, bold = true },

						-- Diagnostics
						DiagnosticError = { fg = colors.red, bold = true },
						DiagnosticWarn = { fg = colors.yellow, bold = true },
						DiagnosticInfo = { fg = colors.sky },
						DiagnosticHint = { fg = colors.teal },

						-- Git Integration
						GitSignsAdd = { fg = colors.green },
						GitSignsChange = { fg = colors.peach },
						GitSignsDelete = { fg = colors.red },

						-- Telescope
						TelescopeBorder = { fg = colors.surface1, bg = colors.base },
						TelescopePromptBorder = { fg = colors.blue, bg = colors.surface0 },
						TelescopeResultsBorder = { fg = colors.surface1, bg = colors.mantle },
						TelescopePreviewBorder = { fg = colors.teal, bg = colors.mantle },
						TelescopeSelection = { bg = colors.surface0, fg = colors.text, bold = true },

						-- Treesitter
						TSKeyword = { fg = colors.mauve, bold = true },
						TSFunction = { fg = colors.blue, bold = true },
						TSVariable = { fg = colors.text },
						TSString = { fg = colors.green },
						TSBoolean = { fg = colors.peach, bold = true },
						TSNumber = { fg = colors.peach, bold = true },
						TSOperator = { fg = colors.sky },

						-- StatusLine
						StatusLine = { bg = colors.mantle, fg = colors.text, bold = true },
						StatusLineNC = { bg = colors.surface0, fg = colors.overlay1 },
					}
				end,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					telescope = {
						enabled = true,
						style = "classic",
					},
					mini = {
						enabled = true,
						indentscope_color = "#45475A",
					},
					fidget = true,
					lsp_trouble = true,
				},
			})

			ColorMyPencils()
		end,
	},
}
