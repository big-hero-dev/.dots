local cargo_bin = vim.fn.expand("~/.cargo/bin")
if not vim.env.PATH:find(cargo_bin, 1, true) then
	vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

local function cargo_exists()
	return vim.fn.executable("cargo") == 1
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind

		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			if not cargo_exists() then
				vim.schedule(function()
					vim.notify("blink.cmp: cargo are not found!Install Rust at https://rustup.rs", vim.log.levels.ERROR)
				end)
				return
			end

			local path = ev.data.spec.path
			vim.notify("Đang build blink.cmp...", vim.log.levels.INFO)

			vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
				vim.schedule(function()
					if obj.code == 0 then
						vim.notify("Build blink.cmp successfully!", vim.log.levels.INFO)
					else
						vim.notify("Build blink.cmp failed:\n" .. (obj.stderr or "unknown error"), vim.log.levels.ERROR)
					end
				end)
			end)
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

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind

		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			local path = ev.data.spec.path
			vim.notify("Đang build blink.cmp...", vim.log.levels.INFO)

			vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
				if obj.code == 0 then
					vim.schedule(function()
						vim.notify("Build blink.cmp successfully!", vim.log.levels.INFO)
					end)
				else
					vim.schedule(function()
						vim.notify("Build blink.cmp failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
					end)
				end
			end)
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
