local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

ts.setup({
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
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = { "yaml" },
	},
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			node_decremental = "grm",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
		},
	},
})
