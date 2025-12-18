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

function M.get_time()
  local current_time = vim.fn.reltimefloat(vim.fn.reltime())
  return current_time * 1000
end

function M.get_time_delta(start_time, end_time)
  local delta = end_time - start_time
  return delta
end

return M
