local plugins = require('core.plugins')

plugins.add_plugin({
  "tiagovla/scope.nvim",
  config = function()
    require('scope').setup()
  end,
})
plugins.add_plugin({
  "nvim-lua/plenary.nvim",
  cmd = {'PlenaryBustedDirectory', 'PlenaryBustedFile'}
})
plugins.add_plugin({ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} })
plugins.add_plugin({ "jghauser/mkdir.nvim", event = "CmdlineEnter" }) -- automatically create missing directories
plugins.add_plugin({
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {},
})
plugins.add_plugin({ "hiphish/rainbow-delimiters.nvim", event = "VeryLazy" })
plugins.add_plugin({ "karb94/neoscroll.nvim", event = "VeryLazy", opts = { easing_function = "sine" } })
plugins.add_plugin({ "tpope/vim-fugitive", cmd = "Git" })
plugins.add_plugin({ "lewis6991/gitsigns.nvim", event = "BufRead", opts = {} })


plugins.add_plugin({ "mbbill/undotree", cmd = "UndotreeToggle" })
plugins.add_plugin({ "famiu/bufdelete.nvim", cmd = "Bdelete" })
plugins.add_plugin({
  "preservim/nerdcommenter",
  event = 'VeryLazy',
  init = function()
    vim.g.NERDCreateDefaultMappings = 0
  end
})
plugins.add_plugin({ "preservim/nerdtree", cmd = "NERDTreeToggle" })
plugins.add_plugin({ "folke/twilight.nvim", cmd = "Twilight", opts = {} }) -- dim inactive code
plugins.add_plugin({ "ii14/neorepl.nvim", cmd = "Repl" })

plugins.add_plugin({
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('nightfox').setup {
      options = {
        transparent = true,
        styles = {
          comments = 'italic',
          keywords = 'bold',
          types = 'bold',
          conditionals = "italic",
          constants = "NONE",
          functions = "italic",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          variables = "NONE",
        }
      }
    }
    vim.cmd([[colorscheme nightfox]])
    require("nvim-web-devicons").setup()
  end,
  dependencies = {
    "kyazdani42/nvim-web-devicons"
  },
})
