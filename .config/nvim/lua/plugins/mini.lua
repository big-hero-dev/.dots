local MiniDeps = require("mini.deps")

MiniDeps.add({ source = "echasnovski/mini.nvim" })
MiniDeps.add({ source = "nvim-lualine/lualine.nvim" })
MiniDeps.add({
	source = "hrsh7th/nvim-cmp",
	depends = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
})

MiniDeps.add({
	source = "L3MON4D3/LuaSnip",
	hooks = {
		post_install = function(params)
			vim.notify("Building lua snippets", vim.log.levels.INFO)
			local result = vim.system({ "make", "install_jsregexp" }, { cwd = params.path }):wait()
			vim.notify("Building lua snippets done", vim.log.levels.INFO)
		end,
	},
	depends = { "rafamadriz/friendly-snippets" },
})

MiniDeps.add({ source = "neovim/nvim-lspconfig" })
MiniDeps.add({ source = "williamboman/mason.nvim" })
MiniDeps.add({ source = "williamboman/mason-lspconfig.nvim" })
MiniDeps.add({ source = "stevearc/conform.nvim" })

MiniDeps.add({ source = "dstein64/vim-startuptime" })

MiniDeps.setup()

-- ======================
-- Mini module configs
-- ======================

local config = {
	basics = {},
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
	jump2d = {
		mappings = { start_jumping = "f" },
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

-- Thứ tự khởi tạo có chủ đích
local order = {
	"basics",
	"icons",
	"notify",
	"comment",
	"pairs",
	"surround",
	"move",
	"jump2d",
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
vim.keymap.set("n", "<Leader>e", function()
	require("mini.files").open()
end, { desc = "Explorer" })
vim.keymap.set("n", "<Leader>ll", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing space" })
