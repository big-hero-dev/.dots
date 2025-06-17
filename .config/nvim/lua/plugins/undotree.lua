local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "mbbill/undotree" })

vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
