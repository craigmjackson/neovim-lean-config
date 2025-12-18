local M = {}

--- Install a NeoVim package if it isn't installed
--- @param name string Name of the package directory
--- @param url string URL suffix for Github, or a full URL
--- @return boolean # Success or failure
function M.install_package(name, url)
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/" .. name
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    local _ = vim.fn.system("echo > /dev/tcp/github.com/443")
    if vim.v.shell_error ~= 0 then
      return false
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
      vim.cmd("packadd " .. name)
      return true
    else
      vim.notify("Error installing " .. name .. ": " .. output, vim.log.levels.INFO)
      return false
    end
  end
  vim.cmd("packadd " .. name)
  return true
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
--- @return boolean # Success or failure
function M.install_npm(name)
  if not is_npm_package_installed(name) then
    local _ = vim.fn.system("echo > /dev/tcp/registry.npmjs.org/443")
    if vim.v.shell_error ~= 0 then
      return false
    end
    local output = vim.fn.system("npm -g install " .. name)
    if vim.v.shell_error == 0 then
      vim.notify(name .. " installed", vim.log.levels.INFO)
      return true
    else
      vim.notify("Error installing " .. name .. ": " .. output, vim.log.levels.INFO)
      return false
    end
  end
  return true
end

function M.try_require(name)
  local ok, module = pcall(require, name)
  if not ok then
    return false
  end
  return module
end

return M
