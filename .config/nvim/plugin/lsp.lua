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
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Diagnostic float on hold
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float({
				focusable = false,
				close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" },
				border = "rounded",
				source = "if_many",
				prefix = " ",
				scope = "cursor",
			})
		end,
	})

	-- Document highlight
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

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			format = { enable = false },
			diagnostics = {
				globals = { "vim", "spec", "add" },
				disable = { "missing-fields" },
			},
			runtime = {
				version = "LuaJIT",
				special = { spec = "require" },
			},
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") },
				maxPreload = 1000,
				preloadFileSize = 150,
			},
			hint = {
				enable = true,
				semicolon = "Disable",
				setType = true,
				paramType = true,
				paramName = "All",
				arrayIndex = "Enable",
			},
			codeLens = { enable = true },
			telemetry = { enable = false },
		},
	},
})

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
			inlayHints = {
				parameterNames = {
					enabled = "all",
					suppressWhenArgumentMatchesName = false,
				},
				functionReturnValues = {
					enabled = true,
				},
				propertyDeclarationTypes = {
					enabled = true,
				},
			},
			logging = { level = "verbose" },
		},
	},
})

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
})

vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
		provideFormatter = true,
	},
	filetypes = { "html" },
})

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

vim.lsp.config("jsonls", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		provideFormatter = true,
	},
})

vim.lsp.config("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("emmet_ls", {
	filetypes = {
		"astro",
		"css",
		"eruby",
		"html",
		"htmlangular",
		"htmldjango",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"svelte",
		"typescriptreact",
		"vue",
	},
})

for _, name in ipairs(servers) do
	vim.lsp.enable(name)
end

local signs = {
	Error = "\u{eb1a} ",
	Warn = "\u{f071} ",
	Hint = "\u{f0eb} ",
	Info = "\u{f129} ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
	},
})
