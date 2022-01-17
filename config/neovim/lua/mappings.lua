-- leader setup
vim.g.leader = ','

-- key mappings
local map_key = vim.api.nvim_set_keymap

map_key('n', '<C-p>', ':Telescope git_files<CR>', { noremap = true, silent = true })
map_key('n', '<C-h>', ':BufferPrevious!<CR>', { silent = true })
map_key('n', '<C-l>', ':BufferNext!<CR>', { silent = true })

-- folding
map_key('n', '<space>', 'za', { noremap = true, silent = true })

-- macro faster
map_key('n', '<leader>m', 'qt0', { noremap = true, silent = true })
map_key('v', '<leader>', ":'<,'> norm @t<CR>", { noremap = true, silent = true })

-- fugitive (git)
map_key('n', '<leader>gs', ':Gstatus<CR>', { noremap = true, silent = true })
map_key('n', '<leader>gd', ':Gvdiff<CR>', { noremap = true, silent = true })

-- search highlighting
map_key('n', '<leader><space>', ':nohl<CR>', { noremap = true, silent = true })

-- commenting
map_key('n', '<leader>cc', ':CommentToggle<CR>', { noremap = true, silent = true })
map_key('v', '<leader>cc', ":'<,'>CommentToggle<CR>", { noremap = true, silent = true })
