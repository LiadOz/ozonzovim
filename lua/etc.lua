require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        disable = {}
    },
	--indent = {
	--	enable = true,
	--	disable = {}
	--},
    --ensure_installed = {
        --"lua",
        --"python",
        --"typescript",
        --"html",
        --"javascript",
        --'tsx',
        --'scss',
        --"rust",
        --"c"
    --},
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean 
    }
}

local telescope = require('telescope')
local action_layout = require("telescope.actions.layout")
telescope.setup{
    defaults = {
        file_ignore_patterns = {"node_modules/.*", "__pycache__/.*", "env/.*", "build/.*"},
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
    patterns = { ".git", ".project" },
    detection_methods = {'pattern', 'lsp'},
}

telescope.load_extension('projects')


local group = vim.api.nvim_create_augroup("config", {clear = true})
vim.api.nvim_create_autocmd({'DirChanged'}, {
    pattern = "*",
    group = group,
    callback = function ()
        local cwd = vim.v.event.cwd
        vim.notify('CWD set to ' .. cwd)
        --require('notify')(cwd, 'info', {title='Setting CWD'})
    end
})
