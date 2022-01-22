-- themes
local themes = {
  neodark  = function() vim.cmd[[colorscheme neodark]] end,
  nord     = function() vim.cmd[[colorscheme nord]] end,
  nightfox = function()
    local nightfox = require("nightfox")
    nightfox.setup({
      fox = "nordfox",
      styles = { comments = "italic" },
    })
    nightfox.load()
  end,
  tokyonight = function()
    vim.g.tokyonight_style = "storm"
    vim.g.tokyonight_italic_comments = true
    vim.g.tokyonight_italic_keywords = true
    vim.cmd[[colorscheme tokyonight]]
  end,
}

local setup_lualine = function(theme)
  require("lualine").setup {
    options = {
      theme = theme,
      component_separators = { left = "", right = ""},
      section_separators = { left = "", right = ""},
    }
  }
end

-- activation
themes[CurrentTheme]()
setup_lualine(CurrentTheme)
