local get_project_path = require('project_utils').get_project_path

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup {}
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls' }
}

require('neodev').setup({
  override = function (root_dir, library)
    library.plugins = true -- enable plugins for all lua projects since I only use lua for plugins
    --if string.match(root_dir, "meta.breakpoints.nvim") then
      --library.plugins = true
    --end
  end
})

local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup {
  capabilities = cmp_capabilities,
}

--lspconfig.pyright.setup {
    --capabilities = cmp_capabilities,
    --root_dir = function(fname)
        --local orig_config = require('lspconfig.server_configurations.pyright')
        --local project_path = get_project_path(fname)
        --if project_path then
            --return project_path
        --end
        --return orig_config.default_config.root_dir(fname)
    --end,
    --handlers = {
        --['textDocument/publishDiagnostics'] = function() end
    --}
--}

lspconfig.pylsp.setup({
  capabilities = cmp_capabilities,
  root_dir = function(fname)
    local orig_config = require('lspconfig.server_configurations.pylsp')
    local project_path = get_project_path(fname)
    if project_path then
      return project_path
    end
    return orig_config.default_config.root_dir(fname)
  end,
  settings = {
    pylsp = {
      plugins = {
        pylint = {
          enabled = true,
        },
        pycodestyle = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        --rope_autoimport = {
          --enabled = true,
        --},
        pyls_mypy = {
          enabled = true,
        },
        pyls_isort = {
          enabled = true,
        },
        pylsp_rope = {
          enabled = true,
        },
      },
    },
  },
})

lspconfig.tsserver.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.clangd.setup {}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config {
  signs = false,
}

require("nvim-lightbulb").setup({
  autocmd = { enabled = true },
  sign = { enabled = false},
  virtual_text = { enabled = true},
})
