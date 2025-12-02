
-- For debugging
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o) .. '\n'
   end
end

-- Find if value is in a table
local function in_table(tbl, val)
  for _, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

--- Package installer
local installed = {}
local function install_package(repo, directory)
  if in_table(installed, directory) then
    return
  end
  local start_path = vim.fn.stdpath('data') .. '/runtime/pack/vendor/opt'
  local command = { 'git', 'clone', 'https://github.com/' .. repo, start_path .. '/' .. directory }
  local output = vim.fn.system(command)
  if vim.v.shell_error == 128 then
    -- print(repo .. ' already installed')
    table.insert(installed, directory)
    vim.cmd('packadd ' .. directory)
  elseif vim.v.shell_error ~= 0 then
    print('Exit code ' .. tostring(vim.v.shell_error) .. ' when running command: ' .. dump(command))
    print('Output: ' .. tostring(output))
  else
    print(repo  .. ' installed')
    table.insert(installed, directory)
    vim.cmd('packadd ' .. directory)
  end
end

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
  install_package('nvim-mini/mini.nvim', 'mini.nvim')
  local minipairs = require('mini.pairs')
  minipairs.setup()
end, 0)

-- Picker
vim.defer_fn(function()
  install_package('nvim-mini/mini.nvim', 'mini.nvim')
  local minipick = require('mini.pick')
  minipick.setup()
end, 0)

--- Theme
vim.defer_fn(function()
  install_package('folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
end, 0)

--- Lua
vim.defer_fn(function()
  install_package('folke/lazydev.nvim', 'lazydev.nvim')
  local lazydev = require('lazydev')
  lazydev.setup()
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' }
  })
  vim.lsp.enable('lua_ls')
end, 0)

