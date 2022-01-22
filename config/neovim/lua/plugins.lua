-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
  -- packer inception
  use { "wbthomason/packer.nvim" }

  -- groundwork
  use { "nvim-lua/plenary.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- ui
  use { "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" }
  use { "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  }

  -- general
  use { "alvan/vim-closetag" }
  use { "mechatroner/rainbow_csv" }
  use { "tpope/vim-endwise" }
  use { "tpope/vim-fugitive" }
  use { "tpope/vim-repeat" }
  use { "tpope/vim-surround" }

  use {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.cmd[[au BufWritePre * StripWhitespace]]
    end,
  }

  use {
    "terrortylor/nvim-comment",
    config = function() require("nvim_comment").setup() end
  }

  use {
    "Raimondi/delimitMate",
    config = function()
      vim.cmd[[let b:delimitMate_expand_cr = 1]]
      vim.cmd[[let b:delimitMate_expand_space = 1]]
      vim.cmd[[let b:delimitMate_jump_expansion = 1]]
    end,
  }

  -- completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/vim-vsnip",
    }
  }

  -- language / debugging
  use {
    "neovim/nvim-lspconfig",
    requires = {
      "onsails/lspkind-nvim",
      "williamboman/nvim-lsp-installer",
    }
  }
  use { "folke/lsp-trouble.nvim" }

  -- language syntax / support
  use { "cespare/vim-toml"}
  use { "hashivim/vim-terraform"}
  use { "LnL7/vim-nix" }

  use { "simrat39/rust-tools.nvim" }
  use { "Saecki/crates.nvim" }

  use { "vim-ruby/vim-ruby" }
  use { "tpope/vim-rails" }

  -- themes
  use "KeitaNakamura/neodark.vim"
  use "arcticicestudio/nord-vim"
  use "EdenEast/nightfox.nvim"
  use "folke/tokyonight.nvim"

  -- bootstrap packer
  if packer_bootstrap then
    require("packer").sync()
  end
end)
