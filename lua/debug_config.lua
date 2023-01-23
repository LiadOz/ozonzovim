local M = {}

local dap = require('dap')


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
      is_multiline = is_multiline
    })
  else
    cb({
      type = 'executable',
      command = 'python',
      args = {'-m', 'debugpy.adapter'},
      is_multiline = is_multiline
    })
  end
end

local python_server_config = {
  type = 'python',
  request = 'attach',
  name = 'Python: Attach To Server',
  justMyCode = false,
  repl_lang = 'python',
}

dap.configurations.python = {
  python_server_config,
  {
    name = "Python: Current File",
    type = "python",
    request = "launch",
    program = "${file}",
    justMyCode = false,
    repl_lang = 'python',
  },
  {
    name = "Python: Current File (Integrated Terminal)",
    type = "python",
    request = "launch",
    program = "${file}",
    console = "integratedTerminal",
    justMyCode = false,
    repl_lang = 'python',
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
      repl_lang = language,
    },
  }
end


dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086})
end


dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    repl_lang = 'lua'
  }
}


local meta = require('meta-breakpoints')
meta.setup({
  meta_breakpoint_sign = '',
  hook_breakpoint_sign = '',
  allow_persistent_breakpoints = true,
})

local function toggle_dap_repl()
  dap.repl.toggle({height = 10})
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
    stopped = highlight.create_component_highlight_group(
      { fg = '#c94f6d' }, 'dap_stopped', self.options),
  }
  self.texts = {
    manual = 'MANUAL',
    auto = 'AUTO',
    running = 'RUNNING',
    stopped = 'STOPPED',
  }

  if self.options.color == nil then self.options.color = '' end
end

local run_status = 'stopped'
dap.listeners.after.event_stopped['lualine_component.stopped'] = function()
  run_status = 'stopped'
end
dap.listeners.after.event_continued['lualine_component.continue'] = function()
  run_status = 'running'
end
dap.listeners.after.event_initialized['lualine_component.initialized'] = function()
  run_status = 'running'
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
    mode = run_status
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

local widgets = require('dap.ui.widgets')
local frames_widget = nil
local function toggle_frames_widget()
  if frames_widget == nil then
    frames_widget = widgets.cursor_float(widgets.frames)
  else
    frames_widget.toggle()
  end
end

local wk = require('which-key')
local mappings = {
  d = {
    name = 'debug+',
    b = { function() meta.toggle_meta_breakpoint() end, 'toggle breakpoint' },
    B = { function() meta.toggle_meta_breakpoint({meta = {persistent = true}}) end, 'toggle Preakpoint' },
    m = { function() meta.toggle_meta_breakpoint({}, nil, true) end, 'toggle meta breakpoint' },
    M = { function() meta.toggle_meta_breakpoint({meta = {persistent = true}}, nil, true) end, 'toggle meta Preakpoint' },
    h = { function() meta.toggle_hook_breakpoint() end, 'toggle hook breakpoint' },
    H = { function() meta.toggle_hook_breakpoint({meta = {persistent = true}}) end, 'toggle hook Preakpoint' },
    r = { toggle_dap_repl, 'toggle repl' },
    D = { function() dap.disconnect({ terminateDebuggee = false }) end, 'disconnect debugger' },
    e = { function() setup_nvim_server() end, 'setup nvim server' },
    E = { function() stop_nvim_server() end, 'stop nvim server' },
    n = { function() require('osv').launch({port = 8086}) end, 'debug this instance' },
    f = { toggle_frames_widget, 'current frames' },
    w = { function() print(vim.inspect(meta.get_all_breakpoints())) end, 'query meta breakpoints' },
    W = { function() print(vim.inspect(meta.get_all_hooks())) end, 'query hooks mapping' }
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
    { 'f', toggle_frames_widget, { desc = 'current frames'} },
    { 'q', nil, { exit = true, desc = 'exit mode' } },
  }

})

return M
