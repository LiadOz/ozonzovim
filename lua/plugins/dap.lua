local M = {}
local plugins = require('core.plugins')

M.python_server_config = {
  type = 'python',
  request = 'attach',
  name = 'Python: Attach To Server',
  justMyCode = false,
}

plugins.add_plugin({
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
  },
  config = function()
    local dap = require('dap')
    dap.defaults.fallback.switchbuf = 'usetab,uselast'

    dap.adapters.python = function(cb, config)
      local function is_multiline(text)
        if string.sub(text, -1) == ':' then
          return true
        elseif string.sub(text, -1) == '\\' then
          return true
        elseif select(2, string.gsub(text, '"""', "")) == 1 then
          return true
        end
        return false
      end
      if config.request == 'attach' then
        cb({
          type = 'server',
          host = '127.0.0.1',
          port = 1337,
          is_multiline = is_multiline,
        })
      else
        cb({
          type = 'executable',
          command = 'python',
          args = { '-m', 'debugpy.adapter' },
          is_multiline = is_multiline,
        })
      end
    end

    dap.configurations.python = {
      M.python_server_config,
      {
        name = "Python: Current File",
        type = "python",
        request = "launch",
        program = "${file}",
        justMyCode = false,
      },
      {
        name = "Python: Current File (Integrated Terminal)",
        type = "python",
        request = "launch",
        program = "${file}",
        console = "integratedTerminal",
        justMyCode = false,
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
      }
    }
  end
})

plugins.add_plugin({
  "liadoz/meta-breakpoints.nvim",
  event = 'VeryLazy',
  config = function()
    local meta = require('meta-breakpoints')
    require('meta-breakpoints.log').level = 'trace'
    meta.setup({
      signs = {
        meta_breakpoint_sign = '',
        hook_breakpoint_sign = '',
      },
    })
  end
})

plugins.add_plugin({
  "jbyuki/one-small-step-for-vimkind",
  lazy = true,
})

return M
