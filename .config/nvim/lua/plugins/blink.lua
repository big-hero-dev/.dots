local ok, blink = pcall(require, "blink.cmp")
if not ok then
	return
end

blink.setup({
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

	fuzzy = {
		implementation = "lua",
	},

	completion = {
		menu = {
			auto_show = true,
		},
	},

	sources = {
		default = { "lsp", "snippets", "buffer", "path" },
	},

	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
})
