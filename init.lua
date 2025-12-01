function dump(o)
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

--- Package installer
local function install_package(repo, directory)
  local start_path = vim.fn.stdpath('data') .. '/runtime/pack/vendor/opt'
  local command = { 'git', 'clone', 'https://github.com/' .. repo, start_path .. '/' .. directory }
  local output = vim.fn.system(command)
  if vim.v.shell_error == 128 then
    -- print(repo .. ' already installed')
  elseif vim.v.shell_error ~= 0 then
    print('Exit code ' .. tostring(vim.v.shell_error) .. ' when running command: ' .. dump(command))
    print('Output: ' .. tostring(output))
  else
    print(repo  .. ' installed')
  end
end

--- lua language server
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  filetypes = { 'lua' }
})
vim.lsp.enable('lua_ls')


--- Enable LSP completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = false })
  end
})

--- Auto pairs
vim.defer_fn(function()
  install_package('nvim-mini/mini.nvim', 'mini.nvim')
  vim.cmd('packadd mini.nvim')
  local pairs = require('mini.pairs')
  pairs.setup({})
end, 0)

