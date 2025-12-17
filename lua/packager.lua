local M = {}

--- Install a NeoVim package if it isn't installed
--- @param name string Name of the package directory
--- @param url string URL suffix for Github, or a full URL
--- @return function # Callback with success or failure
function M.install_package(name, url)
  return function(cb)
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/" .. name
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      local _ = vim.fn.system("echo > /dev/tcp/github.com/443")
      if vim.v.shell_error ~= 0 then
        cb(false, nil)
      end
      -- vim.notify("Installing " .. url .. " to " .. install_path .. "...", vim.log.levels.INFO)
      local full_url = "https://github.com/" .. url
      if string.match(url, "://") then
        full_url = url
      end
      local output = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        full_url,
        install_path,
      })
      if vim.v.shell_error == 0 then
        vim.notify(name .. " installed", vim.log.levels.INFO)
        cb(true, nil)
      else
        vim.notify("Error installing " .. name .. ": " .. output, vim.log.levels.INFO)
        cb(false, nil)
      end
    end
    vim.cmd("packadd " .. name)
    vim.cmd("packloadall")
    cb(true, nil)
  end
end

--- Get whether an npm package is installed
--- @param package_name string Name of the npm package
--- @return boolean # Whether an npm package is installed
local function is_npm_package_installed(package_name)
  local _ = vim.fn.system("npm list -g " .. package_name)
  return vim.v.shell_error == 0
end

--- Install an npm package if it isn't installed
--- @param name string Name of the npm package
--- @return function # Callback with success or failure
function M.install_npm(name)
  return function(cb)
    if not is_npm_package_installed(name) then
      local _ = vim.fn.system("echo > /dev/tcp/registry.npmjs.org/443")
      if vim.v.shell_error ~= 0 then
        cb(false, nil)
      end
      local output = vim.fn.system("npm -g install " .. name)
      if vim.v.shell_error == 0 then
        vim.notify(name .. " installed", vim.log.levels.INFO)
        cb(true, nil)
      else
        vim.notify("Error installing " .. name .. ": " .. output, vim.log.levels.INFO)
        cb(false, nil)
      end
    end
    cb(true, nil)
  end
end

function M.try_require(name)
  local ok, module = pcall(require, name)
  if not ok then
    return false
  end
  return module
end

return M
