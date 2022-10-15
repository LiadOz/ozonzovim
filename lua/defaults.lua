vim.wo.relativenumber = true
vim.o.timeoutlen= 500
vim.o.number = true
vim.o.backup = true
vim.o.swapfile = true
vim.o.undofile = true
vim.o.backupdir = vim.env.HOME .. '/nvim/backup//'
vim.o.directory = vim.env.HOME .. '/nvim/swap//'
vim.o.undodir = vim.env.HOME .. '/nvim/undo//'
vim.o.updatetime = 100
vim.o.autoread = true
vim.o.laststatus = 3
--vim.o.cmdheight = 0
require('nightfox').setup{
    options={
        styles={
            comments='italic',
            keywords='bold',
            types='italic,bold'
        }
    }
}
vim.cmd('colorscheme duskfox')

--vim.g.catppuccin_flavour = "frappe"
--vim.cmd('colorscheme catppuccin')
