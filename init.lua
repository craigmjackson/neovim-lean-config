-- Run :checkhealth to check for missing dependencies

--  Dependencies will be used if they are found to be installed
--    Binaries from your OS
--      node (Many language servers)
--      npm (Many language servers)
--      python3 (Python support)
--      stylua (Lua formatting)
--      xclip (System clipboard integration)
--      git (NeoVim plugin download/installtion)
--      lua-language-server (Lua language server)
--    Python packages
--      black (Python formatting)
--      pynvim (NeoVim support for Python)
--    NPM packages
--   	prettier (JavaScript/Typescript/Vue formatting)
--   	neovim (NeoVim support for Node.js)
--   	ripgrep (High-speed recursive grep)
--   	pyright (Python support)
--   	bash-language-server (Bash language server)
--   	typescript (JavaScript/TypeScript language server dependency)
--   	typescript-language-server (JavaScript/TypeScript language server)
--   	@vue/language-server (Vue.js language server)
--   	@vue/typescript-plugin (Vue.js TypeScript plugin)
--   	vscode-langservers-extracted ()
--   	sql-language-server (SQL language server)
--   	yaml-language-server (YAML language server)

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
