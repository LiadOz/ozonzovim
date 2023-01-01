local M = {}
--local mason_registery = require('mason_registery')
--mason_registery.is_installed()

local dap = require('dap')


dap.adapters.python = function(cb, config)
  local function followup_func_cb(text)
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
      followup_func_cb = followup_func_cb
    })
  else
    cb({
      type = 'executable',
      command = 'python',
      followup_func_cb = followup_func_cb
    })
  end
end

local python_server_config = {
  type = 'python',
  request = 'attach',
  name = 'Python: Attach To Server',
  justMyCode = false,
}
dap.configurations.python = {
  python_server_config,
  {
    name = "Python: Current File (Integrated Terminal)",
    type = "python",
    request = "launch",
    program = "${file}",
    console = "integratedTerminal",
    args = {'-m', 'debugpy.adapter'},
    justMyCode = false
  },
}

require("dap-vscode-js").setup({
  debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
  adapters = { 'pwa-node' }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
end


local meta = require('meta-breakpoints')
meta.setup({
  meta_breakpoint_sign = '',
  hook_breakpoint_sign = '',
  allow_persistent_breakpoints = true,
})

local function toggle_dap_repl()
  dap.repl.toggle()
  vim.cmd('wincmd p')
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == 'dap-repl' then
    vim.cmd('startinsert')
  end
end

require('nvim-dap-virtual-text').setup()

local DEBUG_PIPE = '/tmp/neovim_debug_pipe'
local function setup_nvim_server()
  vim.fn.serverstart(DEBUG_PIPE)
end

local function stop_nvim_server()
  vim.fn.serverstop(DEBUG_PIPE)
end

local lualine_component = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

function lualine_component:init(options)
  lualine_component.super.init(self, options)
  self.status_colors = {
    manual = highlight.create_component_highlight_group(
      { fg = '#569fba' }, 'dap_manual_start', self.options),
    auto = highlight.create_component_highlight_group(
      { fg = '#f6c177' }, 'dap_auto_start', self.options),
    running = highlight.create_component_highlight_group(
      { fg = '#a3be8c' }, 'dap_running', self.options),
  }
  self.texts = {
    manual = 'MANUAL',
    auto = 'AUTO',
    running = 'RUNNING'
  }

  if self.options.color == nil then self.options.color = '' end
end

function lualine_component:update_status()
  local has_debug_pipe = false
  for _, server in ipairs(vim.fn.serverlist()) do
    if server == DEBUG_PIPE then
      has_debug_pipe = true
    end
  end
  local mode
  if dap.session() then
    mode = 'running'
  elseif has_debug_pipe then
    mode = 'auto'
  else
    mode = 'manual'
  end
  local result = ' ' .. self.texts[mode]
  result = highlight.component_format_highlight(self.status_colors[mode]) .. result
  return result
end

M.lualine_component = lualine_component
M.remote_continue = function()
  dap.run(python_server_config)
end

local wk = require('which-key')
local mappings = {
  d = {
    name = 'debug+',
    b = { function() dap.toggle_breakpoint() end, 'toggle breakpoint' },
    B = { function() meta.simple_meta_breakpoint('debug_hook') end, 'toggle meta breakpoint' },
    p = { function() meta.toggle_meta_breakpoint({ meta = { persistent = true } }) end, 'toggle persistent breakpoint' },
    h = { function() meta.toggle_hook_breakpoint('debug_hook') end, 'toggle hook breakpoint' },
    r = { toggle_dap_repl, 'toggle repl' },
    s = { dap.setp_into, 'setup nvim server' },
    n = { dap.step_over, 'step over' },
    D = { function() dap.disconnect({ terminateDebuggee = false }) end, 'disconnect debugger' },
    e = { function() setup_nvim_server() end, 'setup nvim server' },
    E = { function() stop_nvim_server() end, 'stop nvim server' },
  }
}
wk.register(mappings, { prefix = "<leader>" })
wk.register(mappings, { mode = "v", prefix = "<leader>" })

local Hydra = require('hydra')
local hint = {
  type = 'window',
  border = 'rounded',
}
Hydra({
  name = 'debug mode',
  mode = { 'n', 'x' },
  body = '<leader>d',
  config = {
    hint = hint,
    color = 'pink',
  },
  heads = {
    { 'c', dap.continue, { desc = 'continue' } },
    { 'n', dap.step_over, { desc = 'step over' } },
    { 's', dap.step_into, { desc = 'step into' } },
    { 'o', dap.step_out, { desc = 'step out' } },
    { 'u', dap.up, { desc = 'stack up' } },
    { 'd', dap.down, { desc = 'stack down' } },
    { 'D', function() dap.disconnect({ terminateDebuggee = false }) end, { exit = true, desc = 'disconnect' } },
    { 't', dap.run_to_cursor, { desc = 'run to cursor' } },
    { 'r', toggle_dap_repl, { desc = 'repl', exit = true } },
    { 'T', dap.terminate, { desc = 'terminate', exit = true } },
    { 'q', nil, { exit = true, desc = 'exit mode' } },
  }

})

return M
