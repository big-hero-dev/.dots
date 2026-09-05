local pack = vim.pack

----------------------------------------------------------------------
-- Helper: lazy load on event
----------------------------------------------------------------------
local function on_event(events, plugins, setup)
	local name = type(events) == "table" and table.concat(events, "_") or tostring(events)
	vim.api.nvim_create_autocmd(events, {
		group = vim.api.nvim_create_augroup("lazy_" .. name, { clear = true }),
		once = true,
		callback = function()
			if plugins and #plugins > 0 then
				pack.add(plugins)
			end
			if setup then
				setup()
			end
		end,
	})
end

----------------------------------------------------------------------
-- Helper: lazy load on keymap (load once, keep keymap forever)
----------------------------------------------------------------------
local function on_keys(keys, plugins, setup)
	for _, key in ipairs(keys) do
		local mode = key.mode or "n"
		local lhs = key[1]
		local rhs = key[2]
		local opts = key[3] or {}
		local loaded = false

		vim.keymap.set(mode, lhs, function()
			-- Only load + setup once
			if not loaded then
				loaded = true
				if plugins and #plugins > 0 then
					pack.add(plugins)
				end
				if setup then
					setup()
				end
			end

			if type(rhs) == "function" then
				rhs()
			elseif type(rhs) == "string" then
				vim.cmd(rhs)
			end
		end, opts)
	end
end

----------------------------------------------------------------------
-- 1. EAGER
----------------------------------------------------------------------
pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/nvim-mini/mini.nvim",
})

local ui = require("plugins.ui")
ui.setup_core()

-- mini.* modules that don't need to exist before the first screen: run on the next tick
vim.schedule(function()
	ui.setup_deferred()
end)

----------------------------------------------------------------------
-- 2. UIEnter
----------------------------------------------------------------------
on_event({ "UIEnter" }, {
	"https://github.com/rachartier/tiny-cmdline.nvim",
}, function()
	require("plugins.ui").cmdline()
end)

----------------------------------------------------------------------
-- 3. BufReadPre
----------------------------------------------------------------------
on_event({ "BufReadPre", "BufNewFile" }, {
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/lewis6991/gitsigns.nvim",
}, function()
	require("plugins.treesitter")
	require("plugins.gitsigns")
end)

----------------------------------------------------------------------
-- 4. LSP + Formatting + Diagnostics + blink.cmp
----------------------------------------------------------------------
on_event({ "BufReadPre", "BufNewFile" }, {
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },

	-- LSP stack
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/chrisgrieser/nvim-lsp-endhints",
	"https://github.com/folke/trouble.nvim",
}, function()
	require("plugins.completion")
	require("plugins.lsp")
	require("plugins.conform")
	require("plugins.trouble")
end)

----------------------------------------------------------------------
-- 5. Navigation – Harpoon (lazy by keymap)
----------------------------------------------------------------------
on_keys({
	{
		"<leader>ha",
		function()
			require("harpoon"):list():add()
		end,
		{ desc = "Harpoon add" },
	},
	{
		"<leader>hh",
		function()
			require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
		end,
		{ desc = "Harpoon menu" },
	},
	{
		"<leader>hn",
		function()
			require("harpoon"):list():next()
		end,
		{ desc = "Harpoon next" },
	},
	{
		"<leader>hp",
		function()
			require("harpoon"):list():prev()
		end,
		{ desc = "Harpoon prev" },
	},
}, {
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
}, function()
	require("plugins.harpoon")
end)

----------------------------------------------------------------------
-- 6. Plugins only used when a key is pressed
----------------------------------------------------------------------

-- mini.files
on_keys({
	{
		"<leader>e",
		function()
			require("mini.files").open()
		end,
		{ desc = "Explorer" },
	},
}, {}, function()
	require("mini.files").setup({
		mappings = { go_in = "i", go_in_plus = "I" },
	})
end)

-- ToggleTerm
on_keys({
	{ "<leader>T", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" } },
}, {
	"https://github.com/akinsho/toggleterm.nvim",
}, function()
	require("toggleterm").setup({
		shade_terminals = false,
	})
end)

-- Zen Mode
on_keys({
	{ "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" } },
}, {
	"https://github.com/folke/zen-mode.nvim",
})

-- Undotree
on_keys({
	{
		"<leader>u",
		function()
			require("undotree").open({ command = "60vnew" })
		end,
		{ desc = "Undotree" },
	},
}, {}, function()
	vim.cmd("packadd nvim.undotree")
end)

-- mini.map
on_keys({
	{
		"<leader>m",
		function()
			require("mini.map").toggle()
		end,
		{ desc = "Toggle map" },
	},
}, {}, function()
	require("mini.map").setup({})
end)

-- Pack update / clean
vim.keymap.set("n", "<leader>U", function()
	vim.pack.update()
end, { desc = "Pack update" })

vim.keymap.set("n", "<leader>pc", function()
	local unused = {}
	for _, p in ipairs(vim.pack.get()) do
		if not p.active then
			table.insert(unused, p.spec.name)
		end
	end
	if #unused > 0 then
		vim.pack.del(unused)
	else
		vim.notify("No unused plugins")
	end
end, { desc = "Pack clean" })

----------------------------------------------------------------------
-- 7. Misc (always available but very lightweight)
----------------------------------------------------------------------
pack.add({
	"https://github.com/lambdalisue/suda.vim",
	"https://github.com/dstein64/vim-startuptime",
})

----------------------------------------------------------------------
-- 8. Custom haunts (lazy)
----------------------------------------------------------------------
on_event({ "BufReadPost" }, {}, function()
	require("plugins.haunts")
end)

----------------------------------------------------------------------
-- 9. PackChanged hooks (build blink, update treesitter)
----------------------------------------------------------------------
local cargo_bin = vim.fn.expand("~/.cargo/bin")
if not vim.env.PATH:find(cargo_bin, 1, true) then
	vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack_hooks", { clear = true }),
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind

		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			if vim.fn.executable("cargo") ~= 1 then
				vim.schedule(function()
					vim.notify("blink.cmp: cargo not found! Install Rust at https://rustup.rs", vim.log.levels.ERROR)
				end)
				return
			end

			local path = ev.data.spec.path
			vim.notify("Building blink.cmp...", vim.log.levels.INFO)

			vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
				vim.schedule(function()
					if obj.code == 0 then
						vim.notify("Build blink.cmp successfully!", vim.log.levels.INFO)
					else
						vim.notify("Build blink.cmp failed:\n" .. (obj.stderr or "unknown error"), vim.log.levels.ERROR)
					end
				end)
			end)
		end

		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})
