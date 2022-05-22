local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path
	})
	execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'folke/which-key.nvim'
    use 'EdenEast/nightfox.nvim'
    use {
        'phaazon/hop.nvim',
        config = function()
            require'hop'.setup{}
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'nvim-treesitter/nvim-treesitter'
    use 'ahmedkhalf/project.nvim'
    use 'famiu/bufdelete.nvim'
    use 'jiangmiao/auto-pairs'

    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use 'mbbill/undotree'
    use {
        'preservim/nerdcommenter',
        config = function()
            vim.g.NERDCreateDefaultMappings = 0
        end
    }
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup{}
        end
    }
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use 'preservim/nerdtree'
    use 'djoshea/vim-autoread'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    --------------------------------------
    -- completion plugins
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    -- For vsnip users.
    -- use 'hrsh7th/cmp-vsnip'
    -- use 'hrsh7th/vim-vsnip'

    -- For luasnip users.
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- For ultisnips users.
    -- use 'SirVer/ultisnips'
    -- use 'quangnguyen30192/cmp-nvim-ultisnips'

    -- For snippy users.
    -- use 'dcampos/nvim-snippy'
    -- use 'dcampos/cmp-snippy'
    --------------------------------------

  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins

    use 'ryanoasis/vim-devicons' -- dev-icons is suggested being run last
    -- make sure you have a patched font https://github.com/ryanoasis/nerd-fonts

end)
