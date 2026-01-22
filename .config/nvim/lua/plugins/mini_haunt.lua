local M = {}

local uv = vim.uv or vim.loop
local fn = vim.fn

local ns = vim.api.nvim_create_namespace("mini_haunt")

local state = {
	haunts = {}, -- [filepath] = { { lnum, text } }
	config = {},
}

local defaults = {
	sign = "󱙝",
	sign_hl = "DiagnosticInfo",
	virt_text_hl = "DiagnosticInfo",
	annotation_prefix = " 󰆉 ",
	virt_text_pos = "eol",
	line_hl = nil,
	data_dir = fn.stdpath("data") .. "/mini-haunt",
}

-- utils ---------------------------------------------------------

local function ensure_dir(path)
	if not uv.fs_stat(path) then
		uv.fs_mkdir(path, 448) -- 0700
	end
end

local function buf_path(buf)
	return vim.api.nvim_buf_get_name(buf)
end

local function data_file(path)
	return state.config.data_dir .. "/" .. fn.sha256(path) .. ".json"
end

local function load_file(path)
	local f = data_file(path)
	if not uv.fs_stat(f) then
		return {}
	end
	local content = table.concat(fn.readfile(f), "\n")
	local ok, decoded = pcall(vim.json.decode, content)
	return ok and decoded or {}
end

local function save_file(path, data)
	ensure_dir(state.config.data_dir)
	local f = data_file(path)
	local encoded = vim.json.encode(data)
	fn.writefile(vim.split(encoded, "\n"), f)
end

-- rendering -----------------------------------------------------

local function clear(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

local function render(buf)
	clear(buf)

	local path = buf_path(buf)
	local items = state.haunts[path]
	if not items then
		return
	end

	for _, h in ipairs(items) do
		local lnum = h.lnum - 1
		if lnum >= 0 and lnum < vim.api.nvim_buf_line_count(buf) then
			vim.api.nvim_buf_set_extmark(buf, ns, lnum, 0, {
				sign_text = state.config.sign,
				sign_hl_group = state.config.sign_hl,
				virt_text = {
					{ state.config.annotation_prefix .. h.text, state.config.virt_text_hl },
				},
				virt_text_pos = state.config.virt_text_pos,
				line_hl_group = state.config.line_hl,
			})
		end
	end
end

-- core logic ----------------------------------------------------

function M.add()
	local buf = vim.api.nvim_get_current_buf()
	local path = buf_path(buf)
	if path == "" then
		return
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local text = fn.input("Haunt: ")
	if text == "" then
		return
	end

	state.haunts[path] = state.haunts[path] or {}
	table.insert(state.haunts[path], {
		lnum = lnum,
		text = text,
	})

	save_file(path, state.haunts[path])
	render(buf)
end

function M.clear_line()
	local buf = vim.api.nvim_get_current_buf()
	local path = buf_path(buf)
	local lnum = vim.api.nvim_win_get_cursor(0)[1]

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

function M.list()
	local pick = require("mini.pick")

	local items = {}

	for path, hs in pairs(state.haunts) do
		for _, h in ipairs(hs) do
			table.insert(items, {
				path = path,
				lnum = h.lnum,
				text = h.text,
			})
		end
	end

	if #items == 0 then
		vim.notify("No haunts found", vim.log.levels.INFO, {
			title = "Mini Haunt",
		})
		return
	end

	pick.start({
		preview = false,
		source = {
			name = "Haunts",
			items = items,
			format = function(h)
				local fname = vim.fn.fnamemodify(h.path, ":t")
				return string.format("%s:%d  %s", fname, h.lnum, h.text)
			end,
		},
		action = function(h)
			vim.cmd("edit " .. vim.fn.fnameescape(h.path))
			vim.api.nvim_win_set_cursor(0, { h.lnum, 0 })
			return true
		end,
	})
end

function M.clear_buffer()
	local buf = vim.api.nvim_get_current_buf()
	local path = buf_path(buf)
	if path == "" then
		return
	end

	if not state.haunts[path] or vim.tbl_isempty(state.haunts[path]) then
		vim.notify("No haunts in current buffer", vim.log.levels.INFO, {
			title = "Mini Haunt",
		})
		return
	end

	state.haunts[path] = nil

	local f = data_file(path)
	if uv.fs_stat(f) then
		uv.fs_unlink(f)
	end

	clear(buf)

	vim.notify("Cleared haunts in current buffer", vim.log.levels.INFO, {
		title = "Mini Haunt",
	})
end

function M.clear_all()
	if vim.tbl_isempty(state.haunts) then
		vim.notify("No haunts to clear", vim.log.levels.INFO, {
			title = "Mini Haunt",
		})
		return
	end
	state.haunts = {}

	if uv.fs_stat(state.config.data_dir) then
		local handle = uv.fs_scandir(state.config.data_dir)
		if handle then
			while true do
				local name = uv.fs_scandir_next(handle)
				if not name then
					break
				end
				uv.fs_unlink(state.config.data_dir .. "/" .. name)
			end
		end
	end

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			clear(buf)
		end
	end

	vim.notify("All haunts cleared", vim.log.levels.INFO, {
		title = "Mini Haunt",
	})
end

-- lifecycle ----------------------------------------------------

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

	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function(args)
			load_buffer(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			render(args.buf)
		end,
	})

	-- keymaps (parity with haunt.nvim)
	vim.keymap.set("n", "<leader>ha", M.add, { desc = "Haunt add" })
	vim.keymap.set("n", "<leader>hd", M.clear_line, { desc = "Haunt delete" })
	vim.keymap.set("n", "<leader>hl", M.list, { desc = "Haunt list" })
	vim.keymap.set("n", "<leader>hD", M.clear_buffer, { desc = "Haunt delete buffer" })
	vim.keymap.set("n", "<leader>hX", M.clear_all, { desc = "Haunt delete all" })
end

M.setup()
