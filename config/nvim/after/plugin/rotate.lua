-- rotate files (works only with c++ projects)
vim.api.nvim_create_user_command("Rotate", "lua require('extras.rotate').rotate_file()<CR>", {})
vim.api.nvim_create_user_command("RotateSplit", "lua require('extras.rotate').rotate_file({ open = 'split' })<CR>", {})
vim.api.nvim_create_user_command(
    "RotateVSplit",
    "lua require('extras.rotate').rotate_file({ open = 'vsplit' })<CR>",
    {}
)
vim.api.nvim_create_user_command("RotateTab", "lua require('extras.rotate').rotate_file({ open = 'tabnew' })<CR>", {})

vim.keymap.set("n", "<Leader>ro", ":Rotate<CR>", { silent = true }) -- rotate
vim.keymap.set("n", "<Leader>rx", ":RotateSplit<CR>", { silent = true })
vim.keymap.set("n", "<Leader>rv", ":RotateVSplit<CR>", { silent = true })
vim.keymap.set("n", "<Leader>rt", ":RotateTab<CR>", { silent = true })
