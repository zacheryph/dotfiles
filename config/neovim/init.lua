-- initialize the world
require("plugins")
require("settings")
require("mappings")
require("completion")
require("theme")
require("treesitter")

-- set our colorscheme
SetupTheme("tokyonight")

-- telescope configuration
-- this is here cause i cant have lua/telescope.lua
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        -- close telescope with one esc
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

-- fzf lets me use spaces in search
telescope.load_extension('fzf')

