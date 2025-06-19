local add = require("mini.deps").add

add({ source = "folke/zen-mode.nvim" })

vim.keymap.set("n", "<leader>z", function()
	require("zen-mode").toggle()
end, { desc = "Toggle Zen Mode" })
