local wk = require('which-key')

wk.register({
    ["<TAB>"] = {':bnext<cr>', 'next buffer'},
    [" "] = {':HopChar2<cr>', 'jump2'},
    b = {
        name = 'buffer+',
        n = {':bnext<cr>', 'next buffer'},
        p = {':bprev<cr>', 'previous buffer'},
        d = {':bdelete<cr>', 'delete buffer'},
    },
    f = {
        name = 'find+',
        f = {"<cmd>lua require('telescope.builtin').find_files()<cr>", 'find files'},
        g = {"<cmd>lua require('telescope.builtin').live_grep()<cr>", 'grep'},
        p = {"<cmd>lua require('telescope.builtin').git_files()<cr>", 'project'},
        b = {"<cmd>lua require('telescope.builtin').buffers()<cr>", 'buffers'},
        h = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", 'help'},
    },
    c = {
        name = 'code+',
        D = {'<cmd>lua vim.lsp.buf.declaration()<cr>', 'go to declaration'},
        d = {'<cmd>lua vim.lsp.buf.definition()<CR>', 'go to definition'},
        k = {'<cmd>lua vim.lsp.buf.hover()<CR>', 'hover'},
        i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'go to implementation'},
        t = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'type definition'},
        n = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'rename'},
        a = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'code action'},
        r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'references'},
        f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'formatting'},
    },
}, { prefix = "<leader>" })
