require("defaults")
local plugin_manager = require('core.plugin_manager')
local plugins = require('core.plugins')
local host_config = require('core.custom_config')

plugin_manager.bootstrap_plugin_manager()

require("keymappings")
require("plugins")

host_config.pre_plugin_setup()


plugin_manager.install_plugins(plugins.get_plugins())


host_config.post_plugin_setup()
