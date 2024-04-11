-- term-debug helpers

-- start gdb
-- StartGdb => all windows on h splits (good for vertical monitor)
-- StartGdbW => source window on v split
vim.cmd([[
    function! StartGdb(bin)
        packadd termdebug
        execute 'Termdebug ' . a:bin
    endfunction

    function! StartGdbW(bin)
        packadd termdebug
        let g:termdebug_wide=1
        execute 'Termdebug ' . a:bin
    endfunction

command! -nargs=1 -complete=file StartGdb call StartGdb(<q-args>)
command! -nargs=1 -complete=file StartGdbW call StartGdbW(<q-args>)
]])

-- Useful keymaps for debugging
-- window switching
vim.keymap.set('n', '<A-i>', "<cmd>Source<CR>", { silent = true }) -- implementation window
vim.keymap.set('n', '<A-g>', "<cmd>Gdb<CR>", { silent = true }) -- gdb window
vim.keymap.set('n', '<A-b>', "<cmd>Break<CR>", { silent = true }) -- set a break point
-- stepping in/out etc
vim.keymap.set('n', '<A-n>', "<cmd>call TermDebugSendCommand('n')<CR>", { silent = true })
vim.keymap.set('n', '<A-s>', "<cmd>call TermDebugSendCommand('s')<CR>", { silent = true })
vim.keymap.set('n', '<A-f>', "<cmd>call TermDebugSendCommand('finish')<CR>", { silent = true })
vim.keymap.set('n', '<A-c>', "<cmd>call TermDebugSendCommand('continue')<CR>", { silent = true })
-- frame traversal
vim.keymap.set('n', '<A-u>', "<cmd>call TermDebugSendCommand('up')<CR>", { silent = true })
vim.keymap.set('n', '<A-d>', "<cmd>call TermDebugSendCommand('down')<CR>", { silent = true })
