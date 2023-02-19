-- no italics
require('kanagawa').setup({
    undercurl = false,
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
    statementStyle = { bold = false },
    typeStyle = {},
    variablebuiltinStyle = { italic = false},
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords
    transparent = false,        -- do not set background color
    dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
    globalStatus = false,       -- adjust window separators highlight for laststatus=3
    terminalColors = true,      -- define vim.g.terminal_color_{0,17}
    colors = {},
    overrides = {},
    theme = "default"
})

vim.cmd.colorscheme("kanagawa")

-- More traditional colors for diff to be consistent across many terminals
-- diff
vim.cmd([[highlight DiffAdd guibg=#005f00]])
vim.cmd([[highlight DiffDelete guibg=#af0000]])
vim.cmd([[highlight DiffText guibg=#5f5f87]])

-- spelling
vim.cmd([[highlight SpellBad cterm=underline gui=underline guibg=underline guisp=grey]])

-- termdebug
vim.cmd([[highlight debugPC term=reverse ctermbg=yellow guibg=yellow]])
vim.cmd([[highlight debugBreakpoint term=reverse ctermbg=red guibg=red]])
