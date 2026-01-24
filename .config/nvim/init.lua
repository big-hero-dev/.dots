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

	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end

require("core.options")
require("core.keymaps")
require("core.autocmds")

local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })
local now, later = MiniDeps.now, MiniDeps.later

now(function()
	require("plugins")
	require("core.colorscheme")
	require("plugins.treesitter")
	require("plugins.haunts")
	require("plugins.harpoon")
end)

later(function()
	require("plugins.mini")
	require("plugins.lsp")
	require("plugins.endhints")
	require("plugins.blink")
	require("plugins.luasnip")
	require("plugins.format")

	pcall(require, "plugins.trouble")
end)
