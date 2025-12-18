local packager = require("packager")

-- Install formatting
packager.install_package("conform", "stevearc/conform.nvim")
-- Install formatting for JavaScript
packager.install_npm("prettier")
-- Load formatting
local conform = packager.try_require("conform")
if conform then
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      vue = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  })
end
