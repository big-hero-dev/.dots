local add = require("mini.deps").add
add({ source = "sainnhe/everforest" })
add({ source = "e-ink-colorscheme/e-ink.nvim" })

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

-- Set theme theo giờ khi mở vim
local hour = tonumber(os.date("%H"))
-- Tối (18h-6h sáng) -> dark mode
-- Sáng (6h-18h) -> light mode
if hour >= 18 or hour < 6 then
	vim.o.background = "dark"
else
	vim.o.background = "light"
end
set_theme()

-- Toggle dark/light mode
vim.keymap.set("n", "td", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	set_theme()
end, { desc = "Toggle Dark/Light Mode" })

-- Toggle transparency
vim.keymap.set("n", "tt", function()
	transparency_clon = not transparency_clon
	set_theme()
end, { desc = "Toggle Transparency" })
