return {
	-- TypeScript tools
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
		opts = {
			settings = {
				tsserver_file_preferences = {
					importModuleSpecifierPreference = "relative",
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},

	-- Tailwind CSS tools
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		ft = {
			"html",
			"css",
			"scss",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"php",
			"blade",
		},
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},

	-- CSS color preview
	{
		"norcalli/nvim-colorizer.lua",
		ft = {
			"html",
			"css",
			"scss",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"php",
			"blade",
		},
		config = function()
			require("colorizer").setup({
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"vue",
				"php",
				"blade",
			}, {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
			})
		end,
	},

	-- Auto close tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},

	-- HTML/JSX/Vue/etc support
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string", "source" },
					javascript = { "string", "template_string" },
					typescript = { "string", "template_string" },
					vue = { "string", "template_string" },
				},
				fast_wrap = {
					map = "<M-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[%'%"%)%>%]%)%}%,%= ]=],
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
			})

			-- Make it work with CMP
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Emmet support
	{
		"mattn/emmet-vim",
		ft = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"php",
			"blade",
		},
		init = function()
			vim.g.user_emmet_leader_key = "<C-e>"
			vim.g.user_emmet_mode = "i"
			vim.g.user_emmet_settings = {
				javascript = {
					extends = "jsx",
				},
				typescript = {
					extends = "tsx",
				},
				vue = {
					extends = "html",
				},
				php = {
					extends = "html",
				},
				blade = {
					extends = "html",
				},
			}
		end,
	},
}
