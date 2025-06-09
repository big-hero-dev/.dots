---@diagnostic disable: undefined-global, undefined-field
-- Define path constants upfront
local data_path = vim.fn.stdpath("data")
local path_package = data_path .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"

-- Basic UI settings
vim.o.termguicolors = true
vim.g.border = "single"

-- Auto-install mini.nvim if not present
if not vim.loop.fs_stat(mini_path) then
	vim.notify("Installing mini.nvim", vim.log.levels.INFO)
	local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
	local success = vim.fn.system(clone_cmd)
	if success then
		vim.Cmd("packadd mini.nvim | helptags ALL")
		vim.notify("Installed mini.nvim", vim.log.levels.INFO)
	else
		vim.notify("Failed to install mini.nvim", vim.log.levels.ERROR)
	end
end

-- Load mini.deps and destructure functions
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Group all basic settings into one function
now(function()
	-- Initialize basic mini plugins
	local mini_basic_plugins = {
		notify = { config = {} },
		tabline = { config = {} },
		files = {
			config = {
				mappings = {
					go_in = "i",
					go_in_plug = "I",
				},
			},
		},
		basics = { config = {} },
		icons = { config = {} },
	}

	-- Setup basic plugins with their configurations
	for plugin, options in pairs(mini_basic_plugins) do
		require("mini." .. plugin).setup(options.config)
	end

	-- Set notify after loading it
	vim.notify = require("mini.notify").make_notify()
end)

-- Consolidate all standard mini plugins with default setup
later(function()
	-- List of mini plugins with default setup
	local standard_mini_plugins = {
		"ai",
		"align",
		"animate",
		"comment",
		"cursorword",
		"extra",
		"git",
		"pairs",
		"pick",
		"surround",
		"trailspace",
		"splitjoin",
	}

	-- Setup all standard plugins
	for _, plugin in ipairs(standard_mini_plugins) do
		require("mini." .. plugin).setup()
	end

	-- Specialized mini plugin configurations
	local specialized_mini_plugins = {
		move = {
			mappings = {
				left = "<M-h>",
				right = "<M-i>",
				down = "<M-n>",
				up = "<M-e>",
				line_left = "<M-h>",
				line_right = "<M-i>",
				line_down = "<M-n>",
				line_up = "<M-e>",
			},
		},
		jump2d = { mappings = { start_jumping = "f" } },
		indentscope = {
			symbol = "│",
			options = { try_as_border = true },
		},
		hipatterns = {
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		},
	}

	-- Setup specialized plugins with their configurations
	for plugin, config in pairs(specialized_mini_plugins) do
		require("mini." .. plugin).setup(config)
	end

	-- Clue
	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},
	})
end)

-- Custom plugins installation and setup
now(function()
	-- Group all custom plugins with their dependencies
	local custom_plugins = {
		{ source = "alexxGmZ/e-ink.nvim" },
		{ source = "dstein64/vim-startuptime" },
		{ source = "lewis6991/gitsigns.nvim" },
		{ source = "mbbill/undotree" },
		{ source = "nvim-tree/nvim-web-devicons" },
		{
			source = "m4xshen/hardtime.nvim",
			depends = { "MunifTanjim/nui.nvim" },
		},
		-- LSP setup
		{
			source = "neovim/nvim-lspconfig",
			depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		},
	}

	-- Add all plugins at once
	for _, plugin in ipairs(custom_plugins) do
		add(plugin)
	end

	-- Apply theme
	vim.cmd.colorscheme("e-ink")

	-- Hardtime setup
	require("hardtime").setup()

	-- Configure gitsigns
	require("gitsigns").setup({ current_line_blame = true })

	-- LSP setup
	local function setup_lsp()
		local server_names = {
			"ts_ls",
			"lua_ls",
			"cssls",
			"html",
			"jsonls",
			"eslint",
			"emmet_ls",
		}

		-- Setup Mason first
		require("mason").setup({ ui = { border = vim.g.border } })
		require("mason-lspconfig").setup({
			ensure_installed = server_names,
			automatic_installation = true,
		})

		-- LSP common capabilities
		local function common_capabilities()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			return capabilities
		end

		-- LSP on_attach function with keymaps
		local function on_attach(client, bufnr)
			local keymap_opts = { buffer = true, noremap = true, silent = true }

			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = false,
				float = {
					border = vim.g.border,
				},
				underline = true,
				jump = {
					float = true,
				},
			})

			vim.api.nvim_create_autocmd("CursorHold", {
				buffer = bufnr,
				callback = function()
					local opts = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						source = "always",
						prefix = " ",
						scope = "cursor",
					}
					vim.diagnostic.open_float(nil, opts)
				end,
			})

			local custom_util_open_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or vim.g.border
				return custom_util_open_floating_preview(contents, syntax, opts, ...)
			end

			-- The blow command will highlight the current variable and its usages in the buffer.
			if client.server_capabilities.documentHighlightProvider then
				vim.cmd([[
					hi! link LspReferenceRead Visual
					hi! link LspReferenceText Visual
					hi! link LspReferenceWrite Visual
					]])

				local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
				vim.api.nvim_create_autocmd("CursorHold", {
					group = gid,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.document_highlight()
					end,
				})

				vim.api.nvim_create_autocmd("CursorMoved", {
					group = gid,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.clear_references()
					end,
				})
			end

			local lsp_keymaps = {
				{ mode = "n", key = "<Leader>ca", fn = vim.lsp.buf.code_action, desc = "LSP Code Actions" },
				{
					mode = "n",
					key = "<Leader>r",
					fn = function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end,
					expr = true,
					desc = "LSP Rename",
				},
				{ mode = "n", key = "gd", fn = vim.lsp.buf.definition, desc = "Go to Definition" },
				{ mode = "n", key = "gD", fn = vim.lsp.buf.declaration, desc = "Go to Declaration" },
				{ mode = "n", key = "gi", fn = vim.lsp.buf.implementation, desc = "Go to Implementation" },
				{ mode = "n", key = "gt", fn = vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
				{ mode = "n", key = "H", fn = vim.lsp.buf.hover, desc = "Hover Documentation" },
				{ mode = "i", key = "<C-k>", fn = vim.lsp.buf.signature_help, desc = "Signature Help" },
				{
					mode = "n",
					key = "gr",
					fn = function()
						if not vim.lsp.buf.references() then
							require("mini.pick").builtin.lsp({ kind = "references" })
						else
							vim.notify("No references found", vim.log.levels.INFO)
						end
					end,
					desc = "LSP References",
				},
			}

			for _, map in ipairs(lsp_keymaps) do
				local opts = vim.tbl_extend("force", keymap_opts, {
					desc = map.desc,
					expr = map.expr,
				})
				vim.keymap.set(map.mode, map.key, map.fn, opts)
			end
		end

		-- Additional LSP plugins
		add({ source = "smjonas/inc-rename.nvim" })
		require("inc_rename").setup()

		add({ source = "folke/trouble.nvim" })
		require("trouble").setup()

		add({ source = "sphamba/smear-cursor.nvim" })
		require("smear_cursor").setup()

		-- Configure LSP servers
		local lspconfig = require("lspconfig")
		local servers = require("mason-lspconfig").get_installed_servers()

		require("lspconfig.ui.windows").default_options.border = vim.g.border

		for _, server in ipairs(servers) do
			local opts = {
				capabilities = common_capabilities(),
				on_attach = on_attach,
			}

			local ok, settings = pcall(require, "lspsettings." .. server)
			if ok then
				opts = vim.tbl_deep_extend("force", settings, opts)
			end

			lspconfig[server].setup(opts)
		end
	end
	setup_lsp()

	-- end of now
end)

later(function()
	-- Add suda
	add({ source = "lambdalisue/suda.vim" })

	-- Termail Toggle
	add({ source = "akinsho/toggleterm.nvim" })
	require("toggleterm").setup()

	-- CMP and its dependencies
	add({
		source = "hrsh7th/nvim-cmp",
		depends = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"dcampos/cmp-emmet-vim",
			"mattn/emmet-vim",
		},
	})

	-- LuaSnip
	add({
		source = "L3MON4D3/LuaSnip",
		hooks = {
			post_install = function(params)
				vim.notify("Building lua snippets", vim.log.levels.INFO)
				local result = vim.system({ "make", "install_jsregexp" }, { cwd = params.path }):wait()
				local level = result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
				local status = result.code == 0 and "done" or "failed"
				vim.notify("Building lua snippets " .. status, level)
			end,
		},
		depends = { "rafamadriz/friendly-snippets" },
	})

	-- Codeium
	add({ source = "Exafunction/codeium.nvim", depends = { "nvim-lua/plenary.nvim" } })
	require("codeium").setup()

	-- CMP configuration
	local function setup_cmp()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry)
						return entry:get_kind() ~= 15
					end,
				},
				{ name = "nvim_lsp_signature_help" },
				{ name = "luasnip" },
				{ name = "codeium" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "emmet_vim" },
			}),
			enabled = function()
				return vim.bo.filetype ~= "scss" or vim.fn.getline("."):match("%$") == nil
			end,
		})

		-- Command line completion
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
		})
	end
	setup_cmp()

	-- Folds with UFO
	add({ source = "kevinhwang91/nvim-ufo", depends = { "kevinhwang91/promise-async" } })
	require("ufo").setup({
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	})

	-- Formatting configuration
	add({ source = "stevearc/conform.nvim" })
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			sh = { "beautysh" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})

	-- Treesitter configuration
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.Cmd("TSUpdate")
			end,
		},
		depends = {
			"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
			"windwp/nvim-ts-autotag",
		},
	})

	local function setup_treesitter()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"html",
				"javascript",
				"typescript",
				"lua",
				"css",
				"php",
				"jsdoc",
				"json",
				"tsx",
				"markdown",
				"markdown_inline",
				"vim",
				"bash",
				"prisma",
				"regex",
				"java",
				"xml",
				"http",
				"graphql",
				"vimdoc",
			},
			auto_install = true,
			highlight = { enable = true },
			rainbow = { enable = true, disable = { "html" } },
			autotag = { enable = true },
			incremental_selection = { enable = true },
			indent = { enable = true, disable = { "yaml" } },
			ignore_install = { "help" },
		})
	end
	setup_treesitter()

	-- LSP end hints
	add({ source = "chrisgrieser/nvim-lsp-endhints" })
	require("lsp-endhints").setup()

	-- Namu
	add({ source = "bassamsdata/namu.nvim" })
	require("namu").setup({
		namu_symbols = {
			enable = true,
			options = {
				window = {
					auto_size = true,
					min_height = 1,
					min_width = 20,
					max_width = 120,
					max_height = 30,
					padding = 2,
					border = vim.g.border,
					title_pos = "left",
					footer_pos = "right",
					show_footer = true,
					relative = "editor",
					style = "minimal",
					width_ratio = 0.6,
					height_ratio = 0.6,
					title_prefix = "󰠭 ",
				},
			},
		},
		ui_select = { enable = true },
	})

	add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })
	-- Harpoon configuration in its own scope
	local function setup_harpoon()
		local harpoon = require("harpoon")
		harpoon.setup()

		local mappings = {
			{
				key = "<Leader>pa",
				fn = function()
					harpoon:list():add()
				end,
				desc = "Add to quick menu",
			},
			{
				key = "<Leader>pm",
				fn = function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Toggle quick menu",
			},
			{
				key = "<Leader>pn",
				fn = function()
					harpoon:list():select(1)
				end,
				desc = "Select first entry in quick menu",
			},
		}

		for _, map in ipairs(mappings) do
			vim.keymap.set("n", map.key, map.fn, { desc = map.desc })
		end
	end
	setup_harpoon()
end)

-- Global keymaps
local function setup_keymaps()
	local keymaps = {
		-- File navigation
		{ mode = "n", key = "<Leader><Leader>", fn = "<Cmd>Pick files<CR>", desc = "Pick File" },
		{ mode = "n", key = "<Leader>g", fn = "<Cmd>Pick grep_live<CR>", desc = "Pick Grep Live" },
		{ mode = "n", key = "<Leader>o", fn = "<Cmd>Pick oldfiles<CR>", desc = "Pick Old Files" },
		{ mode = "n", key = "<Leader>b", fn = "<Cmd>Pick buffers<CR>", desc = "Pick Buffers" },
		{ mode = "n", key = "<Leader>h", fn = "<Cmd>Pick help<CR>", desc = "Pick Help" },
		{ mode = "n", key = "<Leader>d", fn = "<Cmd>Pick diagnostic<CR>", desc = "Pick Diagnostic" },
		{ mode = "n", key = "<Leader>H", fn = "<Cmd>Pick hl_groups<CR>", desc = "Highlight" },

		-- Utilities
		{ mode = "n", key = "<Leader>e", fn = "<Cmd>lua MiniFiles.open()<CR>", desc = "Explorer" },
		{ mode = "n", key = "<Leader>ll", fn = "<Cmd>lua MiniTrailspace.trim()<CR>", desc = "Trailing Space" },

		-- Trouble
		{ mode = "n", key = "<Leader>tp", fn = "<Cmd>Trouble diagnostics toggle<CR>", desc = "Toggle Diagnostics" },
		{
			mode = "n",
			key = "<Leader>tb",
			fn = "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Toggle Buffer Diagnostics",
		},
		{ mode = "n", key = "<Leader>ts", fn = "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Toggle Symbols" },

		-- Folds
		{
			mode = "n",
			key = "zR",
			fn = function()
				require("ufo").openAllFolds()
			end,
			desc = "Open All Folds",
		},
		{
			mode = "n",
			key = "zM",
			fn = function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close All Folds",
		},

		-- Undotree
		{ mode = "n", key = "<Leader>u", fn = "<Cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },

		-- MiniDeps
		{
			mode = "n",
			key = "<Leader>U",
			fn = function()
				vim.notify("Starting update dependencies", vim.log.levels.INFO)
				vim.defer_fn(function()
					MiniDeps.update()
				end, 500)
			end,
			desc = "Update Dependencies",
		},

		-- Toggle Term
		{ mode = "n", key = "<Leader>tt", fn = "<Cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },

		-- Namu keymaps
		{
			mode = "n",
			key = "<Leader>ss",
			fn = function()
				require("namu.namu_symbols").show()
			end,
			desc = "Jump to LSP symbol",
		},
	}

	for _, map in ipairs(keymaps) do
		vim.keymap.set(map.mode, map.key, map.fn, { desc = map.desc })
	end
end
setup_keymaps()
