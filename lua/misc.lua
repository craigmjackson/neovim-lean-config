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

function M.get_time()
  local current_time = vim.fn.reltimefloat(vim.fn.reltime())
  return current_time * 1000
end

function M.get_time_delta(start_time, end_time)
  local delta = end_time - start_time
  return delta
end

return M
