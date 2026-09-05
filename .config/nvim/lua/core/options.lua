-- lua/core/options.lua
-- Core options · Optimized for Neovim 0.13

local opt = vim.opt
local g = vim.g

-- Disable unused providers (giảm startup)
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

-- Global
g.editorconfig = false
g.border = "rounded"
g.toggle_colemark = true

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.cmdheight = 0
opt.laststatus = 3
opt.showtabline = 2
opt.showmode = false
opt.showcmdloc = "statusline"
opt.pumheight = 10
opt.winblend = 0
opt.title = true
opt.list = true
opt.listchars = { eol = "", tab = " ", trail = "·" }
opt.fillchars = {
  fold = " ",
  eob = " ",
  diff = "∙",
  msgsep = "‾",
}
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.conceallevel = 2

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.scrolljump = 5
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.timeoutlen = 400
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")
opt.backspace = "indent,eol,start"
opt.isfname:append("@-@")
opt.iskeyword:append("-")
opt.matchpairs = "(:),{:},[:],<:>"

-- Indent
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8"

-- Cursor
opt.guicursor = "n-v-c:block,i-ci-ve:hor20,a:blinkwait700-blinkoff400-blinkon250"

-- Wildmenu
opt.wildmenu = true
opt.wildmode = { "longest:full", "full" }
opt.wildignorecase = true
opt.visualbell = false
opt.ruler = false
