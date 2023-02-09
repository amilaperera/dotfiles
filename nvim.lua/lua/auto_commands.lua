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
