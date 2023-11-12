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

    local python_utils = require('utilities.python')

    lspconfig.pylsp.setup({
      capabilities = cmp_capabilities,
      on_init = function(client)
        if python_utils.is_poetry_installed() then
          local poetry_env = python_utils.get_poetry_project_path()
          if poetry_env then
            client.config.settings.pylsp.plugins.jedi.environment = poetry_env
            vim.print(client.config.settings)
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            return true
          end
        end
      end,
      --root_dir = function(fname)
      --local orig_config = require('lspconfig.server_configurations.pylsp')
      --local project_path = get_project_path(fname)
      --if project_path then
      --return project_path
      --end
      --return orig_config.default_config.root_dir(fname)
      --end,
      settings = {
        pylsp = {
          plugins = {
            jedi = {
              extra_paths = {},
              env_vars = nil,
              environment = nil,
            },
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
  "simrat39/rust-tools.nvim",
  ft = 'rs',
  opts = {},
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
