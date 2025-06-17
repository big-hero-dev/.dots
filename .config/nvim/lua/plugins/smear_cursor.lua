local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "sphamba/smear-cursor.nvim" })
require("smear_cursor").setup()
