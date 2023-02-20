-- easily close temporary buffer windows like help, fugitive etc.
vim.api.nvim_create_augroup("FastCloseGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"help", "fugitive", "fugitiveblame"},
    callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<CR>', { silent = true, buffer = true })
    end,
    group = "FastCloseGroup"
})
