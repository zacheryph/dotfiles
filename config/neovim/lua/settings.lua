local o = vim.opt
local g = vim.g

-- options
o.modelines = 1
o.termguicolors = true

o.autowriteall = true
o.backup = false
o.writebackup = false
o.swapfile = false
o.wrap = true
o.linebreak = true

o.colorcolumn = '100,140'
o.expandtab = true
o.softtabstop = 2
o.tabstop = 2
o.shiftwidth = 2
o.smartindent = true

o.autoindent = true
o.smartindent = true
o.number = true
o.relativenumber = true
o.swapfile = false
o.backup = false

o.cursorline = true
o.hlsearch = true
o.smartcase = true
o.smarttab = true

o.mouse = 'a'

o.scrolloff = 5
o.sidescrolloff = 10

o.completeopt = 'menu,menuone,noinsert,noselect'

--o.splitbelow = true
--o.splitright = true

g.mapleader = ','

o.clipboard = 'unnamedplus'

-- folding
o.foldenable = true
o.foldlevelstart = 5
o.foldnestmax = 5
o.foldmethod = 'syntax'
