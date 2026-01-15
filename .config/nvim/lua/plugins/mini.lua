local MiniDeps = require("mini.deps")

MiniDeps.setup()

local add = MiniDeps.add

add({ source = "echasnovski/mini.nvim" })
add({ source = "nvim-lualine/lualine.nvim" })
add({
	source = "saghen/blink.cmp",
	hooks = {
		post_install = function(params)
			vim.system({ "cargo", "build", "--release" }, { cwd = params.path })
		end,
	},
})

add({
	source = "L3MON4D3/LuaSnip",
	version = "v2.*",
	depends = {
		"rafamadriz/friendly-snippets",
	},
})

add({ source = "neovim/nvim-lspconfig" })
add({ source = "williamboman/mason.nvim" })
add({ source = "williamboman/mason-lspconfig.nvim" })
add({ source = "stevearc/conform.nvim" })

add({ source = "dstein64/vim-startuptime" })
add({ source = "chrisgrieser/nvim-lsp-endhints" })
add({ source = "lambdalisue/suda.vim", on_cmd = { "SudaRead", "SudaWrite" } })
add({ source = "stevearc/aerial.nvim" })

add({
	source = "nvim-treesitter/nvim-treesitter",
	branch = "main",
	now = true,
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
		"nvim-treesitter/nvim-treesitter-context",
	},
})
-- add({source= "nvim-treesitter/nvim-treesitter-textobjects"})

add({ source = "folke/trouble.nvim" })

add({ source = "mbbill/undotree" })
vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Toggle Undotree" })

add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })

add({ source = "tpope/vim-fugitive" })
add({
	source = "lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
})

-- ======================
-- Mini module configs
-- ======================

local config = {
	basics = {},
	diff = {},
	icons = {},
	notify = {},
	tabline = {},
	files = {
		mappings = {
			go_in = "i",
			go_in_plug = "I",
		},
	},
	pick = {},
	comment = {},
	pairs = {},
	surround = {},
	move = {
		mappings = {
			left = "<M-h>",
			right = "<M-i>",
			down = "<M-n>",
			up = "<M-e>",
			line_left = "<M-h>",
			line_right = "<M-i>",
			line_down = "<M-n>",
			line_up = "<M-e>",
		},
	},
	splitjoin = {},
	trailspace = {},
	cursorword = {},
	indentscope = {
		symbol = "│",
		options = { try_as_border = true },
	},
	hipatterns = {
		highlighters = {
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
		},
	},
}

local order = {
	"basics",
	"icons",
	"notify",
	"comment",
	"pairs",
	"surround",
	"move",
	"splitjoin",
	"trailspace",
	"cursorword",
	"indentscope",
	"hipatterns",
	"pick",
	"files",
}

for _, name in ipairs(order) do
	require("mini." .. name).setup(config[name] or {})
end

-- ======================
-- Notify override
-- ======================

vim.notify = require("mini.notify").make_notify()

-- ======================
-- Mini.clue
-- ======================

local clue = require("mini.clue")

clue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
	},
})

vim.keymap.set("n", "<Leader><Leader>", "<Cmd>Pick files<CR>", { desc = "Pick files" })
vim.keymap.set("n", "<Leader>pg", "<Cmd>Pick grep_live<CR>", { desc = "Grep" })
vim.keymap.set("n", "<Leader>pb", "<Cmd>Pick buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ph", "<Cmd>Pick help<CR>", { desc = "Pick Help" })

vim.keymap.set("n", "<Leader>e", function()
	require("mini.files").open()
end, { desc = "Explorer" })
vim.keymap.set("n", "<Leader>ll", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing space" })

-- Auto trim with exclusions
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		-- Skip for certain filetypes
		local exclude_ft = { "markdown", "text" }
		if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
			return
		end

		require("mini.trailspace").trim()
		require("mini.trailspace").trim_last_lines()
	end,
})
