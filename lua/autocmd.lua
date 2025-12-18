-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--- Highlight TODOs
vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    vim.fn.matchadd("TodoHighlight", [[\<TODO\>]])
    vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
  end,
})
vim.api.nvim_exec_autocmds("BufEnter", { buffer = 0 })
