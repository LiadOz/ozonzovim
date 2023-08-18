local plugins = require('core.plugins')

plugins.add_plugin({ "rcarriga/nvim-notify", event = 'VeryLazy' })
plugins.add_plugin({
  "stevearc/dressing.nvim",
  event = 'VeryLazy',
  config = function()
    require('dressing').setup({
      input = {
        enabled = true
      }
    })
  end
})

plugins.add_plugin({
  "nvim-lualine/lualine.nvim",
  event = 'VeryLazy',
  config = function()
    local dap_component = require('debug_config').get_dap_lualine_component()
    require('lualine').setup {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' }
      },
      sections = {
        lualine_y = {
          { dap_component }
        },
        lualine_x = { 'hostname', 'fileformat', 'filetype' }
      }
    }
  end
})
