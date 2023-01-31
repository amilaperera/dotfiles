vim.keymap.set("n", "<Leader>q", "<cmd>lua require('toggle_lists').toggle_quickfix()<CR>", { silent = true})
vim.keymap.set("n", "<Leader>l", "<cmd>lua require('toggle_lists').toggle_loclist()<CR>", { silent = true})
