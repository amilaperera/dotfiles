vim.o.background = "dark"
vim.cmd.colorscheme("edge")

-- restoring colors if they're cleared by the vim colorscheme
vim.cmd([[hi debugPC term=reverse ctermbg=yellow guibg=yellow]])
vim.cmd([[hi debugBreakpoint term=reverse ctermbg=red guibg=red]])
