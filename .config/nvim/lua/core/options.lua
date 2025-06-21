-- Global settings
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_browsex_viewer = "xdg-open"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.editorconfig = false

local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.mouse = "a"
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.compatible = false
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.scrolljump = 5
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.winblend = 0
opt.background = "dark"
opt.list = true
opt.title = true
opt.pumheight = 10
opt.updatetime = 250
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.timeoutlen = 400
opt.cmdheight = 0
opt.shortmess:append("c")
opt.showcmdloc = "statusline"
opt.showmode = false
opt.laststatus = 3
opt.showtabline = 2
opt.completeopt = { "menu", "menuone", "noselect" }

-- Tab & indent
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.autoindent = true
opt.smartindent = true

-- Cursor
opt.cursorline = true
opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Others
opt.backspace = "indent,eol,start"
opt.listchars:append({ eol = "", tab = " ", trail = "·" })
opt.isfname:append("@-@")
opt.iskeyword:append("-")
opt.ruler = false
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
vim.wo.conceallevel = 2
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.fillchars = {
	fold = " ",
	eob = " ",
	diff = "∙",
	msgsep = "‾",
}

vim.scriptencoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8"

opt.wildmenu = true
opt.wildmode = { "longest:full", "full" }
opt.wildignorecase = true

vim.cmd("syntax enable")
opt.clipboard = "unnamedplus"
opt.errorbells = false
opt.visualbell = true

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	float = {
		focusable = false,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
		scope = "cursor",
		border = "single",
		prefix = " - ",
		header = "",
	},
	underline = true,
	jump = {
		float = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "e",
			[vim.diagnostic.severity.WARN] = "w",
			[vim.diagnostic.severity.INFO] = "i",
			[vim.diagnostic.severity.HINT] = "h",
		},
	},
	update_in_insert = false,
	severity_sort = true,
})
