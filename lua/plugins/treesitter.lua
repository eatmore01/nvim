return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- frozen but stable API (configs.setup); "main" is the new rewrite
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"hcl",
					"terraform",
					"yaml",
					"go",
					"gomod",
					"gowork",
					"dockerfile",
					"bash",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
