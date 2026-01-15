local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.toggle_colemark = true

local function clear_mappings()
	local modes = { "n", "v", "x", "i" }
	local keys = { "n", "e", "i", "u", "U", "l" }
	for _, mode in ipairs(modes) do
		for _, key in ipairs(keys) do
			pcall(vim.keymap.del, mode, key, {})
		end
	end
end

local function active_layout()
	clear_mappings()
	if vim.g.toggle_colemark then
		local normal_mode_keys = {
			n = "j",
			e = "k",
			i = "l",
			u = "i",
			U = "I",
			l = "u",
		}
		for lhs, rhs in pairs(normal_mode_keys) do
			map({ "n", "v" }, lhs, rhs, opts)
		end
		map("x", "l", ":<C-U>undo<CR>", opts)
	end
end

local function toggle_layout()
	vim.g.toggle_colemark = not vim.g.toggle_colemark
	active_layout()
end

map("n", "<leader>lc", toggle_layout, { desc = "Toggle Colemak layout" })

map("n", "x", '"_x')
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit file" })
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

map("n", "ss", ":split<CR><C-w>w")
map("n", "sv", ":vsplit<CR><C-w>w")
map("n", "wh", "<C-w>h")
map("n", "wn", "<C-w>j")
map("n", "we", "<C-w>k")
map("n", "wi", "<C-w>l")

map({ "n", "v" }, "<A-n>", ":m .+1<CR>==", opts)
map({ "n", "v" }, "<A-e>", ":m .-2<CR>==", opts)
map("i", "<A-n>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-e>", "<Esc>:m .-2<CR>==gi", opts)

map("n", "<ESC>", "<cmd>noh<CR>", opts)
map("n", "m", "nzzzv")
map("n", "M", "Nzzzv")
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

map("c", "<C-e>", "<C-p>")

map("n", "<Tab>", vim.cmd.bn)
map("n", "<S-Tab>", vim.cmd.bp)

map("n", "gx", function()
	local url = vim.fn.expand("<cfile>")
	vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end, { desc = "Open link under cursor" })

map({ "n", "v" }, "s", "<Nop>")

map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local function move(direction, tmux_flag)
	local current = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. direction)
	if vim.api.nvim_get_current_win() == current then
		vim.fn.system("tmux select-pane -" .. tmux_flag)
	end
end

map("n", "<C-Left>", function()
	move("h", "L")
end, opts)
map("n", "<C-Down>", function()
	move("j", "D")
end, opts)
map("n", "<C-Up>", function()
	move("k", "U")
end, opts)
map("n", "<C-Right>", function()
	move("l", "R")
end, opts)

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

active_layout()
