local function setup_themes()
	vim.g.gruvbox_material_enable_italic = true
	vim.g.gruvbox_material_cursor = "auto"
	vim.g.gruvbox_material_background = "soft"
	vim.g.gruvbox_material_show_eob = 1
	vim.g.gruvbox_material_diagnostic_text_highlight = 1
	vim.g.gruvbox_material_inlay_hints_background = "dimmed"
	vim.g.gruvbox_material_current_word = "underline"

	local hour = tonumber(os.date("%H"))
	vim.o.background = (hour >= 18 or hour < 6) and "dark" or "light"
	vim.cmd.colorscheme("gruvbox-material")
end
setup_themes()

vim.keymap.set("n", "td", function()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle Dark/Light Mode" })

-- =========================================================
-- Core keymaps
-- =========================================================
vim.keymap.set("n", "<Leader>u", function()
	require("undotree").open({ command = "60vnew" })
end, { desc = "Undotree" })

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

local lsp_cache = {}
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
	callback = function(args)
		local clients = vim.lsp.get_clients({ bufnr = args.buf })
		local names = {}
		for _, c in ipairs(clients) do
			table.insert(names, c.name)
		end
		lsp_cache[args.buf] = #names > 0 and ("󰭆 " .. table.concat(names, " ")) or ""
	end,
})

local config = {
	basics = {
		options = { basic = false },
		mappings = { basic = false },
		autocommands = { basic = false },
	},
	icons = {},
	git = {},
	diff = {},
	notify = {
		window = { config = { border = "rounded" } },
	},
	statusline = {
		content = {
			active = function()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({ trunc_width = 40 })
				local diff = MiniStatusline.section_diff({ trunc_width = 75 })
				local diagnostics = MiniStatusline.section_diagnostics({
					trunc_width = 75,
					signs = {
						ERROR = " ",
						WARN = " ",
						HINT = "󰌵 ",
						INFO = " ",
					},
				})
				local filename = shorten_path(vim.api.nvim_buf_get_name(0), 45)
				local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
				local location = "%p%%"
				local lsp = lsp_cache[vim.api.nvim_get_current_buf()] or ""
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
	files = { mappings = { go_in = "i", go_in_plug = "I" } },
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

require("mini.notify").setup(config.notify)
vim.notify = require("mini.notify").make_notify()

local order = {
	"basics",
	"icons",
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
		{ mode = "o", keys = "a" },
		{ mode = "o", keys = "i" },
		{ mode = "x", keys = "a" },
		{ mode = "x", keys = "i" },
	},
	clues = {
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.g(),
		clue.gen_clues.windows(),
		clue.gen_clues.z(),
		-- textobjects
		{ mode = "o", keys = "af", desc = "function outer" },
		{ mode = "o", keys = "if", desc = "function inner" },
		{ mode = "o", keys = "ac", desc = "class outer" },
		{ mode = "o", keys = "ic", desc = "class inner" },
		{ mode = "o", keys = "aa", desc = "parameter outer" },
		{ mode = "o", keys = "ia", desc = "parameter inner" },
		-- visual mode
		{ mode = "x", keys = "af", desc = "function outer" },
		{ mode = "x", keys = "if", desc = "function inner" },
		{ mode = "x", keys = "ac", desc = "class outer" },
		{ mode = "x", keys = "ic", desc = "class inner" },
		{ mode = "x", keys = "aa", desc = "parameter outer" },
		{ mode = "x", keys = "ia", desc = "parameter inner" },
	},
})

vim.keymap.set("n", "<Leader><Leader>", "<cmd>Pick files<cr>", { desc = "Pick files" })
vim.keymap.set("n", "<Leader>pg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
vim.keymap.set("n", "<Leader>pb", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>ph", "<cmd>Pick help<cr>", { desc = "Pick Help" })

vim.keymap.set("n", "<Leader>e", function()
	require("mini.files").open()
end, { desc = "Explorer" })

vim.keymap.set("n", "<Leader>ll", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing space" })

vim.keymap.set("n", "<Leader>U", function()
	vim.pack.update()
end, { desc = "Pack update" })

vim.keymap.set("n", "<Leader>x", function()
	require("mini.bufremove").delete()
end, { desc = "Remove buffer" })

require("toggleterm").setup({
	sade_terminals = false,
	highlights = {
		Normal = {
			link = "Normal",
		},
		NormalFloat = {
			link = "Normal",
		},
		StatusLine = {
			link = "StatusLine",
		},
		StatusLineNC = {
			link = "StatusLineNC",
		},
	},
})
vim.keymap.set("n", "<Leader>T", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- Auto trim with exclusions
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local exclude_ft = { "markdown", "text" }
		if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
			return
		end

		require("mini.trailspace").trim()
		require("mini.trailspace").trim_last_lines()
	end,
})
