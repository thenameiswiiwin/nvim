return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"stevearc/conform.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"j-hui/fidget.nvim",
			"roobert/tailwindcss-colorizer-cmp.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"mfussenegger/nvim-lint",
		},

		config = function()
			local conform = require("conform")
			local cmp = require("cmp")
			local cmp_lsp = require("cmp_nvim_lsp")
			local lint = require("lint")
			local lspconfig = require("lspconfig")

			-- Conform Setup
			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
					lua = { "stylua" },
					tsx = { "prettier" },
					vue = { "prettier" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end)
			-- Lint Setup
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				lua = { "luacheck" },
				vue = { "eslint_d" },
				tsx = { "eslint_d" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				require("lint").try_lint()
			end)

			-- LSP Setup
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"selene",
					"luacheck",
					"shellcheck",
					"shfmt",
					"prettier",
					"eslint_d",
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"html",
					"cssls",
					"bashls",
					"graphql",
					"ts_ls",
					"tailwindcss",
					"volar",
					"intelephense",
					"phpactor",
				},
				handlers = {
					function(server_name) -- default handler (optional)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = { version = "Lua 5.1" },
									diagnostics = {
										globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
									},
								},
							},
						})
					end,
					["ts_ls"] = function()
						lspconfig.ts_ls.setup({
							capabilities = capabilities,
							root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
							init_options = {
								plugins = {
									{
										name = "@vue/typescript-plugin",
										location = vim.fn.stdpath("data")
											.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
										languages = { "vue" },
									},
								},
							},
							filetypes = {
								"typescript",
								"javascript",
								"javascriptreact",
								"typescriptreact",
								"typescript.tsx",
								"javascript.jsx",
								"tsx",
								"jsx",
								"vue",
							},
							single_file_support = true,
							settings = {
								complete_function_calls = true,
								typescript = {
									updateImportsOnFileMove = "always",
									suggest = { completeFunctionCalls = true },
									tsserver = {
										useSyntaxServer = false,
									},
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = true,
										includeInlayFunctionParameterTypeHints = true,
										includeInlayVariableTypeHints = true,
										includeInlayVariableTypeHintsWhenTypeMatchesName = true,
										includeInlayPropertyDeclarationTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										includeInlayEnumMemberValueHints = true,
										includeInlayVariableTypes = true,
									},
								},
								javascript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayParameterNameHintsWhenArgumentMatchesName = true,
										includeInlayFunctionParameterTypeHints = true,
										includeInlayVariableTypeHints = true,
										includeInlayVariableTypeHintsWhenTypeMatchesName = true,
										includeInlayPropertyDeclarationTypeHints = true,
										includeInlayFunctionLikeReturnTypeHints = true,
										includeInlayEnumMemberValueHints = true,
										includeInlayVariableTypes = true,
									},
								},
							},
						})
					end,
					["volar"] = function()
						lspconfig.volar.setup({
							capabilities = capabilities,
							filetypes = { "typescript", "javascript", "vue" },
							init_options = {
								vue = {
									hybridMode = true,
								},
							},
							settings = {
								typescript = {
									inlayHints = {
										enumMemberValues = {
											enabled = true,
										},
										functionLikeReturnTypes = {
											enabled = true,
										},
										propertyDeclarationTypes = {
											enabled = true,
										},
										parameterTypes = {
											enabled = true,
											suppressWhenArgumentMatchesName = true,
										},
										variableTypes = {
											enabled = true,
										},
									},
								},
							},
						})
					end,
					["tailwindcss"] = function()
						lspconfig.tailwindcss.setup({
							capabilities = capabilities,
							root_dir = require("lspconfig.util").root_pattern(".git"),
						})
					end,
					["graphql"] = function()
						-- configure graphql language server
						lspconfig["graphql"].setup({
							capabilities = capabilities,
							filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
						})
					end,
					["emmet_ls"] = function()
						-- configure emmet language server
						lspconfig["emmet_ls"].setup({
							capabilities = capabilities,
							filetypes = {
								"html",
								"typescriptreact",
								"javascriptreact",
								"css",
								"sass",
								"scss",
								"less",
								"svelte",
							},
						})
					end,
					["jsonls"] = function()
						lspconfig.jsonls.setup({
							capabilities = capabilities,
							filetypes = { "json", "jsonc" },
							settings = {
								json = {
									-- Schemas https://www.schemastore.org
									schemas = {
										{
											fileMatch = { "package.json" },
											url = "https://json.schemastore.org/package.json",
										},
										{
											fileMatch = { "manifest.json", "manifest.webmanifest" },
											url = "https://json.schemastore.org/web-manifest-combined.json",
										},
										{
											fileMatch = { "tsconfig*.json" },
											url = "https://json.schemastore.org/tsconfig.json",
										},
										{
											fileMatch = {
												".prettierrc",
												".prettierrc.json",
												"prettier.config.json",
											},
											url = "https://json.schemastore.org/prettierrc.json",
										},
										{
											fileMatch = { ".eslintrc", ".eslintrc.json" },
											url = "https://json.schemastore.org/eslintrc.json",
										},
										{
											fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
											url = "https://json.schemastore.org/babelrc.json",
										},
										{
											fileMatch = { "lerna.json" },
											url = "https://json.schemastore.org/lerna.json",
										},
										{
											fileMatch = { "now.json", "vercel.json" },
											url = "https://json.schemastore.org/now.json",
										},
										{
											fileMatch = {
												".stylelintrc",
												".stylelintrc.json",
												"stylelint.config.json",
											},
											url = "http://json.schemastore.org/stylelintrc.json",
										},
									},
								},
							},
						})
					end,
					["yamlls"] = function()
						lspconfig.yamlls.setup({
							capabilities = capabilities,
							settings = {
								yaml = { keyOrdering = false },
							},
						})
					end,
				},
			})

			require("fidget").setup({})
			require("tailwindcss-colorizer-cmp").setup({})

			-- CMP Setup
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
