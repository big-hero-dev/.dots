local M = {}

local uv = vim.uv or vim.loop
local fn = vim.fn
local api = vim.api

-- ==============================================================
-- Namespaces
-- ==============================================================

local ns_buf = api.nvim_create_namespace("haunt_buf")
local ns_panel = api.nvim_create_namespace("haunt_panel")

-- ==============================================================
-- State
-- ==============================================================

local state = {
	haunts = {}, -- [filepath] = { { lnum, text, group, order } }
	config = {},
	panel_items = {}, -- array: { path, lnum, group, line }
}

-- ==============================================================
-- Config
-- ==============================================================

local defaults = {
	sign = "󱙝",
	annotation_prefix = " 󰆉 ",
	virt_text_pos = "eol",
	virt_text_hl = "DiagnosticInfo",
	line_hl = nil,
	data_dir = fn.stdpath("data") .. "/mini-haunt",
}

-- ==============================================================
-- Utils
-- ==============================================================

local function ensure_dir(path)
	if not uv.fs_stat(path) then
		uv.fs_mkdir(path, 448) -- 0700
	end
end

local function buf_path(buf)
	return api.nvim_buf_get_name(buf)
end

local function data_file(path)
	return state.config.data_dir .. "/" .. fn.sha256(path) .. ".json"
end

local function parse_group(text)
	local g, rest = text:match("^%[(%w+)%]%s*(.+)")
	if g then
		return g, rest
	end
	return "note", text
end

local function haunt_hl(group)
	return ({
		bug = "DiagnosticError",
		fix = "DiagnosticWarn",
		idea = "DiagnosticHint",
		refa = "DiagnosticInfo",
		note = state.config.virt_text_hl,
	})[group] or state.config.virt_text_hl
end

-- ==============================================================
-- Persistence
-- ==============================================================

local function load_file(path)
	local f = data_file(path)
	if not uv.fs_stat(f) then
		return {}
	end
	local ok, decoded = pcall(vim.json.decode, table.concat(fn.readfile(f), "\n"))
	return ok and decoded or {}
end

local function save_file(path, data)
	ensure_dir(state.config.data_dir)
	fn.writefile(vim.split(vim.json.encode(data), "\n"), data_file(path))
end

-- ==============================================================
-- Buffer Rendering
-- ==============================================================

local function clear_buf(buf)
	api.nvim_buf_clear_namespace(buf, ns_buf, 0, -1)
end

local function render(buf)
	clear_buf(buf)

	local path = buf_path(buf)
	local items = state.haunts[path]
	if not items then
		return
	end

	for _, h in ipairs(items) do
		local lnum = h.lnum - 1
		if lnum >= 0 and lnum < api.nvim_buf_line_count(buf) then
			local hl = haunt_hl(h.group)

			api.nvim_buf_set_extmark(buf, ns_buf, lnum, 0, {
				sign_text = state.config.sign,
				sign_hl_group = hl,
				virt_text = {
					{
						string.format("%s[%s] %s", state.config.annotation_prefix, h.group, h.text),
						hl,
					},
				},
				virt_text_pos = state.config.virt_text_pos,
				line_hl_group = state.config.line_hl,
			})
		end
	end
end

-- ==============================================================
-- Core API
-- ==============================================================

function M.add()
	local buf = api.nvim_get_current_buf()
	local path = buf_path(buf)
	if path == "" then
		return
	end

	local lnum = api.nvim_win_get_cursor(0)[1]
	local input = fn.input("Haunt: ")
	if input == "" then
		return
	end

	local group, text = parse_group(input)

	state.haunts[path] = state.haunts[path] or {}
	table.insert(state.haunts[path], {
		lnum = lnum,
		text = text,
		group = group,
		order = uv.now(),
	})

	save_file(path, state.haunts[path])
	render(buf)
end

function M.clear_line()
	local buf = api.nvim_get_current_buf()
	local path = buf_path(buf)
	local lnum = api.nvim_win_get_cursor(0)[1]

	local items = state.haunts[path]
	if not items then
		return
	end

	state.haunts[path] = vim.tbl_filter(function(h)
		return h.lnum ~= lnum
	end, items)

	save_file(path, state.haunts[path])
	render(buf)
end

function M.clear_buffer()
	local buf = api.nvim_get_current_buf()
	local path = buf_path(buf)
	if path == "" then
		return
	end

	local choice = fn.confirm("Delete ALL haunts in this buffer?", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	state.haunts[path] = nil
	local f = data_file(path)
	if uv.fs_stat(f) then
		uv.fs_unlink(f)
	end

	clear_buf(buf)
end

function M.clear_project()
	local choice = fn.confirm("Delete ALL haunts in this project?\n\nThis cannot be undone.", "&Yes\n&No", 2)
	if choice ~= 1 then
		return
	end

	state.haunts = {}

	if uv.fs_stat(state.config.data_dir) then
		local h = uv.fs_scandir(state.config.data_dir)
		if h then
			while true do
				local name = uv.fs_scandir_next(h)
				if not name then
					break
				end
				uv.fs_unlink(state.config.data_dir .. "/" .. name)
			end
		end
	end

	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(buf) then
			clear_buf(buf)
		end
	end
end

-- ==============================================================
-- Panel UI (open_panel style)
-- ==============================================================

function M.open_panel()
	state.prev_win = vim.api.nvim_get_current_win()
	local buf = api.nvim_create_buf(false, true)
	local origin_win = vim.api.nvim_get_current_win()

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "mini-haunt"

	vim.bo[buf].modifiable = true
	vim.bo[buf].undolevels = 1000

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.6)

	local win = api.nvim_open_win(buf, true, {
		relative = "editor",
		style = "minimal",
		border = "rounded",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
	})

	vim.wo[win].cursorline = true

	M._render_panel(buf)

	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, {
			buffer = buf,
			silent = true,
			desc = desc,
		})
	end

	map("q", function()
		api.nvim_win_close(win, true)
	end, "Haunt panel: close")

	map("<CR>", function()
		M._panel_jump(buf, origin_win, win)
	end, "Haunt panel: jump to location")

	map("dd", function()
		M._panel_delete(buf)
	end, "Haunt panel: delete annotation")

	map("u", function()
		M.undo()
		M._render_panel(buf)
	end, "Haunt panel: undo delete")
end

function M._panel_jump(panel_buf, target_win, panel_win)
	local cur = api.nvim_win_get_cursor(0)[1]

	for _, item in ipairs(state.panel_items) do
		if item.line == cur then
			if not api.nvim_win_is_valid(target_win) then
				return
			end

			local buf = fn.bufadd(item.path)
			fn.bufload(buf)

			-- Đóng panel trước
			if panel_win and api.nvim_win_is_valid(panel_win) then
				api.nvim_win_close(panel_win, true)
			end

			-- Sau đó jump đến vị trí
			api.nvim_set_current_win(target_win)
			api.nvim_win_set_buf(target_win, buf)
			api.nvim_win_set_cursor(target_win, { item.lnum, 0 })
			return
		end
	end
end

function M._render_panel(buf)
	api.nvim_buf_clear_namespace(buf, ns_panel, 0, -1)

	local lines = {}
	state.panel_items = {}

	table.insert(lines, " Haunts")
	table.insert(lines, string.rep("─", 50))

	for path, hs in pairs(state.haunts) do
		local fname = fn.fnamemodify(path, ":t")
		table.insert(lines, "")
		table.insert(lines, " " .. fname)

		for _, h in ipairs(hs) do
			local group = string.format("[%-4s]", h.group)
			table.insert(lines, string.format("  %s %5d │ %s", group, h.lnum, h.text))

			table.insert(state.panel_items, {
				path = path,
				lnum = h.lnum,
				group = h.group,
				line = #lines,
			})
		end
	end

	vim.bo[buf].modifiable = true
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	for _, item in ipairs(state.panel_items) do
		api.nvim_buf_set_extmark(buf, ns_panel, item.line - 1, 0, {
			line_hl_group = haunt_hl(item.group),
			priority = 200,
		})
	end
end

-- ==============================================================
-- Lifecycle
-- ==============================================================

function M.undo()
	state.undo_stack = state.undo_stack or {}
	if #state.undo_stack == 0 then
		vim.notify("No actions to undo", vim.log.levels.INFO)
		return
	end

	local last = table.remove(state.undo_stack)

	if last.action == "delete_from_panel" then
		state.haunts[last.path] = state.haunts[last.path] or {}
		table.insert(state.haunts[last.path], last.data)
		save_file(last.path, state.haunts[last.path])

		for _, buf in ipairs(api.nvim_list_bufs()) do
			if buf_path(buf) == last.path then
				render(buf)
			end
		end

		vim.notify("Undo successful", vim.log.levels.INFO)
	end
end

function M._panel_delete(buf)
	local cur = api.nvim_win_get_cursor(0)[1]

	for _, item in ipairs(state.panel_items) do
		if item.line == cur then
			local msg = string.format("Delete haunt [%s] at line %d?\n\n%s", item.group, item.lnum, item.path)

			local choice = fn.confirm(msg, "&Yes\n&No", 2)
			if choice ~= 1 then
				return
			end

			state.undo_stack = state.undo_stack or {}
			table.insert(state.undo_stack, {
				action = "delete_from_panel",
				path = item.path,
				data = {
					lnum = item.lnum,
					group = item.group,
					text = item.text,
					order = item.order,
				},
			})

			local hs = state.haunts[item.path]
			if not hs then
				return
			end

			state.haunts[item.path] = vim.tbl_filter(function(h)
				return not (h.lnum == item.lnum and h.group == item.group)
			end, hs)

			save_file(item.path, state.haunts[item.path])

			for _, b in ipairs(api.nvim_list_bufs()) do
				if buf_path(b) == item.path then
					render(b)
				end
			end

			M._render_panel(buf)
			return
		end
	end
end

local function load_buffer(buf)
	local path = buf_path(buf)
	if path == "" then
		return
	end

	state.haunts[path] = load_file(path)
	render(buf)
end

function M.setup(opts)
	state.config = vim.tbl_deep_extend("force", defaults, opts or {})
	ensure_dir(state.config.data_dir)

	api.nvim_create_autocmd("BufReadPost", {
		desc = "mini-haunt: load haunts",
		callback = function(args)
			load_buffer(args.buf)
		end,
	})

	api.nvim_create_autocmd("BufEnter", {
		desc = "mini-haunt: render haunts",
		callback = function(args)
			render(args.buf)
		end,
	})

	vim.keymap.set("n", "<leader>na", M.add, {
		desc = "Add annotation",
	})
	vim.keymap.set("n", "<leader>nd", M.clear_line, {
		desc = "Delete annotation at line",
	})
	vim.keymap.set("n", "<leader>nD", M.clear_buffer, {
		desc = "Delete all in buffer",
	})
	vim.keymap.set("n", "<leader>nP", M.clear_project, {
		desc = "Delete all in project",
	})
	vim.keymap.set("n", "<leader>np", M.open_panel, {
		desc = "Open panelg",
	})
end

M.setup()
