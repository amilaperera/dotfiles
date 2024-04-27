return {
    {
        "folke/tokyonight.nvim",
        laze = false,
        priority = 1000,
        -- no italics
        config = function()
            vim.cmd.colorscheme("tokyonight")
            -- More traditional colors for diff to be consistent across many terminals
            -- diff
            -- vim.cmd([[highlight DiffAdd guibg=#005f00]])
            -- vim.cmd([[highlight DiffDelete guibg=#af0000]])
            -- vim.cmd([[highlight DiffText guibg=#5f5f87]])

            -- -- most of the plugins relies on the following highligt group links from the colorscheme
            -- vim.cmd([[highlight diffAdded guifg=green]])
            -- vim.cmd([[highlight diffDeleted guifg=red]])
            -- vim.cmd([[highlight diffChanged guifg=orange]])

            -- -- spelling
            -- vim.cmd([[highlight SpellBad cterm=underline gui=underline guibg=underline guisp=grey]])

            -- -- termdebug
            -- vim.cmd([[highlight debugPC term=reverse ctermbg=blue guibg=navyblue]])
            -- vim.cmd([[highlight debugBreakpoint term=reverse ctermbg=red guibg=red]])
        end,
    },
}
