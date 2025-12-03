local packager = require('lua/packager')

local installed = {}

--- Enable LSP completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = false })
    -- Goto definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.implementation, { buffer = event.buf })
    -- Enable virtual text
    vim.diagnostic.config({
      virtual_text = {
        source = false
      },
      severity_sort = true
    })
    vim.diagnostic.enable()
  end
})

--- Auto pairs
vim.schedule(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipairs = require('mini.pairs')
  minipairs.setup()
end)

-- Picker
vim.schedule(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipick = require('mini.pick')
  minipick.setup()
  vim.keymap.set('n', '<c-n>', ':Pick files<cr>', { noremap = true })
  vim.keymap.set('n', '<c-g>', ':Pick grep_live<cr>', { noremap = true })
end)

--- Theme
vim.schedule(function()
  packager.install_package(installed, 'folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
end)

--- Automatic indenting
vim.schedule(function()
  packager.install_package(installed, 'NMAC427/guess-indent.nvim', 'guess-indent.nvim')
  local guess_indent = require('guess-indent')
  guess_indent.setup({})
  vim.api.nvim_exec_autocmds('BufReadPost', { buffer = 0 })
end)

--- Lua support
vim.schedule(function()
  packager.install_package(installed, 'folke/lazydev.nvim', 'lazydev.nvim')
  local lazydev = require('lazydev')
  lazydev.setup()
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' }
  })
  vim.lsp.enable('lua_ls')
end)

