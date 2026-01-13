local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("core.options")
require("core.keymaps")
require("core.autocmds")

require("plugins.mini")
require("core.colorscheme")
vim.defer_fn(function()
	require("plugins.treesitter")
end, 50)
require("plugins.lsp")
require("plugins.endhints")
require("plugins.blink")
require("plugins.luasnip")
require("plugins.format")
require("plugins.statusline")
require("plugins.harpoon")
require("plugins.namu")
require("plugins.trouble")
