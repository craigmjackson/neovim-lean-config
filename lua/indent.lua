local packager = require("packager")
-- Install indenting
packager.install_package("guess-indent", "NMAC427/guess-indent.nvim")
-- Load automatic indenting
local guess_indent = packager.try_require("guess-indent")
if guess_indent then
  guess_indent.setup({})
  vim.api.nvim_exec_autocmds("BufReadPost", { buffer = 0 })
end
