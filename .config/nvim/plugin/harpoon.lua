local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = true,
		save_on_change = true,
		sync_on_ui_close = true,
	},
})

local map = vim.keymap.set

map("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

map("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Harpoon next" })

map("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Harpoon prev" })
