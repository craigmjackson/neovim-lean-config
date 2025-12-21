local packager = require("packager")

packager.install_package("nvim", "catppuccin/nvim")
local catppuccin = packager.try_require("catppuccin")
if catppuccin then
  catppuccin.setup()
  vim.cmd("colorscheme catppuccin-macchiato")
end
