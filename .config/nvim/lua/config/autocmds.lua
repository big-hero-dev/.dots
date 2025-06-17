local autocmd = vim.api.nvim_create_autocmd

-- Basic editor behavior
autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })
autocmd("BufWinEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})
autocmd("BufWritePre", { pattern = "", command = ":%s/\\s\\+$//e" })
autocmd("BufWritePre", { pattern = "", command = ":silent lua vim.lsp.buf.format()" })

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

-- UI enhancements
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
	end,
})
autocmd(
	{ "BufWinLeave" },
	{ pattern = "*", command = "if expand('%') != '' && &buftype != 'terminal' | mkview | endif" }
)
autocmd(
	{ "BufWinEnter" },
	{ pattern = "*", command = "if expand('%') != '' && &buftype != 'terminal' | silent! loadview | endif" }
)

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
		vim.cmd("nnoremap <silent> <buffer> q :close<CR> | set nobuflisted")
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
		if ok and luasnip.expand_or_jumpable() then
			luasnip.unlink_current()
		end
	end,
})
