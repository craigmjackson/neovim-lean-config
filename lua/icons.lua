local packager = require("packager")

-- Install icons
packager.install_package("nvim-web-devicons", "nvim-tree/nvim-web-devicons")
-- Load icons
local nvim_web_devicons = packager.try_require("nvim-web-devicons")
if nvim_web_devicons then
  require("nvim-web-devicons").setup()
end
