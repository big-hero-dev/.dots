local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		php = { "php-cs-fixer" },
	},
	formatters = {
		["php-cs-fixer"] = {
			command = "php-cs-fixer",
			args = {
				"fix",
				"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
				"$FILENAME",
			},
			stdin = false,
		},
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			timeout_ms = 1000,
			lsp_fallback = false,
			async = false,
		})
	end,
})
