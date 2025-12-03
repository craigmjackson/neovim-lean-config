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
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipairs = require('mini.pairs')
  minipairs.setup()
end, 0)

-- Picker
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipick = require('mini.pick')
  minipick.setup()
  vim.keymap.set('n', '<c-n>', ':Pick files<cr>', { noremap = true })
end, 0)

--- Theme
vim.defer_fn(function()
  packager.install_package(installed, 'folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
end, 0)

--- Lua
vim.defer_fn(function()
  packager.install_package(installed, 'folke/lazydev.nvim', 'lazydev.nvim')
  local lazydev = require('lazydev')
  lazydev.setup()
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' }
  })
  vim.lsp.enable('lua_ls')
end, 0)

