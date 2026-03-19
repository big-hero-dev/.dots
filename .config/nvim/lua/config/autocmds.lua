local autocmd = vim.api.nvim_create_autocmd

-- File type specific settings
autocmd("FileType", {
	pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
	callback = function(_)
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

autocmd("FileType", {
	pattern = { "gitcommit", "markdown", "text", "NeogitCommitMessage" },
	callback = function(_)
		vim.opt_local.wrap = true
		vim.opt_local.spell = false
	end,
})

-- ╭──────────────────────────────────────╮
-- │ UI Enhancements                      │
-- ╰──────────────────────────────────────╯
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
	end,
})

-- Special buffer handling
autocmd("FileType", {
	pattern = {
		"netrw",
		"Jaq",
		"qf",
		"git",
		"help",
		"man",
		"lspinfo",
		"oil",
		"spectre_panel",
		"lir",
		"DressingSelect",
		"tsplayground",
		"",
	},
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true, desc = "Close special buffer" })
	end,
})

-- Window management
autocmd("CmdwinEnter", {
	desc = "Disable command-line window",
	callback = function()
		vim.cmd("quit")
	end,
})
autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Diagnostics
local diag_timer = nil
autocmd("DiagnosticChanged", {
	callback = function()
		if diag_timer then
			diag_timer:stop()
		end
		diag_timer = vim.defer_fn(function()
			vim.diagnostic.setloclist({ open = false })
			vim.diagnostic.setqflist({ open = false })
		end, 200)
	end,
})

-- LuaSnip handling
local luasnip = nil
autocmd("CursorHold", {
	callback = function()
		if not luasnip then
			local ok, ls = pcall(require, "luasnip")
			if not ok then
				return
			end
			luasnip = ls
		end
		if luasnip.in_snippet() and not luasnip.jumpable(1) then
			pcall(luasnip.unlink_current)
		end
	end,
})

autocmd("FocusGained", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

autocmd("BufWritePre", {
	callback = function(args)
		local dir = vim.fn.fnamemodify(args.file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

autocmd("BufReadPre", {
	pattern = "*",
	callback = function(args)
		local ok, stats = pcall(vim.uv.fs_stat, args.match)
		if ok and stats and stats.size > 1000000 then -- > 1MB
			vim.b.large_file = true
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.signcolumn = "no"
			vim.opt_local.spell = false
			vim.opt_local.swapfile = false
			vim.opt_local.syntax = "off"
			vim.opt_local.undofile = false
			vim.treesitter.stop()
		end
	end,
})

autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

autocmd("BufWinLeave", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
			vim.cmd("silent! mkview")
		end
	end,
})

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" then
			vim.cmd("silent! loadview")
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("enew")
		end
		vim.defer_fn(function()
			require("config.lsp")
		end, 10)
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		io.write("\27[3 q")
	end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("luasnip").setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = false,
		})
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_lua").lazy_load()
	end,
})
