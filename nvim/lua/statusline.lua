vim.g.laststatus = 2

vim.api.nvim_exec(
    [[set statusline=%!v:lua.require('statusline_utils').active_statusline()]],
    false)

