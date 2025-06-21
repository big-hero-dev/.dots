local add = require("mini.deps").add

add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "master",
	monitor = "main",
	hooks = {
		post_checkout = function()
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end,
	},
	depends = {
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		"windwp/nvim-ts-autotag",
	},
	event = { "BufReadPost", "BufNewFile" },
})

add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"html",
		"javascript",
		"typescript",
		"lua",
		"css",
		"php",
		"jsdoc",
		"json",
		"tsx",
		"markdown",
		"markdown_inline",
		"vim",
		"bash",
		"prisma",
		"regex",
		"java",
		"xml",
		"http",
		"graphql",
		"vimdoc",
	},
	auto_install = true,
	sync_install = false,
	highlight = { enable = true },
	rainbow = { enable = true, disable = { "html" } },
	autotag = { enable = true },
	incremental_selection = { enable = true },
	indent = { enable = true, disable = { "yaml" } },
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},
})
