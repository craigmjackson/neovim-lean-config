-- Run :checkhealth to check for missing dependencies

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd fonts are special programming fonts that provide icons.
-- Set to false if you don't have a nerd font or can't guarantee
-- the user has one.  Get one from https://www.nerdfonts.com/font-downloads
-- and set your terminal emulator to use it.
vim.g.nerd_font = true

-- Set to true to enable automatic installation of NPM packages
-- You must install node/npm somewhere inside your user directory and make sure <node_install_dir>/bin is in your PATH for this to work.
vim.g.manage_npm = false

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
