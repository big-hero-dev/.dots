local add = require("mini.deps").add

add({ source = "shaunsingh/nord.nvim" })
add({ source = "mcchrish/zenbones.nvim", depends = { "rktjmp/lush.nvim" } })
add({ source = "rebelot/kanagawa.nvim" })

vim.g.zenbones_dark_contrast = "low"
vim.cmd([[colorscheme nordbones]])
vim.o.background = "dark"

local function bg_trans()
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
		"StatusLine",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

bg_trans()
