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

function M.promise_all(tasks)
  return coroutine.yield(function(resume)
    local remaining = #tasks
    local results = {}
    local done = false
    if remaining == 0 then
      resume(results)
      return
    end
    for i, task in ipairs(tasks) do
      task(function(ok, value)
        if done then
          return
        end

        if not ok then
          done = true
          resume(nil, value) -- reject
          return
        end

        results[i] = value
        remaining = remaining - 1

        if remaining == 0 then
          done = true
          resume(results)
        end
      end)
    end
  end)
end

function M.run_coroutine(co)
  local function step(...)
    local ok, wait = coroutine.resume(co, ...)
    if not ok then
      error(wait)
    end
    if coroutine.status(co) ~= "dead" then
      wait(step)
    end
  end
  step()
end

return M
