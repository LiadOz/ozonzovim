require('packer_nvim')
require('keymappings')

require('defaults')
require('completion')
require('lsp_configuration')
require('etc')
local debug = require('debug_config')

require('lualine').setup {
    options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' }
    },
    sections = {
        lualine_y = {
            { debug.lualine_component }
        },
        lualine_x = {'hostname', 'fileformat', 'filetype'}
    }
}

local host_config_path = vim.fn.getcwd() .. '/host_configs/current_host/init.lua'
local stat, _ = vim.loop.fs_stat(host_config_path)
if stat then
  local custom_config = require('host_configs.current_host')
  if type(custom_config) == 'table' and custom_config.setup then
    custom_config.setup()
  end
end
