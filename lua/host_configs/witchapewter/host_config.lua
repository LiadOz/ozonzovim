local M = {}

local host_disabled_plugins = {}
host_disabled_plugins["mfussenegger/nvim-dap"] = true
host_disabled_plugins["p00f/nvim-ts-rainbow"] = true

M.host_disabled_plugins = host_disabled_plugins

M.host_additional_plugins = {
  '~/projects/nvim_plugins/meta-breakpoints.nvim',
  '~/projects/nvim_plugins/nvim-dap',
  '~/projects/nvim_plugins/nvim-ts-rainbow',
}

return M
