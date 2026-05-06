require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		php = { "php-cs-fixer" },
	},
	formatters = {
		["php-cs-fixer"] = {
			command = vim.fn.expand("~/.local/share/nvim/mason/bin/php-cs-fixer"),
			env = {
				PHP_CS_FIXER_IGNORE_ENV = "1",
			},
			args = {
				"fix",
				"--rules=@PSR12",
				"--no-interaction",
				"--using-cache=no",
				"$FILENAME",
			},
			stdin = false,
			exit_codes = { 0, 1 },
		},
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			timeout_ms = 3000,
			lsp_format = "fallback",
			async = false,
		})
	end,
})
