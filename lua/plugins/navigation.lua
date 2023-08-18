local plugins = require('core.plugins')

plugins.add_plugin({
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-symbols.nvim",
    {
      "ahmedkhalf/project.nvim",
      event = "VeryLazy",
      config = function()
        require("project_nvim").setup({
          patterns = { ".git", ".project" }, detection_methods = { 'pattern', 'lsp' },
        })
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local action_layout = require("telescope.actions.layout")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "__pycache__/.*", "build/.*" },
        layout_strategy = 'vertical',
        layout_config = { width = 0.7 },
      },
      mappings = {
        i = {
          ["<C-h>"] = action_layout.toggle_preview
        }
      },
    })
    telescope.load_extension('fzf')
    telescope.load_extension('projects')
  end
})
