return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "filetype" },
				lualine_y = {
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then
							return ""
						end
						local names = {}
						for _, c in ipairs(clients) do
							table.insert(names, c.name)
						end
						return table.concat(names, ", ")
					end,
				},
				lualine_z = { "location" },
			},
		},
	},
}
