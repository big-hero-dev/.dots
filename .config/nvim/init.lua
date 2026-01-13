local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	local result = vim.fn.system(clone_cmd)
	if vim.v.shell_error ~= 0 then
		error("Failed to install mini.nvim\n" .. result)
	end
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("core.options")
require("core.keymaps")
require("core.autocmds")

require("plugins.mini")
require("core.colorscheme")
require("plugins.treesitter")

require("plugins.lsp")
require("plugins.endhints")
require("plugins.blink")
require("plugins.luasnip")
require("plugins.format")
require("plugins.statusline")
pcall(require, "plugins.harpoon")
pcall(require, "plugins.namu")
pcall(require, "plugins.trouble")
