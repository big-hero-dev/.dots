local mini_basic_plugins = {
	notify = { config = {} },
	tabline = { config = {} },
	files = {
		config = {
			mappings = {
				go_in = "i",
				go_in_plug = "I",
			},
		},
	},
	basics = { config = {} },
	icons = { config = {} },
	ai = { config = {} },
	align = { config = {} },
	animate = { config = {} },
	comment = { config = {} },
	cursorword = { config = {} },
	extra = { config = {} },
	git = { config = {} },
	pairs = { config = {} },
	pick = { config = {} },
	surround = { config = {} },
	trailspace = { config = {} },
	splitjoin = { config = {} },
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
	jump2d = { mappings = { start_jumping = "f" } },
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

for plugin, options in pairs(mini_basic_plugins) do
	require("mini." .. plugin).setup(options.config)
end

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- Marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
})

vim.notify = require("mini.notify").make_notify()

local keymaps = {
	{ mode = "n", key = "<Leader><Leader>", fn = "<Cmd>Pick files<CR>", desc = "Pick File" },
	{ mode = "n", key = "<Leader>g", fn = "<Cmd>Pick grep_live<CR>", desc = "Pick Grep Live" },
	{ mode = "n", key = "<Leader>o", fn = "<Cmd>Pick oldfiles<CR>", desc = "Pick Old Files" },
	{ mode = "n", key = "<Leader>b", fn = "<Cmd>Pick buffers<CR>", desc = "Pick Buffers" },
	{ mode = "n", key = "<Leader>h", fn = "<Cmd>Pick help<CR>", desc = "Pick Help" },
	{ mode = "n", key = "<Leader>pd", fn = "<Cmd>Pick diagnostic<CR>", desc = "Pick Diagnostic" },
	{ mode = "n", key = "<Leader>H", fn = "<Cmd>Pick hl_groups<CR>", desc = "Highlight" },

	-- Utilities
	{ mode = "n", key = "<Leader>e", fn = "<Cmd>lua MiniFiles.open()<CR>", desc = "Explorer" },
	{ mode = "n", key = "<Leader>ll", fn = "<Cmd>lua MiniTrailspace.trim()<CR>", desc = "Trailing Space" },
}

for _, map in ipairs(keymaps) do
	vim.keymap.set(map.mode, map.key, map.fn, { desc = map.desc })
end
