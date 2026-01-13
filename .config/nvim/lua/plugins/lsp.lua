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

	local capabilities = require("blink.cmp").get_lsp_capabilities()

	local function on_attach(_, bufnr)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
		end

		map("n", "gd", vim.lsp.buf.definition, "Definition")
		map("n", "gr", vim.lsp.buf.references, "References")
		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
	end

	-- override config
	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
			},
		},
	})

	for _, name in ipairs({
		"lua_ls",
		"ts_ls",
		"html",
		"cssls",
		"jsonls",
		"phpactor",
		"dockerls",
	}) do
		vim.lsp.enable(name)
	end
end)
