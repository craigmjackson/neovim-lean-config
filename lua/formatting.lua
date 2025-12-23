local packager = require("packager")

-- Install formatting
packager.install_package("conform", "stevearc/conform.nvim")
-- Install formatting for JavaScript
if vim.g.manage_npm then
	packager.install_npm("prettier")
end
-- Load formatting
local conform = packager.try_require("conform")
if conform then
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettier" },
			vue = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})
end
