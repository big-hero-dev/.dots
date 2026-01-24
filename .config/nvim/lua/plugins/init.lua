-- =========================================================
-- Plugin manager helper
-- =========================================================
local add = require("mini.deps").add

-- =========================================================
-- Core editing & basic UI
-- =========================================================
add({ source = "mbbill/undotree" })
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undotree" })

add({ source = "dstein64/vim-startuptime" })
add({ source = "lambdalisue/suda.vim", on_cmd = { "SudaRead", "SudaWrite" } })

-- =========================================================
-- Completion & snippets
-- =========================================================
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

-- =========================================================
-- LSP, formatting & diagnostics
-- =========================================================
add({ source = "neovim/nvim-lspconfig" })
add({ source = "williamboman/mason.nvim" })
add({ source = "williamboman/mason-lspconfig.nvim" })

add({ source = "stevearc/conform.nvim" })
add({ source = "chrisgrieser/nvim-lsp-endhints" })
add({ source = "folke/trouble.nvim" })

-- =========================================================
-- Syntax tree & structural intelligence
-- =========================================================
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

-- =========================================================
-- Git & project context
-- =========================================================
add({
	source = "lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
})

-- =========================================================
-- Navigation & memory
-- Harpoon 2
-- =========================================================
add({
	source = "ThePrimeagen/harpoon",
	checkout = "harpoon2",
	depends = { "nvim-lua/plenary.nvim" },
})

-- =========================================================
-- Mini.nvim ecosystem
-- =========================================================
local MiniStatusline = require("mini.statusline")

local function shorten_path(path, max_len)
	if not path or path == "" then
		return ""
	end

	max_len = max_len or 40

	path = vim.fn.fnamemodify(path, ":~")

	if #path <= max_len then
		return path
	end

	local parts = vim.split(path, "/")
	local filename = table.remove(parts)

	for i = 1, #parts do
		if parts[i] ~= "~" then
			parts[i] = parts[i]:sub(1, 1)
		end
	end

	local short = table.concat(parts, "/") .. "/" .. filename

	if #short > max_len then
		short = "…" .. short:sub(#short - max_len + 2)
	end

	return short
end

local config = {
	basics = {},
	icons = {},
	git = {},
	diff = {},
	notify = {
		window = {
			config = { border = "rounded" },
		},
	},
	statusline = {
		content = {
			active = function()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({ trunc_width = 40 })
				local diff = MiniStatusline.section_diff({ trunc_width = 75 })
				local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
				local filename = shorten_path(vim.api.nvim_buf_get_name(0), 45)
				local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
				local location = "%p%%"

				local lsp = ""
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients > 0 then
					local names = {}
					for _, c in ipairs(clients) do
						table.insert(names, c.name)
					end
					lsp = "󰭆 " .. table.concat(names, " ")
				end

				mode = mode:upper()

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
					{ hl = mode_hl, strings = { location } },
				})
			end,
		},
	},
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
	bufremove = {},
	jump2d = {},
}

local order = {
	"basics",
	"icons",
	"notify",
	"git",
	"diff",
	"statusline",
	"tabline",
	"bufremove",
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
	"jump2d",
}

for _, name in ipairs(order) do
	require("mini." .. name).setup(config[name] or {})
end

-- =========================================================
-- Notify override
-- =========================================================
vim.notify = require("mini.notify").make_notify()

-- =========================================================
-- Mini.clue
-- =========================================================
local clue = require("mini.clue")

clue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "<C-w>" },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
	},
})
