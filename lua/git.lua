local packager = require("packager")
-- Install Git signs
packager.install_package("gitsigns", "lewis6991/gitsigns.nvim")
-- Load git signs
local git_signs = packager.try_require("gitsigns")
if git_signs then
  git_signs.setup({
    signs = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "_" },
      changedelete = { text = "~" },
      untracked = { text = " " },
    },
    signs_staged = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "_" },
      changedelete = { text = "~" },
      untracked = { text = " " },
    },
  })
end
