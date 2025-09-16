local add = require("mini.deps").add

add({ source = "alexxGmZ/e-ink.nvim" })
add({ source = "rebelot/kanagawa.nvim" })
add({ source = "shaunsingh/nord.nvim" })

vim.cmd([[colorscheme nord]])

-- Transparent background
local function bg_trans()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end
