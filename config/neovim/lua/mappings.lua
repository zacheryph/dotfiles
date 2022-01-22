-- leader setup
vim.g.leader = ","

-- key mappings
local key_map = vim.api.nvim_set_keymap
local function buf_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

-- buffers
key_map("n", "<C-p>", ":Telescope git_files<CR>", { noremap = true, silent = true })
key_map("n", "<C-r>", ":Telescope lsp_document_symbols<CR>", { noremap = true, silent = true })
key_map("n", "<C-h>", ":BufferPrevious!<CR>", { silent = true })
key_map("n", "<C-l>", ":BufferNext!<CR>", { silent = true })

-- debugging
key_map("n", "t", ":TroubleToggle<CR>", { noremap = true, silent = true })

-- jumping
key_map("n", "<leader>s", ":AS<CR>", {noremap = true, silent = true }) -- rails rspec
buf_map("n", "gd", ":lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- folding
key_map("n", "<space>", "za", { noremap = true, silent = true })

-- macro faster
key_map("n", "<leader>m", "qt0", { noremap = true, silent = true })
key_map("v", "<leader>", ":'<,'> norm @t<CR>", { noremap = true, silent = true })

-- fugitive (git)
key_map("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true })
key_map("n", "<leader>gd", ":Gvdiff<CR>", { noremap = true, silent = true })

-- search highlighting
key_map("n", "<leader><space>", ":nohl<CR>", { noremap = true, silent = true })

-- commenting
key_map("n", "<leader>cc", ":CommentToggle<CR>", { noremap = true, silent = true })
key_map("v", "<leader>cc", ":'<,'>CommentToggle<CR>", { noremap = true, silent = true })
