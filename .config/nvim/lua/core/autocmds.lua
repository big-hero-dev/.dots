local autocmd = vim.api.nvim_create_autocmd

-- Basic editor behavior
autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

-- File type specific settings
autocmd("Filetype", {
	pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})
autocmd("Filetype", { pattern = { "python", "rst", "c", "cpp", "php" }, command = "set colorcolumn=80" })
autocmd("Filetype", {
	pattern = { "gitcommit", "markdown", "text", "NeogitCommitMessage" },
	callback = function()
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
autocmd("CmdWinEnter", {
	callback = function()
		vim.cmd("quit")
	end,
})
autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		vim.cmd("checktime")
	end,
})

-- Diagnostics
autocmd("DiagnosticChanged", {
	callback = function()
		if #vim.diagnostic.get(0) > 0 then
			vim.diagnostic.setloclist({ open = false })
		end
		vim.diagnostic.setqflist({ open = false })
	end,
})

-- LuaSnip handling
autocmd("CursorHold", {
	callback = function()
		local ok, luasnip = pcall(require, "luasnip")
		if ok and luasnip.in_snippet() and not luasnip.jumpable(1) then
			pcall(luasnip.unlink_current)
		end
	end,
})

autocmd("FocusGained", {
	callback = function()
		vim.cmd("checktime")
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
	callback = function()
		local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand("%:p"))
		if ok and stats and stats.size > 1000000 then -- > 1MB
			vim.b.large_file = true
			vim.opt_local.swapfile = false
			vim.opt_local.undofile = false
			vim.opt_local.syntax = "off"
			vim.opt_local.foldmethod = "manual"
		end
	end,
})

autocmd("TermOpen", {
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

autocmd("BufWinLeave", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
			vim.cmd("mkview")
		end
	end,
})

autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
			pcall(vim.cmd, "loadview")
		end
	end,
})
