return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"stevearc/conform.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"mfussenegger/nvim-lint",
			"j-hui/fidget.nvim",
			"roobert/tailwindcss-colorizer-cmp.nvim",
			"folke/neodev.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Setup neodev for better lua development
			require("neodev").setup()

			-- Formatter setup
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					css = { "prettierd" },
					scss = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "prettierd" },
					lua = { "stylua" },
					php = { "php_cs_fixer" },
					blade = { "blade-formatter" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				require("conform").format({ timeout_ms = 500 })
			end, { desc = "Format document" })

			-- Linter setup
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				vue = { "eslint_d" },
				lua = { "luacheck" },
				php = { "phpstan" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Run linter" })

			-- LSP setup
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			-- Mason setup for tools
			require("mason").setup({
				ui = { border = "rounded" },
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Formatters
					"prettierd",
					"stylua",
					"php-cs-fixer",
					"blade-formatter",
					-- Linters
					"eslint_d",
					"luacheck",
					"phpstan",
				},
				auto_update = true,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"volar",
					"tailwindcss",
					"intelephense",
					"cssls",
					"html",
					"jsonls",
					"emmet_ls",
					"eslint",
					"yamlls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									completion = { callSnippet = "Replace" },
									diagnostics = {
										globals = { "vim", "it", "describe", "before_each", "after_each" },
									},
									workspace = { checkThirdParty = false },
									telemetry = { enable = false },
								},
							},
						})
					end,

					["ts_ls"] = function()
						require("lspconfig").ts_ls.setup({
							capabilities = capabilities,
							init_options = {
								preferences = {
									disableSuggestions = false,
									includeCompletionsForImportStatements = true,
								},
							},
							settings = {
								typescript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayVariableTypeHints = true,
									},
								},
								javascript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayVariableTypeHints = true,
									},
								},
							},
						})
					end,

					["volar"] = function()
						require("lspconfig").volar.setup({
							capabilities = capabilities,
							filetypes = { "vue" },
							init_options = {
								vue = { hybridMode = true },
								typescript = {
									tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
								},
							},
						})
					end,

					["tailwindcss"] = function()
						require("lspconfig").tailwindcss.setup({
							capabilities = capabilities,
							filetypes = {
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
							init_options = {
								userLanguages = {
									blade = "html",
									vue = "html",
								},
							},
						})
					end,

					["eslint"] = function()
						require("lspconfig").eslint.setup({
							capabilities = capabilities,
							on_attach = function(_, bufnr)
								vim.api.nvim_create_autocmd("BufWritePre", {
									buffer = bufnr,
									command = "EslintFixAll",
								})
							end,
						})
					end,

					["intelephense"] = function()
						require("lspconfig").intelephense.setup({
							capabilities = capabilities,
							settings = {
								intelephense = {
									environment = {
										includePaths = { "/vendor" },
									},
									files = {
										maxSize = 5000000,
									},
									stubs = {
										"apache",
										"bcmath",
										"Core",
										"date",
										"dom",
										"filter",
										"mbstring",
										"mysqli",
										"openssl",
										"pcre",
										"PDO",
										"PDO_mysql",
										"session",
										"standard",
										"xml",
										"zip",
										"laravel",
										"blade",
									},
								},
							},
						})
					end,

					["emmet_ls"] = function()
						require("lspconfig").emmet_ls.setup({
							capabilities = capabilities,
							filetypes = {
								"html",
								"css",
								"scss",
								"javascript",
								"javascriptreact",
								"typescript",
								"typescriptreact",
								"vue",
								"blade",
								"php",
							},
						})
					end,
				},
			})

			-- LSP UI
			require("fidget").setup({
				progress = {
					display = { progress_icon = { pattern = "dots" } },
				},
				notification = {
					window = { winblend = 0 },
				},
			})

			require("tailwindcss-colorizer-cmp").setup()

			-- Completion setup
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "path", priority = 500 },
					{ name = "buffer", priority = 250 },
				}),
				formatting = {
					format = function(entry, vim_item)
						-- Set max width of abbr
						local abbr_max = 30
						if #vim_item.abbr > abbr_max then
							vim_item.abbr = string.sub(vim_item.abbr, 1, abbr_max) .. "..."
						end

						-- Add type info and source
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
						})[entry.source.name]

						return vim_item
					end,
				},
			})

			-- Diagnostic settings
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
				float = {
					border = "rounded",
					source = "always",
				},
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},

	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<Tab>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = { enabled = false },
				filetypes = {
					markdown = true,
					help = true,
				},
				server_opts_overrides = {
					settings = {
						advanced = {
							telemetry = false,
						},
					},
				},
			})
		end,
	},
}
