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

return M
