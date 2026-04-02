local function pack_clean()
	local unused = {}

	for _, plugin in ipairs(vim.pack.get()) do
		if not plugin.active or not plugin.spec then
			table.insert(unused, plugin.spec.name)
		end
	end

	if #unused == 0 then
		print("No unused plugins.")
		return
	end

	local choice =
		vim.fn.confirm("Remove " .. #unused .. " unused plugins?\n" .. table.concat(unused, "\n"), "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean, { desc = "Pack: clean unsed plugins" })
