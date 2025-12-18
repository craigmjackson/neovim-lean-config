local packager = require("packager")

-- Install mini.nvim
packager.install_package("mini.nvim", "nvim-mini/mini.nvim")
-- Load status line
local statusline = packager.try_require("mini.statusline")
if statusline then
  statusline.setup({
    use_icons = vim.g.nerd_font,
  })
end
