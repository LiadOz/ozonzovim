local M = {}


local host_disabled_plugins = {}
host_disabled_plugins['liadoz/meta-breakpoints.nvim'] = true
M.host_disabled_plugins = host_disabled_plugins


M.host_additional_plugins = {
    "~/ozonzono/meta-breakpoints.nvim",
}

return M
