local wk = require('which-key')

local proj_dir = require('project_utils').get_cwd_project_dir
local telescope = require('telescope.builtin')

local mappings = {
    ["<TAB>"] = {':b#<cr>', 'prev buffer'},
    [" "] = {':HopChar2<cr>', 'jump2'},
    a = {function() telescope.commands() end, 'commands'},
    b = {
        name = 'buffer+',
        n = {':bnext<cr>', 'next buffer'},
        p = {':bprev<cr>', 'previous buffer'},
        d = {':Bdelete<cr>', 'delete buffer'},
        D = {':Bdelete!<cr>', 'delete buffer no save'},
        b = {function() telescope.buffers({sort_lastused = true, ignore_current_buffer = true}) end, 'buffers'},
        B = {function() telescope.buffers({sort_lastused = true, ignore_current_buffer = true, cwd_only = true}) end, 'buffers (cwd)'},
    },
    f = {
        name = 'find+',
        f = {function() telescope.find_files() end, 'find files'},
        F = {function() telescope.find_files({hidden = true}) end, 'find files (hidden)'},
        s = {"<cmd>lua require('telescope.builtin').resume()<cr>", 'resume last'},
        g = {"<cmd>lua require('telescope.builtin').live_grep()<cr>", 'grep'},
        c = {"<cmd>lua require('telescope.builtin').grep_string()<cr>", 'grep cursor'},
        p = {"<cmd>lua require('telescope.builtin').git_files()<cr>", 'project'},
        h = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", 'help'},
        r = {"<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'recent files'},
        R = {function() telescope.oldfiles({only_cwd = true}) end, 'recent files (cwd)'}
    },
    p = {
        name = 'project+',
        o = {"<cmd>Telescope projects<cr>", 'open'},
        f = {function() telescope.find_files({cwd = proj_dir()}) end, 'find files'},
        g = {function() telescope.live_grep({cwd = proj_dir()}) end, 'grep'},
        c = {function() telescope.grep_string({cwd = proj_dir()}) end, 'grep cursor'},
    },
    c = {
        name = 'code+',
        D = {'<cmd>lua vim.lsp.buf.declaration()<cr>', 'go to declaration'},
        d = {'<cmd>lua vim.lsp.buf.definition()<cr>', 'go to definition'},
        h = {'<cmd>lua vim.lsp.buf.hover()<cr>', 'hover'},
        i = {'<cmd>lua vim.lsp.buf.implementation()<cr>', 'go to implementation'},
        t = {'<cmd>lua vim.lsp.buf.type_definition()<cr>', 'type definition'},
        n = {'<cmd>lua vim.lsp.buf.rename()<cr>', 'rename'},
        a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", 'code action'},
        r = {"<cmd>lua require('telescope.builtin').lsp_references()<cr>", 'references'},
        f = {'<cmd>lua vim.lsp.buf.formatting()<cr>', 'formatting'},
        w = {
            name = 'workspace+',
            l = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', 'list'},
            a = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', 'add'},
            r = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', 'remove'},
        }
    },
    g = {
        name = 'git+',
        b = {':Git blame --date short --color-by-age<cr>', 'blame'},
        c = {function() telescope.git_branches() end, 'branches'},
        s = {function() telescope.git_status() end, 'status'},
    },
    t = {
        name = 'toggle+',
        u = {':UndotreeToggle<cr>', 'undo tree'},
        f = {':NERDTreeToggle<cr>', 'explorer'}
    },
    e = {
        name = 'edit+',
        c = {'<plug>NERDCommenterToggle', 'comment'},
        s = {'<plug>NERDCommenterSexy', 'sexy comment'},
        y = {'<plug>NERDCommenterYank', 'comment yank'},
    },
    o = {
        name = 'other+',
        t = {function() telescope.colorscheme({enable_preview = true}) end, 'select theme'},
        v = {function() telescope.vim_options() end, 'vim options'},
        r = {function() telescope.reloader() end, 'reloader'},
    }
}
wk.register(mappings, { prefix = "<leader>" })
wk.register(mappings, { mode = "v", prefix = "<leader>" })
