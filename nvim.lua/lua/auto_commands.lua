-- conditionally enable spell checking
vim.api.nvim_create_augroup("SpellCheckGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"c", "cpp", "markdown","python", "lua", "text"},
    callback = function()
        vim.api.nvim_win_set_option(0, "spell", true)
    end,
    group = "SpellCheckGroup"
})
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.log"},
    callback = function()
        vim.api.nvim_win_set_option(0, "spell", false)
    end,
    group = "SpellCheckGroup"
})

-- easily close temporary buffer windows like help, fugitive etc.
vim.api.nvim_create_augroup("EasyClose", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"fugitive", "help"},
    callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<CR>', { silent = true, buffer = true })
    end,
    group = "EasyClose"
})