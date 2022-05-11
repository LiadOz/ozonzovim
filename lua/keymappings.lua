local wk = require('which-key')

local mappings = {
    ["<TAB>"] = {':b#<cr>', 'prev buffer'},
    [" "] = {':HopChar2<cr>', 'jump2'},
    b = {
        name = 'buffer+',
        n = {':bnext<cr>', 'next buffer'},
        p = {':bprev<cr>', 'previous buffer'},
        d = {':Bdelete<cr>', 'delete buffer'},
        D = {':Bdelete!<cr>', 'delete buffer no save'},
        b = {"<cmd>lua require('telescope.builtin').buffers()<cr>", 'buffers'},
    },
    f = {
        name = 'find+',
        f = {"<cmd>lua require('telescope.builtin').find_files()<cr>", 'find files'},
        s = {"<cmd>lua require('telescope.builtin').resume()<cr>", 'resume last'},
        g = {"<cmd>lua require('telescope.builtin').live_grep()<cr>", 'grep'},
        c = {"<cmd>lua require('telescope.builtin').grep_string()<cr>", 'grep cursor'},
        p = {"<cmd>lua require('telescope.builtin').git_files()<cr>", 'project'},
        h = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", 'help'},
        r = {"<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'recent files'},
        o = {"<cmd>Telescope projects<cr>", 'projects'},
    },
    c = {
        name = 'code+',
        D = {'<cmd>lua vim.lsp.buf.declaration()<cr>', 'go to declaration'},
        d = {'<cmd>lua vim.lsp.buf.definition()<cr>', 'go to definition'},
        h = {'<cmd>lua vim.lsp.buf.hover()<cr>', 'hover'},
        i = {'<cmd>lua vim.lsp.buf.implementation()<cr>', 'go to implementation'},
        t = {'<cmd>lua vim.lsp.buf.type_definition()<cr>', 'type definition'},
        n = {'<cmd>lua vim.lsp.buf.rename()<cr>', 'rename'},
        a = {"<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", 'code action'},
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
    },
    t = {
        name = 'toggle+',
        u = {':UndotreeToggle<cr>', 'undo tree'}
    },
    e = {
        name = 'edit+',
        c = {'<plug>NERDCommenterToggle', 'comment'},
        s = {'<plug>NERDCommenterSexy', 'sexy comment'},
        y = {'<plug>NERDCommenterYank', 'comment yank'},
    }
}
wk.register(mappings, { prefix = "<leader>" })
wk.register(mappings, { mode = "v", prefix = "<leader>" })
