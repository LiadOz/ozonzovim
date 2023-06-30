local M = {}

local host_disabled_plugins = {}
host_disabled_plugins["mfussenegger/nvim-dap"] = true
host_disabled_plugins["p00f/nvim-ts-rainbow"] = true
host_disabled_plugins["liadoz/meta-breakpoints.nvim"] = true
host_disabled_plugins["liadoz/nvim-dap-repl-highlights"] = true
host_disabled_plugins["hrsh7th/nvim-cmp"] = true

M.host_disabled_plugins = host_disabled_plugins

M.host_additional_plugins = {
  '~/projects/nvim_plugins/meta-breakpoints.nvim',
  '~/projects/nvim_plugins/nvim-dap',
  '~/projects/nvim_plugins/nvim-ts-rainbow',
  'simrat39/rust-tools.nvim',
  '~/projects/nvim_plugins/nvim-dap-repl-highlights',
  '~/projects/nvim_plugins/nvim-cmp'
}

return M
