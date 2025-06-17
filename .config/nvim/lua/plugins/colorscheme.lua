local MiniDeps = require("mini.deps")
local add, now = MiniDeps.add, MiniDeps.now

add({
	source = "alexxGmZ/e-ink.nvim",
})

now(function()
	vim.cmd([[colorscheme e-ink]])
end)
