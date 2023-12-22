vim.o.completeopt = 'menu,menuone,noselect'

local plugins = require('core.plugins')

local function configure_cmp()
  local cmp = require 'cmp'
  local luasnip = require('luasnip')
  local neogen = require('neogen')
  local function cmp_tab(fallback)
    if cmp.visible() then
      if #cmp.get_entries() == 1 then
        cmp.confirm({ select = true })
      else
        cmp.select_next_item()
      end
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif neogen.jumpable() then
      neogen.jump_next()
    else
      fallback()
    end
  end
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          or require("cmp_dap").is_dap_buffer()
    end,
    mapping = {
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<TAB>'] = cmp.mapping({
        i = cmp_tab,
        s = cmp_tab,
        c = function(_)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_next_item()
            end
          else
            cmp.complete()
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            end
          end
        end,
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        elseif neogen.jumpable(true) then
          neogen.jump_prev()
        else
          fallback()
        end
      end, { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
      format = require('lspkind').cmp_format({
        mode = 'symbol_text', -- show only symbol annotations
        maxwidth = 50,
        ellipsis_char = '...',
        --before = function (entry, vim_item)
        --return vim_item
        --end
      })
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })


  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
      { name = "path" }
    },
  })
end

plugins.add_plugin({
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  }
})

plugins.add_plugin({
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  config = configure_cmp,
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    'hrsh7th/cmp-buffer',
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lua",
    "onsails/lspkind.nvim",
    {
      "rcarriga/cmp-dap",
      dependencies = "mfussenegger/nvim-dap"
    },
    {
      "danymat/neogen",
      dependencies = "nvim-treesitter/nvim-treesitter",
      lazy = true,
      opts = {
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              annotation_convention = "reST"
            }
          }
        }
      },
    }
  }
})
