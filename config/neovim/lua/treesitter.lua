require("nvim-treesitter.configs").setup({
  ensure_installed = { "bash", "dockerfile", "lua", "markdown", "nix", "ruby", "rust" },
  sync_install = false,

  highlight = {
    enable = true,
  },

  endwise = {
    enable = true,
  },
})
