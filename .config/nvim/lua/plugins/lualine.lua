local add = require("mini.deps").add

add({ source = "nvim-lualine/lualine.nvim", depends = { "nvim-tree/nvim-web-devicons" } })

local function recording()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end -- not recording
	return "󰑊 REC"
end

local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if not clients or vim.tbl_isempty(clients) then
		return ""
	end

	local seen, names = {}, {}
	for _, client in ipairs(clients) do
		if client and not client:is_stopped() and not seen[client.name] then
			seen[client.name] = true
			table.insert(names, client.name)
		end
	end

	if #names == 0 then
		return ""
	end

	local names_s = table.concat(names, ", ")
	local progress = vim.lsp.status()
	if progress ~= "" then
		return "󰭆" .. names_s .. " " .. progress
	end
	return "󰭆 " .. names_s
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		component_separators = "",
		section_separators = "",
		globalstatus = true,
		refresh = {
			tabline = 100,
			statusline = 300,
			winbar = 300,
		},
	},
	sections = {

		lualine_a = {
			{
				"mode",
				separator = { left = "", right = "" },
				padding = { left = 1, right = 1 },
			},
		},
		lualine_b = {
			{ "branch", separator = { right = "" }, draw_empty = true },
		},
		lualine_c = {
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			"%=",
			"diagnostics",
		},

		lualine_x = {
			{ lsp_status, color = { fg = "#88C0D0", gui = "bold" } },
			"filetype",
		},
		lualine_y = {
			{ "progress", separator = { left = "" } },
		},
		lualine_z = {
			{ "location", separator = { left = "", right = "" } },
		},
	},
	tabline = {

		lualine_a = {
			{ "searchcount", separator = { left = "", right = "" } },
			{
				recording,
				separator = { left = "", right = "" },
				color = { fg = "white", bg = "#FF746C" },
			},
		},

		lualine_b = {},
		lualine_c = { "selectioncount" },
		lualine_x = {},
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
				separator = { left = "", right = "" },
				component_separators = { right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},
})
