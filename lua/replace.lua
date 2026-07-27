local M = {}

function M.replace_to_eof()
	local pattern = vim.fn.input("Replace: ")
	if pattern == "" then
		return
	end
	local replacement = vim.fn.input("With: ")

	local safe_pat = vim.fn.escape(pattern, "/\\")
	local safe_rep = vim.fn.escape(replacement, "/\\&")

	vim.cmd(string.format(".,$s/%s/%s/gc", safe_pat, safe_rep))

	vim.notify(string.format('Replaced "%s" -> "%s" (cursor -> EOF)', pattern, replacement), vim.log.levels.INFO)
end

function M.setup()
	vim.keymap.set("n", "<leader>c", M.replace_to_eof, { desc = "Replace from cursor to EOF" })
end

return M
