-- lua/plugins/treesitter.lua

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"bash",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"json",
		"php",
		"markdown",
		"markdown_inline",
	},
	auto_install = true,
	sync_install = false,
})

-- Rainbow delimiters
pcall(function()
	require("rainbow-delimiters.setup").setup()
end)

-- Context
pcall(function()
	require("treesitter-context").setup({
		enable = true,
		max_lines = 3,
	})
end)

-- Autotag
pcall(function()
	require("nvim-ts-autotag").setup({
		enable = true,
		disable = { "php" },
	})
end)
