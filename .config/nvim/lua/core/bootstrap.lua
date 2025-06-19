local M = {}

function M.bootstrap_mini()
	local path_package = vim.fn.stdpath("data") .. "/site/"
	local mini_path = path_package .. "pack/deps/start/mini.nvim"

	if not vim.loop.fs_stat(mini_path) then
		vim.cmd('echo "Installing mini.nvim..." | redraw')
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/echasnovski/mini.nvim",
			mini_path,
		})
		vim.cmd("packadd mini.nvim")

		if vim.fn.isdirectory(mini_path .. "/doc") == 1 then
			vim.cmd("helptags " .. mini_path .. "/doc")
		end

		vim.notify("Installed mini.nvim", vim.log.levels.INFO)
	else
		vim.cmd("packadd mini.nvim")
	end

	-- Setup MiniDeps
	local MiniDeps = require("mini.deps")
	MiniDeps.setup({ path = { package = path_package } })
end

return M
