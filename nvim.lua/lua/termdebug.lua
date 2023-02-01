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

vim.keymap.set('n', '<Leader>dn', "<cmd>call TermDebugSendCommand('n')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>ds', "<cmd>call TermDebugSendCommand('s')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>df', "<cmd>call TermDebugSendCommand('finish')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>dc', "<cmd>call TermDebugSendCommand('continue')<CR>", { silent = true })
