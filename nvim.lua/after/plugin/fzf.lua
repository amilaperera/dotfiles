require('fzf-lua').setup({
    winopts = {
        preview = {
            border = 'border',
            layout = 'vertical'
        }
    }
})

vim.api.nvim_set_keymap(
    'n', '<leader>f', "<cmd>lua require('fzf-lua').files()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<C-t>', "<cmd>lua require('fzf-lua').git_files()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<leader>c', "<cmd>lua require('fzf-lua').git_commits()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>",
    { noremap = true, silent = true })
-- most recently used
vim.api.nvim_set_keymap(
    'n', '<leader>m', "<cmd>lua require('fzf-lua').oldfiles()<CR>",
    { noremap = true, silent = true })
-- search
vim.api.nvim_set_keymap(
    'n', '<leader>s', "<cmd>lua require('fzf-lua').live_grep()<CR>",
    { noremap = true, silent = true })
-- git project search
vim.api.nvim_set_keymap(
    'n', '<leader>ps',
    "<cmd>lua require('fzf-lua').live_grep({ cmd = 'git grep --line-number --column --color=always --ignore-case' })<CR>",
    { noremap = true, silent = true })
