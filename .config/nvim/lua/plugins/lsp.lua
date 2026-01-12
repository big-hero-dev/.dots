local later = require("mini.deps").later

later(function()
	require("mason").setup()

	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"ts_ls",
			"html",
			"cssls",
			"jsonls",
			"phpactor",
			"dockerls",
		},
		automatic_installation = false,
	})

	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local servers = {
		ts_ls = {},
		html = {},
		cssls = {},
		jsonls = {},
		dockerls = {},
		phpactor = {},
		lua_ls = {
			root_dir = require("lspconfig.util").root_pattern(".luarc.json", ".luarc.jsonc", ".git") or vim.fn.getcwd(),
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
				},
			},
		},
	}

	for name, config in pairs(servers) do
		config.capabilities = capabilities
		lspconfig[name].setup(config)
	end
end)
