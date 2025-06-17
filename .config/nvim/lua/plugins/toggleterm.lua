local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "akinsho/toggleterm.nvim" })
require("toggleterm").setup()

vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Term" })
