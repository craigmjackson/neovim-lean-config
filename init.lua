local packager = require('lua/packager')
local misc = require('lua/misc')

local installed = {}

--- Theme
vim.schedule(function()
  packager.install_package(installed, 'folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
end)

--- Enable LSP completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    -- Goto definition
    vim.keymap.set('n', 'gd', vim.lsp.buf.implementation, { buffer = event.buf })
    -- Enable virtual text
    vim.diagnostic.config({
      virtual_text = {
        source = false
      },
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR }
    })
    -- Enable autocompletion while typing
    vim.o.completeopt = 'menu,menuone,noinsert,noselect'
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })
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

--- Python support
vim.schedule(function()
  if not misc.is_npm_package_installed('pyright') then
    vim.fn.system('npm -g install pyright')
  end
  vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' }
  })
  vim.lsp.enable('pyright')
end)

--- JavaScript support
vim.schedule(function()
  if not misc.is_npm_package_installed('@vue/language-server') then
    vim.fn.system('@vue/language-server')
  end
  if not misc.is_npm_package_installed('typescript') then
    vim.fn.system('typescript')
  end
  if not misc.is_npm_package_installed('@vue/typescript-plugin') then
    vim.fn.system('@vue/typescript-plugin')
  end
  if not misc.is_npm_package_installed('typescript-language-server') then
    vim.fn.system('typescript-language-server')
  end
  vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
  })
  vim.lsp.enable('ts_ls')
end)

