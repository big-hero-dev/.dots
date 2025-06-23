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
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- Function
				["af"] = "@function.outer",
				["if"] = "@function.inner",

				-- Class
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",

				-- Parameter
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",

				-- Block
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",

				-- Conditional
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",

				-- Loop
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",

				-- Statement
				["as"] = "@statement.outer",
				["is"] = "@statement.inner",

				-- Call
				["ak"] = "@call.outer",
				["ik"] = "@call.inner",
			},
		},
	},
})
