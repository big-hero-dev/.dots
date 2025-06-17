local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "folke/zen-mode.nvim" })

vim.keymap.set("n", "<leader>z", function()
	require("zen-mode").toggle()
end, { desc = "Toggle Zen Mode" })
