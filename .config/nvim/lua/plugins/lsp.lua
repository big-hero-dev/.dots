-- =====================================================================
-- LSP CONFIGURATION (Neovim >= 0.11)
-- =====================================================================

-- ── Capabilities ─────────────────────────────────────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
	dynamicRegistration = true,
	lineFoldingOnly = true,
}
capabilities.textDocument.semanticTokens = {
	multilineTokenSupport = true,
}
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Apply default config to all servers
vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = function(_, bufnr)
		-- Show diagnostics on hover
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				vim.diagnostic.open_float()
			end,
		})
	end,
})

-- ── Global LSP Keymaps (on attach) ───────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		-- Enable completion & tagfunc if supported
		if client.server_capabilities.completionProvider then
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
		if client.server_capabilities.definitionProvider then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		-- Disable semantic tokens (for performance)
		client.server_capabilities.semanticTokensProvider = nil

		-- Keymaps
		local keymap = vim.keymap.set
		local lsp = vim.lsp
		local opts = { silent = true }
		local function opt(desc, others)
			return vim.tbl_extend("force", opts, { desc = desc }, others or {})
		end

		keymap("n", "gd", lsp.buf.definition, opt("Go to definition"))
		keymap("n", "gD", lsp.buf.type_definition, opt("Go to type definition"))
		keymap("n", "gi", lsp.buf.implementation, opt("Go to implementation"))
		keymap("n", "gr", lsp.buf.references, opt("Show References"))
		keymap("n", "gl", vim.diagnostic.open_float, opt("Open diagnostic in float"))
		keymap("n", "<C-k>", lsp.buf.signature_help, opts)
		keymap("n", "K", function()
			lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 })
		end, opt("Hover"))

		-- More LSP mappings
		keymap("n", "<Leader>lS", lsp.buf.workspace_symbol, opt("Workspace Symbols"))
		keymap("n", "<Leader>la", lsp.buf.code_action, opt("Code Action"))
		keymap("n", "<Leader>lh", function()
			lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({}))
		end, opt("Toggle Inlay Hints"))
		keymap("n", "<Leader>li", vim.cmd.LspInfo, opt("LspInfo"))
		keymap("n", "<Leader>lr", lsp.buf.rename, opt("Rename"))

		-- Diagnostic navigation
		keymap("n", "<Leader>dn", function()
			vim.diagnostic.jump({ count = 1 })
		end, opt("Next Diagnostic"))
		keymap("n", "<Leader>dp", function()
			vim.diagnostic.jump({ count = -1 })
		end, opt("Prev Diagnostic"))
		keymap("n", "<Leader>dq", vim.diagnostic.setloclist, opt("Diagnostics to LocList"))
		keymap("n", "<Leader>dv", function()
			vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
		end, opt("Toggle Virtual Lines"))
	end,
})

-- ── Helper: Root dir finder ──────────────────────────────────────────
local function root_dir(patterns)
	return function(fname)
		return vim.fs.dirname(vim.fs.find(patterns, { upward = true, path = fname })[1]) or vim.uv.cwd()
	end
end

-- =====================================================================
-- Language Servers
-- =====================================================================

-- Lua
vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = root_dir({ ".luarc.json", ".git" }),
	settings = {
		Lua = {
			format = { enable = false },
			diagnostics = { globals = { "vim", "spec", "Snacks" } },
			runtime = { version = "LuaJIT", special = { spec = "require" } },
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			hint = {
				enable = true,
				arrayIndex = "Enable",
				await = true,
				paramName = "All",
				paramType = true,
				semicolon = "All",
				setType = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")

-- Go
vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gotempl", "gowork", "gomod" },
	root_dir = root_dir({ "go.mod", "go.work", ".git" }),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = { unusedparams = true },
			["ui.inlayhint.hints"] = {
				compositeLiteralFields = true,
				constantValues = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
vim.lsp.enable("gopls")

-- C / C++
vim.lsp.config.clangd = {
	cmd = {
		"clangd",
		"-j=2",
		"--background-index",
		"--clang-tidy",
		"--inlay-hints",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_dir = root_dir({ "CMakeLists.txt", ".clangd", ".git" }),
}
vim.lsp.enable("clangd")

-- Rust
vim.lsp.config.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = root_dir({ "Cargo.toml", "rust-project.json", ".git" }),
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
}
vim.lsp.enable("rust_analyzer")

-- Typst
vim.lsp.config.tinymist = {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_dir = root_dir({ ".git" }),
}
vim.lsp.enable("tinymist")

-- Bash
vim.lsp.config.bashls = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
	root_dir = root_dir({ ".git" }),
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
}
vim.lsp.enable("bashls")

-- JavaScript / TypeScript
vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = root_dir({ "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
	init_options = {
		hostInfo = "neovim",
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
			importModuleSpecifierPreference = "non-relative",
		},
	},
}
vim.lsp.enable("ts_ls")

-- CSS
vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss" },
	root_dir = root_dir({ "package.json", ".git" }),
	init_options = { provideFormatter = true },
}
vim.lsp.enable("cssls")

-- TailwindCSS
vim.lsp.config.tailwindcssls = {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"ejs",
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_dir = root_dir({
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"package.json",
		"node_modules",
		".git",
	}),
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
			includeLanguages = {
				eelixir = "html-eex",
				eruby = "erb",
				htmlangular = "html",
				templ = "html",
			},
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
}
vim.lsp.enable("tailwindcssls")

-- HTML
vim.lsp.config.htmlls = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_dir = root_dir({ "package.json", ".git" }),
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = { css = true, javascript = true },
		provideFormatter = true,
	},
}
vim.lsp.enable("htmlls")

-- PHP (Intelephense)
vim.lsp.config.intelephense = {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_dir = root_dir({ "composer.json", ".git" }),
	settings = {
		intelephense = {
			storagePath = vim.fn.stdpath("cache") .. "/intelephense",
		},
	},
}
vim.lsp.enable("intelephense")

-- =====================================================================
-- User Commands
-- =====================================================================
vim.api.nvim_create_user_command("LspStart", function()
	vim.cmd.e()
end, { desc = "Start LSP in current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if opts.args == "" or opts.args == client.name then
			client:stop(true)
			vim.notify(client.name .. ": stopped")
		end
	end
end, {
	desc = "Stop LSP client(s)",
	nargs = "?",
	complete = function()
		return vim.tbl_map(function(c)
			return c.name
		end, vim.lsp.get_clients({ bufnr = 0 }))
	end,
})

vim.api.nvim_create_user_command("LspRestart", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		client:stop(true)
	end
	vim.defer_fn(function()
		vim.cmd.e()
	end, 200)
end, { desc = "Restart LSP client(s)" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.vsplit(vim.lsp.log.get_filename())
end, { desc = "Open LSP log file" })

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("silent checkhealth vim.lsp")
end, { desc = "Check LSP health" })
