return {
    {
        "catppuccin/nvim",
        priority = 1000,
        -- no italics
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                -- background = {
                -- light = "latte",
                -- dark = "mocha",
                -- },
                -- undercurl = false,
                -- commentStyle = { italic = false },
                -- functionStyle = {},
                -- keywordStyle = { italic = false },
                -- statementStyle = { bold = false },
                -- typeStyle = {},
                -- variablebuiltinStyle = { italic = false },
                -- specialReturn = true, -- special highlight for the return keyword
                -- specialException = true, -- special highlight for exception handling keywords
                -- transparent = false, -- do not set background color
                -- dimInactive = false, -- dim inactive window `:h hl-NormalNC`
                -- globalStatus = false, -- adjust window separators highlight for laststatus=3
                -- terminalColors = true, -- define vim.g.terminal_color_{0,17}
                -- colors = {},
                -- theme = "default",
            })

            vim.cmd.colorscheme("catppuccin")

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
