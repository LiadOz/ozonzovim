local M = {}

local plugin_list = {}

function M.add_plugin(plugin_opts)
  --local plugin_identifier
  --if type(plugin_opts) ~= 'table' then
    --plugin_identifier = plugin_opts
  --else
    --plugin_identifier =  plugin_opts[1] or plugin_opts['dir'] or plugin_opts['url']
  --end
  --assert(not plugin_list[plugin_identifier], string.format('Plugin options for %s already exists', plugin_identifier))
  --plugin_list[plugin_identifier] = plugin_opts
  table.insert(plugin_list, plugin_opts)
end

--function M.override_plugin(plugin_identifier, plugin_opts)
  --local original_opts = plugin_list[plugin_identifier]
  --assert(original_opts, string.format('Plugin %s does not exist in plugin list', plugin_identifier))
  --if type(original_opts) == 'table' then
    --plugin_list[plugin_identifier] = plugin_opts
  --else
    --plugin_list[plugin_identifier] = vim.tbl_deep_extend('force', original_opts, plugin_opts)
  --end
--end

--function M.remove_plugin(plugin_identifier)
  --plugin_list[plugin_identifier] = nil
--end

function M.get_plugins()
  return vim.tbl_values(plugin_list)
end

return M
