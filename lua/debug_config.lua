local M = {}

function M.toggle_dap_repl()
  require('dap').repl.toggle({ height = 15 })
  vim.cmd('wincmd p')
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == 'dap-repl' then
    vim.cmd('startinsert')
  end
end

local DEBUG_PIPE = '/tmp/neovim_debug_pipe'
function M.setup_nvim_server()
  vim.fn.serverstart(DEBUG_PIPE)
end

function M.stop_nvim_server()
  vim.fn.serverstop(DEBUG_PIPE)
end

function M.get_dap_lualine_component()
  local lualine_component = require('lualine.component'):extend()
  local highlight = require('lualine.highlight')
  local dap = require('dap')

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
  return lualine_component
end

M.remote_continue = function()
  require('dap').run(require('core.plugins.dap').python_server_config)
end

local frames_widget = nil
function M.toggle_frames_widget()
  local widgets = require('dap.ui.widgets')
  if frames_widget == nil then
    frames_widget = widgets.cursor_float(widgets.frames)
  else
    frames_widget.toggle()
  end
end

return M
