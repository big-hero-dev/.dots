local function setup_themes()
	local has_mini, add = pcall(function()
		return require("mini.deps").add
	end)

	if has_mini then
		add({ source = "sainnhe/gruvbox-material" })
	end

	vim.g.gruvbox_material_enable_italic = true
	vim.g.gruvbox_material_cursor = "auto"
	vim.g.gruvbox_material_background = "soft"
	vim.g.gruvbox_material_show_eob = 1
	vim.g.gruvbox_material_diagnostic_text_highlight = 1
	vim.g.gruvbox_material_inlay_hints_background = "dimmed"
	vim.g.gruvbox_material_current_word = "underline"
	vim.cmd.colorscheme("gruvbox-material")
end

setup_themes()

local hour = tonumber(os.date("%H"))

if hour >= 18 or hour < 6 then
	vim.o.background = "dark"
else
	vim.o.background = "light"
end

vim.keymap.set("n", "td", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end, { desc = "Toggle Dark/Light Mode" })
