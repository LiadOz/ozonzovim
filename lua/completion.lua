vim.o.completeopt = 'menu,menuone,noselect'


local cmp = require'cmp'
local luasnip = require('luasnip')


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
    ['<TAB>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(function (fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
      fields = {'menu', 'abbr', 'kind'},
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

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
    { name = "path" }
  },
})
