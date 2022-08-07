local get_project_path = require('project_utils').get_project_path

local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('mason').setup {}
require('mason-lspconfig').setup {
    ensure_installed = { 'sumneko_lua', 'pyright' }
}
local lspconfig = require('lspconfig')

lspconfig.sumneko_lua.setup {
    capabilities = cmp_capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                }
            }
        }
    }
}

lspconfig.pyright.setup {
    capabilities = cmp_capabilities,
    root_dir = function(fname)
        local project_path = get_project_path(fname)
        if project_path then
            return project_path
        end
        return lspconfig.server_configurations.pyright.default_config.root_dir(fname)
    end,
    handlers = {
        ['textDocument/publishDiagnostics'] = function() end
    }
}

lspconfig.tsserver.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.rust_analyzer.setup {}

--local nls_root_pattern = require('null-ls.utils').root_pattern
require('null-ls').setup({
    sources = {
        require('null-ls').builtins.diagnostics.pylint,
    },
    --root_dir = function (fname)
    --for _, value in pairs(projects_dirs) do
    --if fname:find(value) then
    --print(value)
    --return value
    --end
    --end
    --return nls_root_pattern(".null-ls-root", "Makefile", ".git")(fname)
    --end
})

vim.diagnostic.config {
    signs = false,
}
