vim.g.mapleader = ' '
vim.wo.relativenumber = true
vim.wo.colorcolumn = '80'
vim.cmd('colorscheme duskfox')
vim.o.timeoutlen= 500
vim.o.number = true
vim.o.backup = true
vim.o.swapfile = true
vim.o.undofile = true
vim.o.backupdir = vim.env.HOME .. '/nvim/backup//'
vim.o.directory = vim.env.HOME .. '/nvim/swap//'
vim.o.undodir = vim.env.HOME .. '/nvim/undo//'
-- vim.o.autochdir = true


require('packer_nvim')
require('keymappings')
require('completion')

require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		disable = {}
	},
	-- indent = {
	-- 	enable = true,
	-- 	disable = {}
	-- },
	ensure_installed = {
		"lua",
		"python",
        "typescript",
        "html",
        "javascript",
	},
}

require'telescope'.setup{
    defaults = { file_ignore_patterns = {"node_modules/.*", "__pycache__/.*"}}
}

require('project_nvim').setup{}

require('lspconfig').pylsp.setup{
}
require('telescope').load_extension('projects')

local projects_dirs = require('projects')
local lsp_installer = require("nvim-lsp-installer")
-- You should install for each language server manually with :LspInstall

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end
    if server.name == 'pylsp' then
        local orig_config = require('lspconfig.server_configurations.pylsp')
        local orig_root_dir = orig_config['default_config']['root_dir']
        opts.root_dir = function (fname)
            for _, value in pairs(projects_dirs) do
                if fname:find(value) then
                    return value
                end
            end
            return orig_root_dir(fname)
        end
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
