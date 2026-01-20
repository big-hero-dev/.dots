local function setup_themes()
	local has_mini, add = pcall(function()
		return require("mini.deps").add
	end)

	if has_mini then
		add({ source = "sainnhe/everforest" })
		add({ source = "e-ink-colorscheme/e-ink.nvim" })
	end
end

setup_themes()

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

set_theme()

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
