local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "chrisgrieser/nvim-lsp-endhints" })
require("lsp-endhints").setup()
