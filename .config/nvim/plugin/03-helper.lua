local function pack_clean()
	local active = {}
	local unused = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active[plugin.spec.name] then
			table.insert(unused, plugin.spec.name)
		end
	end

	if #unused == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean, { desc = "Pack: clean unsed plugins" })
