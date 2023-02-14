local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path
    })
    execute 'packadd packer.nvim'
end

local default_plugins = {
  'wbthomason/packer.nvim',
  'folke/which-key.nvim',
  'EdenEast/nightfox.nvim',
  {
    'phaazon/hop.nvim',
    config = function()
        require 'hop'.setup {}
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  },
  'nvim-telescope/telescope-symbols.nvim',

  'neovim/nvim-lspconfig',
  'williamboman/nvim-lsp-installer',
  'nvim-treesitter/nvim-treesitter',
  'ahmedkhalf/project.nvim',
  'famiu/bufdelete.nvim',
  'jiangmiao/auto-pairs',

  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',
  'mbbill/undotree',
  {
    'preservim/nerdcommenter',
    config = function()
        vim.g.NERDCreateDefaultMappings = 0
    end
  },
  {
    'j-hui/fidget.nvim',
    config = function()
        require('fidget').setup {}
    end
  },
  {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { { 'nvim-lua/plenary.nvim' } }
  },
  'preservim/nerdtree',
  'djoshea/vim-autoread',
  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-web-devicons',
  'rcarriga/nvim-notify',
  'nvim-treesitter/playground',
  {
    'catppuccin/nvim',
    name = 'catppuccin'
  },
  { -- dims inactive portions of code
    "folke/twilight.nvim",
    config = function()
        require("twilight").setup {}
    end
  },
  'jghauser/mkdir.nvim', -- automatically create missing directories
  'tpope/vim-surround',

  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
        require("lsp_lines").setup()
        require("lsp_lines").toggle()
    end
  },
  "akinsho/toggleterm.nvim",
  "mrjones2014/nvim-ts-rainbow",
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
        require('treesitter-context').setup()
    end
  },
  "anuvyklack/hydra.nvim",
  "mfussenegger/nvim-dap",
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/cmp-dap",
  "ii14/neorepl.nvim",
  "stevearc/dressing.nvim",
  "jbyuki/one-small-step-for-vimkind",
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = {"mfussenegger/nvim-dap"}
  },
  "liadoz/meta-breakpoints.nvim",

  --------------------------------------
  -- completion plugins
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-nvim-lua',

  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'onsails/lspkind.nvim',
  --------------------------------------
}

local ok, host_plugin_config = pcall(require, 'host_configs.current_host.host_config')
local host_additional_plugins = {}
local host_disabled_plugins = {}
if ok then
  host_disabled_plugins = host_plugin_config.host_disabled_plugins or {}
  host_additional_plugins = host_plugin_config.host_additional_plugins or {}
end

local host_plugins = {}

for _, plugin_data in ipairs(default_plugins) do
  local plugin_name = ''
  if type(plugin_data) == "table" then
    plugin_name = plugin_data[1]
  else
    plugin_name = plugin_data
  end
  if not host_disabled_plugins[plugin_name] then
    table.insert(host_plugins, plugin_data)
  end
end

for _, plugin_data in ipairs(host_additional_plugins) do
  table.insert(host_plugins, plugin_data)
end

return require('packer').startup(function(use)
  for _, plugin_data in ipairs(host_plugins) do
    use(plugin_data)
  end
end)
