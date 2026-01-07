local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add("neovim/nvim-lspconfig")
	add("williamboman/mason.nvim") -- LSP installer
	add("williamboman/mason-lspconfig.nvim") -- Bridge mason & lspconfig

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"clangd",
			"rust_analyzer",
			"html",
			"cssls",
			"intelephense",
		},
		automatic_installation = true,
	})

	-- =====================================================================
	-- LSP CONFIGURATION with nvim-lspconfig plugin
	-- =====================================================================

	-- ── Capabilities ─────────────────────────────────────────────────────
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- ── Folding Range ─────────────────────────────────────────────────────
	capabilities.textDocument = capabilities.textDocument or {}
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = true,
		lineFoldingOnly = true,
	}

	-- ── Snippet Support ──────────────────────────────────────────────────
	if capabilities.textDocument.completion and capabilities.textDocument.completion.completionItem then
		capabilities.textDocument.completion.completionItem.snippetSupport = true
	end

	-- ── Global LSP on_attach function ────────────────────────────────────
	local function on_attach(client, bufnr)
		-- Disable semantic tokens for performance
		client.server_capabilities.semanticTokensProvider = nil

		-- Enable completion & tagfunc if supported
		if client.server_capabilities.completionProvider then
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
		if client.server_capabilities.definitionProvider then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		-- Show diagnostics on hover
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				vim.diagnostic.open_float({ focusable = false })
			end,
		})

		-- Keymaps
		local keymap = vim.keymap.set
		local lsp = vim.lsp
		local opts = { buffer = bufnr, silent = true }
		local function opt(desc, others)
			return vim.tbl_extend("force", opts, { desc = desc }, others or {})
		end

		-- ── Navigation ───────────────────────────────────────────────────
		keymap("n", "gd", lsp.buf.definition, opt("Go to definition"))
		keymap("n", "gD", lsp.buf.type_definition, opt("Go to type definition"))
		keymap("n", "gi", lsp.buf.implementation, opt("Go to implementation"))
		keymap("n", "gr", lsp.buf.references, opt("Show References"))
		keymap("n", "gI", lsp.buf.incoming_calls, opt("Incoming calls"))
		keymap("n", "gO", lsp.buf.outgoing_calls, opt("Outgoing calls"))

		-- Alternative navigation with <Leader>g
		keymap("n", "<Leader>gd", lsp.buf.definition, opt("Go to definition"))
		keymap("n", "<Leader>gt", lsp.buf.type_definition, opt("Go to type definition"))
		keymap("n", "<Leader>gi", lsp.buf.implementation, opt("Go to implementation"))
		keymap("n", "<Leader>gr", lsp.buf.references, opt("Show references"))

		-- ── Hover & Documentation ────────────────────────────────────────
		keymap("n", "K", function()
			lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 })
		end, opt("Hover documentation"))
		keymap("n", "<C-k>", lsp.buf.signature_help, opt("Signature help"))
		keymap("i", "<C-k>", lsp.buf.signature_help, opt("Signature help (insert)"))

		-- ── LSP Actions ──────────────────────────────────────────────────
		keymap({ "n", "v" }, "<Leader>la", lsp.buf.code_action, opt("Code Action"))
		keymap("n", "<Leader>lA", function()
			lsp.buf.code_action({
				context = { only = { "source" }, diagnostics = vim.diagnostic.get(0) },
				apply = false,
			})
		end, opt("Source Actions"))
		keymap("n", "<Leader>lr", lsp.buf.rename, opt("Rename symbol"))
		keymap("n", "<Leader>lR", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { buffer = bufnr, expr = true, desc = "Incremental rename" })

		-- ── Formatting ───────────────────────────────────────────────────
		keymap({ "n", "v" }, "<Leader>lf", function()
			lsp.buf.format({ async = true })
		end, opt("Format"))
		keymap("n", "<Leader>lF", function()
			lsp.buf.format({ async = true, range = nil })
		end, opt("Format file"))

		-- ── Workspace & Symbols ──────────────────────────────────────────
		keymap("n", "<Leader>lS", lsp.buf.workspace_symbol, opt("Workspace Symbols"))
		keymap("n", "<Leader>ls", lsp.buf.document_symbol, opt("Document Symbols"))
		keymap("n", "<Leader>lw", function()
			print(vim.inspect(lsp.buf.list_workspace_folders()))
		end, opt("List workspace folders"))
		keymap("n", "<Leader>lW", lsp.buf.add_workspace_folder, opt("Add workspace folder"))

		-- ── Inlay Hints & Features ───────────────────────────────────────
		keymap("n", "<Leader>lh", function()
			lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, opt("Toggle Inlay Hints"))
		keymap("n", "<Leader>lH", function()
			-- Toggle inlay hints globally
			local enabled = lsp.inlay_hint.is_enabled()
			lsp.inlay_hint.enable(not enabled)
			vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled") .. " globally")
		end, opt("Toggle Inlay Hints (global)"))

		-- ── LSP Info & Control ───────────────────────────────────────────
		keymap("n", "<Leader>li", "<cmd>LspInfo<cr>", opt("LSP Info"))
		keymap("n", "<Leader>ll", "<cmd>LspLog<cr>", opt("LSP Log"))
		keymap("n", "<Leader>lq", "<cmd>LspRestart<cr>", opt("Restart LSP"))

		-- ── Diagnostics ──────────────────────────────────────────────────
		keymap("n", "gl", vim.diagnostic.open_float, opt("Open diagnostic float"))
		keymap("n", "<Leader>dl", vim.diagnostic.open_float, opt("Show line diagnostics"))
		keymap("n", "<Leader>dq", vim.diagnostic.setloclist, opt("Diagnostics to LocList"))
		keymap("n", "<Leader>dQ", vim.diagnostic.setqflist, opt("Diagnostics to QuickFix"))

		-- Diagnostic navigation
		keymap("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opt("Previous diagnostic"))
		keymap("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opt("Next diagnostic"))
		keymap("n", "[e", function()
			vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
		end, opt("Previous error"))
		keymap("n", "]e", function()
			vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
		end, opt("Next error"))
		keymap("n", "[w", function()
			vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
		end, opt("Previous warning"))
		keymap("n", "]w", function()
			vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
		end, opt("Next warning"))

		-- Legacy diagnostic navigation (keep for compatibility)
		keymap("n", "<Leader>dn", function()
			vim.diagnostic.jump({ count = 1 })
		end, opt("Next diagnostic"))
		keymap("n", "<Leader>dp", function()
			vim.diagnostic.jump({ count = -1 })
		end, opt("Previous diagnostic"))

		-- ── Diagnostic Control ───────────────────────────────────────────
		keymap("n", "<Leader>dt", function()
			vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, opt("Toggle diagnostics (buffer)"))
		keymap("n", "<Leader>dT", function()
			local enabled = vim.diagnostic.is_enabled()
			vim.diagnostic.enable(not enabled)
			vim.notify("Diagnostics " .. (enabled and "disabled" or "enabled") .. " globally")
		end, opt("Toggle diagnostics (global)"))
		keymap("n", "<Leader>dv", function()
			local config = vim.diagnostic.config()
			local current_vt = false
			if config and config.virtual_text then
				current_vt = true
			end
			vim.diagnostic.config({
				virtual_text = not current_vt,
				virtual_lines = false,
			})
		end, opt("Toggle virtual text"))
		keymap("n", "<Leader>dV", function()
			local config = vim.diagnostic.config()
			local current_vt = false
			if config and config.virtual_text then
				current_vt = true
			end
			vim.diagnostic.config({
				virtual_lines = not current_vt,
				virtual_text = false,
			})
		end, opt("Toggle virtual lines"))

		keymap("n", "<Leader>rn", lsp.buf.rename, opt("Rename (quick)"))
	end

	-- ── Setup lspconfig ──────────────────────────────────────────────────
	local lspconfig = require("lspconfig")

	-- Default config for all servers
	local default_config = {
		capabilities = capabilities,
		on_attach = on_attach,
	}

	-- =====================================================================
	-- Language Servers
	-- =====================================================================

	-- Lua
	lspconfig.lua_ls.setup(vim.tbl_extend("force", default_config, {
		settings = {
			Lua = {
				format = { enable = false },
				diagnostics = {
					globals = { "vim", "spec", "Snacks", "add", "MiniDeps" },
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
	}))
	-- Go
	lspconfig.gopls.setup(vim.tbl_extend("force", default_config, {
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = { unusedparams = true },
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	}))

	-- C/C++
	lspconfig.clangd.setup(vim.tbl_extend("force", default_config, {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
	}))

	-- Rust
	lspconfig.rust_analyzer.setup(vim.tbl_extend("force", default_config, {
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
					loadOutDirsFromCheck = true,
					runBuildScripts = true,
				},
				checkOnSave = {
					allFeatures = true,
					command = "clippy",
					extraArgs = { "--no-deps" },
				},
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
					},
				},
			},
		},
	}))

	-- TypeScript/JavaScript
	lspconfig.ts_ls.setup(vim.tbl_extend("force", default_config, {
		init_options = {
			preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	}))

	-- CSS
	lspconfig.cssls.setup(default_config)

	-- HTML
	lspconfig.html.setup(vim.tbl_extend("force", default_config, {
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		},
	}))

	-- TailwindCSS
	lspconfig.tailwindcss.setup(vim.tbl_extend("force", default_config, {
		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
				validate = true,
			},
		},
	}))

	-- Bash
	lspconfig.bashls.setup(default_config)

	-- PHP
	lspconfig.intelephense.setup(vim.tbl_extend("force", default_config, {
		settings = {
			intelephense = {
				storagePath = vim.fn.stdpath("cache") .. "/intelephense",
				files = {
					maxSize = 1000000,
				},
			},
		},
	}))

	-- Python (if you need it)
	-- lspconfig.pyright.setup(default_config)

	-- JSON
	lspconfig.jsonls.setup(default_config)

	-- YAML
	lspconfig.yamlls.setup(default_config)
end)
