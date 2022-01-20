-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'LnL7/vim-nix' }
  use { 'Raimondi/delimitMate' }
  use { 'Saecki/crates.nvim' }
  use { 'alvan/vim-closetag' }
  use { 'cespare/vim-toml'}
  use { 'hashivim/vim-terraform'}
  use { 'mechatroner/rainbow_csv' }
  use { 'tpope/vim-endwise' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-rails' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'vim-ruby/vim-ruby' }

  use { 'terrortylor/nvim-comment' }

  use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons' }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'onsails/lspkind-nvim',
      'williamboman/nvim-lsp-installer',
    }
  }
  use { 'folke/lsp-trouble.nvim' }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/vim-vsnip',
    }
  }

  use { 'simrat39/rust-tools.nvim' }

  -- themes
  use 'KeitaNakamura/neodark.vim'
  use 'arcticicestudio/nord-vim'
  use 'EdenEast/nightfox.nvim'
  use 'folke/tokyonight.nvim'

  -- bootstrap packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)
