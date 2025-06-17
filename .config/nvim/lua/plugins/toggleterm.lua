local MiniDeps = require("mini.deps")
local add, later = MiniDeps.add, MiniDeps.later

add({ source = "akinsho/toggleterm.nvim" })
later(function()
	require("toggleterm").setup()
end)

vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Term" })
