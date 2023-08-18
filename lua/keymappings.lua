local plugins = require('core.plugins')

plugins.add_plugin({
  "folke/which-key.nvim",
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup({})
    local mappings = {
      b = { name = '+buffer' },
      d = { name = '+debug' },
      f = { name = '+file' },
      p = { name = '+project' },
      c = { name = '+code' },
      w = { name = '+workspace' },
      g = { name = '+git' },
      t = { name = '+toggle' },
      e = { name = '+edit' },
      o = { name = '+other' },
    }
    wk.register(mappings, { mode = { "n", "v" }, prefix = "<leader>" })
  end
})

local proj_dir = require('project_utils').get_cwd_project_dir
local function d(description)
  return { desc = description }
end

local lazy_require = require('core.utils').lazy_require
local telescope = lazy_require('telescope.builtin')
local neogen = lazy_require('neogen')
local tutils = lazy_require('telescope_utils')

-- general key bindings --
vim.keymap.set('n', '<TAB>', ':b#<cr>', d('prev buffer'))
vim.keymap.set('n', '<leader>a', telescope.commands, d('commands'))


-- buffer key bindings --
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', d('next'))
vim.keymap.set('n', '<leader>bp', ':bprev<cr>', d('previous'))
vim.keymap.set('n', '<leader>bd', ':Bdelete<cr>', d('delete'))
vim.keymap.set('n', '<leader>bD', ':Bdelete!<cr>', d('delete no save'))
vim.keymap.set('n', '<leader>bb', function() telescope.buffers({ sort_lastused = true }) end, d('buffers'))
vim.keymap.set('n', '<leader>bB', function() telescope.buffers({ sort_lastused = true, cwd_only = true }) end,
  d('cwd buffers'))


-- file key bindings
vim.keymap.set('n', '<leader>ff', function() tutils.cwd_change_wrapper(telescope.find_files)() end, d('find files'))
vim.keymap.set('n', '<leader>fF', function() tutils.cwd_change_wrapper(telescope.find_files)({ hidden = true }) end,
  d('find files (hidden)'))
vim.keymap.set('n', '<leader>fs', telescope.resume, d('resume last'))
vim.keymap.set('n', '<leader>fg', function() tutils.cwd_change_wrapper(telescope.live_grep)() end, d('grep'))
vim.keymap.set('n', '<leader>fc', function() tutils.cwd_change_wrapper(telescope.grep_string)() end, d('grep cursor'))
vim.keymap.set('n', '<leader>fp', telescope.git_files, d('project'))
vim.keymap.set('n', '<leader>fh', telescope.help_tags, d('help'))
vim.keymap.set('n', '<leader>fr', telescope.oldfiles, d('recent files'))
vim.keymap.set('n', '<leader>fR', function() telescope.oldfiles({ only_cwd = true }) end, d('recent files (cwd)'))


-- project key bindings
vim.keymap.set('n', '<leader>po', '<cmd>Telescope projects<cr>', d('open'))
vim.keymap.set('n', '<leader>pf', function() telescope.find_files({ cwd = proj_dir() }) end, d('find files'))
vim.keymap.set('n', '<leader>pg', function() telescope.live_grep({ cwd = proj_dir() }) end, d('grep'))
vim.keymap.set('n', '<leader>pc', function() telescope.grep_string({ cwd = proj_dir() }) end, d('grep cursor'))


-- code key bindings
vim.keymap.set('n', '<leader>ca', function() neogen.generate({ type = 'func' }) end, d('annotate function'))
vim.keymap.set('n', '<leader>cA', function() neogen.generate({ type = 'class' }) end, d('annotate class'))
vim.keymap.set('n', '<leader>cd', vim.lsp.buf.definition, d('go to definition'))
vim.keymap.set('n', '<leader>cD', vim.lsp.buf.declaration, d('go to declaration'))
vim.keymap.set('n', '<leader>cs', vim.diagnostic.open_float, d('open diagnostic'))
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, d('hover'))
vim.keymap.set('n', '<leader>ci', vim.lsp.buf.implementation, d('go to implementation'))
vim.keymap.set('n', '<leader>ct', vim.lsp.buf.type_definition, d('type definition'))
vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, d('rename'))
vim.keymap.set('n', '<leader>cc', vim.lsp.buf.code_action, d('code action'))
vim.keymap.set('n', '<leader>cr', telescope.lsp_references, d('references'))
vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, d('format'))


-- workspace bindings
vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, d('list'))
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, d('add'))
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, d('remove'))

-- git bindings
local gitsigns = lazy_require('gitsigns')
vim.keymap.set('n', '<leader>gb', function() vim.cmd('Git blame --date=relative --color-by-age') end, d('blame'))
vim.keymap.set('n', '<leader>gB', telescope.git_bcommits, d('buffer commits'))
vim.keymap.set('n', '<leader>gg', function() vim.cmd('Git') end, d('git menu'))
vim.keymap.set('n', '<leader>gc', telescope.git_branches, d('branches'))
vim.keymap.set('n', '<leader>gs', telescope.git_status, d('status'))
vim.keymap.set('n', '<leader>gl', function() vim.cmd('Git log --graph --abbrev-commit --date=relative') end, d('log'))
vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, d('diff'))
vim.keymap.set('n', '<leader>gh', gitsigns.stage_hunk, d('stage hunk'))
vim.keymap.set('n', '<leader>gH', gitsigns.undo_stage_hunk, d('project commits'))


-- toggle bindings
local lsp_lines = lazy_require('lsp_lines')
vim.keymap.set('n', '<leader>tu', ':UndotreeToggle<cr>', d('undo tree'))
vim.keymap.set('n', '<leader>tf', ':NERDTreeToggle<cr>', d('explorer'))
vim.keymap.set('n', '<leader>tt', ':Twilight<cr>', d('twilight'))
vim.keymap.set('n', '<leader>td', lsp_lines.toggle, d('diagnostics'))
vim.keymap.set('n', '<leader>tp', function() vim.treesitter.inspect_tree() end, d('inspect tree'))
vim.keymap.set('n', '<leader>th', ':nohlsearch<CR>', d('search hl'))
vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, d('blame line'))


-- edit bindings
vim.keymap.set({ 'n', 'v' }, '<leader>ec', '<plug>NERDCommenterToggle', d('comment'))
vim.keymap.set({ 'n', 'v' }, '<leader>es', '<plug>NERDCommenterSexy', d('sexy comment'))
vim.keymap.set({ 'n', 'v' }, '<leader>ey', '<plug>NERDCommenterYank', d('comment yank'))


-- other keybindings
vim.keymap.set('n', '<leader>ot', function() telescope.colorscheme({ enable_preview = true }) end, d('select theme'))
vim.keymap.set('n', '<leader>ov', telescope.vim_options, d('vim options'))
vim.keymap.set('n', '<leader>oR', ':source $MYVIMRC<cr> ', d('Reload nvim'))
vim.keymap.set('n', '<leader>os', function() vim.api.nvim_cmd({ cmd = 'source', args = { '%' } }, {}) end,
  d('source file'))
vim.keymap.set('n', '<leader>ol', require('lazy').home, d('Lazy'))


-- buffer navigation keybindings
vim.keymap.set('n', '[h', gitsigns.prev_hunk, d('previous hunk'))
vim.keymap.set('n', ']h', gitsigns.next_hunk, d('next hunk'))
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, d('previous diagnostic'))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, d('next diagnostic'))


-- debug keymappings
local dap = lazy_require('dap')
local meta = lazy_require('meta-breakpoints')
local debug_config = require('debug_config')
vim.keymap.set('n', '<leader>db', meta.toggle_meta_breakpoint, d('toggle breakpoint'))
vim.keymap.set('n', '<leader>dB', function() meta.toggle_meta_breakpoint({}, { persistent = true }) end,
  d('toggle Preakpoint'))
vim.keymap.set('n', '<leader>dC', meta.put_conditional_breakpoint, d('conditional breakpoint'))
vim.keymap.set('n', '<leader>dm', function() meta.toggle_meta_breakpoint({}, {}, nil, true) end,
  d('toggle meta breakpoint'))
vim.keymap.set('n', '<leader>dM', function() meta.toggle_meta_breakpoint({}, { persistent = true }, nil, true) end,
  d('toggle meta Preakpoint'))
vim.keymap.set('n', '<leader>dh', meta.toggle_hook_breakpoint, d('toggle hook breakpoint'))
vim.keymap.set('n', '<leader>dH', function() meta.toggle_hook_breakpoint({}, { persistent = true }) end,
  d('toggle hook Preakpoint'))
vim.keymap.set('n', '<leader>dr', debug_config.toggle_dap_repl, d('toggle repl'))
vim.keymap.set('n', '<leader>dD', function() dap.disconnect({ terminateDebuggee = false }) end, d('disconnect debugger'))
vim.keymap.set('n', '<leader>de', debug_config.setup_nvim_server, d('setup nvim server'))
vim.keymap.set('n', '<leader>dE', debug_config.stop_nvim_server, d('stop nvim server'))
vim.keymap.set('n', '<leader>dN', function() require('osv').launch({ port = 8086 }) end, d('debug this instance'))
vim.keymap.set('n', '<leader>df', debug_config.toggle_frames_widget, d('current frames'))
vim.keymap.set('n', '<leader>dw', function() vim.print(meta.get_all_breakpoints()) end, d('query meta breakpoints'))
vim.keymap.set('n', '<leader>dW', function() vim.print(meta.get_all_hooks()) end, d('query hooks mapping'))


plugins.add_plugin({
  "anuvyklack/hydra.nvim",
  event = 'VeryLazy',
  config = function()
    local Hydra = require('hydra')
    Hydra({
      name = 'debug mode',
      mode = { 'n', 'x' },
      body = '<leader>d',
      config = {
        hint = {type = 'window', border = 'rounded'},
        color = 'pink',
      },
      heads = {
        { 'c', dap.continue,{ desc = 'continue' } },
        { 'n', dap.step_over,{ desc = 'step over' } },
        { 's', dap.step_into,{ desc = 'step into' } },
        { 'o', dap.step_out, { desc = 'step out' } },
        { 'u', dap.up,{ desc = 'stack up' } },
        { 'd', dap.down,{ desc = 'stack down' } },
        { 'D', function() dap.disconnect({ terminateDebuggee = false }) end, { exit = true, desc = 'disconnect' } },
        { 't', dap.run_to_cursor,{ desc = 'run to cursor' } },
        { 'r', debug_config.toggle_dap_repl, { desc = 'repl', exit = true } },
        { 'T', dap.terminate, { desc = 'terminate', exit = true } },
        { 'f', debug_config.toggle_frames_widget,{ desc = 'current frames' } },
        { 'q', nil, { exit = true, desc = 'exit mode' } },
      }
    })
  end
})
