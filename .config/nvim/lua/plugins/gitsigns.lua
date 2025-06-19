local add = require("mini.deps").add

add({
	source = "lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
})

require("gitsigns").setup({ current_line_blame = true })
