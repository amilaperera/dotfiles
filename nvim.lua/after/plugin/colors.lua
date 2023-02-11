vim.cmd([[let g:edge_transparent_background = 0]])
vim.cmd([[let g:edge_disable_italic_comment = 1]])
vim.o.background = "dark"
vim.cmd.colorscheme("edge")

-- More traditional colors for diff to be consistent across many terminals
-- diff
vim.cmd([[highlight DiffAdd guibg=#005f00]])
vim.cmd([[highlight DiffDelete guibg=#af0000]])
vim.cmd([[highlight DiffChange guibg=#878700]])

-- spelling
vim.cmd([[highlight SpellBad cterm=underline gui=underline guibg=underline guisp=grey]])

-- termdebug
vim.cmd([[highlight debugPC term=reverse ctermbg=yellow guibg=yellow]])
vim.cmd([[highlight debugBreakpoint term=reverse ctermbg=red guibg=red]])
