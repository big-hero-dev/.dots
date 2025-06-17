-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })

local now = MiniDeps.now

now(function()
	local plugin_dir = vim.fn.stdpath('config')..'/lua/plugins'
	local plugin_files = vim.fn.glob(plugin_dir..'/*.lua', false, true)

	for _, file in ipairs(plugin_files) do
		local module_path = file:gsub(vim.fn.stdpath('config')..'/lua/',''):gsub('%.lua$', ''):gsub('/', '.')

		require(module_path)
	end
end)

vim.keymap.set("n", "<leader>U", function()
		vim.notify("Starting update dependencies", vim.log.levels.INFO)
				vim.defer_fn(function()
					MiniDeps.update()
				end, 500)
end, {desc="Update Dependencies"} )
