-- check if we can load the module as packer treats this as a conditionally useable plugin
local loaded, _ = pcall(function () require 'fzf-lua' end)
if not loaded then
    return
end

require('fzf-lua').setup({
    winopts = {
        preview = {
            border = 'border',
            layout = 'vertical'
        }
    }
})

-- keymaps
vim.keymap.set('n', 'T', '<cmd>FzfLua<CR>', {})
vim.api.nvim_set_keymap(
    'n', '<Leader>sf', "<cmd>lua require('fzf-lua').files()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<C-T>', "<cmd>lua require('fzf-lua').git_files()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<Leader>sc', "<cmd>lua require('fzf-lua').git_commits()<CR>",
    { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    'n', '<Leader>,', "<cmd>lua require('fzf-lua').buffers()<CR>",
    { noremap = true, silent = true })
-- most recently used
vim.api.nvim_set_keymap(
    'n', '<Leader>?', "<cmd>lua require('fzf-lua').oldfiles()<CR>",
    { noremap = true, silent = true })
-- search
vim.api.nvim_set_keymap(
    'n', '<Leader>sp', "<cmd>lua require('fzf-lua').live_grep()<CR>",
    { noremap = true, silent = true })

-- git grepping facilities
-- project search (live grep, case sensitive)
vim.api.nvim_set_keymap(
    'n', '<Leader>pl',
    "<cmd>lua require('fzf-lua').live_grep({ cmd = 'git grep --line-number --column --color=always' })<CR>",
    { noremap = true, silent = true })

-- project search (live grep, case insensitive)
vim.api.nvim_set_keymap(
    'n', '<Leader>pli',
    "<cmd>lua require('fzf-lua').live_grep({ cmd = 'git grep --line-number --column --color=always --ignore-case' })<CR>",
    { noremap = true, silent = true })

-- project search with prompt
-- A nice use case would be to search the exact word under the cursor (C-R, C-W)
-- without having to type it
vim.api.nvim_set_keymap(
    'n', '<Leader>ps',
    "<cmd>lua require('fzf-lua').grep({ input_prompt = 'git-grep for > ', cmd = 'git grep --line-number --column --color=always --word-regexp' })<CR>",
    { noremap = true, silent = true })
