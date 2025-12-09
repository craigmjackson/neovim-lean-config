local M = {}
local misc = require('./misc')

function M.install_package(repo, directory)
  if misc.in_table(INSTALLED, directory) then
    return
  end
  local start_path = vim.fn.stdpath('data') .. '/site/pack/packages/opt'
  local command = { 'git', 'clone', 'https://github.com/' .. repo, start_path .. '/' .. directory }
  local output = vim.fn.system(command)
  if vim.v.shell_error == 128 then
    -- print(repo .. ' already installed')
    table.insert(INSTALLED, directory)
    vim.cmd('packadd ' .. directory)
    vim.cmd('packloadall')
  elseif vim.v.shell_error ~= 0 then
    print('Exit code ' .. tostring(vim.v.shell_error) .. ' when running command: ' .. misc.dump(command))
    print('Output: ' .. tostring(output))
  else
    print(repo .. ' installed')
    table.insert(INSTALLED, directory)
    vim.cmd('packadd ' .. directory)
    vim.cmd('packloadall')
  end
end

return M
