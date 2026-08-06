return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>m", "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
		},
		config = function()
			require("render-markdown").setup({})
		end,
	},
}
