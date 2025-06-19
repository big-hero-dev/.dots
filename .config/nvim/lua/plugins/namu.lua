local add = require("mini.deps").add

add({ source = "bassamsdata/namu.nvim" })
require("namu").setup({
	namu_symbols = {
		enable = true,
		options = {
			window = {
				auto_size = true,
				min_height = 1,
				min_width = 20,
				max_width = 120,
				max_height = 30,
				padding = 2,
				border = "single",
				title_pos = "left",
				footer_pos = "right",
				show_footer = true,
				relative = "editor",
				style = "minimal",
				width_ratio = 0.6,
				height_ratio = 0.6,
				title_prefix = "󰠭 ",
			},
		},
	},
	ui_select = { enable = true },
})

vim.keymap.set("n", "<leader>ss", function()
	require("namu.namu_symbols").show()
end, { desc = "Jump to symbol" })
