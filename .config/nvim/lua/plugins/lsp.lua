local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
	dynamicRegistration = true,
	lineFoldingOnly = true,
}

capabilities.textDocument.semanticTokens.multilineTokenSupport = true
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					source = false,
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})
	end,
})

for _, bind in ipairs({ "grn", "gra", "gri", "grr" }) do
	pcall(vim.keymap.del, "n", bind)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		---@diagnostic disable-next-line need-check-nil
		if client.server_capabilities.completionProvider then
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			-- vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
		end
		---@diagnostic disable-next-line need-check-nil
		if client.server_capabilities.definitionProvider then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		-- -- nightly has inbuilt completions, this can replace all completion plugins
		-- if client:supports_method("textDocument/completion", bufnr) then
		--   -- Enable auto-completion
		--   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
		-- end

		--- Disable semantic tokens
		---@diagnostic disable-next-line need-check-nil
		client.server_capabilities.semanticTokensProvider = nil


		-- All the keymaps
		-- stylua: ignore start
		local keymap = vim.keymap.set
		local lsp = vim.lsp
		local opts = { silent = true }
		local function opt(desc, others)
			return vim.tbl_extend("force", opts, { desc = desc }, others or {})
		end
		keymap("n", "gd", lsp.buf.definition, opt("Go to definition"))
		keymap("n", "gD", lsp.buf.type_definition, opt("Go to type definition"))
		keymap("n", "gi", function() lsp.buf.implementation({ border = "single" }) end, opt("Go to implementation"))
		keymap("n", "gr", lsp.buf.references, opt("Show References"))
		keymap("n", "gl", vim.diagnostic.open_float, opt("Open diagnostic in float"))
		keymap("n", "<C-k>", function() lsp.buf.signature_help({border="single"}) end, opts)
		-- disable the default binding first before using a custom one
		pcall(vim.keymap.del, "n", "K", { buffer = ev.buf })
		keymap("n", "K", function() lsp.buf.hover({ border = "single", max_height = 30, max_width = 120 }) end,
			opt("Toggle hover"))
		keymap("n", "<Leader>lS", lsp.buf.workspace_symbol, opt("Workspace Symbols"))
		keymap("n", "<Leader>la", lsp.buf.code_action, opt("Code Action"))
		keymap("n", "<Leader>lh", function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({})) end,
			opt("Toggle Inlayhints"))
		keymap("n", "<Leader>li", vim.cmd.LspInfo, opt("LspInfo"))
		keymap("n", "<Leader>lr", lsp.buf.rename, opt("Rename"))

		-- diagnostic mappings
		keymap("n", "<Leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, opt("Next Diagnostic"))
		keymap("n", "<Leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end, opt("Prev Diagnostic"))
		keymap("n", "<Leader>dq", vim.diagnostic.setloclist, opt("Set LocList"))
		keymap("n", "<Leader>dv", function()
			vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
		end, opt("Toggle diagnostic virtual_lines"))
		-- stylua: ignore end
	end,
})

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			diagnostics = {
				globals = { "vim", "spec", "Snacks" },
			},
			runtime = {
				version = "LuaJIT",
				special = {
					spec = "require",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			hint = {
				enable = true,
				arrayIndex = "Enable", -- "Enable" | "Auto" | "Disable"
				await = true,
				paramName = "All", -- "All" | "Literal" | "Disable"
				paramType = true,
				semicolon = "All", -- "All" | "SameLine" | "Disable"
				setType = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gotempl", "gowork", "gomod" },
	root_markers = { ".git", "go.mod", "go.work", vim.uv.cwd() },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
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

vim.lsp.config.clangd = {
	cmd = {
		"clangd",
		"-j=" .. 2,
		"--background-index",
		"--clang-tidy",
		"--inlay-hints",
		"--fallback-style=llvm",
		"--all-scopes-completion",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--header-insertion-decorators",
		"--pch-storage=memory",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		"CMakeLists.txt",
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
		vim.uv.cwd(),
	},
}
vim.lsp.enable("clangd")

vim.lsp.config.rust_analyzer = {
	filetypes = { "rust" },
	cmd = { "rust-analyzer" },
	workspace_required = true,
	root_dir = function(buf, cb)
		local root = vim.fs.root(buf, { "Cargo.toml", "rust-project.json" })
		local out = vim.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" }, { cwd = root }):wait()
		if out.code ~= 0 then
			return cb(root)
		end

		local ok, result = pcall(vim.json.decode, out.stdout)
		if ok and result.workspace_root then
			return cb(result.workspace_root)
		end

		return cb(root)
	end,
	settings = {
		autoformat = false,
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
}
vim.lsp.enable("rust_analyzer")

vim.lsp.config.tinymist = {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git", vim.uv.cwd() },
}

vim.lsp.enable("tinymist")

vim.lsp.config.bashls = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
	root_markers = { ".git", vim.uv.cwd() },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
}
vim.lsp.enable("bashls")

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

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

vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss" },
	root_markers = { "package.json", ".git" },
	init_options = {
		provideFormatter = true,
	},
}

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
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"postcss.config.mjs",
		"postcss.config.ts",
		"package.json",
		"node_modules",
	},
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

vim.lsp.config.htmlls = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },

	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
}

vim.lsp.enable({ "ts_ls", "cssls", "tailwindcssls", "htmlls" })

vim.api.nvim_create_user_command("LspStart", function()
	vim.cmd.e()
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if opts.args == "" or opts.args == client.name then
			client:stop(true)
			vim.notify(client.name .. ": stopped")
		end
	end
end, {
	desc = "Stop all LSP clients or a specific client attached to the current buffer.",
	nargs = "?",
	complete = function(_, _, _)
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local client_names = {}
		for _, client in ipairs(clients) do
			table.insert(client_names, client.name)
		end
		return client_names
	end,
})

vim.api.nvim_create_user_command("LspRestart", function()
	local detach_clients = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client:stop(true)
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end
	local timer = vim.uv.new_timer()
	if not timer then
		return vim.notify("Servers are stopped but havent been restarted")
	end
	timer:start(
		100,
		50,
		vim.schedule_wrap(function()
			for name, client in pairs(detach_clients) do
				local client_id = vim.lsp.start(client[1].config, { attach = false })
				if client_id then
					for _, buf in ipairs(client[2]) do
						vim.lsp.buf_attach_client(buf, client_id)
					end
					vim.notify(name .. ": restarted")
				end
				detach_clients[name] = nil
			end
			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
	desc = "Get all the lsp logs",
})

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("silent checkhealth vim.lsp")
end, {
	desc = "Get all the information about all LSP attached",
})
