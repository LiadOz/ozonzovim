vim.g.mapleader = ' '
vim.wo.relativenumber = true
vim.o.timeoutlen = 500
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
vim.o.mouse = nil
vim.o.foldmethod = 'expr'
vim.o.foldlevel = 99
vim.o.spell = true
vim.o.scrolloff = 15
vim.o.breakindent = true  -- when line wraps set its indent to the same level as previous line
vim.o.cursorline = true
vim.o.splitkeep = "screen"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
--vim.o.cmdheight = 0

--vim.g.catppuccin_flavour = "frappe"
--vim.cmd('colorscheme catppuccin')
