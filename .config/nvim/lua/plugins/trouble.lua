local ok, trouble = pcall(require, "trouble")
if not ok then
	return
end

trouble.setup({
	auto_close = true,
	use_diagnostic_signs = true,
	focus = true,
	modes = {
		diagnostics = {
			auto_open = false,
			auto_close = true,
			auto_preview = true,
			auto_refresh = true,
		},
	},
	icons = {
		indent = {
			middle = "├╌",
			last = "└╌",
			top = "│ ",
			ws = "  ",
		},
	},
})

-- Diagnostics
vim.keymap.set("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (workspace)" })
vim.keymap.set("n", "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnostics (buffer)" })

-- LSP
vim.keymap.set("n", "<leader>td", "<cmd>Trouble lsp_definitions toggle<cr>", { desc = "Definitions" })
vim.keymap.set("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "References" })
vim.keymap.set("n", "<leader>ti", "<cmd>Trouble lsp_implementations toggle<cr>", { desc = "Implementations" })
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble lsp_type_definitions toggle<cr>", { desc = "Type definitions" })
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>tl", "<cmd>checkhealth lsp<cr>", { desc = "LSP info" })

-- Lists
vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- Navigation
vim.keymap.set("n", "[q", function()
	if require("trouble").is_open() then
		require("trouble").prev({ skip_groups = true, jump = true })
	else
		local ok_pcall, err = pcall(vim.cmd.cprev)
		if not ok_pcall then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, { desc = "Prev trouble/qf" })

vim.keymap.set("n", "]q", function()
	if require("trouble").is_open() then
		require("trouble").next({ skip_groups = true, jump = true })
	else
		local ok_pcall, err = pcall(vim.cmd.cnext)
		if not ok_pcall then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, { desc = "Next trouble/qf" })

-- Diagnostics
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = { border = "single" } })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = { border = "single" } })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({
		count = -1,
		severity = vim.diagnostic.severity.ERROR,
		float = { border = "single" },
	})
end, { desc = "Prev error" })

vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({
		count = 1,
		severity = vim.diagnostic.severity.ERROR,
		float = { border = "single" },
	})
end, { desc = "Next error" })

vim.keymap.set("n", "[w", function()
	vim.diagnostic.jump({
		count = -1,
		severity = vim.diagnostic.severity.WARN,
		float = { border = "single" },
	})
end, { desc = "Prev warning" })

vim.keymap.set("n", "]w", function()
	vim.diagnostic.jump({
		count = 1,
		severity = vim.diagnostic.severity.WARN,
		float = { border = "single" },
	})
end, { desc = "Next warning" })
