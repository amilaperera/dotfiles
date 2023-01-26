require('fzf-lua').setup{
  winopts = {
  }
}

vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', "<cmd>lua require('fzf-lua').git_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', "<cmd>lua require('fzf-lua').git_commits()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', "<cmd>lua require('fzf-lua').oldfiles()<CR>", { noremap = true, silent = true })
