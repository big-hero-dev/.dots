local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.toggle_colemark = true

-- Utility: Clear Colemak-related mappings
local function clear_mappings()
	local modes = { "n", "v", "x", "i" }
	local keys = { "n", "e", "i", "u", "U", "l" }
	for _, mode in ipairs(modes) do
		for _, key in ipairs(keys) do
			pcall(vim.keymap.del, mode, key, {})
		end
	end
end

-- Apply Colemak layout remaps
local function active_layout()
	clear_mappings()

	if vim.g.toggle_colemark then
		local modes = { "n", "v", "x" }
		local layout_map = {
			n = "j",
			e = "k",
			i = "l",
			u = "i",
			U = "I",
			l = "u",
		}

		for lhs, rhs in pairs(layout_map) do
			map(modes, lhs, rhs, opts)
		end

		map("x", "l", ":<C-U>undo<CR>", opts) -- Undo in visual mode
	end

	vim.defer_fn(function()
		if package.loaded["lualine"] then
			require("lualine").refresh()
		end
	end, 100)
end

-- Toggle layout (Colemak <-> QWERTY)
local function toggle_layout()
	vim.g.toggle_colemark = not vim.g.toggle_colemark
	active_layout()
end

-- Core keymaps
map("n", "<leader>lc", toggle_layout, { desc = "Toggle Colemak layout" })

-- Basic
map("n", "x", '"_x') -- Don't copy when deleting single char
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit file" })
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Window navigation
map("n", "ss", ":split<CR><C-w>w")
map("n", "sv", ":vsplit<CR><C-w>w")
map("n", "wh", "<C-w>h")
map("n", "wn", "<C-w>j")
map("n", "we", "<C-w>k")
map("n", "wi", "<C-w>l")

-- Move lines
map({ "n", "v" }, "<A-n>", ":m .+1<CR>==", opts)
map({ "n", "v" }, "<A-e>", ":m .-2<CR>==", opts)
map("i", "<A-n>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-e>", "<Esc>:m .-2<CR>==gi", opts)

-- Search enhancements
map("n", "<ESC>", "<cmd>noh<CR>", opts)
map("n", "m", "nzzzv")
map("n", "M", "Nzzzv")
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

-- Command mode
map("c", "<C-e>", "<C-p>")

-- Buffers
map("n", "<Tab>", vim.cmd.bn)
map("n", "<S-Tab>", vim.cmd.bp)

-- Links
map("n", "gx", function()
	local url = vim.fn.expand("<cfile>")
	vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end, { desc = "Open link under cursor" })

-- Disable 's'
map({ "n", "v" }, "s", "<Nop>")

-- Terminal
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Tmux-aware navigation
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

-- Scroll centering
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Apply layout
-- Apply layout immediately and after short delay (for UI plugins to init)
active_layout()
vim.defer_fn(active_layout, 200)

-- Optional export if you want to use this in other modules
return {
	active_layout = active_layout,
}
