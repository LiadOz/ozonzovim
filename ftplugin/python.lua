vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

local wk = require('which-key')
local utils = require('python_utils')
wk.register({
    c = {
        o = {':PyrightOrganizeImports<cr>', 'organize imports'}
    },
    o = {
        t = {utils.cp_test_path, 'slash test path'},
        T = {function() utils.cp_test_path(true) end, 'pytest test path'}
    }
} , { prefix = "<leader>" })
