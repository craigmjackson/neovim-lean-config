local packager = require("packager")

-- Install mini.nvim
packager.install_package("mini.nvim", "nvim-mini/mini.nvim")
--- Load auto pairs
local mini_pairs = packager.try_require("mini.pairs")
if mini_pairs then
  mini_pairs.setup()
end
