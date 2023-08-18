local plugins = require('core.plugins')

plugins.add_plugin({
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context"
  },
  config = function()
    require('nvim-dap-repl-highlights').setup() -- must be setup before nvim-treesitter
    require('nvim-treesitter.configs').setup {
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end
      },
      indent = {
        enable = true,
        disable = {}
      },
      ensure_installed = {
        "bash",
        "luadoc",
        "json",
        "markdown",
        "regex",
        "vim",
        "vimdoc",
        "lua",
        "python",
        "typescript",
        "html",
        "javascript",
        'tsx',
        'scss',
        "rust",
        "c",
        "dap_repl",
        "yaml",
      },
    }
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})

plugins.add_plugin({
  "liadoz/nvim-dap-repl-highlights",
  opts = {},
  lazy = true,
})

plugins.add_plugin({
  "nvim-treesitter/nvim-treesitter-context",
  opts = {},
  lazy = true
})
