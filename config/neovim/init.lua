require('plugins')
require('settings')
require('completion')
require('mappings')

-- comment needs to be initialized
require('nvim_comment').setup()

-- lualine
require('lualine').setup {
  options = {
    theme = 'nord',
  }
}

