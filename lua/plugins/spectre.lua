return {
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Spectre",
		keys = {
			{
				"<leader>c",
				function()
					require("spectre").open_file_search({ select_word = false })
				end,
				mode = { "n" },
				desc = "Search & replace in current file",
			},
		},
		opts = {},
	},
}
