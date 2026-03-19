require("lsp-endhints").setup()
vim.api.nvim_set_hl(0, "LspInlayHint", {
	fg = "#b8963e",
	bg = "NONE",
	italic = true,
})
