---@diagnostic disable: duplicate-set-field
local statusline_augroup = vim.api.nvim_create_augroup("gmr_statusline", { clear = true })

-- ── Auto Theme Detection & Color Setup ──────────────────────────────
local function setup_statusline_colors()
	-- Get current colorscheme
	local colorscheme = vim.g.colors_name or "default"

	-- Define color palettes for different themes
	local theme_colors = {
		-- Kanagawa theme colors
		kanagawa = {
			normal = { fg = "#1F1F28", bg = "#98BB6C" },
			insert = { fg = "#1F1F28", bg = "#7E9CD8" },
			visual = { fg = "#1F1F28", bg = "#C34043" },
			vline = { fg = "#1F1F28", bg = "#FF9E3B" },
			vblock = { fg = "#1F1F28", bg = "#E6C384" },
			command = { fg = "#1F1F28", bg = "#7AA89F" },
			replace = { fg = "#1F1F28", bg = "#D27E99" },
			term = { fg = "#1F1F28", bg = "#DCD7BA" },
			git_branch = { fg = "#7E9CD8", bold = true },
			git_add = { fg = "#76946A" },
			git_change = { fg = "#C0A36E" },
			git_delete = { fg = "#C34043" },
		},

		-- Catppuccin theme colors
		catppuccin = {
			normal = { fg = "#1e1e2e", bg = "#a6e3a1" },
			insert = { fg = "#1e1e2e", bg = "#89b4fa" },
			visual = { fg = "#1e1e2e", bg = "#cba6f7" },
			vline = { fg = "#1e1e2e", bg = "#fab387" },
			vblock = { fg = "#1e1e2e", bg = "#f38ba8" },
			command = { fg = "#1e1e2e", bg = "#94e2d5" },
			replace = { fg = "#1e1e2e", bg = "#f9e2af" },
			term = { fg = "#1e1e2e", bg = "#cdd6f4" },
			git_branch = { fg = "#89b4fa", bold = true },
			git_add = { fg = "#a6e3a1" },
			git_change = { fg = "#f9e2af" },
			git_delete = { fg = "#f38ba8" },
		},

		-- Tokyonight theme colors
		tokyonight = {
			normal = { fg = "#1a1b26", bg = "#9ece6a" },
			insert = { fg = "#1a1b26", bg = "#7aa2f7" },
			visual = { fg = "#1a1b26", bg = "#bb9af7" },
			vline = { fg = "#1a1b26", bg = "#e0af68" },
			vblock = { fg = "#1a1b26", bg = "#f7768e" },
			command = { fg = "#1a1b26", bg = "#7dcfff" },
			replace = { fg = "#1a1b26", bg = "#ff9e64" },
			term = { fg = "#1a1b26", bg = "#c0caf5" },
			git_branch = { fg = "#7aa2f7", bold = true },
			git_add = { fg = "#9ece6a" },
			git_change = { fg = "#e0af68" },
			git_delete = { fg = "#f7768e" },
		},

		-- Gruvbox theme colors
		gruvbox = {
			normal = { fg = "#282828", bg = "#b8bb26" },
			insert = { fg = "#282828", bg = "#83a598" },
			visual = { fg = "#282828", bg = "#d3869b" },
			vline = { fg = "#282828", bg = "#fabd2f" },
			vblock = { fg = "#282828", bg = "#fb4934" },
			command = { fg = "#282828", bg = "#8ec07c" },
			replace = { fg = "#282828", bg = "#fe8019" },
			term = { fg = "#282828", bg = "#ebdbb2" },
			git_branch = { fg = "#83a598", bold = true },
			git_add = { fg = "#b8bb26" },
			git_change = { fg = "#fabd2f" },
			git_delete = { fg = "#fb4934" },
		},

		-- Nord theme colors (original)
		nord = {
			normal = { fg = "#2E3440", bg = "#A3BE8C" },
			insert = { fg = "#2E3440", bg = "#81A1C1" },
			visual = { fg = "#2E3440", bg = "#B48EAD" },
			vline = { fg = "#2E3440", bg = "#EBCB8B" },
			vblock = { fg = "#2E3440", bg = "#BF616A" },
			command = { fg = "#2E3440", bg = "#88C0D0" },
			replace = { fg = "#2E3440", bg = "#D08770" },
			term = { fg = "#2E3440", bg = "#D8DEE9" },
			git_branch = { fg = "#7E9CD8", bold = true },
			git_add = { fg = "#76946A" },
			git_change = { fg = "#C0A36E" },
			git_delete = { fg = "#C34043" },
		},

		-- Dracula theme colors
		dracula = {
			normal = { fg = "#282a36", bg = "#50fa7b" },
			insert = { fg = "#282a36", bg = "#8be9fd" },
			visual = { fg = "#282a36", bg = "#bd93f9" },
			vline = { fg = "#282a36", bg = "#f1fa8c" },
			vblock = { fg = "#282a36", bg = "#ff5555" },
			command = { fg = "#282a36", bg = "#ffb86c" },
			replace = { fg = "#282a36", bg = "#ff79c6" },
			term = { fg = "#282a36", bg = "#f8f8f2" },
			git_branch = { fg = "#8be9fd", bold = true },
			git_add = { fg = "#50fa7b" },
			git_change = { fg = "#f1fa8c" },
			git_delete = { fg = "#ff5555" },
		},
	}

	-- Auto-detect theme or fallback to default
	local colors = theme_colors.nord -- default fallback

	-- Smart theme detection
	if colorscheme:find("kanagawa") then
		colors = theme_colors.kanagawa
	elseif colorscheme:find("catppuccin") then
		colors = theme_colors.catppuccin
	elseif colorscheme:find("tokyonight") then
		colors = theme_colors.tokyonight
	elseif colorscheme:find("gruvbox") then
		colors = theme_colors.gruvbox
	elseif colorscheme:find("nord") then
		colors = theme_colors.nord
	elseif colorscheme:find("dracula") then
		colors = theme_colors.dracula
	else
		-- Try to extract colors from existing highlights for unknown themes
		local normal_bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg#")
		local normal_fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg#")
		if normal_bg ~= "" and normal_fg ~= "" then
			-- Generate colors based on current theme
			colors = {
				normal = { fg = normal_bg, bg = normal_fg },
				insert = { fg = normal_bg, bg = "#7aa2f7" },
				visual = { fg = normal_bg, bg = "#bb9af7" },
				vline = { fg = normal_bg, bg = "#e0af68" },
				vblock = { fg = normal_bg, bg = "#f7768e" },
				command = { fg = normal_bg, bg = "#7dcfff" },
				replace = { fg = normal_bg, bg = "#ff9e64" },
				term = { fg = normal_bg, bg = normal_fg },
				git_branch = { fg = "#7aa2f7", bold = true },
				git_add = { fg = "#9ece6a" },
				git_change = { fg = "#e0af68" },
				git_delete = { fg = "#f7768e" },
			}
		end
	end

	-- Apply the colors
	vim.api.nvim_set_hl(0, "StatusLineNormal", colors.normal)
	vim.api.nvim_set_hl(0, "StatusLineInsert", colors.insert)
	vim.api.nvim_set_hl(0, "StatusLineVisual", colors.visual)
	vim.api.nvim_set_hl(0, "StatusLineVLine", colors.vline)
	vim.api.nvim_set_hl(0, "StatusLineVBlock", colors.vblock)
	vim.api.nvim_set_hl(0, "StatusLineCommand", colors.command)
	vim.api.nvim_set_hl(0, "StatusLineReplace", colors.replace)
	vim.api.nvim_set_hl(0, "StatusLineTerm", colors.term)

	-- Git colors
	vim.api.nvim_set_hl(0, "SLGitBranch", colors.git_branch)
	vim.api.nvim_set_hl(0, "SLGitDiffAdd", colors.git_add)
	vim.api.nvim_set_hl(0, "SLGitDiffChange", colors.git_change)
	vim.api.nvim_set_hl(0, "SLGitDiffDelete", colors.git_delete)
end

-- Setup colors initially
setup_statusline_colors()

-- Auto-update colors when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	group = statusline_augroup,
	callback = setup_statusline_colors,
})

-- Get LSP diagnostic count
local function get_lsp_diagnostics_count(severity)
	local diagnostics = vim.diagnostic.get(0, { severity = severity })
	return #diagnostics
end

-- Get git diff stats
local function get_git_diff(type)
	local git_status = vim.b.gitsigns_status_dict
	return (git_status and git_status[type] and git_status[type] ~= 0) and tostring(git_status[type]) or ""
end

-- Mode mappings
local mode_map = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	R = "REPLACE",
	t = "TERM",
}

local mode_color = {
	NORMAL = "StatusLineNormal",
	INSERT = "StatusLineInsert",
	VISUAL = "StatusLineVisual",
	["V-LINE"] = "StatusLineVLine",
	["V-BLOCK"] = "StatusLineVBlock",
	COMMAND = "StatusLineCommand",
	REPLACE = "StatusLineReplace",
	TERM = "StatusLineTerm",
	UNKNOWN = "StatusLine",
}

local function mode()
	local current_mode = mode_map[vim.api.nvim_get_mode().mode] or "UNKNOWN"
	local hl = mode_color[current_mode] or "StatusLine"
	return string.format("%%#%s# %s %%*", hl, current_mode)
end

local function diagnostics(severity, hl, symbol)
	local count = get_lsp_diagnostics_count(severity)
	return count > 0 and string.format("%%#%s# %s%s%%*", hl, symbol, count) or ""
end

local function diagnostics_display()
	return table.concat({
		diagnostics(vim.diagnostic.severity.ERROR, "DiagnosticError", "E"),
		diagnostics(vim.diagnostic.severity.WARN, "DiagnosticWarn", "W"),
		diagnostics(vim.diagnostic.severity.INFO, "DiagnosticInfo", "I"),
		diagnostics(vim.diagnostic.severity.HINT, "DiagnosticHint", "H"),
	}, " ")
end

-- LSP Progress tracking
local lsp_progress = {
	client = nil,
	kind = nil,
	title = nil,
	percentage = nil,
	message = nil,
}

-- Combined LSP status - shows either progress or active clients, not both

local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	if #clients == 0 then
		return ""
	end

	-- Ưu tiên hiện progress nếu có
	if lsp_progress.client and lsp_progress.title and vim.o.columns >= 100 then
		local msg = string.format(
			"%s %s %s",
			lsp_progress.title,
			lsp_progress.message or "",
			lsp_progress.percentage and (lsp_progress.percentage .. "%%") or ""
		)
		return string.format("%%#MsgArea# LSP:%s | %s %%*", lsp_progress.client, msg)
	end

	-- Nếu không có progress thì chỉ hiện tên client
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return string.format("%%#Normal# LSP:%s %%*", table.concat(names, ","))
end

-- LSP Progress handler
vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end

	local value = result.value
	if not value then
		return
	end

	-- Update progress info
	if value.kind == "begin" then
		lsp_progress.client = client.name
		lsp_progress.title = value.title or ""
		lsp_progress.percentage = value.percentage
		lsp_progress.message = value.message
	elseif value.kind == "report" then
		lsp_progress.percentage = value.percentage
		lsp_progress.message = value.message or lsp_progress.message
	elseif value.kind == "end" then
		-- Clear progress after a short delay
		vim.defer_fn(function()
			lsp_progress.client = nil
			lsp_progress.title = nil
			lsp_progress.percentage = nil
			lsp_progress.message = nil
			vim.cmd("redrawstatus")
		end, 1000)
	end

	vim.cmd("redrawstatus")
end

-- Git info
local function git_info()
	local branch = vim.b.gitsigns_head or ""
	if branch == "" then
		return ""
	end
	return string.format("%%#Normal#  %s %%*", branch)
end

local function git_diff()
	local added = get_git_diff("added")
	local changed = get_git_diff("changed")
	local removed = get_git_diff("removed")
	local parts = {}
	if added ~= "" and added ~= "0" then
		table.insert(parts, string.format("%%#diffAdded#+%s%%*", added))
	end
	if changed ~= "" and changed ~= "0" then
		table.insert(parts, string.format("%%#diffChanged#~%s%%*", changed))
	end
	if removed ~= "" and removed ~= "0" then
		table.insert(parts, string.format("%%#diffRemoved#-%s%%*", removed))
	end
	return table.concat(parts, " ")
end

-- File info
local function file_percentage()
	return string.format(
		"%%#Normal# %d%%%% %%*",
		math.ceil(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
	)
end

local function total_lines()
	return string.format("%%#Normal#of %s %%*", vim.fn.line("$"))
end

local function readonly_indicator()
	return vim.bo.readonly and " " or ""
end

local function keyboard_layout()
	return vim.g.toggle_colemark and "󰨑 COLEMAK" or "󰌓 QWERTY"
end

local function file_encoding()
	local fenc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
	return string.format(" %s", fenc)
end

-- Status line
StatusLine = {}

StatusLine.active = function()
	return table.concat({
		mode(),
		" %t",
		readonly_indicator(),
		"%m",
		git_info(),
		git_diff(),
		"%=",
		diagnostics_display(),
		lsp_status(), -- Now shows either progress OR clients, not both
		keyboard_layout(),
		file_encoding(),
		" %3l:%-2c",
		file_percentage(),
		total_lines(),
	})
end

StatusLine.inactive = function()
	local ft = vim.bo.filetype or ""
	if ft == "qf" then
		return "%#StatusLineNC# [Quickfix List] %= %3l:%-2c %#Normal#"
	end
	return "%#StatusLineNC# %t %= %3l:%-2c %#Normal#"
end

vim.opt.statusline = "%!v:lua.StatusLine.active()"

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType" }, {
	group = statusline_augroup,
	pattern = {
		"NvimTree_1",
		"NvimTree",
		"TelescopePrompt",
		"fzf",
		"lspinfo",
		"lazy",
		"netrw",
		"mason",
		"noice",
		"qf",
		"mini",
	},
	callback = function()
		vim.opt_local.statusline = "%!v:lua.StatusLine.inactive()"
	end,
})
