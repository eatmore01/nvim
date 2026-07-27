return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main branch explicitly doesn't support lazy-loading
		build = ":TSUpdate",
		config = function()
			local parsers = {
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
			}

			require("nvim-treesitter").install(parsers)

			-- highlight/indent aren't auto-enabled by nvim-treesitter's main branch
			-- (old `.configs.setup({ highlight = ..., indent = ... })` API is gone)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"hcl",
					"terraform",
					"yaml",
					"go",
					"gomod",
					"gowork",
					"dockerfile",
					"sh",
					"bash",
					"json",
					"lua",
					"markdown",
				},
				callback = function()
					-- pcall: parser install above is async, may not be finished yet
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
