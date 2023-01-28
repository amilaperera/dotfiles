-- alternate files (works only with c++ projects)
vim.cmd([[command! Alternate lua alternate()]])
vim.cmd([[command! AlternateSplit lua alternate({open = 'split'})]])
vim.cmd([[command! AlternateVSplit lua alternate({open = 'vsplit'})]])
vim.cmd([[command! AlternateTab lua alternate({open = 'tabnew'})]])

vim.keymap.set("n", "<Leader>a", ":Alternate<CR>", { silent = true}) -- alternate
vim.keymap.set("n", "<Leader>sa", ":AlternateSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>va", ":AlternateVSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>ta", ":AlternateTab<CR>", { silent = true})

