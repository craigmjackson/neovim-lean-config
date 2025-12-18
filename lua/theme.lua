local packager = require("packager")

-- Install Theme
packager.install_package("tokyonight", "folke/tokyonight.nvim")
-- Load theme
local tokyonight = packager.try_require("tokyonight")
if tokyonight then
  tokyonight.setup()
  vim.cmd("colorscheme tokyonight")
end
