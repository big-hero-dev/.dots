local g = vim.g

-- Disable unused providers (giảm startup)
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.clipboard = {
	name = "wl-clipboard",
	copy = { ["+"] = "wl-copy", ["*"] = "wl-copy --primary" },
	paste = { ["+"] = "wl-paste", ["*"] = "wl-paste --primary --no-newline" },
	cache_enabled = 1,
}

-- Global
g.editorconfig = false
g.border = "rounded"
g.toggle_colemark = true

-- UI
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.showmode = false
vim.opt.showcmdloc = "statusline"
vim.opt.pumheight = 10
vim.opt.winblend = 0
vim.opt.title = true
vim.opt.list = true
vim.opt.listchars = { eol = "", tab = " ", trail = "·" }
vim.opt.fillchars = {
	fold = " ",
	eob = " ",
	diff = "∙",
	msgsep = "‾",
}
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.conceallevel = 2

-- Behavior
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.scrolljump = 5
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.backspace = "indent,eol,start"
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.matchpairs = "(:),{:},[:],<:>"

-- Indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

-- Cursor
vim.opt.guicursor = "n-v-c:block,i-ci-ve:hor20,a:blinkwait700-blinkoff400-blinkon250"

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildignorecase = true
vim.opt.visualbell = false
vim.opt.ruler = false
