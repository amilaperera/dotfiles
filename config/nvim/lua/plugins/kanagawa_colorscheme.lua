return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        -- no italics
        config = function()
            require("kanagawa").setup({
                undercurl = false,
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                statementStyle = { bold = false },
                transparent = true, -- do not set background color
                theme = "dragon",
            })

            vim.cmd.colorscheme("kanagawa")

            -- spelling
            vim.cmd([[highlight SpellBad cterm=underline gui=underline guibg=underline guisp=grey]])

            -- termdebug
            vim.cmd([[highlight debugPC term=reverse ctermbg=blue guibg=navyblue]])
            vim.cmd([[highlight debugBreakpoint term=reverse ctermbg=red guibg=red]])
        end,
    },
}
