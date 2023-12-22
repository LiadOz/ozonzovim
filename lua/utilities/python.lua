local M = {}
M.is_poetry_installed = function()
    local result = vim.fn.system('poetry --version')
    return result ~= "" and vim.v.shell_error == 0
end

M.get_poetry_project_path = function()
  local result = vim.fn.system('poetry env info --path')
  if vim.v.shell_error == 0 then
    return result:gsub('\n', '')
  end
  return nil
end

M.get_poetry_site_packages = function()
  local result = vim.fn.system('poetry run python -c "import site; print(site.getsitepackages()[0])"')
  if vim.v.shell_error == 0 then
    return result:gsub('\n', '')
  end
  return nil
end

M.get_poetry_executable = function()
  local result = vim.fn.system('poetry env info --executable')
  if vim.v.shell_error == 0 then
    return result:gsub('\n', '')
  end
  return nil
end

return M
