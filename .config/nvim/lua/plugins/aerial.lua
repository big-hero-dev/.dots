local ok, aerial = pcall(require, "aerial")
if not ok then
	return
end

aerial.setup({
	attach_mode = "window",
	backends = { "lsp", "treesitter", "markdown" },
	show_guides = true,
	default_bindings = false,
	float = {
		border = "single",
		max_height = 30,
		max_width = 80,
	},
	layout = {
		min_width = 30,
		max_width = 40,
	},
	guides = {
		mid_item = "├─",
		last_item = "└─",
		nested_top = "│ ",
	},
})

local map = vim.keymap.set
local opts = { silent = true }

map("n", "<Leader>ao", "<cmd>AerialToggle!<CR>", vim.tbl_extend("force", opts, { desc = "Aerial: Toggle panel" }))
map("n", "<Leader>an", "<cmd>AerialNext<CR>", vim.tbl_extend("force", opts, { desc = "Aerial: Next symbol" }))
