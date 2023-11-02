local M = {}

function M.pre_plugin_setup()
  local plugins = require('core.plugins')

  plugins.add_plugin({
    "mfussenegger/nvim-dap",
    dir = '~/projects/nvim_plugins/nvim-dap'
  })
  plugins.add_plugin({
    "liadoz/meta-breakpoints.nvim",
    dir = "~/projects/nvim_plugins/meta-breakpoints.nvim"
  })

  plugins.add_plugin({
    "liadoz/nvim-dap-repl-highlights",
    dir = "~/projects/nvim_plugins/nvim-dap-repl-highlights"
  })

  plugins.add_plugin({
    "hrsh7th/nvim-cmp",
    dir = "~/projects/nvim_plugins/nvim-cmp"
  })
end

function M.post_plugin_setup()
  require('host_configs.witchapewter.test')
  vim.o.clipboard = 'unnamedplus'
end

return M
