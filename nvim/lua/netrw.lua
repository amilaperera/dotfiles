vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 20

local toggle_netrw = function(args)
    if vim.t.netrw_open == nil then
        local cmd = 'Lexplore' .. (args or '')
        vim.cmd(cmd)
        vim.t.netrw_open = true
    else
        vim.cmd('Lexplore')
        vim.t.netrw_open = nil
    end
end

vim.keymap.set('n', '<Leader>e', function() toggle_netrw() end, { silent = true, desc = "Lexplore in the current working directory" })
vim.keymap.set('n', '<Leader>r', function() toggle_netrw('%:p:h') end, { silent = true, desc = "Lexplore in the directory of the current file" })
