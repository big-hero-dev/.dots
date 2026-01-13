local function setup_themes()
	local ok, add = pcall(function()
		return require("mini.deps").add
	end)

	if ok then
		add({ source = "sainnhe/everforest" })
		add({ source = "e-ink-colorscheme/e-ink.nvim" })
	end
end

if package.loaded["mini.deps"] then
	setup_themes()
else
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = setup_themes,
	})
end

local transparency_clon = false

local function apply_transparency()
	if not transparency_clon then
		return
	end
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"TelescopeNormal",
		"TelescopeBorder",
		"Pmenu",
		"SignColumn",
		"LineNr",
		"CursorLineNr",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

local function set_theme()
	if vim.o.background == "dark" then
		vim.g.everforest_background = "soft"
		vim.g.everforest_better_performance = 1
		vim.cmd([[colorscheme everforest]])
	else
		vim.cmd([[colorscheme e-ink]])
	end
	apply_transparency()
end

local hour = tonumber(os.date("%H"))

if hour >= 18 or hour < 6 then
	vim.o.background = "dark"
else
	vim.o.background = "light"
end

vim.defer_fn(set_theme, 10)

vim.keymap.set("n", "td", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	set_theme()
end, { desc = "Toggle Dark/Light Mode" })

vim.keymap.set("n", "tt", function()
	transparency_clon = not transparency_clon
	set_theme()
end, { desc = "Toggle Transparency" })
