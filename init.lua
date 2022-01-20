-- botstrap pack


vim.g.mapleader = ' '
vim.wo.colorcolumn = '80'
vim.cmd('colorscheme duskfox')
vim.o.timeoutlen= 500
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.number = true

require('packer_nvim')


require('hop').setup()

local wk = require('which-key')
wk.register({
	b = {
		name = 'buffer',
		n = {'<cmd>bn<cr>', 'next buffer'}
	},
	[' '] = {'<cmd>HopChar2<cr>', 'Jump To Chars'},
	f = {
		name = 'files',
		f = {'<cmd>Telescope find_files<cr>', 'find file'},
		g = {'<cmd>Telescope live_grep<cr>', 'grep file'},
	}
}, { prefix = "<leader>" })
