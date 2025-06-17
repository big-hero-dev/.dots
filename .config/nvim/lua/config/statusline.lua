---@diagnostic disable: duplicate-set-field
local statusline_augroup = vim.api.nvim_create_augroup("gmr_statusline", { clear = true })

-- Get LSP diagnostic count
local function get_lsp_diagnostics_count(severity)
	return vim.diagnostic.count(0, { severity = severity })[severity] or 0
end

-- Get git diff stats
local function get_git_diff(type)
	local git_status = vim.b.gitsigns_status_dict
	if not git_status or not git_status[type] or git_status[type] == 0 then
		return ""
	end
	return tostring(git_status[type])
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

local function mode()
	return string.format("%%#StatusLine#%s%%*", mode_map[vim.api.nvim_get_mode().mode] or "UNKNOWN")
end

-- LSP Clients
local function lsp_active()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	return #clients > 0
			and string.format(
				"%%#Normal# %s %%*",
				table.concat(
					vim.tbl_map(function(c)
						return c.name
					end, clients),
					","
				)
			)
		or ""
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

local lsp_progress = {
	client = nil,
	kind = nil,
	title = nil,
	percentage = nil,
	message = nil,
}

local function lsp_status()
	if not lsp_progress.client or not lsp_progress.title or vim.o.columns < 120 then
		return ""
	end
	local msg = string.format(
		"%s %s %s",
		lsp_progress.title,
		lsp_progress.message or "",
		lsp_progress.percentage and lsp_progress.percentage .. "%%" or ""
	)
	return string.format("%%#MsgArea#%s%%* ", msg)
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end

	local value = result.value
	if not value then
		return
	end

	lsp_progress.client = client.name
	lsp_progress.kind = value.kind
	lsp_progress.title = value.title or ""
	lsp_progress.percentage = value.percentage
	lsp_progress.message = value.message

	vim.cmd("redrawstatus")
end

-- Git info
local function git_info()
	local branch = vim.b.gitsigns_head or ""
	if branch == "" then
		return ""
	end
	return string.format("%%#Normal#  %s %%*", branch)
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
		"%%#Normal#  %d%%%% %%*",
		math.ceil(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
	)
end

local function total_lines()
	return string.format("%%#Normal#of %s %%*", vim.fn.line("$"))
end

local function readonly_indicator()
	return vim.bo.readonly and " " or ""
end

local function keyboard_layout()
	return vim.g.toggle_colemark and " Colemak-DH" or ""
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
		lsp_status(),
		lsp_active(),
		keyboard_layout(),
		" %3l:%-2c",
		file_percentage(),
		total_lines(),
	})
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
