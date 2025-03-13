return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.hipatterns").setup({
				highlighters = {
					hsl_color = {
						pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
						group = function(_, match)
							local catppuccin = require(ColorMyPencils()) -- Import your Catppuccin colors
							local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
							local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

							-- Convert HSL to HEX using Catppuccin's color palette
							local hex_color = catppuccin.hsl_to_hex(h, s, l)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
					},
				},
			})
		end,
	},
}
