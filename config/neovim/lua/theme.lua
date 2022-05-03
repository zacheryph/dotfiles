-- theme configurations

-- nightfox
require("nightfox").setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "italic",
    },
  },
})

-- tokyonight
vim.g.tokyonight_style = "storm"
vim.g.tokyonight_italic_comments = true
vim.g.tokyonight_italic_keywords = true


function SetupTheme(theme)
  vim.cmd("colorscheme " .. theme)

  require("lualine").setup {
    options = {
      theme = theme,
      component_separators = { left = "", right = ""},
      section_separators = { left = "", right = ""},
    }
  }
end
