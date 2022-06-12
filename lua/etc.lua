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
local action_layout = require("telescope.actions.layout")
telescope.setup{
    defaults = {
        file_ignore_patterns = {"node_modules/.*", "__pycache__/.*", ".env/.*", "env/.*", "build/.*"},
        layout_strategy = 'vertical',
        layout_config = { width = 0.7 },
    },
    mappings = {
        i = {
            ["<C-h>"] = action_layout.toggle_preview
        }
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
telescope.load_extension('fzf')

require('project_nvim').setup{
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project" },
    detection_methods = {'pattern', 'lsp'},
}

telescope.load_extension('projects')


require('lualine').setup{
    --options = {
        --theme = "catppuccin"
    --}
}

local group = vim.api.nvim_create_augroup("config", {clear = true})
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = vim.lsp.buf.hover,
    group = group
})

vim.api.nvim_create_autocmd({'DirChanged'}, {
    pattern = "*",
    group = group,
    callback = function ()
        local cwd = vim.v.event.cwd
        require('notify')(cwd, 'info', {title='Setting CWD'})
    end
})
