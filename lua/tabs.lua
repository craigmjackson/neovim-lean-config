local packager = require("packager")
-- Install tabs
packager.install_package("bufferline", "akinsho/bufferline.nvim")
-- Load tabs
local bufferline = packager.try_require("bufferline")
if bufferline then
  bufferline.setup({
    options = {
      nubmers = "ordinal",
      separator_style = "slant",
      buffer_close_icon = vim.g.nerd_font and "" or "x",
      close_icon = vim.g.nerd_font and "" or "x",
      modified_icon = vim.g.nerd_font and "" or "m",
      left_trunc_marker = vim.g.nerd_font and "" or "/",
      right_trunc_marker = vim.g.nerd_font and "" or "\\",
    },
  })
end
