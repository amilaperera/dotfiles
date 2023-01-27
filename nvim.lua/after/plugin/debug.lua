-- term-debug helpers

-- start gdb with source window on a vertical split
vim.api.nvim_create_user_command(
  'StartGdbW',
  function(opts)
    vim.cmd([[packadd termdebug]])
    vim.g.termdebug_wide = 1
    vim.fn.execute('Termdebug ' .. opts.args)
  end,
  { nargs = 1, complete = 'file' }
)

-- start gdb with horizontal splits (looks better on vertical monitor)
vim.api.nvim_create_user_command(
  'StartGdb',
  function(opts)
    vim.cmd([[packadd termdebug]])
    vim.fn.execute('Termdebug ' .. opts.args)
  end,
  { nargs = 1, complete = 'file' }
)

vim.keymap.set('n', '<Leader>dn', "<cmd>TermDebugSendCommand('n')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>ds', "<cmd>TermDebugSendCommand('s')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>df', "<cmd>TermDebugSendCommand('finish')<CR>", { silent = true })
vim.keymap.set('n', '<Leader>dc', "<cmd>TermDebugSendCommand('continue')<CR>", { silent = true })

-- restoring colors if they're cleared by the vim colorscheme
vim.cmd([[hi debugPC term=reverse ctermbg=darkblue guibg=darkblue]])
vim.cmd([[hi debugBreakpoint term=reverse ctermbg=red guibg=red]])

