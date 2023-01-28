-- alternate files (works only with c++ projects)
vim.api.nvim_create_user_command('Alternate', "lua require('utils').alternate()<CR>", {})
vim.api.nvim_create_user_command('AlternateSplit', "lua require('utils').alternate({ open = 'split' })<CR>", {})
vim.api.nvim_create_user_command('AlternateVSplit', "lua require('utils').alternate({ open = 'vsplit' })<CR>", {})
vim.api.nvim_create_user_command('AlternateTab', "lua require('utils').alternate({ open = 'tabnew' })<CR>", {})

vim.keymap.set("n", "<Leader>a", ":Alternate<CR>", { silent = true}) -- alternate
vim.keymap.set("n", "<Leader>sa", ":AlternateSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>va", ":AlternateVSplit<CR>", { silent = true})
vim.keymap.set("n", "<Leader>ta", ":AlternateTab<CR>", { silent = true})

