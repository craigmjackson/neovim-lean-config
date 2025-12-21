local packager = require("packager")

packager.install_package("nvim", "catppuccin/nvim")
local tokyonight = packager.try_require("catppuccin")
if tokyonight then
  tokyonight.setup()
  vim.cmd("colorscheme catppuccin-macchiato")
end
