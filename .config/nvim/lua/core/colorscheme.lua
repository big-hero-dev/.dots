local function setup_themes()
	local has_mini, add = pcall(function()
		return require("mini.deps").add
	end)

	if has_mini then
		add({ source = "rose-pine/neovim" })
	end
end

setup_themes()
local theme = {
	dark = "rose-pine-moon",
	light = "rose-pine-dawn",
}

local function set_theme()
	if vim.o.background == "dark" then
		vim.cmd("colorscheme " .. theme["dark"])
	else
		vim.cmd("colorscheme " .. theme["light"])
	end
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
