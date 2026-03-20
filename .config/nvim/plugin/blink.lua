local has_rust = vim.fn.executable("cargo") == 1
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },
		["<C-e>"] = { "hide", "fallback" },
		["<Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_next()
				end
				return false
			end,
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_prev()
				end
				return false
			end,
			"fallback",
		},
	},
	fuzzy = { implementation = has_rust and "prefer_rust_with_warning" or "lua" },
	completion = {
		menu = { auto_show = true },
		list = { selection = { preselect = false, auto_insert = true } },
	},
	sources = {
		default = { "lsp", "snippets", "buffer", "path" },
	},
	cmdline = {
		sources = { "buffer", "cmdline" },
	},
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
})
