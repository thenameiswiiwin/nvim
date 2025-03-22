return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- LSP Management
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },
			-- Additional lua configuration
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- Setup mason for tool management
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", -- TypeScript
					"volar", -- Vue
					"tailwindcss", -- TailwindCSS
					"cssls", -- CSS
					"html", -- HTML
					"jsonls", -- JSON
					"yamlls", -- YAML
					"lua_ls", -- Lua
					"marksman", -- Markdown
					"intelephense", -- PHP
					"emmet_ls", -- Emmet
					"eslint", -- ESLint
				},
				automatic_installation = true,
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Formatters
					"prettierd",
					"stylua",
					"php-cs-fixer",
					-- Linters
					"eslint_d",
					"luacheck",
					"phpstan",
				},
				auto_update = true,
				run_on_start = true,
			})

			-- Setup LSP handlers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Diagnostic configuration
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
				float = {
					border = "rounded",
					source = "always",
				},
				severity_sort = true,
				update_in_insert = false,
			})

			-- Server configurations
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			require("lspconfig").ts_ls.setup({
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})

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

			require("lspconfig").volar.setup({
				capabilities = capabilities,
				filetypes = { "vue" },
				init_options = {
					vue = {
						hybridMode = true,
					},
				},
			})

			require("lspconfig").intelephense.setup({
				capabilities = capabilities,
				settings = {
					intelephense = {
						stubs = {
							"apache",
							"bcmath",
							"bz2",
							"calendar",
							"Core",
							"curl",
							"date",
							"dba",
							"dom",
							"enchant",
							"fileinfo",
							"filter",
							"ftp",
							"gd",
							"gettext",
							"hash",
							"iconv",
							"imap",
							"intl",
							"json",
							"ldap",
							"libxml",
							"mbstring",
							"mcrypt",
							"mysqli",
							"oci8",
							"odbc",
							"openssl",
							"pcntl",
							"pcre",
							"PDO",
							"pdo_mysql",
							"pdo_pgsql",
							"pdo_sqlite",
							"pgsql",
							"Phar",
							"posix",
							"pspell",
							"readline",
							"recode",
							"reflection",
							"session",
							"shmop",
							"SimpleXML",
							"snmp",
							"soap",
							"sockets",
							"sodium",
							"SPL",
							"sqlite3",
							"standard",
							"superglobals",
							"sysvmsg",
							"sysvsem",
							"sysvshm",
							"tidy",
							"tokenizer",
							"xml",
							"xmlreader",
							"xmlrpc",
							"xmlwriter",
							"xsl",
							"zip",
							"zlib",
							"wordpress",
							"woocommerce",
							"acf",
							"wordpress-globals",
							"wp-cli",
							"laravel",
							"blade",
						},
						environment = {
							includePaths = { "vendor" },
						},
						files = {
							maxSize = 5000000,
						},
					},
				},
			})

			-- Other servers (simple setup)
			local servers = {
				"cssls",
				"html",
				"jsonls",
				"yamlls",
				"marksman",
				"emmet_ls",
				"eslint",
			}

			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					capabilities = capabilities,
				})
			end
		end,
	},

	-- Formatters and linters
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
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
				lua = { "stylua" },
				php = { "php_cs_fixer" },
				blade = { "blade_formatter" },
			},
			format_on_save = function(bufnr)
				-- Don't format on save for files in node_modules or vendor
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("node_modules") or bufname:match("vendor") then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
		},
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				vue = { "eslint_d" },
				php = { "phpstan" },
				lua = { "luacheck" },
			}

			-- Setup autocommand to run linters
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "Run linter" })
		end,
	},
}
