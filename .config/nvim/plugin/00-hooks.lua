vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind

		if name == "blink.cmp" and kind == "install" then
			local path = ev.data.spec.path
			vim.system({ "cargo", "build", "--release" }, { cwd = path })
		end

		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})
