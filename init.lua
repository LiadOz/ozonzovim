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
vim.o.autochdir = true


require('packer_nvim')
require('keymappings')
require('completion')

require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		disable = {}
	},
	--indent = {
	--	enable = true,
	--	disable = {}
	--},
	ensure_installed = {
		"lua",
		"python",
        "typescript",
        "html",
        "javascript",
        'tsx',
        'scss',
	},
}

local telescope = require('telescope')
telescope.setup{
    defaults = {
        file_ignore_patterns = {"node_modules/.*", "__pycache__/.*", "^env/.*", "/env/.*", "build/.*"},
        layout_strategy = 'center',
        layout_config = { width = 0.8 },
    },
    pickers = {
        -- find_files = {
        --     theme = "dropdown"
        -- },
        -- grep_string = {
        --     theme = "dropdown"
        -- },
        -- live_grep = {
        --     theme = "dropdown"
        -- },
    }
}
--telescope.load_extension('fzf')

require('project_nvim').setup{
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project" },
    silent_chdir = false,
}

telescope.load_extension('projects')

local projects_dirs = require('projects')
local lsp_installer = require("nvim-lsp-installer")
-- You should install for each language server manually with :LspInstall

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {}
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
    elseif server.name == 'pyright' then
        local orig_config = require('lspconfig.server_configurations.pyright')
        local orig_root_dir = orig_config['default_config']['root_dir']
        opts.root_dir = function (fname)
            for _, value in pairs(projects_dirs) do
                if fname:find(value) then
                    return value
                end
            end
            return orig_root_dir(fname)
        end
    elseif server.name == 'sumneko_lua' then
        opts.settings = {
            Lua = {
                diagnostics = { globals = {'vim'} }
            }
        }
    end
    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
