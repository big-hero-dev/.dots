local MiniDeps = require("mini.deps")
local add = MiniDeps.add
add({ source = "neovim/nvim-lspconfig" })

local function on_attach(_, bufnr)
	local map = function(key, func, desc)
		vim.keymap.set("n", key, func, { buffer = bufnr, desc = desc, silent = true })
	end

	map("gd", vim.lsp.buf.definition, "Go to Definition")
	map("gD", vim.lsp.buf.declaration, "Go to Declaration")
	map("gr", vim.lsp.buf.references, "Go to References")
	map("gi", vim.lsp.buf.implementation, "Go to Implementation")
	map("K", function()
		vim.lsp.buf.hover({ border = "single" })
	end, "Hover Documentation")
	map("<C-k>", function()
		vim.lsp.buf.signature_help({ border = "single" })
	end, "Signature Help")
	map("<leader>rn", vim.lsp.buf.rename, "Rename")
	map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

-- Auto-load LSP servers from lua/lsp/*.lua
local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
local lsp_files = vim.fn.glob(lsp_path .. "/*.lua", false, true)

for _, file in ipairs(lsp_files) do
	local server_name = vim.fn.fnamemodify(file, ":t:r")
	local ok, config = pcall(require, "lsp." .. server_name)

	if ok then
		config.on_attach = on_attach
		require("lspconfig")[server_name].setup(config)
	end
end
