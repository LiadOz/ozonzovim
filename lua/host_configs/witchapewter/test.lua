local lsp = require('vim.lsp')
local util = require('vim.lsp.util')

local win_to_context = {}
local ReferenceContext = {}
function ReferenceContext:new(window)
  window = window or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(window)
  local state = { curr_positions = {}, window = window, bufnr = bufnr, folded = false }
  return setmetatable(state, { __index = self })
end

-- position like in lsp
function ReferenceContext:add_position(position)
  position = position or util.make_position_params(self.window, 'utf-8').position
  table.insert(self.curr_positions, position)
end

function ReferenceContext:reference_cb(resp)
  local text_document = util.make_text_document_params(self.bufnr)
  local locations = {}
  for _, client_result in pairs(resp) do
    if client_result and client_result.result then
      local result = client_result.result
      table.move(result, 1, #result, #locations+1, locations)
    end
  end
  if not locations then
    return
  end
  if not self.folded then
    vim.wo[self.window].foldlevel = 0
    self.folded = true
  end
  for _, reference in ipairs(locations) do
    if reference.uri == text_document.uri then
      local range = reference.range
      for _ = 1, vim.fn.foldlevel(range.start.line + 1), 1 do
        vim.api.nvim_cmd({ cmd = 'foldopen', range = { range.start.line + 1, range['end'].line + 1 } }, {})
      end
    end
  end
end

local function with_custom_workspace(workspace, callback)
  -- this function does not work well when there are multiple lsp clients attached to a buffer
  -- since list/remove/add workspaces acts on all current clients so it actually mixes up things
  -- if you want to make it work you have to do these thing per client
  local curr_workspace_folders = lsp.buf.list_workspace_folders()
  print('starting workspaces')
  vim.pretty_print(curr_workspace_folders)

  local contains_curr_dir = false
  if #curr_workspace_folders ~= 1 then
    for _, path in ipairs(curr_workspace_folders) do
      vim.pretty_print('removing path' .. path)
      if path ~= workspace then
        lsp.buf.remove_workspace_folder(path)
      else
        contains_curr_dir = true
      end
    end
    if not contains_curr_dir then
      lsp.buf.add_workspace_folder(workspace)
    end
  end
  print('after remove workspaces')
  vim.pretty_print(lsp.buf.list_workspace_folders())

  callback()

  print('removing ' .. workspace)
  lsp.buf.remove_workspace_folder(workspace)
  print('after remove workspaces')
  vim.pretty_print(lsp.buf.list_workspace_folders())
  for _, path in ipairs(curr_workspace_folders) do
    print('restoring ' .. path)
    lsp.buf.add_workspace_folder(path)
    print('after restore')
    vim.pretty_print(lsp.buf.list_workspace_folders())
  end

  print('after restore workspaces')
  vim.pretty_print(lsp.buf.list_workspace_folders())
end

function ReferenceContext:apply_references()
  local text_document = util.make_text_document_params(self.bufnr)
  --local workspace = vim.fn.getcwd()
  for _, position in ipairs(self.curr_positions) do
    lsp.buf_request_all(self.bufnr, 'textDocument/references', {
      textDocument = text_document,
      position = position,
      context = {
        includeDeclaration = true
      }
    }, function(resp) self:reference_cb(resp) end)
  end
  --with_custom_workspace(workspace, function()
  --end)
  self.curr_positions = {}
end

local function unfold_me()
  local winnr = vim.api.nvim_get_current_win()
  local curr_context = ReferenceContext:new(winnr)
  win_to_context[winnr] = curr_context
  curr_context:add_position()
  curr_context:apply_references()
end

local function unfold_more()
  local winnr = vim.api.nvim_get_current_win()
  local curr_context = win_to_context[winnr]
  if not curr_context then
    curr_context = ReferenceContext:new(winnr)
    win_to_context[winnr] = curr_context
  end
  curr_context:add_position()
  curr_context:apply_references()
end

vim.keymap.set('n', ' rm', unfold_me, {desc = 'unfold me'})
vim.keymap.set('n', ' ro', unfold_more, {desc = 'unfold more'})

local function get_all_extmarks()
  for namespace, namespace_id in pairs(vim.api.nvim_get_namespaces()) do
    print(namespace)
    vim.pretty_print(vim.api.nvim_buf_get_extmarks(0, namespace_id, 0, -1, {}))
  end
end

vim.keymap.set('n', ' ra', get_all_extmarks, {desc = 'all extmarks'})

local function get_unfolded_lines()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local ommited_lines = 0
  local unfolded_lines = {}
  local function add_ommited_lines()
    if ommited_lines then
      if ommited_lines == 1 then
        table.insert(unfolded_lines, '... ommited line ...')
      else
        table.insert(unfolded_lines, '... ommited ' .. ommited_lines .. ' lines ...')
      end
    end
  end
  for i, line in ipairs(lines) do
    print(line .. ' ' .. vim.fn.foldlevel(i))
    if vim.fn.foldlevel(i) == 0 then
      add_ommited_lines()
      ommited_lines = 0
      table.insert(unfolded_lines, line)
    else
      ommited_lines = ommited_lines + 1
    end
  end
  add_ommited_lines()
  print(table.concat(unfolded_lines, '\n'))
end

vim.keymap.set('n', ' rf', get_unfolded_lines, {desc = 'get unfolded'})

local function setup_buf_help()
  local function create_print(msg)
    local function wrapped()
      print(msg)
    end
    return wrapped
  end
  vim.api.nvim_buf_attach(0, false, {
    on_lines=create_print('on_lines'),
    on_bytes=create_print('on_bytes'),
    on_changedtick=create_print('on_changedtick'),
    on_reload=create_print('on_reload'),
  })
end
vim.keymap.set('n', ' rs', setup_buf_help, {desc = 'setup buf help'})
