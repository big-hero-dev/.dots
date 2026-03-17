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

	if client.server_capabilities.documentHighlightProvider then
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

for _, name in ipairs(servers) do
	vim.lsp.enable(name)
end

vim.api.nvim_set_hl(0, "LspInlayHint", {
	fg = "#7c7c7c",
	bg = "NONE",
	italic = true,
})
