require("vim._core.ui2").enable({})
require("tiny-cmdline").setup({
	on_reposition = require("tiny-cmdline").adapters.blink,
})
