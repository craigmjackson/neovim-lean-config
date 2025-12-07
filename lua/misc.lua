local M = {}

-- Find if value is in a table
function M.in_table(tbl, val)
  for _, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

-- Get if NPM package is installed
function M.is_npm_package_installed(package_name)
  vim.fn.system('npm list -g ' .. package_name)
  return vim.api.nvim_get_vvar('shell_error') == 0
end

return M
