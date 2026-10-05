require("mason").setup()

local servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
	"dockerls",
	"intelephense",
	"pyright",
	"ruff",
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
				source = "if_many",
				prefix = " ",
				scope = "cursor",
				border = vim.g.border,
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

-- Server configs
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			format = { enable = false },
			diagnostics = {
				globals = { "vim" },
				disable = { "missing-fields" },
			},
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") },
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
			files = { maxSize = 5000000 },
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
		},
	},
})

vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("jsonls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

local function get_python_path(root_dir)
	-- 1. venv đang được activate
	if vim.env.VIRTUAL_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/python"
	end
	-- 2. .venv / venv nằm trong project
	if root_dir then
		for _, name in ipairs({ ".venv", "venv" }) do
			local path = root_dir .. "/" .. name .. "/bin/python"
			if vim.uv.fs_stat(path) then
				return path
			end
		end
	end
	-- 3. fallback
	return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

vim.lsp.config("pyright", {
	before_init = function(_, config)
		config.settings = config.settings or {}
		config.settings.python = config.settings.python or {}
		config.settings.python.pythonPath = get_python_path(config.root_dir)
	end,
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
				},
			},
		},
	},
})

for _, name in ipairs(servers) do
	vim.lsp.enable(name)
end

-- Diagnostic signs
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	virtual_text = false,
	underline = true,
	update_in_insert = false,
})

-- Endhints
pcall(require, "lsp-endhints")
pcall(function()
	require("lsp-endhints").setup()
end)
