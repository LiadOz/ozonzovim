vim.g.mapleader = ' '
local wk = require('which-key')

local proj_dir = require('project_utils').get_cwd_project_dir
local telescope = require('telescope.builtin')

require('toggleterm').setup({
    open_mapping = [[<c-t>]],
    direction = 'float'
})
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

local function _lazygit_toggle()
    lazygit:toggle()
end

local function slash_term()
    local test_path = require('slash_utils').cp_test_path()
    local term = Terminal:new({ cmd = "slash run -s ibox609" .. test_path, hidden = true, close_on_exit = false })
    term:toggle()
end

local mappings = {
    ["<TAB>"] = { ':b#<cr>', 'prev buffer' },
    [" "] = { ':HopChar2<cr>', 'jump2' },
    a = { function() telescope.commands() end, 'commands' },
    b = {
        name = 'buffer+',
        n = { ':bnext<cr>', 'next buffer' },
        p = { ':bprev<cr>', 'previous buffer' },
        d = { ':Bdelete<cr>', 'delete buffer' },
        D = { ':Bdelete!<cr>', 'delete buffer no save' },
        b = { function() telescope.buffers({ sort_lastused = true, ignore_current_buffer = true }) end, 'buffers' },
        B = { function() telescope.buffers({ sort_lastused = true, ignore_current_buffer = true, cwd_only = true }) end,
            'buffers (cwd)' },
    },
    f = {
        name = 'find+',
        f = { function() telescope.find_files() end, 'find files' },
        F = { function() telescope.find_files({ hidden = true }) end, 'find files (hidden)' },
        s = { "<cmd>lua require('telescope.builtin').resume()<cr>", 'resume last' },
        g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", 'grep' },
        c = { "<cmd>lua require('telescope.builtin').grep_string()<cr>", 'grep cursor' },
        p = { "<cmd>lua require('telescope.builtin').git_files()<cr>", 'project' },
        h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", 'help' },
        r = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'recent files' },
        R = { function() telescope.oldfiles({ only_cwd = true }) end, 'recent files (cwd)' }
    },
    p = {
        name = 'project+',
        o = { "<cmd>Telescope projects<cr>", 'open' },
        f = { function() telescope.find_files({ cwd = proj_dir() }) end, 'find files' },
        g = { function() telescope.live_grep({ cwd = proj_dir() }) end, 'grep' },
        c = { function() telescope.grep_string({ cwd = proj_dir() }) end, 'grep cursor' },
    },
    c = {
        name = 'code+',
        D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'go to declaration' },
        d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'go to definition' },
        s = { function() vim.diagnostic.open_float() end, 'open diagnostics' },
        h = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'hover' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'go to implementation' },
        t = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'type definition' },
        n = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'rename' },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", 'code action' },
        r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", 'references' },
        f = { function() vim.lsp.buf.format({ async = true }) end, 'format' },
        w = {
            name = 'workspace+',
            l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', 'list' },
            a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', 'add' },
            r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', 'remove' },
        }
    },
    g = {
        name = 'git+',
        b = { function() vim.cmd('Git blame --date=relative --color-by-age') end, 'blame' },
        g = { function() vim.cmd('Git') end, 'git menu' },
        c = { function() telescope.git_branches() end, 'branches' },
        s = { function() telescope.git_status() end, 'status' },
        l = { function() vim.cmd('Git log --graph --abbrev-commit --date=relative') end, 'log' },
        d = { function() vim.cmd('GitGutterDiffOrig') end, 'diff' },
        L = { function() vim.cmd('GitGutterLineHighlightsToggle') end, 'highlight lines' },
        f = { function() vim.cmd('GitGutterFold') end, 'fold' },
        h = { function() vim.cmd('GitGutterStageHunk') end, 'stage hunk' },
    },
    t = {
        name = 'toggle+',
        u = { ':UndotreeToggle<cr>', 'undo tree' },
        f = { ':NERDTreeToggle<cr>', 'explorer' },
        t = { ':Twilight<cr>', 'twilight' },
        g = { function() _lazygit_toggle() end, 'lazygit' },
        s = { function() slash_term() end, 'slash' },
        d = { require("lsp_lines").toggle, 'diagnostics' },
        p = { ':TSPlaygroundToggle<CR>', 'treesitter playground' }
    },
    e = {
        name = 'edit+',
        c = { '<plug>NERDCommenterToggle', 'comment' },
        s = { '<plug>NERDCommenterSexy', 'sexy comment' },
        y = { '<plug>NERDCommenterYank', 'comment yank' }
    },
    o = {
        name = 'other+',
        t = { function() telescope.colorscheme({ enable_preview = true }) end, 'select theme' },
        v = { function() telescope.vim_options() end, 'vim options' },
        r = { function() telescope.reloader() end, 'reloader' },
        R = { ':source $MYVIMRC<cr> ', 'Reload nvim' },
        s = { function() vim.api.nvim_cmd({ cmd = 'source', args = { '%' } }, {}) end, 'source file' }
    },
    j = {
        name = 'jump+',
    },
}
wk.register(mappings, { prefix = "<leader>" })
wk.register(mappings, { mode = "v", prefix = "<leader>" })

local Hydra = require('hydra')
local hint = {
        type = 'window',
        border = 'rounded',
}
Hydra({
    name = 'jump',
    mode = 'n',
    body = '<leader>j',
    config = {
        hint = hint
    },
    heads = {
        { 'h', function() vim.api.nvim_cmd({ cmd = 'GitGutterNextHunk' }, {}) end, { desc = '[N] hunk' } },
        { 'H', function() vim.api.nvim_cmd({ cmd = 'GitGutterPrevHunk' }, {}) end, { desc = '[P] hunk' } },
        { 'd', function() vim.diagnostic.goto_next() end, { desc = '[N] diagnostic' } },
        { 'D', function() vim.diagnostic.goto_prev() end, { desc = '[P] diagnostic' } },
        { 's', ']s', { desc = '[N] spell' } },
        { 'S', '[s', { desc = '[P] spell' } },
    }
})
