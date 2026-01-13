local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = false,
})

require("luasnip.loaders.from_vscode").lazy_load()
