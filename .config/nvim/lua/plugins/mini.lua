vim.keymap.set("n", "<Leader><Leader>", "<cmd>Pick files<cr>", { desc = "Pick files" })
vim.keymap.set("n", "<Leader>pg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
vim.keymap.set("n", "<Leader>pb", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ph", "<cmd>Pick help<cr>", { desc = "Pick Help" })

vim.keymap.set("n", "<Leader>e", function()
	require("mini.files").open()
end, { desc = "Explorer" })

vim.keymap.set("n", "<Leader>ll", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing space" })

vim.keymap.set("n", "<Leader>U", "<cmd>DepsUpdate<cr>", { desc = "DepsUpdate" })

vim.keymap.set("n", "<leader>x", function()
	require("mini.bufremove").delete()
end, { desc = "Buffer: Delete" })

-- Auto trim with exclusions
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local exclude_ft = { "markdown", "text" }
		if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
			return
		end

		require("mini.trailspace").trim()
		require("mini.trailspace").trim_last_lines()
	end,
})
