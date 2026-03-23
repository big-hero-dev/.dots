local function setup_themes()
	vim.g.gruvbox_material_enable_italic = true
	vim.g.gruvbox_material_cursor = "auto"
	vim.g.gruvbox_material_background = "soft"
	vim.g.gruvbox_material_show_eob = 1
	vim.g.gruvbox_material_diagnostic_text_highlight = 1
	vim.g.gruvbox_material_inlay_hints_background = "dimmed"
	vim.g.gruvbox_material_current_word = "underline"

	local hour = tonumber(os.date("%H"))
	vim.o.background = (hour >= 18 or hour < 6) and "dark" or "light"

	vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })
	vim.cmd.colorscheme("gruvbox-material")
end
setup_themes()

vim.keymap.set("n", "td", function()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, { desc = "Toggle Dark/Light Mode" })
