return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"astro",
					"bash",
					"css",
					"gitignore",
					"go",
					"graphql",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"php",
					"python",
					"scss",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
				},
				sync_install = false,
				auto_install = true,
				indent = { enable = true },
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

						-- Disable for HTML (handled by other plugins)
						if lang == "html" then
							return true
						end

						-- Disable for large files
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
					additional_vim_regex_highlighting = { "markdown" },
				},
			})

			-- Setup templ parser
			local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
			}

			vim.treesitter.language.register("templ", "templ")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
		opts = {
			enable = true,
			multiline_threshold = 20,
			mode = "cursor",
			separator = nil,
			trim_scope = "outer",
		},
	},

	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "php", "blade" },
		opts = {},
	},
}
