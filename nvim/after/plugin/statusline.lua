vim.g.laststatus = 2

require("extras.statusline").config()

local statusline_group = vim.api.nvim_create_augroup("StatuslineGroup", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.require('extras.statusline').active_statusline()]], false)
    end,
    group = statusline_group,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.require('extras.statusline').inactive_statusline()]], false)
    end,
    group = statusline_group,
})
