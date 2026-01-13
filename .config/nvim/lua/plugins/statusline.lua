local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

local function recording()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end -- not recording
	return "󰑊 REC"
end

lualine.setup({
	options = {
		theme = "auto",
		icons_enabled = true,
		component_separators = "",
		section_separators = "",
		globalstatus = true,
		refresh = {
			statusline = 500,
			tabline = 500,
		},
	},
	sections = {
		lualine_a = {
			{ "mode" },
		},
		lualine_b = {
			{ "branch" },
		},
		lualine_c = {
			"diagnostics",
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					local names = {}
					for _, client in ipairs(clients) do
						table.insert(names, client.name)
					end
					return "󰭆 " .. table.concat(names, ", ")
				end,
			},
		},
		lualine_x = {
			"filetype",
		},
		lualine_y = {
			"progress",
		},
		lualine_z = {
			"location",
		},
	},
	tabline = {
		lualine_a = {
			{ "searchcount" },
			{ recording },
		},
		lualine_z = {
			{
				"buffers",
				fmt = function(str)
					return str:sub(1, 20)
				end,
				use_mode_colors = true,
				symbols = {
					modified = " ●",
					directory = " ",
					alternate_file = "",
				},
				max_length = 20,
			},
		},
	},
})
