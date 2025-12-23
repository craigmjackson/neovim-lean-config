--- Options
-- Enable line numbers
vim.opt.number = true
-- Enable relative line numbers
vim.opt.relativenumber = true
-- Enable mouse support
vim.opt.mouse = "nvi"
-- Sync with the OS clipboard
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
-- Make undo files
vim.opt.undofile = true
-- Make searches case-insensitive in general
vim.opt.ignorecase = true
-- If there is a mixed case in your search, make it case-sensitive
vim.opt.smartcase = true
-- Only show sign column if needed
vim.opt.signcolumn = "yes"
-- Write swapfile to disk if no activity for 250ms
vim.opt.updatetime = 250
-- How long for other sequences to timeout
vim.opt.timeoutlen = 300
-- Horizontal splits on the right
vim.opt.splitright = true
-- Vertical splits below
vim.opt.splitbelow = true
-- Highlight the line with the cursor
vim.opt.cursorline = true
-- Keep some lines above and below the cursor
vim.opt.scrolloff = 5
-- Enable 256 colors even in text mode
vim.opt.termguicolors = true
-- Transparency for floating windows
vim.opt.winblend = 30
-- Nerd fonts are special programming fonts that provide icons.
-- Set to false if you don't have a nerd font or can't guarantee
-- the user has one.  Get one from https://www.nerdfonts.com/font-downloads
-- and set your terminal emulator to use it.
vim.g.nerd_font = true
-- Set to true to enable automatic resolving of NPM packages
vim.g.manage_npm = false
