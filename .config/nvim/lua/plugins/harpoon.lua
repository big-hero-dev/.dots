local ok, harpoon = pcall(require, "harpoon")
if not ok then
	return
end

harpoon.setup()

local mappings = {
	{
		key = "<Leader>ha",
		fn = function()
			harpoon:list():add()
		end,
		desc = "Add to quick menu",
	},
	{
		key = "<Leader>hm",
		fn = function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Toggle quick menu",
	},
	{
		key = "<Leader>hn",
		fn = function()
			harpoon:list():select(1)
		end,
		desc = "Select first entry in quick menu",
	},
}

for _, map in ipairs(mappings) do
	vim.keymap.set("n", map.key, map.fn, { desc = map.desc })
end
