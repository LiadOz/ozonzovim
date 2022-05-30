vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

local wk = require('which-key')
wk.register({
    c = {
        o = {':PyrightOrganizeImports<cr>', 'organize imports'}
    },
    o = {
        t = {":lua require('slash_utils').cp_test_path()<CR>", 'slash test path'}
    }
} , { prefix = "<leader>" })
