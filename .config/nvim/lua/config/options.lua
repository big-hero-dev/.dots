vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- Disable EditorConfig
vim.g.editorconfig = false

local opt = vim.opt -- for conciseness

-- Line number
opt.nu = true
opt.relativenumber = true

-- Tab & indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor
opt.cursorline = true
opt.mouse = "a"
opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
opt.swapfile = false
opt.backup = false
opt.compatible = false
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.winblend = 0
opt.background = "dark"
opt.listchars:append({ eol = "", tab = " ", trail = "·" })
opt.list = true
opt.title = true
opt.pumheight = 10

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"
vim.g.clipboard = {
	name = "xclip",
	copy = {
		["+"] = "xclip -selection clipboard -i",
		["*"] = "xclip -selection clipboard -i",
	},
	paste = {
		["+"] = "xclip -selection clipboard -o",
		["*"] = "xclip -selection clipboard -o",
	},
	cache_enabled = 0,
}

opt.updatetime = 250

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"

-- Disable nvim intro
-- opt.shortmess:append("sI")

-- Slit windows
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

opt.timeoutlen = 400
opt.iskeyword:append("-")
-- Number of item show popup menu
opt.ph = 7

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Cs = "\e[4:0m"]])
vim.cmd("set path+=**")

opt.ruler = false
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.wo.conceallevel = 2

opt.cmdheight = 0
opt.showcmd = true
opt.showcmdloc = "statusline"
opt.showmode = false

opt.laststatus = 3
opt.showtabline = 2

opt.completeopt = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	float = {
		border = "single",
	},
	underline = true,
	jump = {
		float = true,
	},
})

vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})
