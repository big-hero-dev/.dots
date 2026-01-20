local add = require("mini.deps").add

add({ source = "echasnovski/mini.nvim" })
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

add({ source = "folke/trouble.nvim" })

add({ source = "mbbill/undotree" })
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undotree" })

add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })

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

local MiniStatusline = require("mini.statusline")

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
				local filename = MiniStatusline.section_filename({ trunc_width = 140 })
				local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
				local location = "%p%%"

				-- LSP names
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
					"%<", -- Mark general truncate point
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=", -- End left alignment
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
}

for _, name in ipairs(order) do
	require("mini." .. name).setup(config[name] or {})
end

-- ======================
-- Notify override
-- ======================

vim.notify = require("mini.notify").make_notify()

-- ======================
-- Mini.bufremove keymaps
-- ======================

vim.keymap.set("n", "<leader>x", function()
	require("mini.bufremove").delete()
end, { desc = "Buffer: Delete" })

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

vim.keymap.set("n", "<Leader>U", "<cmd>DepsUpdate<cr>", { desc = "DepsUpdate" })
