local M = {}

-- For debugging
function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o) .. '\n'
   end
end

-- Find if value is in a table
function M.in_table(tbl, val)
  for _, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

return M
