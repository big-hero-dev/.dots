local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "kevinhwang91/nvim-ufo", depends = { "kevinhwang91/promise-async" } })
require("ufo").setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

vim.keymap.set("n", "zr", function()
	require("ufo").openAllFolds()
end)
vim.keymap.set("n", "zm", function()
	require("ufo").closeAllFolds()
end)
