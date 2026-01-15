require("mason").setup()

local servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	"dockerls",
	"intelephense",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = false,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function on_attach(client, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
	map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
	map("n", "gr", vim.lsp.buf.references, "LSP: References")
	map("n", "gi", vim.lsp.buf.implementation, "LSP: Implementation")
	map("n", "gt", vim.lsp.buf.type_definition, "LSP: Type definition")

	map("n", "K", function()
		vim.lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 })
	end, "LSP: Hover")

	map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
	map({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP: Code action")
	map("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, "LSP: Format")

	-- Auto show diagnostics on cursor hold
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = true,
				border = "single",
				scope = "cursor",
				source = "if_many",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})

	-- Highlight symbol under cursor
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

-- Lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			format = { enable = false },
			diagnostics = {
				globals = { "vim", "spec", "add", "MiniDeps" },
				disable = { "missing-fields" },
			},
			runtime = {
				version = "LuaJIT",
				special = { spec = "require" },
				path = vim.split(package.path, ";"),
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
				maxPreload = 1000,
				preloadFileSize = 150,
			},
			hint = {
				enable = true,
				semicolon = "Disable",
			},
			codeLens = { enable = true },
			telemetry = { enable = false },
		},
	},
})

-- PHP - Intelephense
vim.lsp.config("intelephense", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		intelephense = {
			storagePath = vim.fn.stdpath("cache") .. "/intelephense",
			files = {
				maxSize = 1000000,
			},
			diagnostics = { enable = true },
			logging = { level = "verbose" },
		},
	},
})

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
})

-- HTML
vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
		provideFormatter = true,
	},
	filetypes = { "html", "templ" },
})

-- CSS/SCSS/LESS
vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		provideFormatter = true,
	},
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})

-- JSON
vim.lsp.config("jsonls", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		provideFormatter = true,
	},
})

-- Docker
vim.lsp.config("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Enable all configured servers
for _, name in ipairs(servers) do
	vim.lsp.enable(name)
end

-- Global diagnostic config
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "single",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- Diagnostic signs
local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
