local harpoon = require("harpoon")

harpoon:setup({
	settings = {
		save_on_toggle = true,
		save_on_change = true,
		sync_on_ui_close = true,
	},
})

local map = vim.keymap.set
local list = harpoon:list()

-- Add file
map("n", "<leader>ha", function()
	list:add()
end, { desc = "Harpoon add file" })

-- Toggle quick menu
map("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(list)
end, { desc = "Harpoon menu" })

-- Cycle
map("n", "<leader>hn", function()
	list:next()
end, { desc = "Harpoon next" })

map("n", "<leader>hp", function()
	list:prev()
end, { desc = "Harpoon prev" })
