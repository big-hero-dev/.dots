local ok, trouble = pcall(require, "trouble")
if not ok then
	return
end

trouble.setup({
	auto_close = true,
	use_diagnostic_signs = true,
})

vim.keymap.set("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", {
	desc = "Diagnostics (workspace)",
})

vim.keymap.set("n", "<leader>tw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
	desc = "Diagnostics (buffer)",
})

vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle<cr>", {
	desc = "Location list",
})

vim.keymap.set("n", "<leader>tq", "<cmd>Trouble quickfix toggle<cr>", {
	desc = "Quickfix list",
})

vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle<cr>", {
	desc = "LSP references",
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diag: prev" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Diag: next" })
