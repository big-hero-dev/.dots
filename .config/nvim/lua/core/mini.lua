-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)

	vim.cmd("packadd mini.nvim")
	if vim.fn.isdirectory(mini_path .. "/doc") == 1 then
		vim.cmd("helptags " .. mini_path .. "/doc")
	end

	vim.notify("Installing mini.nvim...", vim.log.levels.INFO)
end

local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local plugin_files = vim.fn.glob(plugin_dir .. "/*.lua", false, true)

for _, file in ipairs(plugin_files) do
	local module_path = file:gsub(vim.fn.stdpath("config") .. "/lua/", ""):gsub("%.lua$", ""):gsub("/", ".")

	require(module_path)
end

vim.keymap.set("n", "<leader>U", function()
	vim.notify("Starting update dependencies", vim.log.levels.INFO)
	vim.defer_fn(function()
		MiniDeps.update()
	end, 500)
end, { desc = "Update Dependencies" })
