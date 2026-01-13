require("mason").setup()

local servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	"dockerls",
	"intelephense",
	-- "phpactor",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = false,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function on_attach(_, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "Definition")
	map("n", "gr", vim.lsp.buf.references, "References")
	map("n", "K", function()
		vim.lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 })
	end, "Hover documentation")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float({
				focusable = true,
				border = "single",
				scope = "cursor",
			})
		end,
	})
end

-- override config
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
				library = {
					vim.env.VIMRUNTIME,
				},
				maxPreload = 1000,
				preloadFileSize = 150,
			},
			hint = { enable = true },
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
			logging = { level = "verbose" },
		},
	},
})

vim.lsp.config("phpactor", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		phpactor = {
			useComposer = true,
			php_version = "8.1",
			memory_limit = 2048,
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
})

-- CSS
vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- TailwindCSS
vim.lsp.config("tailwindcss", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
			validate = true,
		},
	},
})

for _, name in ipairs(servers) do
	vim.lsp.enable(name)
end
