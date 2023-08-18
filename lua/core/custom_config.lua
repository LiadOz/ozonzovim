local M = {}

local config_name = vim.loop.os_environ()['OZONZOVIM_CONFIG']
local config = nil
if config_name then
  local ok
  ok, config = pcall(require, 'host_configs.' .. config_name)
  assert(ok, string.format('Config name set to %s but no such a configuration found', config_name))
end

local function call_config_with_warning(config_function)
  if not config then
    return
  end
  if config[config_function] then
    return config[config_function]()
  else
    vim.notify(string.format('Function %s not found in custom config', config_function), vim.log.levels.WARN)
  end
end

function M.pre_plugin_setup()
  return call_config_with_warning("pre_plugin_setup")
end

function M.post_plugin_setup()
  return call_config_with_warning("post_plugin_setup")
end

return M
