local function safe_require(mod)
	local ok, err = pcall(require, mod)
	if not ok then
		vim.notify("Failed to load " .. mod .. "\n" .. err, vim.log.levels.ERROR)
	end
end

safe_require("core.options")
safe_require("core.keymaps")
safe_require("core.autocmds")
safe_require("core.statusline")
safe_require("core.mini_deps")
