local MiniDeps = require("mini.deps")

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
