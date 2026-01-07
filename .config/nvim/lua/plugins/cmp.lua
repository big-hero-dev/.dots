local add = require("mini.deps").add

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
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
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
		if vim.bo.filetype == "minifiles" then
			return false
		end
		return vim.bo.filetype ~= "scss" or vim.fn.getline("."):match("%$") == nil
	end,
	window = {
		completion = {
			border = "single",
		},
		documentation = {
			border = "single",
		},
	},
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
