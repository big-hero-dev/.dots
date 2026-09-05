-- lua/plugins/trouble.lua

require("trouble").setup({
  auto_close = true,
  focus = true,
})

local map = vim.keymap.set

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>td", "<cmd>Trouble lsp_definitions toggle<cr>", { desc = "Definitions" })
map("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "References" })
map("n", "<leader>ti", "<cmd>Trouble lsp_implementations toggle<cr>", { desc = "Implementations" })
map("n", "<leader>tt", "<cmd>Trouble lsp_type_definitions toggle<cr>", { desc = "Type definitions" })
map("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
map("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

map("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cprev)
  end
end, { desc = "Prev trouble/qf" })

map("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cnext)
  end
end, { desc = "Next trouble/qf" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
