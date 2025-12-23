local packager = require("packager")

-- Install mini.nvim
packager.install_package("mini.nvim", "nvim-mini/mini.nvim")
-- Load Picker
local minipick = packager.try_require("mini.pick")
if minipick then
	minipick.setup({
		source = {
			show = minipick.default_show,
		},
		window = {
			prompt_caret = "|",
			prompt_prefix = "> ",
		},
		show_icons = vim.g.nerd_font,
	})
	local pick_neovim_config = function()
		local picked_filename = minipick.start({
			source = {
				items = vim.fn.readdir(vim.fn.stdpath("config")),
			},
		})
		local filename_with_path = vim.fn.stdpath("config") .. "/" .. picked_filename
		vim.cmd("edit " .. filename_with_path)
	end
	-- Fuzzy find NeoVim config files
	vim.keymap.set("n", "<space>sn", pick_neovim_config, { noremap = true })
end
