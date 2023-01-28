vim.cmd([[command! Rotate lua rotate()]])
vim.cmd([[command! RotateSplit lua rotate({open = 'split'})]])
vim.cmd([[command! RotateVSplit lua rotate({open = 'vsplit'})]])
vim.cmd([[command! RotateTab lua rotate({open = 'tabnew'})]])

vim.keymap.set("n", "<Leader>a", ":Rotate<CR>", { silent = true}) -- alternate
vim.keymap.set("n", "<Leader>sa", ":RotateSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>va", ":RotateVSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>ta", ":RotateTab<CR>", { silent = true})

