require("lualine").setup({
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
			recording,
		},
		lualine_z = {
			{
				"buffers",
				max_length = 20,
				symbols = {
					modified = " ●",
					alternate_file = "",
				},
			},
		},
	},
})
