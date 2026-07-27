return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"venv/",
						".venv/",
						".terraform/",
						"dist/",
						"build/",
						"target/",
						".idea/",
						".vscode/",
					},
					preview = {
						treesitter = true,
					},
					layout_strategy = "horizontal",
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
		end,
	},
}
