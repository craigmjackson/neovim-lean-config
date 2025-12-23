-- Run :checkhealth to check for missing dependencies

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load keymaps
require("keymaps")
-- Load options
require("options")
-- Load custom autocmds
require("autocmd")
-- Load LSPs
require("lsp")

-- Wait 100ms for NeoVim to render its UI, then load the most essential plugins
vim.defer_fn(function()
	-- Load theme
	require("theme")
	-- Load icons
	require("icons")
	-- Load file manager
	require("filemanager")
	-- Load Picker
	require("picker")
	-- Wait 500ms then load the remaining plugins
	vim.defer_fn(function()
		-- Load autocommands
		require("autocmd")
		-- Load gitsigns
		require("git")
		-- Load statusline
		require("statusline")
		-- Load breadcrumbs
		require("breadcrumbs")
		-- Load tabs
		require("tabs")
		-- Load formatting
		require("formatting")
		-- Load scrollbar
		require("scrollbar")
		-- Load autopairs
		require("autopairs")
		-- Load auto-indent
		require("indent")
		-- Load Zen mode
		require("zen")
		-- Load Number Toggle
		require("numbertoggle")
	end, 500)
end, 100)
