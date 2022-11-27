require('packer_nvim')
require('keymappings')

require('defaults')
require('completion')
require('lsp')
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

