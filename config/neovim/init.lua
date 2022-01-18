require('plugins')
require('settings')
require('completion')
require('mappings')

-- vim.cmd[[colorscheme nightfox]]
local nightfox = require('nightfox')
nightfox.setup({
  fox = 'nordfox',
  styles = { comments = "italic" },
})
nightfox.load()

-- comment needs to be initialized
require('nvim_comment').setup()

-- lualine
require('lualine').setup {
  options = {
    theme = 'nightfox',
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
