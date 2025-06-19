local add = require("mini.deps").add

add({ source = "mbbill/undotree" })

vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
