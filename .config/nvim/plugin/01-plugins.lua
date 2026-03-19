-- =========================================================
-- Core editing & basic UI
-- =========================================================
vim.pack.add({
	"https://github.com/mbbill/undotree",
	"https://github.com/dstein64/vim-startuptime",
	"https://github.com/lambdalisue/suda.vim",
})

-- =========================================================
-- Completion & snippets
-- =========================================================
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
})

-- =========================================================
-- LSP, formatting & diagnostics
-- =========================================================
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/chrisgrieser/nvim-lsp-endhints",
	"https://github.com/folke/trouble.nvim",
})

-- =========================================================
-- Syntax tree & structural intelligence
-- =========================================================
-- Dependencies need list first target plugin
vim.pack.add({
	"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- =========================================================
-- Git & project context
-- =========================================================
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	callback = function()
		if vim.fn.isdirectory(".git") == 1 then
			vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
			require("gitsigns").setup()
		end
	end,
})

-- =========================================================
-- Navigation — Harpoon 2
-- =========================================================
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

-- =========================================================
-- Mini.nvim
-- =========================================================
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
})
