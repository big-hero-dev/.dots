local opt = vim.opt

-- Global settings
vim.g.editorconfig = false
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.nu = true
opt.relativenumber = true
opt.mouse = "a"
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.hlsearch = false
opt.incsearch = true
opt.scrolloff = 8
opt.scrolljump = 5
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.winblend = 0
opt.list = true
opt.title = true
opt.pumheight = 10
opt.updatetime = 250
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.timeoutlen = 400
opt.cmdheight = 1
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
opt.guicursor = "n-v-c:block,i-ci-ve:hor20,a:blinkwait700-blinkoff400-blinkon250"

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
opt.matchpairs = "(:),{:},[:],<:>"
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
opt.visualbell = false
