local MiniDeps = require("mini.deps")
local add = MiniDeps.add

add({ source = "m4xshen/hardtime.nvim", depends = { "MunifTanjim/nui.nvim" } })

require("hardtime").setup()
