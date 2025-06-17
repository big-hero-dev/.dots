local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "neovim/nvim-lspconfig" })

local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
local lsp_servers = vim.fn.glob(lsp_path .. "/*.lua", false, true)

local function on_attach(_, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
	map("gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
	map("gr", vim.lsp.buf.references, "[G]o to [R]eferences")
	map("gi", vim.lsp.buf.implementation, "[G]o to [I]mplementation")

	map("K", function()
		vim.lsp.buf.hover({ border = "single" })
	end, "Hover Documentation")
	map("<C-k>", function()
		vim.lsp.buf.signature_help({ border = "single" })
	end, "Signature Help")

	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
end

for _, file in ipairs(lsp_servers) do
	local module_name = file
		:gsub(vim.fn.stdpath("config") .. "/lua/", "") -- remove leading path
		:gsub("%.lua$", "") -- remove extension
		:gsub("/", ".") -- convert to module path
	local server_name = module_name:match("lsp%.(.+)$") -- extract server name, e.g., "lua_ls"
	local ok, config = pcall(require, module_name)
	if ok then
		config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
		config.on_attach = on_attach
		require("lspconfig")[server_name].setup(config)
	else
		vim.notify("Error: Failed to load LSP config for " .. server_name, vim.log.levels.ERROR)
	end
end
