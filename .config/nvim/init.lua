local bt_ok, bootstrap = pcall(require, "core.bootstrap")
if not bt_ok then
	vim.notify("Failed to load core.bootstrap\n" .. bootstrap, vim.log.levels.ERROR)
	return
end

bootstrap.bootstrap_mini()

local function safe_require(mod)
	local ok, err = pcall(require, mod)
	if not ok then
		vim.notify("Failed to load " .. mod .. "\n" .. err, vim.log.levels.ERROR)
	end
end

safe_require("core.options")
safe_require("core.keymaps")

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		local later, now = require("mini.deps").later, require("mini.deps").now
		now(function()
			safe_require("core.colorscheme")
		end)
		later(function()
			safe_require("core.autocmds")
			safe_require("core.mini_deps")
		end)
	end,
})
