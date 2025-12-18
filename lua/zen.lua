local packager = require("packager")
-- Install zen mode
packager.install_package("zen-mode", "folke/zen-mode.nvim")
-- Load zen mode
local zenmode = packager.try_require("zen-mode")
if zenmode then
  zenmode.setup({
    window = {
      width = 0.95,
    },
  })
end
