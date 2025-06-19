local add = require("mini.deps").add

add({ source = "chrisgrieser/nvim-lsp-endhints" })
require("lsp-endhints").setup()
