return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diff against HEAD" },
			{ "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "File history" },
		},
		config = function()
			require("diffview").setup({})
		end,
	},
}
