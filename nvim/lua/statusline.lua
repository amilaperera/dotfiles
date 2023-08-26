vim.g.laststatus = 2


local statusline_group = vim.api.nvim_create_augroup("StatuslineGroup", { clear = true })
vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.require('statusline_utils').active_statusline()]], false)
    end,
    group = statusline_group
})

vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.require('statusline_utils').inactive_statusline()]], false)
    end,
    group = statusline_group
})
