require('plugins')
require('settings')
require('completion')
require('mappings')

vim.cmd[[let g:everforest_background = 'hard']]
vim.cmd[[colorscheme everforest]]

-- comment needs to be initialized
require('nvim_comment').setup()

-- lualine
require('lualine').setup {
  options = {
    theme = 'everforest',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  }
}

-- exit telescope one on esc
local actions = require("telescope.actions")
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
})
