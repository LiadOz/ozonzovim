local plugins = require('core.plugins')

plugins.add_plugin({
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')
    lspconfig.lua_ls.setup {
      capabilities = cmp_capabilities,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false
          }
        }
      }
    }
    lspconfig.pyright.setup {
      capabilities = cmp_capabilities,
      handlers = {
        ['textDocument/publishDiagnostics'] = function() end
      }
    }
    lspconfig.tsserver.setup {}
    lspconfig.tailwindcss.setup {}
    lspconfig.rust_analyzer.setup {}
    lspconfig.clangd.setup {}
  end,
  dependencies = {
    { "williamboman/mason.nvim", opts = {} },
    {
      "folke/neodev.nvim",
      opts = {
        override = function(_, library)
          library.plugins = true -- enable plugins for all lua projects since I only use lua for plugins
        end
      }
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          'lua_ls',
          'pyright'
        }
      }
    },
  }
})

plugins.add_plugin({
  'j-hui/fidget.nvim',
  tag = 'legacy',
  event = 'LspAttach',
  config = function()
    require('fidget').setup {}
  end
})

plugins.add_plugin({
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()
    require("lsp_lines").toggle()
  end
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config {
  signs = false,
}
