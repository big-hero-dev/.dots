local M = {}

--------------------------------------------------------------------------
-- CORE
--------------------------------------------------------------------------
function M.setup_core()
	pcall(function()
		require("vim._core.ui2").enable({})
	end)

	-- Colorscheme
	vim.o.background = "dark"
	require("gruvbox").setup({
		terminal_colors = true,
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
			strings = true,
			comments = true,
			operators = false,
			folds = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		invert_intend_guides = false,
		inverse = true,
		contrast = "hard", -- "hard", "soft", or "" for default
		dim_inactive = false,
		transparent_mode = false,
	})
	vim.cmd.colorscheme("gruvbox")

	-- LSP cache for statusline
	local lsp_cache = {}

	local function update_lsp_cache(bufnr)
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		local names = {}
		for _, client in ipairs(clients) do
			names[#names + 1] = client.name
		end
		lsp_cache[bufnr] = #names > 0 and ("󰭆 " .. table.concat(names, " ")) or ""
	end

	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		group = vim.api.nvim_create_augroup("statusline_lsp", { clear = true }),
		callback = function(args)
			update_lsp_cache(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		group = vim.api.nvim_create_augroup("statusline_lsp_clean", { clear = true }),
		callback = function(args)
			lsp_cache[args.buf] = nil
		end,
	})

	-- Mini modules needed immediately so statusline / tabline / icons render correctly
	require("mini.basics").setup({
		options = { basic = false },
		mappings = { basic = false },
		autocommands = { basic = false },
	})
	require("mini.icons").setup({})
	require("mini.git").setup({})
	require("mini.diff").setup({})
	require("mini.statusline").setup({
		content = {
			active = function()
				local MiniStatusline = require("mini.statusline")
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git = MiniStatusline.section_git({ trunc_width = 40 })
				local diff = MiniStatusline.section_diff({ trunc_width = 75 })
				local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })
				local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
				local location = MiniStatusline.section_location({ trunc_width = 75 })
				local lsp_info = lsp_cache[vim.api.nvim_get_current_buf()] or ""

				return MiniStatusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
					"%<",
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=",
					{ hl = "MiniStatuslineFileinfo", strings = { lsp_info } },
					{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
					{ hl = mode_hl, strings = { location } },
				})
			end,
		},
		set_vim_settings = true,
	})
	require("mini.tabline").setup({})

	-- vim.notify needs to be ready early (mason/lsp may notify right at startup)
	require("mini.notify").setup({
		window = { config = { border = vim.g.border } },
	})
	vim.notify = require("mini.notify").make_notify()
end

--------------------------------------------------------------------------
-- DEFERRED: doesn't need to exist before the first screen is shown.
-- Called via vim.schedule() from pack.lua (next event loop tick), so it
-- isn't counted in measured startup time but still runs effectively
-- instantly, before the user gets a chance to press any key.
--------------------------------------------------------------------------
function M.setup_deferred()
	local config = {
		bufremove = {},
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
	}
	for _, name in ipairs(order) do
		require("mini." .. name).setup(config[name] or {})
	end

	-- Mini.clue (which-key like)
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
		},
	})

	-- Mini.pick
	require("mini.pick").setup({})
	vim.keymap.set("n", "<Leader><Leader>", "<cmd>Pick files<cr>", { desc = "Pick files" })
	vim.keymap.set("n", "<Leader>pg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
	vim.keymap.set("n", "<Leader>pb", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
	vim.keymap.set("n", "<Leader>ph", "<cmd>Pick help<cr>", { desc = "Help" })

	-- Keymaps for other mini modules
	vim.keymap.set("n", "<Leader>c", function()
		require("mini.bufremove").delete()
	end, { desc = "Remove buffer" })

	vim.keymap.set("n", "<Leader>ll", function()
		require("mini.trailspace").trim()
	end, { desc = "Trim trailing space" })
end

function M.cmdline()
	require("vim._core.ui2").enable({})
	require("tiny-cmdline").setup({
		on_reposition = require("tiny-cmdline").adapters.blink,
		native_types = {},
		border = vim.g.border,
	})
end

return M
