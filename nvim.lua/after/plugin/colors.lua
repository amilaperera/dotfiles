vim.o.background = "dark"
vim.cmd([[let g:edge_style = 'neon']])
vim.cmd([[let g:edge_transparent_background = 1]])
vim.cmd([[let g:edge_disable_italic_comment = 1]])
vim.cmd([[let g:edge_menu_selection_background = 'purple']])
vim.cmd.colorscheme("edge")

-- restoring colors if they're cleared by the vim colorscheme
vim.cmd([[hi debugPC term=reverse ctermbg=yellow guibg=yellow]])
vim.cmd([[hi debugBreakpoint term=reverse ctermbg=red guibg=red]])
